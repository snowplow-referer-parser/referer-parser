<?php
namespace Snowplow\RefererParser\Tests;

use Snowplow\RefererParser\Config\JsonConfigReader;
use Snowplow\RefererParser\Parser;

class JsonParserTest extends AbstractParserTest
{
    protected function createParser(array $internalHosts = [])
    {
        return new Parser(new JsonConfigReader(__DIR__ . '/../../../../data/referers.json'), $internalHosts);
    }
}
