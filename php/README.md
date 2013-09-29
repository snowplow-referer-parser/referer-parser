# PHP referrer-parser port

A port of snowplow/referer-parser for PHP.

## Usage

```php
use Snowplow\ReferrerParser\Parser;

$parser = new Parser();
$referrer = $parser->parse('http://google.com');

if ($referrer->isKnown()) {
    ...
}
```
