using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RefererParser
{
    /// <summary>
    /// Referer definition for a single referer.
    /// </summary>
    public class RefererDefinition<T> where T: struct, IComparable, IFormattable, IConvertible
    {
        /// <summary>
        /// Medium of definition
        /// </summary>
        public T Medium
        {
            get;
            set;
        }

        /// <summary>
        /// Name of referer
        /// </summary>
        public string Name
        {
            get;
            set;
        }

        /// <summary>
        /// Domains belonging to this referer
        /// </summary>
        public string[] Domains
        {
            get;
            set;
        }

        /// <summary>
        /// Search parameter names in referer request string
        /// </summary>
        public string[] Parameters
        {
            get;
            set;
        }
    }
}
