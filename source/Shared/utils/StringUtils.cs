using System;
using System.Linq;

namespace Shared.utils
{
    public static class StringUtils
    {
        public static bool ContainsIgnoreCase(this string self, string val)
            => self.IndexOf(val, StringComparison.InvariantCultureIgnoreCase) != -1;

        public static bool EqualsIgnoreCase(this string self, string val)
            => self.Equals(val, StringComparison.InvariantCultureIgnoreCase);

        public static bool StartsWithIgnoreCase(this string self, string val)
             => self.StartsWith(val, StringComparison.InvariantCultureIgnoreCase);

        public static byte[] StringToByteArray(string hex)
            => Enumerable.Range(0, hex.Length)
            .Where(x => x % 2 == 0)
            .Select(x => Convert.ToByte(hex.Substring(x, 2), 16))
            .ToArray();
    }
}
