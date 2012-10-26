# Attlib

Attlib is a multi-language library for XXX, inspired by the [ua-parser] [ua-parser] project (which does the same for user agent parsing). Attlib is available in multiple languages - each available in a sub-folder of this repository:

* Ruby implementation (`attlib`)
* Java and Scala implementation (to come)

## Usage: Ruby

```ruby
new_referrer = Referrer.new('http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari&tbo=d&biw=768&bih=900&source=lnms&tbm=isch&ei=t9fTT_TFEYb28gTtg9HZAw&sa=X&oi=mode_link&ct=mode&cd=2&sqi=2&ved=0CEUQ_AUoAQ')

new_referrer.is_search_engine?  # => True
new_referrer.search_engine      # => 'Google'
new_referrer.keywords           # => 'gateway oracle cards denise linn'
```

For more information, please see the Ruby [README] [ruby-readme].

## search_engines.yml

Attlib identifies whether a URL is a search engine or not by checking it against data in the [`search_engines.yml`] [search-engines-yml] YAML file; the intention is that this file is reusable as-is by the various implementations of Attlib in different programming languages.

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

The number of search engines and the domains they use is constantly growing - so we need to keep `search_engines.yml` up-to-date, and hope that the community will help!

## Contributing

We welcome contributions to Attlib:

1. New search engines and other referrers - if you spot a search engine missing from `search_engines.yml`, please fork the repo, add the missing entry and submit a pull request
2. Ports of Attlib to new languages - we welcome ports of Attlib to new programming languages (e.g. Python, JavaScript, PHP)
3. Bug fixes, feature requests etc - much appreciated!

## Copyright and license

Copyright on XXX.

The original Ruby code is copyright 2012 SnowPlow Analytics Ltd and is available under the [Apache License, Version 2.0] [apache-license].

The Java/Scala port is copyright 2012 SnowPlow Analytics Ltd and is available under the [Apache License, Version 2.0] [apache-license].

[ua-parser]: https://github.com/tobie/ua-parser

[ruby-readme]: xxx

[search-engines-yml]: https://github.com/snowplow/attlib/blob/master/search_engines.yml

[apache-license]: http://www.apache.org/licenses/LICENSE-2.0