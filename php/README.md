# PHP referer-parser port

A port of snowplow/referer-parser for PHP.

## Usage

```php
use Snowplow\RefererParser\Parser;

$parser = new Parser();
$referer = $parser->parse('http://google.com');

if ($referer->isKnown()) {
    ...
}
```
