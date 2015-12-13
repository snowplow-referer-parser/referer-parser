<?php
namespace Snowplow\RefererParser\Tests\Config;

use Snowplow\RefererParser\Config\YamlConfigReader;

class YamlConfigReaderTest extends AbstractConfigReaderTest
{
    protected function createConfigReader($fileName)
    {
        return new YamlConfigReader($fileName);
    }
    
    protected function createConfigReaderFromFile()
    {
        return $this->createConfigReader(__DIR__ . '/../../../../../data/referers.yml');
    }
}
