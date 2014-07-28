<?php
namespace Snowplow\RefererParser\Config;

class JsonConfigReader implements ConfigReaderInterface
{
    use ConfigFileReaderTrait {
        ConfigFileReaderTrait::init as public __construct;
    }

    protected function parse($content)
    {
        return json_decode($content, true);
    }
}
