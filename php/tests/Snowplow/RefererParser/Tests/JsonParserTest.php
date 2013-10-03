<?php
namespace Snowplow\RefererParser\Tests;

use Snowplow\RefererParser\Config\JsonConfigReader;
use Snowplow\RefererParser\Parser;

class JsonParserTest extends AbstractParserTest
{
    public static function setUpBeforeClass()
    {
        static::$parserInstance = new Parser(new JsonConfigReader(__DIR__ . '/../../../../data/referers.json'));
    }
}
