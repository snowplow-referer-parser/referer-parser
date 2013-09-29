<?php
namespace Snowplow\ReferrerParser;

use Snowplow\ReferrerParser\Config\ConfigReaderInterface;
use Snowplow\ReferrerParser\Config\YamlConfigReader;

class Parser
{
    /** @var YamlConfigReader */
    private $configReader;

    public function __construct(ConfigReaderInterface $configReader = null)
    {
        $this->configReader = $configReader ?: static::createDefaultConfigReader();
    }

    /**
     * Parse referrer URL
     *
     * @param string $referrerUrl
     * @param string $pageUrl
     * @return Referrer
     */
    public function parse($referrerUrl, $pageUrl = null)
    {
        $referrerParts = static::parseUrl($referrerUrl);
        if (!$referrerParts) {
            return Referrer::createInvalid();
        }

        $pageUrlParts = static::parseUrl($pageUrl);

        if ($pageUrlParts && $pageUrlParts['host'] === $referrerParts['host']) {
            return Referrer::createInternal();
        }

        $host = $referrerParts['host'];
        do {
            $referrer = $this->configReader->lookup($host);
        } while (!$referrer && substr_count($host, '.') > 1 && ($pos = strpos($host, '.')) && $host = substr($host, $pos + 1));

        if (!$referrer) {
            return Referrer::createUnknown();
        }

        $searchTerm = null;
        if ($referrer['parameters']) {
            parse_str($referrerParts['query'], $queryParts);
            foreach ($referrer['parameters'] as $parameter) {
                $searchTerm = isset($queryParts[$parameter]) ? $queryParts[$parameter] : null;
            }
        }

        return Referrer::createKnown($referrer['medium'], $referrer['source'], $searchTerm);
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
        return new YamlConfigReader(__DIR__ . '/../../../data/referrers.yml');
    }
}
