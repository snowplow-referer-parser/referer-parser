using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace RefererParser
{

    public class Parser : Parser<RefererMedium>
    {
        private Parser(IEnumerable<string> srcString = null, bool ignoreResource = false) : base(srcString,
            ignoreResource)
        {
            
        }
        
        private static readonly Parser<RefererMedium> _Parser;

        static Parser()
        {
            _Parser = new Parser<RefererMedium>();
        }

        public static Referer<RefererMedium> Parse(Uri refererUri, string pageHost = "")
        {
            return _Parser.ParseReferer(refererUri, pageHost);
        }
    }
    /// <summary>
    /// Parse URL referers
    /// </summary>
    public class Parser<T>  where T: struct, IComparable, IFormattable, IConvertible
    {

        private readonly T _internalMedium;
        private readonly T _searchMedium;
        private readonly T _unknownMedium;
        
        public Parser(IEnumerable<string> srcString=null, bool ignoreResource=false)
        {
            var mySrcString = new List<string>();
            if (srcString != null)
            {
                mySrcString.AddRange(srcString);
            }
            if (!ignoreResource)
            {
                mySrcString.Add(Encoding.UTF8.GetString(Resources.referers));
            }
            this.RefererCatalog = new Referers<T>(mySrcString);
            var media = MakeMedia(RefererMedium.Internal, RefererMedium.Search, RefererMedium.Unknown);
            this._internalMedium = media.Item1;
            this._searchMedium = media.Item2;
            this._unknownMedium = media.Item3;
        }

        public Referers<T> RefererCatalog { get; set; }

        /// <summary>
        /// Parse referer and return keyword information if available.
        /// </summary>
        /// <param name="refererUri">Uri to parse</param>
        /// <param name="pageHost">(optional)Host name of website</param>
        /// <returns></returns>
        public Referer<T> ParseReferer(Uri refererUri, string pageHost = "")
        {
            if (refererUri == null)
            {
                throw new NullReferenceException("No refererUri supplied!");
            }

            if (refererUri.Scheme.ToLower() != "http" && refererUri.Scheme.ToLower() != "https")
            {
                return null;
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(pageHost) && string.Compare(pageHost, refererUri.Host) == 0)
                {
                    return new Referer<T>
                    {
                        Medium = _internalMedium
                    };
                }

                var referer = LookupReferer(refererUri.Host, refererUri.AbsolutePath, true) ??
                              LookupReferer(refererUri.Host, refererUri.AbsolutePath, false);

                if (referer == null || !referer.Any())
                {
                    return new Referer<T>
                    {
                        Medium = _unknownMedium
                    };
                }
                else
                {
                    var term = string.Empty;
                    var first = referer
                        .OrderBy(r => r.Medium)
                        .First();

                    if (first.Medium.Equals(_searchMedium))
                    {
                        term = ExtractSearchTerm(refererUri, first.Parameters); 
                    }

                    return new Referer<T>
                    {
                        Medium = first.Medium,
                        Source = first.Name,
                        Term = term
                    };
                }
            }
        }
        
        private Tuple<T,T,T> MakeMedia(RefererMedium @internal, RefererMedium search, RefererMedium unknown)
        {
            T convertedInternal;
            T convertedSearch;
            T convertedUnknown;
            var internalSuccess = TryMakeMedium(@internal, out convertedInternal);
            var searchSuccess = TryMakeMedium(search, out convertedSearch);
            var unknownSuccess = TryMakeMedium(unknown, out convertedUnknown);
            if (internalSuccess && searchSuccess && unknownSuccess)
            {
                return new Tuple<T, T, T>(convertedInternal, convertedSearch, convertedUnknown);
            }

            var errorString = new StringBuilder("Supplied enum missing values for: ");
            if (!internalSuccess)
            {
                errorString.Append("Internal ");
            }
            if (!searchSuccess)
            {
                errorString.Append("Search ");
            }
            if (!unknownSuccess)
            {
                errorString.Append("Unknown ");
            }

            throw new ArgumentException(errorString.ToString());
        }
        
        private static bool TryMakeMedium(RefererMedium medium, out T result)
        {
            return Enum.TryParse(medium.ToString(), true, out result);
        }

        private RefererDefinition<T>[] LookupReferer(string refererHost, string refererPath, bool includePath)
        {

            // Check if domain + full path matches, e.g. apollo.tv/portal/search/
            var referer = includePath ? RefererCatalog[refererHost + refererPath] : RefererCatalog[refererHost];

            // Check if domain+one-level path matches, e.g. for orange.fr/webmail/fr_FR/read.html (in our YAML it's orange.fr/webmail)
            if (includePath && referer == null)
            {
                var pathElements = refererPath.Split('/');
                if (pathElements.Length > 1)
                {
                    referer = RefererCatalog[refererHost + "/" + pathElements[1]];
                }
            }

            if (referer == null)
            {
                int index = refererHost.IndexOf('.');
                if (index >= 0)
                {
                    referer = LookupReferer(refererHost.Substring(index + 1), refererPath, includePath);
                }
            }

            return referer;
        }

        private string ExtractSearchTerm(Uri refererUri, string[] possibleParameters)
        {
            var @params = HttpUtility.ParseQueryString(refererUri.Query);

            foreach (string key in @params.AllKeys.Where(k => !string.IsNullOrWhiteSpace(k)))
            {
                if (possibleParameters.Contains(key.ToLower()))
                {
                    return @params[key];
                }
            }

            return null;
        }
    }
}
