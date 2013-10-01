<?php
namespace Snowplow\RefererParser\Config;

interface ConfigReaderInterface
{
    /**
     * @param string $hostName
     * @return array
     */
    public function lookup($hostName);
}
