using Newtonsoft.Json;
using RefererParser;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Web;

namespace RefererParser
{
    /// <summary>
    /// Parse URL referers
    /// </summary>
    public static class Parser
    {
        /// <summary>
        /// Parse referer and return keyword information if available.
        /// </summary>
        /// <param name="refererUri">Uri to parse</param>
        /// <param name="pageHost">(optional)Host name of website</param>
        /// <returns></returns>
        public static Referer Parse(Uri refererUri, string pageHost = "")
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
                    return new Referer
                    {
                        Medium = RefererMedium.Internal
                    };
                }

                var referer = LookupReferer(refererUri.Host, refererUri.AbsolutePath, true) ??
                              LookupReferer(refererUri.Host, refererUri.AbsolutePath, false);

                if (referer == null || !referer.Any())
                {
                    return new Referer
                    {
                        Medium = RefererMedium.Unknown
                    };
                }
                else
                {
                    var term = string.Empty;
                    var first = referer
                        .OrderBy(r => r.Medium)
                        .First();

                    if (first.Medium == RefererMedium.Search)
                    {
                        term = ExtractSearchTerm(refererUri, first.Parameters); 
                    }

                    return new Referer
                    {
                        Medium = first.Medium,
                        Source = first.Name,
                        Term = term
                    };
                }
            }
        }

        private static RefererDefinition[] LookupReferer(string refererHost, string refererPath, bool includePath)
        {

            // Check if domain + full path matches, e.g. apollo.tv/portal/search/
            var referer = includePath ? Referers.Catalog[refererHost + refererPath] : Referers.Catalog[refererHost];

            // Check if domain+one-level path matches, e.g. for orange.fr/webmail/fr_FR/read.html (in our YAML it's orange.fr/webmail)
            if (includePath && referer == null)
            {
                var pathElements = refererPath.Split('/');
                if (pathElements.Length > 1)
                {
                    referer = Referers.Catalog[refererHost + "/" + pathElements[1]];
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

        private static string ExtractSearchTerm(Uri refererUri, string[] possibleParameters)
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
