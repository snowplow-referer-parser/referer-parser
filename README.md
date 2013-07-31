# referer-parser

Java/Scala: [![Build Status](https://travis-ci.org/snowplow/referer-parser.png)](https://travis-ci.org/snowplow/referer-parser)

referer-parser is a multi-language library for extracting marketing attribution data (such as search terms) from referer URLs, inspired by the [ua-parser] [ua-parser] project (an equivalent library for user agent parsing).

referer-parser is a core component of [Snowplow] [snowplow], the open-source web-scale analytics platform powered by Hadoop, Hive and Redshift.

_Note that we always use the original HTTP misspelling of 'referer' (and thus 'referal') in this project - never 'referrer'._

## Maintainers

* Ruby: [Snowplow Analytics] [snowplow-analytics]
* Java/Scala: [Snowplow Analytics] [snowplow-analytics]
* Python: [Don Spaulding] [donspaulding] 
* .NET: [Sepp Wijnands] [swijnands] at [iPerform Software] [iperform]
* `referers.yml`: [Snowplow Analytics] [snowplow-analytics]

## Usage: Java

The Java version of this library uses the updated API, and identifies search, social, webmail, internal and unknown referers:

```java
import com.snowplowanalytics.refererparser.Parser;

...

String refererUrl = "http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari";
String pageUrl    = "http:/www.psychicbazaar.com/shop"; // Our current URL

Parser refererParser = new Parser();
Referer r = refererParser.parse(refererUrl, pageUrl);

System.out.println(r.medium);     // => "search"
System.out.println(r.source);     // => "Google"
System.out.println(r.term);       // => "gateway oracle cards denise linn"
```

For more information, please see the Java/Scala [README] [java-scala-readme].

## Usage: Scala

The Scala version of this library uses the updated API, and identifies search, social, webmail, internal and unknown referers:

```scala
val refererUrl = "http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari"
val pageUrl    = "http:/www.psychicbazaar.com/shop" // Our current URL

import com.snowplowanalytics.refererparser.scala.Parser
for (r <- Parser.parse(refererUrl, pageUrl)) {
  println(r.medium)         // => "search"
  for (s <- r.source) {
    println(s)              // => "Google"
  }
  for (t <- r.term) {
    println(t)              // => "gateway oracle cards denise linn"
  }
}
```

For more information, please see the Java/Scala [README] [java-scala-readme].

## Usage: Ruby

The Ruby version of this library still uses the **old** API, and identifies search referers only:

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

## Usage: Python

The Python version of this library still uses the **old** API, and identifies search referers only:

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

## Usage: .NET

The .NET (C#) version of this library uses the updated API, and identifies search, social, webmail, internal and unknown referers:

```C#
using RefererParser;

...

string refererUrl = "http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari";
string pageUrl    = "http:/www.psychicbazaar.com/shop"; // Our current URL

var referer = Parser.Parse(new Uri(refererUrl), pageUrl);

Console.WriteLine(r.Medium); // => "Search"
Console.WriteLine(r.Source); // => "Google"
Console.WriteLine(r.Term); // => "gateway oracle cards denise linn"
```

For more information, please see the .NET [README] [dotnet-readme].

## referers.yml

referer-parser identifies whether a URL is a known referer or not by checking it against the [`referers.yml`] [referers-yml] file; the intention is that this YAML file is reusable as-is by every language-specific implementation of referer-parser.

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
2. **Ports of referer-parser to other languages** - we welcome ports of referer-parser to new programming languages (e.g. JavaScript, PHP, Go, Haskell)
3. **Bug fixes, feature requests etc** - much appreciated!

**Please sign the [Snowplow CLA] [cla] before making pull requests.**

## Support

General support for referer-parser is handled by the team at Snowplow Analytics Ltd.

You can contact the Snowplow Analytics team through any of the [channels listed on their wiki] [talk-to-us].

## Copyright and license

`referers.yml` is based on [Piwik's] [piwik] [`SearchEngines.php`] [piwik-search-engines] and [`Socials.php`] [piwik-socials], copyright 2012 Matthieu Aubry and available under the [GNU General Public License v3] [gpl-license].

The original Ruby code is copyright 2012-2013 Snowplow Analytics Ltd and is available under the [Apache License, Version 2.0] [apache-license].

The Java/Scala port is copyright 2012-2013 Snowplow Analytics Ltd and is available under the [Apache License, Version 2.0] [apache-license].

The Python port is copyright 2012-2013 [Don Spaulding] [donspaulding] and is available under the [Apache License, Version 2.0] [apache-license].

The .NET port is copyright 2013 [iPerform Software] [iperform] and is available under the [Apache License, Version 2.0] [apache-license].

[ua-parser]: https://github.com/tobie/ua-parser

[snowplow]: https://github.com/snowplow/snowplow
[snowplow-analytics]: http://snowplowanalytics.com
[donspaulding]: https://github.com/donspaulding
[swijnands]: https://github.com/swijnands
[iperform]: http://www.iperform.nl/

[piwik]: http://piwik.org
[piwik-search-engines]: https://github.com/piwik/piwik/blob/master/core/DataFiles/SearchEngines.php
[piwik-socials]: https://github.com/piwik/piwik/blob/master/core/DataFiles/Socials.php

[ruby-readme]: https://github.com/snowplow/referer-parser/blob/master/ruby/README.md
[java-scala-readme]: https://github.com/snowplow/referer-parser/blob/master/java-scala/README.md
[python-readme]: https://github.com/snowplow/referer-parser/blob/master/python/README.md
[dotnet-readme]: https://github.com/snowplow/referer-parser/blob/master/dotnet/README.md
[referers-yml]: https://github.com/snowplow/referer-parser/blob/master/referers.yml

[talk-to-us]: https://github.com/snowplow/snowplow/wiki/Talk-to-us

[apache-license]: http://www.apache.org/licenses/LICENSE-2.0
[gpl-license]: http://www.gnu.org/licenses/gpl-3.0.html
[cla]: https://github.com/snowplow/snowplow/wiki/CLA
