<?php
namespace Snowplow\ReferrerParser\Config;

use Symfony\Component\Yaml\Yaml;

class YamlConfigReader implements ConfigReaderInterface
{
    /** @var string */
    private $fileName;

    /** @var array */
    private $referrers = [];

    public function __construct($fileName)
    {
        $this->fileName = $fileName;
    }

    private function read()
    {
        if ($this->referrers) {
            return;
        }

        $hash = Yaml::parse(file_get_contents($this->fileName));

        foreach ($hash as $medium => $referrers) {
            foreach ($referrers as $source => $referrer) {
                foreach ($referrer['domains'] as $domain) {
                    $this->referrers[$domain] = [
                        'source'     => $source,
                        'medium'     => $medium,
                        'parameters' => isset($referrer['parameters']) ? $referrer['parameters'] : [],
                    ];
                }
            }
        }
    }

    public function lookup($hostName)
    {
        $this->read();

        return isset($this->referrers[$hostName]) ? $this->referrers[$hostName] : null;
    }
}
