<?php
namespace Snowplow\RefererParser\Tests;

use Snowplow\RefererParser\Config\YamlConfigReader;
use Snowplow\RefererParser\Parser;

class YamlParserTest extends AbstractParserTest
{
    public static function setUpBeforeClass()
    {
        static::$parserInstance = new Parser(new YamlConfigReader(__DIR__ . '/../../../../data/referers.yml'));
    }
}
