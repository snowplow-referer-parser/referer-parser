<?php
namespace Snowplow\RefererParser\Config;

use Symfony\Component\Yaml\Yaml;

class YamlConfigReader implements ConfigReaderInterface
{
    /** @var string */
    private $fileName;

    /** @var array */
    private $referers = [];

    public function __construct($fileName)
    {
        $this->fileName = $fileName;
    }

    private function read()
    {
        if ($this->referers) {
            return;
        }

        $hash = Yaml::parse(file_get_contents($this->fileName));

        foreach ($hash as $medium => $referers) {
            foreach ($referers as $source => $referer) {
                foreach ($referer['domains'] as $domain) {
                    $this->referers[$domain] = [
                        'source'     => $source,
                        'medium'     => $medium,
                        'parameters' => isset($referer['parameters']) ? $referer['parameters'] : [],
                    ];
                }
            }
        }
    }

    public function lookup($hostName)
    {
        $this->read();

        return isset($this->referers[$hostName]) ? $this->referers[$hostName] : null;
    }
}
