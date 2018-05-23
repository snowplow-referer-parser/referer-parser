using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;

namespace RefererParser
{
  
    /// <summary>
    /// Referer definition catalog
    /// </summary>
    public class Referers<T> where T: struct, IComparable, IFormattable, IConvertible
    {
    
        
        private readonly Lazy<ILookup<string, RefererDefinition<T>>> _catalog;
        private readonly IEnumerable<string>  _srcString;

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
        /// Creates a new instance of the referers catalog object
        /// </summary>
        /// <param name="srcStrings">Additional referer files to parse.</param>
        public Referers(IEnumerable<string> srcStrings)
        {
            _catalog = new Lazy<ILookup<string, RefererDefinition<T>>>(Initialize, LazyThreadSafetyMode.PublicationOnly);
            _srcString = srcStrings;
        }

        /// <summary>
        /// Initialize referer catalog.
        /// Load referer definitions from embedded referer resource file.
        /// </summary>
        ILookup<string, RefererDefinition<T>> Initialize()
        {
            var deserializer = new DeserializerBuilder()
                .WithNamingConvention(new CamelCaseNamingConvention())
                .Build();


            var finalLookupHolder = new List<Tuple<string, RefererDefinition<T>>>();
            foreach (var srcString in _srcString)
            {
                var result =
                    deserializer
                        .Deserialize<Dictionary<string, Dictionary<string, Dictionary<string, IEnumerable<string>>>>>(
                            srcString);

                var q = new List<RefererDefinition<T>>();
                if (result != null)
                {
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
                                    Domains = domains?.ToArray() ?? new string[0],
                                    Parameters = parameters?.ToArray() ?? new string[0],
                                }
                            );
                        }
                    }
                }


                // Flatten referer definition, list a definition per domain
                var allDomainsPerDefinition = from definition in q
                    from domain in definition.Domains
                    select new Tuple<string, RefererDefinition<T>>(domain, definition);

                finalLookupHolder.AddRange(allDomainsPerDefinition);
            }

            // Generate a dictionary mapping of domains (case-insensitive) => referer definitions
            return finalLookupHolder.ToLookup(pair => pair.Item1, pair => pair.Item2, StringComparer.OrdinalIgnoreCase);
        }

        /// <summary>
        /// Parse a referer medium/category type
        /// </summary>
        /// <param name="name">Name to parse</param>
        /// <returns>A referer medium value</returns>
        public T ParseMedium(string name)
        {
            T value;
            if (!Enum.TryParse(name, true, out value))
            {
                throw new ArgumentOutOfRangeException(nameof(name), $"Unknown referer medium type: {name}");
            }

            return value;
        }
    }
}
