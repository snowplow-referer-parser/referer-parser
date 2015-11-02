# referer-parser PHP library

This is the PHP implementation of [referer-parser] [referer-parser], the library for extracting search marketing data from referer _(sic)_ URLs.

The implementation uses the shared 'database' of known referers found in [`referers.yml`] [referers-yml].

The PHP version of referer-parser is maintained by [Lars Strojny] [lstrojny].

## Installation

```
php composer.phar require snowplow/referer-parser dev-master
```

## Usage

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
    echo $referer->getSearchTerm();   // "gateway oracle cards denise linn"
}
```

## Copyright and license

The referer-parser PHP library is distributed under the MIT License.

Copyright (c) 2013 Lars Strojny.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[referer-parser]: https://github.com/snowplow/referer-parser
[referers-yml]: https://github.com/snowplow/referer-parser/blob/master/resources/referers.yml

[lstrojny]: https://github.com/lstrojny
