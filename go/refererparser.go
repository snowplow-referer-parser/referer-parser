/*

Package refererparser implements referer extraction using a shared 'database' of known referers found in referers.yml [1].

Links

	[1] https://github.com/snowplow/referer-parser/blob/master/referers.yml

*/
package refererparser

import (
	"encoding/json"
	"net/url"
	"strings"
)

type refererData map[string]map[string]map[string][]string

var data refererData

func init() {
	data = loadRefererData()
}

// loadRefererData loads and parses the YAML file.
func loadRefererData() refererData {
	dat, err := Asset("data/referers.json")
	if err != nil {
		panic(err)
	}
	res := make(refererData)
	if err := json.Unmarshal(dat, &res); err != nil {
		panic(err)
	}
	return res
}

// RefererResult holds the extracted data
type RefererResult struct {
	Known           bool
	Referer         string
	Medium          string
	SearchParameter string
	SearchTerm      string
	URI             *url.URL
}

// SetCurrent is used to set the "internal" medium if needed.
func (ref *RefererResult) SetCurrent(curl string) {
	purl, _ := url.Parse(curl)
	if purl.Host == ref.URI.Host {
		ref.Medium = "internal"
	}
}

func lookup(uri *url.URL, q string, suffix bool) (refResult *RefererResult) {
	refResult = &RefererResult{URI: uri, Medium: "unknown"}
	for medium, mediumData := range data {
		for refName, refconfig := range mediumData {
			for _, domain := range refconfig["domains"] {
				if (!suffix && q == domain) || (suffix && (strings.HasSuffix(q, domain) || strings.HasPrefix(q, domain))) {
					refResult.Known = true
					refResult.Referer = refName
					refResult.Medium = medium
					params, paramExists := refconfig["parameters"]
					if paramExists {
						for _, param := range params {
							sterm := uri.Query().Get(param)
							if sterm != "" {
								refResult.SearchParameter = param
								refResult.SearchTerm = sterm
							}
						}
					}
					return refResult
				}
			}
		}
	}
	return
}

// Parse an url and extract referer, it returns a RefererResult.
func Parse(uri string) (refResult *RefererResult) {
	puri, _ := url.Parse(uri)
	// Split before the first dot ".".
	parts := strings.SplitAfterN(puri.Host, ".", 2)
	rhost := ""
	if len(parts) > 1 {
		rhost = parts[1]
	}
	queries := []string{puri.Host + puri.Path, rhost + puri.Path, puri.Host, rhost}
	for _, q := range queries {
		refResult = lookup(puri, q, false)
		if refResult.Known {
			return
		}
	}
	if !refResult.Known {
		for _, q := range queries {
			refResult = lookup(puri, q, true)
			if refResult.Known {
				return
			}
		}
	}
	return
}
