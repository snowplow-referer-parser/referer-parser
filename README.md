# referer-parser

Java/Scala: [![Build Status](https://travis-ci.org/snowplow/referer-parser.png)](https://travis-ci.org/snowplow/referer-parser)

referer-parser is a multi-language library for extracting marketing attribution data (such as search terms) from referer URLs, inspired by the [ua-parser] [ua-parser] project (an equivalent library for user agent parsing).

referer-parser is a core component of [Snowplow] [snowplow], the open-source web-scale analytics platform powered by Hadoop and Redshift.

_Note that we always use the original HTTP misspelling of 'referer' (and thus 'referal') in this project - never 'referrer'._

## Maintainers

* Java/Scala: [Snowplow Analytics Ltd] [snowplow-analytics]
* Ruby: [Kelley Reynolds] [kreynolds] at Inside Systems, Inc
* Python: [Don Spaulding] [donspaulding] 
* node.js (JavaScript): [Martin Katrenik] [mkatrenik]
* .NET (C#): [Sepp Wijnands] [swijnands] at [iPerform Software] [iperform]
* PHP: [Lars Strojny] [lstrojny]
* Go: [Thomas Sileo] [tsileo]
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

You can also provide a list of domains which should be considered internal:

```scala
val refererUrl = "http://www.subdomain1.snowplowanalytics.com"
val pageUrl = "http://www.snowplowanalytics.com"
val internalDomains = List(
  "www.subdomain1.snowplowanalytics.com", "www.subdomain2.snowplowanalytics.com"
)

import com.snowplowanalytics.refererparser.scala.Parser

for (r <- Parser.parse(refererUrl, pageUrl, internalDomains)) {
  println(r.medium)         // => "internal"
  for (s <- r.source) {
    println(s)              // => null
  }
  for (t <- r.term) {
    println(t)              // => null
  }
}
```

For more information, please see the Java/Scala [README] [java-scala-readme].

## Usage: Ruby

The Ruby version of this library uses the updated API:

```ruby
require 'referer-parser'

parser = RefererParser::Parser.new

parser.parse('http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari')
  # => {
    :known=>true,
    :uri=>"http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari",
    :source=>"Google",
    :medium=>"search",
    :term=>"gateway oracle cards denise linn"
  }
```

For more information, please see the Ruby [README] [ruby-readme].

## Usage: Python

Create a new instance of a Referer object by passing in the url you want to parse:

```python
from referer_parser import Referer

referer_url = 'http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari'

r = Referer(referer_url)
```

The `r` variable now holds a Referer instance.  The important attributes are:

```python
print(r.known)              # True
print(r.referer)            # 'Google'
print(r.medium)             # 'search'
print(r.search_parameter)   # 'q'     
print(r.search_term)        # 'gateway oracle cards denise linn'
print(r.uri)                # ParseResult(scheme='http', netloc='www.google.com', path='/search', params='', query='q=gateway+oracle+cards+denise+linn&hl=en&client=safari', fragment='')
```

Optionally, pass in the current URL as well, to handle internal referers

```python
from referer_parser import Referer

referer_url = 'http://www.snowplowanalytics.com/about/team'
curr_url = 'http://www.snowplowanalytics.com/account/profile'

r = Referer(referer_url, curr_url)
```

For more information, please see the Python [README] [python-readme].

## Usage: node.js

The node.js (JavaScript) version of this library uses a hybrid of the new and old API, and identifies search, social, webmail, internal and unknown referers:

Create a new instance of a Referer object by passing in the url you want to parse:

```js
var Referer = require('referer-parser')

referer_url = 'http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari'

var r = new Referer(referer_url)
```

The `r` variable now holds a Referer instance.

Optionally, pass in the current URL as well, to handle internal referers

```js
var Referer = require('referer-parser')

var referer_url = 'http://www.snowplowanalytics.com/about/team'
var current_url = 'http://www.snowplowanalytics.com/account/profile'

var r = Referer(referer_url, current_url)
```

For more information, please see the node.js [README] [nodejs-readme].

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

## Usage: PHP

The PHP version of this library uses the updated API, and identifies search, social, webmail, internal and unknown referers:

```php
use Snowplow\RefererParser\Parser;

$parser = new Parser();
$referer = $parser->parse(
    'http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari',
    'http:/www.psychicbazaar.com/shop'
);

if ($referer->isKnown()) {
    echo $referer->getMedium(); // "Search"
    echo $referer->getSource(); // "Google"
    echo $referer->getTerm();   // "gateway oracle cards denise linn"
}
```

For more information, please see the PHP [README] [php-readme].

## Usage: Go

The Go version of this library uses the updated API:

```go
package main

import (
  "log"

  "github.com/snowplow/referer-parser/go"
)

func main() {
  referer_url := "http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari"
  r := refererparser.Parse(referer_url)

  log.Printf("Known:%v", r.Known)
  log.Printf("Referer:%v", r.Referer)
  log.Printf("Medium:%v", r.Medium)
  log.Printf("Search parameter:%v", r.SearchParameter)
  log.Printf("Search term:%v", r.SearchTerm)
  log.Printf("Host:%v", r.URI)
}

```

For more information, please see the Go [README] [go-readme]

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
2. **Ports of referer-parser to other languages** - we welcome ports of referer-parser to new programming languages (e.g. Lua, Go, Haskell, C)
3. **Bug fixes, feature requests etc** - much appreciated!

**Please sign the [Snowplow CLA] [cla] before making pull requests.**

## Support

General support for referer-parser is handled by the team at Snowplow Analytics Ltd.

You can contact the Snowplow Analytics team through any of the [channels listed on their wiki] [talk-to-us].

## Copyright and license

`referers.yml` is based on [Piwik's] [piwik] [`SearchEngines.php`] [piwik-search-engines] and [`Socials.php`] [piwik-socials], copyright 2012 Matthieu Aubry and available under the [GNU General Public License v3] [gpl-license].

The Ruby implementation is copyright 2014 Inside Systems, Inc and is available under the [Apache License, Version 2.0] [apache-license].

The Java/Scala port is copyright 2012-2014 [Snowplow Analytics Ltd] [snowplow-analytics] and is available under the [Apache License, Version 2.0] [apache-license].

The Python port is copyright 2012-2014 [Don Spaulding] [donspaulding] and is available under the [Apache License, Version 2.0] [apache-license].

The node.js (JavaScript) port is copyright 2013-2014 [Martin Katrenik] [mkatrenik] and is available under the [Apache License, Version 2.0] [apache-license].

The .NET (C#) port is copyright 2013-2014 [iPerform Software] [iperform] and is available under the [Apache License, Version 2.0] [apache-license].

The PHP port is copyright 2013-2014 [Lars Strojny] [tsileo] and is available under the [MIT License] [mit-license].

The Go port is copyright 2014 [Thomas Sileo] [lstrojny] and is available under the [MIT License] [mit-license].

[ua-parser]: https://github.com/tobie/ua-parser

[snowplow]: https://github.com/snowplow/snowplow
[snowplow-analytics]: http://snowplowanalytics.com
[donspaulding]: https://github.com/donspaulding
[swijnands]: https://github.com/swijnands
[mkatrenik]: https://github.com/mkatrenik
[iperform]: http://www.iperform.nl/
[lstrojny]: https://github.com/lstrojny
[tsileo]: https://github.com/tsileo
[kreynolds]: https://github.com/kreynolds

[piwik]: http://piwik.org
[piwik-search-engines]: https://github.com/piwik/piwik/blob/master/core/DataFiles/SearchEngines.php
[piwik-socials]: https://github.com/piwik/piwik/blob/master/core/DataFiles/Socials.php

[ruby-readme]: https://github.com/snowplow/referer-parser/blob/master/ruby/README.md
[java-scala-readme]: https://github.com/snowplow/referer-parser/blob/master/java-scala/README.md
[python-readme]: https://github.com/snowplow/referer-parser/blob/master/python/README.md
[nodejs-readme]: https://github.com/snowplow/referer-parser/blob/master/nodejs/README.md
[dotnet-readme]: https://github.com/snowplow/referer-parser/blob/master/dotnet/README.md
[php-readme]: https://github.com/snowplow/referer-parser/blob/master/php/README.md
[go-readme]: https://github.com/snowplow/referer-parser/blob/master/go/README.md
[referers-yml]: https://github.com/snowplow/referer-parser/blob/master/resources/referers.yml

[talk-to-us]: https://github.com/snowplow/snowplow/wiki/Talk-to-us

[apache-license]: http://www.apache.org/licenses/LICENSE-2.0
[gpl-license]: http://www.gnu.org/licenses/gpl-3.0.html
[mit-license]: http://opensource.org/licenses/MIT
[cla]: https://github.com/snowplow/snowplow/wiki/CLA
