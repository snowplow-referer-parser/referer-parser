# Attlib

Attlib is a multi-language library for XXX, inspired by the [ua-parser] [ua-parser] project (which does the same for user agent parsing). Attlib is available in multiple implementations (all available in sub-folders of this repository):

XXX

## search_engines.yml

Attlib identifies whether a URL is a search engine or not by checking it against data in the [`search_engines.yml`] [search-engines-yml] file; the intention is that this YAML file is reusable as is by all the various implementations of Attlib in different programming languages.

The file lists each search engine by name, and for each, gives a list of the parameters used in that search engine URL to identify the keywords and a list of domains that the search engine uses, for example:

```yaml
google # Search engine name
	parameters:
		- 'q' # First parameter used by Google
		- 'p' # Alternative parameter used by Google
	domains:
		- google.co.uk 	# One domain
		- google.com 	  # Another domain
    ...
```

The number of search engines and the domains they operate on is constantly growing. We therefore need to keep `search_engines.yml` up-to-date, and hope that the community will help!

## Contributing

We welcome contributions to Attlib:

1. New search engines and other referrers - if you spot a search engine missing from `search_engines.yml`, please fork the repo, add the missing entry and submit a pull request
2. Ports of Attlib to new languages - we welcome ports of Attlib to new programming languages (e.g. Python, JavaScript, PHP)
3. Bug fixes, feature requests etc - much appreciated!

## Copyright and license

Copyright on XXX.

The original Ruby code is copyright 2012 SnowPlow Analytics Ltd and is available under the [Apache License, Version 2.0] [apache-license].

The Java/Scala port is copyright 2012 SnowPlow Analytics Ltd and is available under the [Apache License, Version 2.0] [apache-license].

[search-engines-yml]: https://github.com/snowplow/attlib/blob/master/search_engines.yml
[ua-parser]: https://github.com/tobie/ua-parser
[apache]: http://www.apache.org/licenses/LICENSE-2.0