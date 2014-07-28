<?php
namespace Snowplow\RefererParser;

use Snowplow\RefererParser\Config\ConfigReaderInterface;
use Snowplow\RefererParser\Config\JsonConfigReader;

class Parser
{
    /** @var ConfigReaderInterface */
    private $configReader;

    /**
     * @var string[]
     */
    private $internalHosts = [];

    public function __construct(ConfigReaderInterface $configReader = null, array $internalHosts = [])
    {
        $this->configReader = $configReader ?: static::createDefaultConfigReader();
        $this->internalHosts = $internalHosts;
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

        if ($pageUrlParts
            && $pageUrlParts['host'] === $refererParts['host']
            || in_array($refererParts['host'], $this->internalHosts)) {
            return Referer::createInternal();
        }

        $referer = $this->lookup($refererParts['host'], $refererParts['path']);

        if (!$referer) {
            return Referer::createUnknown();
        }

        $searchTerm = null;
        if ($referer['parameters']) {
            parse_str($refererParts['query'], $queryParts);
            foreach ($referer['parameters'] as $parameter) {
                $searchTerm = isset($queryParts[$parameter]) ? $queryParts[$parameter] : $searchTerm;
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

        return array_merge(['query' => null, 'path' => '/'], $parts);
    }

    private function lookup($host, $path)
    {
        $referer = $this->lookupPath($host, $path);

        if ($referer) {
            return $referer;
        }

        return $this->lookupHost($host);
    }

    private function lookupPath($host, $path)
    {
        $referer = $this->lookupHost($host, $path);

        if ($referer) {
            return $referer;
        }

        $path = substr($path, 0, strrpos($path, '/'));

        if (!$path) {
            return null;
        }

        return $this->lookupPath($host, $path);
    }

    private function lookupHost($host, $path = null)
    {
        do {
            $referer = $this->configReader->lookup($host . $path);
            $host = substr($host, strpos($host, '.') + 1);
        } while (!$referer && substr_count($host, '.') > 0);

        return $referer;
    }

    private static function createDefaultConfigReader()
    {
        return new JsonConfigReader(__DIR__ . '/../../../data/referers.json');
    }
}
