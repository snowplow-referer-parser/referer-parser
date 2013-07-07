using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;

namespace RefererParser
{
    /// <summary>
    /// Referer definition catalog
    /// </summary>
    public class Referers
    {
        public static readonly Referers Catalog = new Referers();
        Lazy<ILookup<string, RefererDefinition>> _catalog;
        
        /// <summary>
        /// Look up a referer definition in the catalog
        /// </summary>
        /// <param name="domain">Domain name of referer to look up.</param>
        /// <returns>Referer definitions for the given domain or an empty array when no matching definitions are found.</returns>
        public RefererDefinition[] this[string domain]
        {
            get
            {
                var result = _catalog.Value[domain];
                return result.Any() ? result.ToArray() : null;
            }
        }

        /// <summary>
        /// Private constructor, so that only one catalog can exist.
        /// </summary>
        private Referers()
        {
            _catalog = new Lazy<ILookup<string, RefererDefinition>>(() => Initialize(), LazyThreadSafetyMode.PublicationOnly);
        }

        /// <summary>
        /// Initialize referer catalog.
        /// Load referer definitions from embedded referer resource file.
        /// </summary>
        ILookup<string, RefererDefinition> Initialize()
        {
            // Parse referer json definition file
            var q = from category in JObject.Parse(Encoding.UTF8.GetString(Resources.referers)).Properties()
                    from definition in ((JObject)category.Value).Properties()
                    let domains = definition.Value["domains"] as JArray
                    let parameters = definition.Value["parameters"] as JArray
                    select new RefererDefinition
                    {
                        Medium = ParseMedium(category.Name),
                        Name =  definition.Name,
                        Domains = domains != null ? domains.Values<string>().ToArray() : new string[0],
                        Parameters = parameters != null ? parameters.Values<string>().ToArray() : new string[0],
                    };

            // Flatten referer definition, list a definition per domain
            var allDomainsPerDefinition = from definition in q
                                          from domain in definition.Domains
                                          select new
                                          {
                                              Key = domain,
                                              Definition = definition
                                          };

            // Generate a dictionary mapping of domains (case-insensitive) => referer definitions
            return allDomainsPerDefinition.ToLookup(pair => pair.Key, pair => pair.Definition, StringComparer.OrdinalIgnoreCase);
        }

        /// <summary>
        /// Parse a referer medium/category type
        /// </summary>
        /// <param name="name">Name to parse</param>
        /// <returns>A referer medium value</returns>
        RefererMedium ParseMedium(string name)
        {
            RefererMedium value;
            if (!Enum.TryParse(name, true, out value))
            {
                throw new ArgumentOutOfRangeException("name", "Unknown referer medium type: " + name);
            }

            return value;
        }
    }
}
