<?php
namespace Snowplow\RefererParser\Tests\Config;

use Snowplow\RefererParser\Config\JsonConfigReader;

class JsonConfigReaderTest extends AbstractConfigReaderTest
{
    protected function createConfigReader($fileName)
    {
        return new JsonConfigReader($fileName);
    }
}
