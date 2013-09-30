<?php
namespace Snowplow\RefererParser\Tests;

use PHPUnit_Framework_TestCase as TestCase;
use Snowplow\RefererParser\Medium;
use Snowplow\RefererParser\Parser;

class ParserTest extends TestCase
{
    /** @var Parser */
    private $parser;

    public function setUp()
    {
        $this->parser = new Parser();
    }

    public static function getTestData()
    {
        return [
            [
                'http://co106w.col106.mail.live.com/default.aspx?rru=inbox',
                null,
                true,
                Medium::EMAIL,
                'Outlook.com',
            ],
            [
                'http://images.yandex.ru/yandsearch?text=Blue%20Angel%20Oracle%20Blue%20Angel%20Oracle&noreask=1&pos=16&rpt=simage&lr=45&img_url=http%3A%2F%2Fmdm.pbzstatic.com%2Foracles%2Fblue-angel-oracle%2Fbox-small.png',
                null,
                true,
                Medium::SEARCH,
                'Yandex Images',
                'Blue Angel Oracle Blue Angel Oracle'
            ],
            [
                'http://www.facebook.com/l.php?u=http%3A%2F%2Fwww.psychicbazaar.com&h=yAQHZtXxS&s=1',
                null,
                true,
                'social',
                'Facebook',
            ],
            [
                'http://foo.com',
                null,
                false,
                Medium::UNKNOWN
            ],
            [
                'http://m.facebook.com/l.php?u=http%3A%2F%2Fwww.psychicbazaar.com%2Fblog%2F2012%2F09%2Fpsychic-bazaar-reviews-tarot-foundations-31-days-to-read-tarot-with-confidence%2F&h=kAQGXKbf9&s=1',
                null,
                true,
                Medium::SOCIAL,
                'Facebook',
            ],
            [
                'HTTP://m.facebook.com/l.php?u=http%3A%2F%2Fwww.psychicbazaar.com%2Fblog%2F2012%2F09%2Fpsychic-bazaar-reviews-tarot-foundations-31-days-to-read-tarot-with-confidence%2F&h=kAQGXKbf9&s=1',
                null,
                true,
                Medium::SOCIAL,
                'Facebook',
            ],
            [
                'http://go.mail.ru/search?q=Gothic%20Tarot%20Cards&where=any&num=10&rch=e&sf=20',
                'invalidUrl',
                true,
                Medium::SEARCH,
                'Mail.ru',
                'Gothic Tarot Cards',
            ],
            [
                'http://url.com',
                'http://url.com/foo/bar',
                false,
                Medium::INTERNAL,
            ],
            [
                'https://url.com/path',
                'http://url.com/foo/bar',
                false,
                Medium::INTERNAL,
            ]
        ];
    }

    /** @dataProvider getTestData */
    public function testRefererParsing($refererUrl, $internalUrl, $isKnown, $medium = null, $source = null, $searchTerm = null)
    {
        $referer = $this->parser->parse($refererUrl, $internalUrl);

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
