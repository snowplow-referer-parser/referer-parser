# referer-parser .NET library

This is the .NET implementation of [referer-parser] [referer-parser], the library for extracting attribution data from referer _(sic)_ URLs.

The implementation uses the shared 'database' of known referers found in [`referers.yml`] [referers-yml].

The .NET version of referer-parser is maintained by [Sepp Wijnands] [swijnands] at [iPerform Software] [iperform].

## C\# 

### Usage

Use referer-parser in C# like this:

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

### Installation

A NuGet Package is available, under package id RefererParser.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright and license

The referer-parser .NET (C#) library is copyright 2013 [iPerform Software] [iperform].

Licensed under the [Apache License, Version 2.0] [license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[snowplow]: https://github.com/snowplow/snowplow

[referer-parser]: https://github.com/snowplow/referer-parser
[referers-yml]: https://github.com/snowplow/referer-parser/blob/master/referers.yml

[license]: http://www.apache.org/licenses/LICENSE-2.0
[iperform]: http://www.iperform.nl/
[swijnands]: https://github.com/swijnands
