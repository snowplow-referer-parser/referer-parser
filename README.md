# referer-parser

referer-parser is a multi-language library for extracting marketing attribution data (such as search terms) from referer URLs, inspired by the [ua-parser] [ua-parser] project (an equivalent library for user agent parsing).

referer-parser is available in the following languages, each in a sub-folder of this repository:

* [Ruby implementation] [ruby-impl]
* [Java and Scala implementation] [java-scala-impl]

referer-parser is a core component of [SnowPlow] [snowplow], the open-source web-scale analytics platform powered by Hadoop and Hive.

_Note that we always use the original HTTP misspelling of 'referer' (and thus 'referal') in this project - never 'referrer'._

## Usage: Ruby

```ruby
require 'referer-parser'

referer_url = 'http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari'

r = RefererParser::Referer.new(referer_url)

puts r.known?                # =>  true
puts r.referer               # => 'Google'
puts r.search_parameter      # => 'q'     
puts r.search_term           # => 'gateway oracle cards denise linn'
puts r.uri.host              # => 'www.google.com'
```

For more information, please see the Ruby [README] [ruby-readme].

## Usage: Java

```java
import com.snowplowanalytics.refererparser.Parser;

...

  String refererUrl = "http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari";

  Parser refererParser = new Parser();
  Referal r = refererParser.parse(refererUrl);

  System.out.println(r.referer.name);       // => "Google"
  System.out.println(r.search.parameter);   // => "q"    
  System.out.println(r.search.term);        // => "gateway oracle cards denise linn"
```

For more information, please see the Java/Scala [README] [java-scala-readme].

## Usage: Scala

```scala
val refererUrl = "http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari"

import com.snowplowanalytics.refererparser.scala.Parser
for (r <- Parser.parse(refererUrl)) {
  println(r.referer.name)      // => "Google"
  for (s <- r.search) {
    println(s.term)            // => "gateway oracle cards denise linn"
    println(s.parameter)       // => "q"    
  }
}
```

For more information, please see the Java/Scala [README] [java-scala-readme].

## Usage: Python

```python
from referer_parser import Referer

referer_url = 'http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari'

r = Referer(referer_url)

print(r.known)              # True
print(r.referer)            # 'Google'
print(r.search_parameter)   # 'q'     
print(r.search_term)        # 'gateway oracle cards denise linn'
print(r.uri)                # ParseResult(scheme='http', netloc='www.google.com', path='/search', params='', query='q=gateway+oracle+cards+denise+linn&hl=en&client=safari', fragment='')
```

For more information, please see the Python [README] [python-readme].

## search.yml

referer-parser identifies whether a URL is a known referer or not by checking it against the [`search.yml`] [search-yml] file; the intention is that this YAML file is reusable as-is by every language-specific implementation of referer-parser.

The file lists known search engines by name, and for each, gives a list of the parameters used in that search engine URL to identify the keywords and a list of domains that the search engine uses, for example:

```yaml
google # Name of search engine referer
  parameters:
    - 'q' # First parameter used by Google
    - 'p' # Alternative parameter used by Google
  domains:
    - google.co.uk  # One domain used by Google
    - google.com    # Another domain used by Google
    - ...
```

The number of search engines and the domains they use is constantly growing - we need to keep `search.yml` up-to-date, and hope that the community will help!

In the future, we may augment `search.yml` with non-search engine referers - e.g. social networks like Facebook or affiliate networks like TradeDoubler. If you have any suggestions here, please [let us know] [talk-to-us]!

## Contributing

We welcome contributions to referer-parser:

1. **New search engines and other referers** - if you notice a search engine missing from `referers.yml`, please fork the repo, add the missing entry and submit a pull request
2. **Ports of referer-parser to other languages** - we welcome ports of referer-parser to new programming languages (e.g. JavaScript, PHP)
3. **Bug fixes, feature requests etc** - much appreciated!

## Support

Support for referer-parser is handled by the team at SnowPlow Analytics Ltd.

You can contact the SnowPlow Analytics team through any of the [channels listed on their wiki] [talk-to-us].

## Copyright and license

`search.yml` is based on [Piwik's] [piwik] [`SearchEngines.php`] [piwik-search-engines], copyright 2012 Matthieu Aubry and available under the [GNU General Public License v3] [gpl-license].

The original Ruby code is copyright 2012 SnowPlow Analytics Ltd and is available under the [Apache License, Version 2.0] [apache-license].

The Java/Scala port is copyright 2012 SnowPlow Analytics Ltd and is available under the [Apache License, Version 2.0] [apache-license].

[ua-parser]: https://github.com/tobie/ua-parser

[snowplow]: https://github.com/snowplow/snowplow
[ruby-impl]: https://github.com/snowplow/referer-parser/tree/master/ruby
[ruby-readme]: https://github.com/snowplow/referer-parser/blob/master/ruby/README.md
[java-scala-impl]: https://github.com/snowplow/referer-parser/tree/master/java-scala
[java-scala-readme]: https://github.com/snowplow/referer-parser/blob/master/java-scala/README.md
[python-readme]: https://github.com/donspaulding/referer-parser/blob/master/python/README.md
[search-yml]: https://github.com/snowplow/referer-parser/blob/master/search.yml
[talk-to-us]: https://github.com/snowplow/snowplow/wiki/Talk-to-us

[piwik]: http://piwik.org
[piwik-search-engines]: https://github.com/piwik/piwik/blob/master/core/DataFiles/SearchEngines.php

[apache-license]: http://www.apache.org/licenses/LICENSE-2.0
[gpl-license]: http://www.gnu.org/licenses/gpl-3.0.html
