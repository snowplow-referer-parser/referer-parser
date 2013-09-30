<?php
namespace Snowplow\RefererParser;

class Referer
{
    /** @var string */
    private $medium;

    /** @var string */
    private $source;

    /** @var string|null */
    private $searchTerm;

    private function __construct()
    {}

    public static function createKnown($medium, $source, $searchTerm = null)
    {
        $referer = new self();
        $referer->medium = $medium;
        $referer->source = $source;
        $referer->searchTerm = $searchTerm;

        return $referer;
    }

    public static function createUnknown()
    {
        $referer = new self();
        $referer->medium = Medium::UNKNOWN;

        return $referer;
    }

    public static function createInternal()
    {
        $referer = new self();
        $referer->medium = Medium::INTERNAL;

        return $referer;
    }

    public static function createInvalid()
    {
        $referer = new self();
        $referer->medium = Medium::INVALID;

        return $referer;
    }

    /** @return boolean */
    public function isValid()
    {
        return $this->medium !== Medium::INVALID;
    }

    /** @return boolean */
    public function isKnown()
    {
        return !in_array($this->medium, [Medium::UNKNOWN, Medium::INTERNAL, Medium::INVALID], true);
    }

    /** @return string */
    public function getMedium()
    {
        return $this->medium;
    }

    public function getSource()
    {
        return $this->source;
    }

    public function getSearchTerm()
    {
        return $this->searchTerm;
    }
}
