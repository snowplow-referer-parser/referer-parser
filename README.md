# Attlib

Attlib is a multi-language library for extracting search marketing attribution data from referrer URLs, inspired by the [ua-parser] [ua-parser] project (an equivalent library for user agent parsing). Attlib is available in the following languages, each available in a sub-folder of this repository:

* [Ruby implementation] [ruby-readme] (`attlib`)
* Java and Scala implementation (_to come_)

## Usage: Ruby

```ruby
refr = Attlib::Referrer.new('http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari')

refr.is_search_engine?  # => True
refr.search_engine      # => 'Google'
refr.keywords           # => 'gateway oracle cards denise linn'
```

For more information, please see the Ruby [README] [ruby-readme].

## Usage: Java

Coming soon...

## search_engines.yml

Attlib identifies whether a URL is a search engine or not by checking it against the [`search_engines.yml`] [search-engines-yml] file; the intention is that this YAML file is reusable as-is by each implementation of Attlib.

The file lists search engines by name, and for each, gives a list of the parameters used in that search engine URL to identify the keywords and a list of domains that the search engine uses, for example:

```yaml
google # Search engine name
  parameters:
    - 'q' # First parameter used by Google
    - 'p' # Alternative parameter used by Google
  domains:
    - google.co.uk  # One domain
    - google.com    # Another domain
    - ...
```

The number of search engines and the domains they use is constantly growing - we need to keep `search_engines.yml` up-to-date, and hope that the community will help!

## Contributing

We welcome contributions to Attlib:

1. **New search engines and other referrers** - if you spot a search engine missing from `search_engines.yml`, please fork the repo, add the missing entry and submit a pull request
2. **Ports of Attlib to other languages** - we welcome ports of Attlib to new programming languages (e.g. Python, JavaScript, PHP)
3. **Bug fixes, feature requests etc** - much appreciated!

## Copyright and license

`search_engines.yml` is based on [Piwik's] [piwik] [`SearchEngines.php`] [piwik-search-engines], copyright 2012 Matthieu Aubry and available under the [GNU General Public License v3] [gpl-license].

The original Ruby code is copyright 2012 SnowPlow Analytics Ltd and is available under the [Apache License, Version 2.0] [apache-license].

The Java/Scala port is copyright 2012 SnowPlow Analytics Ltd and is available under the [Apache License, Version 2.0] [apache-license].

[ua-parser]: https://github.com/tobie/ua-parser

[ruby-readme]: https://github.com/snowplow/attlib/master/ruby/README.md

[piwik]: http://piwik.org
[piwik-search-engines]: https://github.com/piwik/piwik/blob/master/core/DataFiles/SearchEngines.php

[search-engines-yml]: https://github.com/snowplow/attlib/blob/master/search_engines.yml

[apache-license]: http://www.apache.org/licenses/LICENSE-2.0
[gpl-license]: http://www.gnu.org/licenses/gpl-3.0.html