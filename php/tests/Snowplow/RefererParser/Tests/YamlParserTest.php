<?php
namespace Snowplow\RefererParser\Tests;

use Snowplow\RefererParser\Config\YamlConfigReader;
use Snowplow\RefererParser\Parser;

class YamlParserTest extends AbstractParserTest
{
    private static $reader;

    public static function setUpBeforeClass()
    {
        static::$reader = new YamlConfigReader(__DIR__ . '/../../../../data/referers.yml');
    }

    protected function createParser(array $internalHosts = [])
    {
        return new Parser(static::$reader, $internalHosts);
    }
}
