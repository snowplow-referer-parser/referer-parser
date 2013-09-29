<?php
namespace Snowplow\ReferrerParser\Config;

interface ConfigReaderInterface
{
    /**
     * @param string $hostName
     * @return array
     */
    public function lookup($hostName);
}
