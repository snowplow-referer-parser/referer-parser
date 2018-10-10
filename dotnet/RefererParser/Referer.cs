using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RefererParser
{
    /// <summary>
    /// Referer definition
    /// </summary>
    public class Referer<T>  where T: struct, IComparable, IFormattable, IConvertible
    {
        /// <summary>
        /// Referer medium
        /// </summary>
        public T Medium
        {
            get;
            set;
        }

        /// <summary>
        /// Source of referer
        /// </summary>
        public string Source
        {
            get;
            set;
        }

        /// <summary>
        /// Search keywords if available
        /// </summary>
        public string Term
        {
            get;
            set;
        }
    }
}
