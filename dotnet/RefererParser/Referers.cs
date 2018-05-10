using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;

namespace RefererParser
{

    public class Referers
    {
        public static Referers<RefererMedium> Catalog;

        static Referers()
        {
            Catalog = new Referers<RefererMedium>();    
        }        
    }
    
    /// <summary>
    /// Referer definition catalog
    /// </summary>
    public class Referers<T> where T: struct, IComparable, IFormattable, IConvertible
    {
    
        
        private readonly Lazy<ILookup<string, RefererDefinition<T>>> _catalog;
        private readonly string _srcString;

        /// <summary>
        /// Look up a referer definition in the catalog
        /// </summary>
        /// <param name="domain">Domain name of referer to look up.</param>
        /// <returns>Referer definitions for the given domain or an empty array when no matching definitions are found.</returns>
        public RefererDefinition<T>[] this[string domain]
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
        public Referers()
        {
            _catalog = new Lazy<ILookup<string, RefererDefinition<T>>>(Initialize, LazyThreadSafetyMode.PublicationOnly);
            _srcString = Encoding.UTF8.GetString(Resources.referers);
        }

        /// <summary>
        /// Initialize referer catalog.
        /// Load referer definitions from embedded referer resource file.
        /// </summary>
        ILookup<string, RefererDefinition<T>> Initialize()
        {
//            // Parse referer json definition file
//            var q = from category in JObject.Parse(_srcString).Properties()
//                    from definition in ((JObject)category.Value).Properties()
//                    let domains = definition.Value["domains"] as JArray
//                    let parameters = definition.Value["parameters"] as JArray
//                    select new RefererDefinition<T>
//                    {
//                        Medium = ParseMedium(category.Name),
//                        Name =  definition.Name,
//                        Domains = domains != null ? domains.Values<string>().ToArray() : new string[0],
//                        Parameters = parameters != null ? parameters.Values<string>().ToArray() : new string[0],
//                    };
            
            
            var deserializer = new DeserializerBuilder()
                .WithNamingConvention(new CamelCaseNamingConvention())
                .Build();

            // todo: this is insane and ugly, but just trying it out.
            var result =
                deserializer
                    .Deserialize<Dictionary<string, Dictionary<String, Dictionary<string, IEnumerable<string>>>>>(
                        _srcString);
            
            var q = new List<RefererDefinition<T>>();
            foreach (var category in result)
            {
                foreach (var definition in category.Value)
                {
                    var domains = definition.Value["domains"];
                    IEnumerable<string> parameters;
                    definition.Value.TryGetValue("parameters", out parameters);
                    q.Add(
                        new RefererDefinition<T>
                        {
                            Medium = ParseMedium(category.Key),
                            Name = definition.Key,
                            Domains = domains != null ? domains.ToArray() : new string[0],
                            Parameters = parameters != null ? parameters.ToArray() : new string[0],
                        }
                    );
                }
            }
            

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
        T ParseMedium(string name)
        {
            T value;
            if (!Enum.TryParse(name, true, out value))
            {
                throw new ArgumentOutOfRangeException(nameof(name), $"Unknown referer medium type: ${name}");
            }

            return value;
        }
    }
}
