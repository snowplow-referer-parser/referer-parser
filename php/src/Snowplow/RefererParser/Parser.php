<?php
namespace Snowplow\RefererParser;

use Snowplow\RefererParser\Config\ConfigReaderInterface;
use Snowplow\RefererParser\Config\YamlConfigReader;

class Parser
{
    /** @var YamlConfigReader */
    private $configReader;

    public function __construct(ConfigReaderInterface $configReader = null)
    {
        $this->configReader = $configReader ?: static::createDefaultConfigReader();
    }

    /**
     * Parse referer URL
     *
     * @param string $refererUrl
     * @param string $pageUrl
     * @return Referer
     */
    public function parse($refererUrl, $pageUrl = null)
    {
        $refererParts = static::parseUrl($refererUrl);
        if (!$refererParts) {
            return Referer::createInvalid();
        }

        $pageUrlParts = static::parseUrl($pageUrl);

        if ($pageUrlParts && $pageUrlParts['host'] === $refererParts['host']) {
            return Referer::createInternal();
        }

        $host = $refererParts['host'];
        do {
            $referer = $this->configReader->lookup($host);
        } while (!$referer && substr_count($host, '.') > 1 && ($pos = strpos($host, '.')) && $host = substr($host, $pos + 1));

        if (!$referer) {
            return Referer::createUnknown();
        }

        $searchTerm = null;
        if ($referer['parameters']) {
            parse_str($refererParts['query'], $queryParts);
            foreach ($referer['parameters'] as $parameter) {
                $searchTerm = isset($queryParts[$parameter]) ? $queryParts[$parameter] : null;
            }
        }

        return Referer::createKnown($referer['medium'], $referer['source'], $searchTerm);
    }

    private static function parseUrl($url)
    {
        if ($url === null) {
            return null;
        }

        $parts = parse_url($url);
        if (!isset($parts['scheme']) || !in_array(strtolower($parts['scheme']), ['http', 'https'])) {
            return null;
        }

        return $parts;
    }

    private static function createDefaultConfigReader()
    {
        return new YamlConfigReader(__DIR__ . '/../../../data/referers.yml');
    }
}
