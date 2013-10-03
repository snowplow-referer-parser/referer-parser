<?php
namespace Snowplow\RefererParser\Tests;

use Snowplow\RefererParser\Parser;

class DefaultParserTest extends AbstractParserTest
{
    protected function createParser(array $internalHosts = [])
    {
        return new Parser(null, $internalHosts);
    }
}
