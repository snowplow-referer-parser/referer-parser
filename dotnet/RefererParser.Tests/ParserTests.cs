using System;
using System.IO;
using System.Linq;
using Newtonsoft.Json.Linq;
using Xunit;

namespace RefererParser.Tests
{
    public class ParserTests
    {
        [Fact]
        public void TestReferers()
        {    
            var set = from test in JArray.Parse(File.ReadAllText(@"referer-tests.json"))
                    let testObj = ((JObject)test)
                    select new {
                        Name = testObj["spec"].ToString(),
                        Uri = testObj["uri"].ToString(),
                        Medium = (RefererMedium)Enum.Parse(typeof(RefererMedium), testObj["medium"].ToString(), true),
                        Source = testObj["source"].ToString(),
                        Term = testObj["term"].ToString(),
                        Known = testObj["known"].ToString(),
                    };

            foreach (var sample in set)
            {
                var result = Parser.Parse(new Uri(sample.Uri), "www.snowplowanalytics.com");
                Assert.NotNull(result);
                Assert.Equal(sample.Medium, result.Medium);
                Assert.Equal(sample.Source, result.Source ?? string.Empty);
                Assert.Equal(sample.Term, result.Term ?? string.Empty);
            }
        }

        [Fact]
        public void TestUnknownReferer()
        {
            var set = new[] 
            {
                  new 
                  { 
                      Name = "Unknown referer #1",
                      Url = "http://www.behance.net/gallery/psychicbazaarcom/2243272",
                      Source = string.Empty,
                  },
                  new 
                  {
                      Name = "Unknown referer #2",
                      Url = "http://www.wishwall.me/home",
                      Source = string.Empty,
                  },
                  new 
                  {
                      Name = "Unknown referer #3",
                      Url = "http://www.spyfu.com/domain.aspx?d=3897225171967988459",
                      Source = string.Empty,
                  },
                  new
                  {
                     Name = "Unknown referer #4",
                     Url = "http://seaqueen.wordpress.com/",
                     Source = string.Empty,
                  },
                  new 
                  {
                    Name = "Non-search Yahoo! site",
                    Url = "http://finance.yahoo.com",
                    Source = "Yahoo!",
                  },
            };

            foreach (var sample in set)
            {
                var result = Parser.Parse(new Uri(sample.Url), "www.snowplowanalytics.com");
                Assert.NotNull(result);
                Assert.Equal(sample.Source, result.Source ?? string.Empty);
            }
        }


        [Fact]
        public void TestFalsePositivies()
        {
            var set = new[] 
            {
                  new 
                  {
                      Name = "Unknown Google service",
                      Url = "http://xxx.google.com",
                      Medium = RefererMedium.Search,
                      Source = "Google",
                      Term = string.Empty
                  },
                  new
                  {
                      Name = "Unknown Yahoo! service",
                      Url = "http://yyy.yahoo.com",
                      Medium = RefererMedium.Search,
                      Source = "Yahoo!",
                      Term = string.Empty
                  },
                  new 
                  {
                      Name = "Non-search Google Drive link",
                      Url = "http://www.google.com/url?q=http://www.whatismyreferer.com/&sa=D&usg=ALhdy2_qs3arPmg7E_e2aBkj6K0gHLa5rQ",
                      Medium = RefererMedium.Search,
                      Source = "Google",
                      Term = "http://www.whatismyreferer.com/",
                  },
            };

            foreach (var sample in set)
            {
                var result = Parser.Parse(new Uri(sample.Url), "www.snowplowanalytics.com");
                Assert.NotNull(result);
                Assert.Equal(sample.Source, result.Source ?? string.Empty);
            }
        }

        private enum TestEnum
        {
            // Order is important, most important medium's first
            Search = 0,
            Paid,
            Social,
            Email,
            Unknown,
            Internal,
            Foobar
        }
        
        [Fact]
        public void TestCustomEnum()
        {
            var parser = new Parser<TestEnum>();
            var set = new[] 
            {
                new 
                {
                    Name = "Unknown Google service",
                    Url = "http://xxx.google.com",
                    Medium = TestEnum.Search,
                    Source = "Google",
                    Term = string.Empty
                },
                new
                {
                    Name = "Unknown Yahoo! service",
                    Url = "http://yyy.yahoo.com",
                    Medium = TestEnum.Search,
                    Source = "Yahoo!",
                    Term = string.Empty
                },
                new 
                {
                    Name = "Non-search Google Drive link",
                    Url = "http://www.google.com/url?q=http://www.whatismyreferer.com/&sa=D&usg=ALhdy2_qs3arPmg7E_e2aBkj6K0gHLa5rQ",
                    Medium = TestEnum.Search,
                    Source = "Google",
                    Term = "http://www.whatismyreferer.com/",
                },
            };

            foreach (var sample in set)
            {
                var result = parser.ParseReferer(new Uri(sample.Url), "www.snowplowanalytics.com");
                Assert.NotNull(result);
                Assert.Equal(sample.Source, result.Source ?? string.Empty);
            }
        }
        
        [Fact]
        public void TestCustomSrcList()
        {
            var parser = new Parser<TestEnum>(new[] {@"
foobar:
  Thrivehive:
    domains:
      - thrivehive.com"});
            var set = new[] 
            {
                new 
                {
                    Name = "Thrivehive",
                    Url = "https://thrivehive.com",
                    Medium = TestEnum.Foobar,
                    Source = "Thrivehive"
                },
            };

            foreach (var sample in set)
            {
                var result = parser.ParseReferer(new Uri(sample.Url), "www.snowplowanalytics.com");
                Assert.NotNull(result);
                Assert.Equal(sample.Source, result.Source ?? string.Empty);
            }
        }
        
        [Fact]
        public void TestCustomSrcListWithStandardEnum()
        {
            var parser = new Parser<RefererMedium>(new[] {@"
Search:
  Thrivehive:
    domains:
      - thrivehive.com"});
            var set = new[] 
            {
                new 
                {
                    Name = "Thrivehive",
                    Url = "https://thrivehive.com",
                    Medium = TestEnum.Foobar,
                    Source = "Thrivehive"
                },
            };

            foreach (var sample in set)
            {
                var result = parser.ParseReferer(new Uri(sample.Url), "www.snowplowanalytics.com");
                Assert.NotNull(result);
                Assert.Equal(sample.Source, result.Source ?? string.Empty);
            }
        }

        private enum TestInvalidEnum
        {
        }
        
        
        [Fact]
        public void TestInvalidCustomEnum()
        {
            var exception = Assert.Throws<ArgumentException>(() => new Parser<TestInvalidEnum>());
            Assert.Contains("Search", exception.Message);
            Assert.Contains("Internal", exception.Message);
            Assert.Contains("Unknown", exception.Message);
        }
    }
}
