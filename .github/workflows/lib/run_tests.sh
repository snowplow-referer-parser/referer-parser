#!/usr/bin/env bash
set -Eeuo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
MICRO_IMAGE="snowplow/snowplow-micro:latest"
MICRO_PORT=9090
MICRO_CONTAINER_NAME="sp-micro-test"

REFERER_TESTS_FILE="resources/referer-tests.json"
ENRICHMENTS_DIR="resources/enrichments"
REFERER_ENRICH_FILE="$ENRICHMENTS_DIR/referer_parser.json"

YAML_REF="resources/referers.yml"
DB_ASSET="referers.json"
DB_PORT=8000

# tracker version kept inline on purpose
base_event_url="http://localhost:${MICRO_PORT}/com.snowplowanalytics.snowplow/tp2?e=pp&tv=js-0.13.1&p=web"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
urlencode() { jq -rn --arg v "$1" '$v|@uri'; }

check_deps() {
  local missing=()
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null || missing+=("$cmd")
  done
  if (( ${#missing[@]} )); then
    echo "ERROR: missing command(s): ${missing[*]}" >&2
    exit 1
  fi
}

# ---------------------------------------------------------------------------
# Dependency checks
# ---------------------------------------------------------------------------
check_deps jq docker python3

# ---------------------------------------------------------------------------
# Write enrichment configuration
# ---------------------------------------------------------------------------
mkdir -p "$ENRICHMENTS_DIR"
cat > "$REFERER_ENRICH_FILE" <<JSON
{
  "schema": "iglu:com.snowplowanalytics.snowplow/referer_parser/jsonschema/2-0-0",
  "data": {
    "name": "referer_parser",
    "vendor": "com.snowplowanalytics.snowplow",
    "enabled": true,
    "parameters": {
      "internalDomains": [],
      "database": "referers.json",
      "uri": "http://host.docker.internal:${DB_PORT}/"
    }
  }
}
JSON

# ---------------------------------------------------------------------------
# Convert YAML DB ➜ JSON
# ---------------------------------------------------------------------------
echo "Converting referers.yml to JSON..."
docker run --rm -i ghcr.io/mikefarah/yq -o=json - < "$YAML_REF" > "$DB_ASSET"
[[ -s "$DB_ASSET" ]] || { echo "ERROR: yq conversion failed." >&2; exit 1; }

# ---------------------------------------------------------------------------
# Serve DB over HTTP
# ---------------------------------------------------------------------------
echo "Starting local HTTP server on port $DB_PORT..."
python3 -m http.server "$DB_PORT" --directory "$(dirname "$DB_ASSET")" >/dev/null 2>&1 &
HTTP_PID=$!

# ---------------------------------------------------------------------------
# Ensure resources are cleaned up on exit
# ---------------------------------------------------------------------------
trap 'kill "$HTTP_PID" 2>/dev/null || true; docker stop "$MICRO_CONTAINER_NAME" >/dev/null 2>&1 || true' EXIT

# ---------------------------------------------------------------------------
# Launch Snowplow Micro
# ---------------------------------------------------------------------------
echo "Starting Snowplow Micro container..."
docker run -d --rm --name "$MICRO_CONTAINER_NAME" \
  -p "$MICRO_PORT:9090" \
  --add-host host.docker.internal:host-gateway \
  --mount type=bind,source="$(pwd)/$ENRICHMENTS_DIR",destination=/config/enrichments,readonly \
  "$MICRO_IMAGE" >/dev/null

# ---------------------------------------------------------------------------
# Wait until /health returns ok
# ---------------------------------------------------------------------------
printf "Waiting for Micro to become healthy "
for _ in {1..30}; do
  if curl -fs "http://localhost:${MICRO_PORT}/health" | grep -qi 'ok'; then
    echo "✓"
    break
  fi
  printf '.'
  sleep 1
done || { echo -e "\nERROR: Micro did not become healthy." >&2; exit 1; }

# ---------------------------------------------------------------------------
# Load test cases (manual loop kept as requested)
# ---------------------------------------------------------------------------
echo "Reading test cases..."
test_cases=()
while IFS= read -r line; do
  test_cases+=( "$line" )
done < <(jq -c '.[]' "$REFERER_TESTS_FILE")

# ---------------------------------------------------------------------------
# Send events
# ---------------------------------------------------------------------------
echo "Sending ${#test_cases[@]} events..."
for idx in "${!test_cases[@]}"; do
  uri=$(jq -r '.uri' <<< "${test_cases[$idx]}")
  encoded_refr=$(urlencode "$uri")
  curl -s "${base_event_url}&aid=${idx}&refr=${encoded_refr}" >/dev/null
done

# ---------------------------------------------------------------------------
# Wait briefly, then fetch processed events
# ---------------------------------------------------------------------------
sleep 5
good_events=$(curl -s "http://localhost:${MICRO_PORT}/micro/good")
total_good=$(jq 'length' <<< "$good_events")
echo "Micro reports $total_good good events."

all_passed=true
if [[ $total_good -ne ${#test_cases[@]} ]]; then
  echo "❌ Count mismatch (sent ${#test_cases[@]})."
  all_passed=false
fi

# ---------------------------------------------------------------------------
# Field‑level validation
# ---------------------------------------------------------------------------
if $all_passed; then
  for idx in "${!test_cases[@]}"; do
    tc="${test_cases[$idx]}"
    medium=$(jq -r '.medium'  <<< "$tc")
    source=$(jq -r '.source'  <<< "$tc")
    uri=$(jq -r '.uri'        <<< "$tc")

    match=$(jq --arg aid "$idx" --arg m "$medium" --arg s "$source" '
        .[] | select(.event.app_id==$aid)
        | select(.event.refr_medium==$m and (.event.refr_source // "")==$s)' <<<"$good_events")

    if [[ -n $match ]]; then
      echo "✅ $uri"
    else
      echo "❌ $uri – medium/source mismatch"
      all_passed=false
    fi
  done
fi

# ---------------------------------------------------------------------------
# Result
# ---------------------------------------------------------------------------
if ! $all_passed; then
  echo "Some tests failed." >&2
  exit 1
fi

echo "All tests passed successfully!"
