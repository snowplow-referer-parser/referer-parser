<?php
namespace Snowplow\RefererParser\Config;

use Symfony\Component\Yaml\Yaml;

class YamlConfigReader implements ConfigReaderInterface
{
    use ConfigFileReaderTrait {
        ConfigFileReaderTrait::init as public __construct;
    }

    protected function parse($content)
    {
        return Yaml::parse($content);
    }
}
