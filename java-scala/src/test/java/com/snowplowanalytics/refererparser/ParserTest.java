package com.snowplowanalytics.refererparser;

import static org.junit.Assert.assertEquals;

import java.io.IOException;
import java.net.URISyntaxException;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

public class ParserTest {

    private Parser parser;

    @Before
    public void createParser() throws CorruptYamlException, IOException {
        parser = new Parser();
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
    public void subdomainEmpty() throws URISyntaxException {
        String referer = "http://mail.google.com";
        Referer actual = parser.parse(referer, "");
        assertEquals(Medium.UNKNOWN, actual.medium);
        assertEquals("http://mail.google.com", actual.source);
        referer = "http://mail.g.co";
        actual = parser.parse(referer, "");
        assertEquals(Medium.UNKNOWN, actual.medium);
        assertEquals("http://mail.g.co", actual.source);
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
        assertEquals("http://new.mail.y.co", actual.source);
    }
}