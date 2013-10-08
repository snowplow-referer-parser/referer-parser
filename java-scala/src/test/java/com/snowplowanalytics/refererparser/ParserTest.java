package com.snowplowanalytics.refererparser;

import static org.junit.Assert.assertEquals;

import java.io.IOException;
import java.net.URISyntaxException;

import org.junit.Before;
import org.junit.Test;

public class ParserTest {

    private Parser parser;

    @Before
    public void createParser() throws CorruptYamlException, IOException {
        parser = new Parser();
    }

    @Test
    public void domainWithAnyPrefixAndPath() throws URISyntaxException {
        String referer = "http://test.orange.fr/webmail";
        Referer actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("orange_mail", actual.source);
        referer = "http://orange.fr/webmail";
        actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("orange_mail", actual.source);
    }

    @Test
    public void domainWithAnyPrefixAndSuffix() throws URISyntaxException {
        String referer = "http://both.com";
        Referer actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("Both", actual.source);
        referer = "http://pre.both.com";
        actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("Both", actual.source);
    }

    @Test
    public void domainWithAnyPrefixAndSuffixAndPath() throws URISyntaxException {
        String referer = "http://google.co.uk/bookmarks";
        Referer actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("google_bookmarks", actual.source);
        referer = "http://test.google.co.uk/bookmarks";
        actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("google_bookmarks", actual.source);
    }

    @Test
    public void domainWithAnySubdomain() throws URISyntaxException {
        String referer = "http://mail.twitter.com";
        Referer actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("Twitter", actual.source);
        referer = "http://mail.twitter.com.uk";
        actual = parser.parse(referer, "");
        assertEquals(Medium.UNKNOWN, actual.medium);
        assertEquals("", actual.source);
        referer = "http://twitter.com.uk";
        actual = parser.parse(referer, "");
        assertEquals(Medium.UNKNOWN, actual.medium);
        assertEquals("", actual.source);
    }

    @Test
    public void domainWithAnySuffix() throws URISyntaxException {
        String referer = "http://post.com";
        Referer actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("Post", actual.source);
        referer = "http://pre.post.com";
        actual = parser.parse(referer, "");
        assertEquals(Medium.UNKNOWN, actual.medium);
        assertEquals("", actual.source);
    }

    @Test
    public void domainWithAnySuffixAndPath() throws URISyntaxException {
        String referer = "http://google.co.uk/products";
        Referer actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("Google Product Search", actual.source);
        referer = "http://test.google.co.uk/products";
        actual = parser.parse(referer, "");
        assertEquals(Medium.UNKNOWN, actual.medium);
        assertEquals("", actual.source);
    }

    @Test
    public void simple() throws URISyntaxException {
        String referer = "http://facebook.com";
        Referer actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("Facebook", actual.source);
        referer = "http://fb.me";
        actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("Facebook", actual.source);
    }

    @Test
    public void subdomainAllowAll() throws URISyntaxException {
        String referer = "http://mail.bing.com";
        Referer actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("Bing", actual.source);
        referer = "http://mail.b.co";
        actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("Bing", actual.source);
    }

    @Test
    public void subdomainAllowOne() throws URISyntaxException {
        String referer = "http://mail.yandex.com";
        Referer actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("Yandex", actual.source);
        referer = "http://mail.y.co";
        actual = parser.parse(referer, "");
        assertEquals(Medium.SOCIAL, actual.medium);
        assertEquals("Yandex", actual.source);
        referer = "http://new.mail.y.co";
        actual = parser.parse(referer, "");
        assertEquals(Medium.UNKNOWN, actual.medium);
        assertEquals("", actual.source);
    }

    @Test
    public void subdomainEmpty() throws URISyntaxException {
        String referer = "http://mail.google.com";
        Referer actual = parser.parse(referer, "");
        assertEquals(Medium.UNKNOWN, actual.medium);
        assertEquals("", actual.source);
        referer = "http://mail.g.co";
        actual = parser.parse(referer, "");
        assertEquals(Medium.UNKNOWN, actual.medium);
        assertEquals("", actual.source);
    }
}