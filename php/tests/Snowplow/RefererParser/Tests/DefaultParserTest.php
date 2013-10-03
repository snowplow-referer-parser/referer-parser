<?php
namespace Snowplow\RefererParser\Tests;

use Snowplow\RefererParser\Parser;

class DefaultParserTest extends AbstractParserTest
{
    public static function setUpBeforeClass()
    {
        static::$parserInstance = new Parser();
    }
}
