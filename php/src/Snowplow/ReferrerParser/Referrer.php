<?php
namespace Snowplow\ReferrerParser;

class Referrer
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
        $referrer = new self();
        $referrer->medium = $medium;
        $referrer->source = $source;
        $referrer->searchTerm = $searchTerm;

        return $referrer;
    }

    public static function createUnknown()
    {
        $referrer = new self();
        $referrer->medium = Medium::UNKNOWN;

        return $referrer;
    }

    public static function createInternal()
    {
        $referrer = new self();
        $referrer->medium = Medium::INTERNAL;

        return $referrer;
    }

    public static function createInvalid()
    {
        $referrer = new self();
        $referrer->medium = Medium::INVALID;

        return $referrer;
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
