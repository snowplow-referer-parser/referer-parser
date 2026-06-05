# referer-parser

referer-parser is a database for extracting marketing attribution data (such as search terms) from referer URLs, inspired by the [ua-parser][ua-parser] project (an equivalent library for user agent parsing).

The referer-parser project also contains multiple libraries for working with the referer-parser database in different languages.

referer-parser is a core component of [Snowplow][snowplow].

_Note that we always use the original HTTP misspelling of 'referer' (and thus 'referal') in this project - never 'referrer'._

## Database

The database is available in YAML and JSON format and is hosted in a public S3 bucket. The right file to use depends on which version of Snowplow Enrich you are running.

### If you are on Snowplow Enrich 5.3 or later

Use the `referers-5.3` file. This is the actively-maintained database, updated daily. It includes all referer categories including `chatbot`.

```
https://s3-eu-west-1.amazonaws.com/snowplow-hosted-assets/third-party/referer-parser/referers-5.3.yaml
https://s3-eu-west-1.amazonaws.com/snowplow-hosted-assets/third-party/referer-parser/referers-5.3.json
```

### If you are on Snowplow Enrich earlier than 5.3

Use the `referers-latest` file. This file is frozen at its July 2025 state and will never be updated, ensuring that deployments on older versions of Enrich continue to work without any risk of breakage. It does not include `chatbot` entries or any referers added after July 2025.

```
https://s3-eu-west-1.amazonaws.com/snowplow-hosted-assets/third-party/referer-parser/referers-latest.yaml
https://s3-eu-west-1.amazonaws.com/snowplow-hosted-assets/third-party/referer-parser/referers-latest.json
```

### Version numbering

The version number in the filename (e.g. `5.3`) refers to the minimum version of Snowplow Enrich required to parse that file. If a future change to the database requires a newer version of Enrich, a new versioned file will be introduced at that point (e.g. `referers-9.9`) and the previous versioned file will be frozen.

### Date-stamped snapshots

Each day's database is also archived with a date stamp. These follow the current format and therefore also require Enrich 5.3 or later.

```
https://s3-eu-west-1.amazonaws.com/snowplow-hosted-assets/third-party/referer-parser/referers-YYYYMMDD.yaml
https://s3-eu-west-1.amazonaws.com/snowplow-hosted-assets/third-party/referer-parser/referers-YYYYMMDD.json
```

Example:

```
https://s3-eu-west-1.amazonaws.com/snowplow-hosted-assets/third-party/referer-parser/referers-20260531.yaml
https://s3-eu-west-1.amazonaws.com/snowplow-hosted-assets/third-party/referer-parser/referers-20260531.json
```

## Language-specific repositories

- Scala: https://github.com/snowplow-referer-parser/scala-referer-parser
- Java: https://github.com/snowplow-referer-parser/java-referer-parser
- Ruby: https://github.com/snowplow-referer-parser/ruby-referer-parser
- Python: https://github.com/snowplow-referer-parser/python-referer-parser
- NodeJS: https://github.com/snowplow-referer-parser/nodejs-referer-parser
- .NET: https://github.com/snowplow-referer-parser/dotnet-referer-parser
- PHP: https://github.com/snowplow-referer-parser/php-referer-parser
- Golang: https://github.com/snowplow-referer-parser/golang-referer-parser
- Erlang: https://github.com/silviucpp/refererparser

## referers.yml

referer-parser identifies whether a URL is a known referer or not by checking it against the [`referers.yml`][referers-yml] file; the intention is that this YAML file is reusable as-is by every language-specific implementation of referer-parser.

The file is broken out into sections for the different mediums that we support:

* `unknown` for when we know the source, but not the medium
* `email` for webmail providers
* `social` for social media services
* `search` for search engines

Then within each section, we list each known provider (aka `source`) by name, and then which domains each provider uses. For search engines, we also list the parameters used in the search engine URL to identify the search `term`. For example:

```yaml
Google: # Name of search engine referer
  parameters:
    - 'q' # First parameter used by Google
    - 'p' # Alternative parameter used by Google
  domains:
    - google.co.uk  # One domain used by Google
    - google.com    # Another domain used by Google
    - ...
```

The number of referers and the domains they use is constantly growing - we need to keep `referers.yml` up-to-date, and hope that the community will help!

## Contributing

We welcome contributions to referer-parser:

1. **New search engines and other referers** - if you notice a search engine, social network or other site missing from `referers.yml`, please fork the repo, add the missing entry and submit a pull request
2. **Bug fixes, feature requests etc** - much appreciated!

See the [Snowplow contributing guidelines][contributing] for more details.

## Copyright and license

`referers.yml` is based on [Matomo's][matomo] `SearchEngines.php` and `Socials.php`, copyright 2012 Matthieu Aubry and available under the [GNU General Public License v3][gpl-license].

[ua-parser]: https://github.com/tobie/ua-parser

[snowplow]: https://docs.snowplow.io/docs/

[contributing]: https://docs.snowplow.io/docs/contributing/

[matomo]: https://matomo.org

[referers-yml]: https://github.com/snowplow-referer-parser/referer-parser/blob/master/resources/referers.yml

[gpl-license]: http://www.gnu.org/licenses/gpl-3.0.html
