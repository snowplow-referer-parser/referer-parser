<?php
namespace Snowplow\RefererParser\Config;

class JsonConfigReader implements ConfigReaderInterface
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

        $hash = json_decode(file_get_contents($this->fileName), true);

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

    public function lookup($lookupString)
    {
        $this->read();

        return isset($this->referers[$lookupString]) ? $this->referers[$lookupString] : null;
    }
}
