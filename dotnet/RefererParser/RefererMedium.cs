using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RefererParser
{
    /// <summary>
    /// Referer medium
    /// </summary>
    public enum RefererMedium
    {
        // Order is important, most important medium's first
        Search = 0,
        Paid,
        Social,
        Email,
        Unknown,
        Internal
    }
}
