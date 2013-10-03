<?php
namespace Snowplow\RefererParser\Tests;

use PHPUnit_Framework_TestCase as TestCase;
use Snowplow\RefererParser\Medium;
use Snowplow\RefererParser\Parser;

class ParserTest extends TestCase
{
    /** @var Parser */
    private $parser;

    private static $parserInstance;

    public static function setUpBeforeClass()
    {
        static::$parserInstance = new Parser();
    }

    public function setUp()
    {
        $this->parser = static::$parserInstance;
    }

    public static function getTestData()
    {
        $data = json_decode(file_get_contents(__DIR__ . '/referer-tests.json'), true);

        $arguments = [];
        foreach ($data as $case) {
            $arguments[] = array_values($case);
        }

        return $arguments;
    }

    /** @dataProvider getTestData */
    public function testRefererParsing($_, $refererUrl, $medium, $source, $searchTerm, $isKnown)
    {
        $referer = $this->parser->parse($refererUrl, 'http://www.snowplowanalytics.com/');

        $this->assertTrue($referer->isValid());
        $this->assertSame($isKnown, $referer->isKnown());
        $this->assertSame($source, $referer->getSource());
        $this->assertSame($medium, $referer->getMedium());
        $this->assertSame($searchTerm, $referer->getSearchTerm());
    }

    public static function getErrorData()
    {
        return [
            ['ftp://google.com', null],
            [null, null],
            ['invalidString', 'http://google.de'],
        ];
    }

    /** @dataProvider getErrordata */
    public function testHandleErrors($refererUrl, $internalUrl)
    {
        $referer = $this->parser->parse($refererUrl, $internalUrl);
        $this->assertFalse($referer->isValid());
        $this->assertFalse($referer->isKnown());
    }
}
