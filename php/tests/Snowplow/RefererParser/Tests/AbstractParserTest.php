<?php
namespace Snowplow\RefererParser\Tests;

use PHPUnit_Framework_TestCase as TestCase;
use Snowplow\RefererParser\Medium;
use Snowplow\RefererParser\Parser;

abstract class AbstractParserTest extends TestCase
{
    /** @var Parser */
    private $parser;

    public function setUp()
    {
        $this->parser = $this->createParser(['www.subdomain1.snowplowanalytics.com', 'www.subdomain2.snowplowanalytics.com']);
    }

    /**
     * @param string[] $internalHosts
     * @return Parser
     */
    abstract protected function createParser(array $internalHosts = []);

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

    public function testCustomInternalHosts()
    {
        $parser = $this->createParser(['google.com']);

        $this->assertSame(Medium::INTERNAL, $parser->parse('http://google.com')->getMedium());
        $this->assertSame(Medium::SEARCH, $this->parser->parse('http://google.com')->getMedium());
    }
}
