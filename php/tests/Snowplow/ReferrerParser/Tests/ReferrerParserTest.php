<?php
namespace Snowplow\ReferrerParser\Tests;

use PHPUnit_Framework_TestCase as TestCase;
use Snowplow\ReferrerParser\Medium;
use Snowplow\ReferrerParser\Parser;

class ReferrerParser extends TestCase
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
    public function testReferrerParsing($referrerUrl, $internalUrl, $isKnown, $medium = null, $source = null, $searchTerm = null)
    {
        $referrer = $this->parser->parse($referrerUrl, $internalUrl);

        $this->assertTrue($referrer->isValid());
        $this->assertSame($isKnown, $referrer->isKnown());
        $this->assertSame($source, $referrer->getSource());
        $this->assertSame($medium, $referrer->getMedium());
        $this->assertSame($searchTerm, $referrer->getSearchTerm());
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
    public function testHandleErrors($referrerUrl, $internalUrl)
    {
        $referrer = $this->parser->parse($referrerUrl, $internalUrl);
        $this->assertFalse($referrer->isValid());
        $this->assertFalse($referrer->isKnown());
    }
}
