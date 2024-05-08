using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Xml.Linq;
using Shared.resources;

namespace Shared
{
    public static class Utils
    {
        private static readonly Logger Log = LogManager.GetCurrentClassLogger();

        public static T[] CommaToArray<T>(this string x)
        {
            if (typeof(T) == typeof(ushort)) return x.Split(',').Select(_ => (T)(object)(ushort)GetInt(_.Trim())).ToArray();

            if (typeof(T) == typeof(string)) return x.Split(',').Select(_ => (T)(object)_.Trim()).ToArray();
            else return x.Split(',').Select(_ => (T)(object)GetInt(_.Trim())).ToArray();
        }
        public static string FirstCharToUpper(string input)
        {
            switch (input)
            {
                case null:
                    throw new ArgumentNullException(nameof(input));
                case "":
                    throw new ArgumentException($"{nameof(input)} cannot be empty", nameof(input));
                default:
                    return input.First().ToString().ToUpper() + input.Substring(1);
            }
        }
        public static byte[] Deflate(byte[] src)
        {
            byte[] zipBytes;

            using (var dst = new MemoryStream())
            {
                using (var df = new DeflateStream(dst, CompressionMode.Compress))
                    df.Write(src, 0, src.Length);

                zipBytes = dst.ToArray();
            }

            return zipBytes;
        }

        public static T FromJson<T>(string json) where T : class
        {
            if (string.IsNullOrWhiteSpace(json)) return null;

            var jsonSerializer = new JsonSerializer();

            using (var strRdr = new StringReader(json))
            using (var jsRdr = new JsonTextReader(strRdr))
                return jsonSerializer.Deserialize<T>(jsRdr);
        }

        public static int FromString(string x)
        {
            var val = 0;
            try
            {
                val = x.StartsWith("0x") ? int.Parse(x.Substring(2), NumberStyles.HexNumber) : int.Parse(x);
            }
            catch { }

            return val;
        }

        public static DateTime FromUnixTimestamp(int time)
        {
            var dateTime = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
            dateTime = dateTime.AddSeconds(time).ToLocalTime();
            return dateTime;
        }

        public static string GetAssemblyDirectory()
        {
            var codeBase = Assembly.GetExecutingAssembly().CodeBase;
            var uri = new UriBuilder(codeBase);
            var path = Uri.UnescapeDataString(uri.Path);
            return Path.GetDirectoryName(path);
        }

        public static T GetAttribute<T>(this XElement e, string n, T def = default)
        {
            if (e.Attribute(n) == null) return def;

            var val = e.Attribute(n).Value;
            var t = typeof(T);

            if (t == typeof(string)) return (T)Convert.ChangeType(val, t);
            else if (t == typeof(ushort)) return (T)Convert.ChangeType(Convert.ToUInt16(val, 16), t);
            else if (t == typeof(int)) return (T)Convert.ChangeType(GetInt(val), t);
            else if (t == typeof(uint)) return (T)Convert.ChangeType(Convert.ToUInt32(val, 16), t);
            else if (t == typeof(double)) return (T)Convert.ChangeType(double.Parse(val, CultureInfo.InvariantCulture), t);
            else if (t == typeof(float)) return (T)Convert.ChangeType(float.Parse(val, CultureInfo.InvariantCulture), t);
            else if (t == typeof(bool)) return (T)Convert.ChangeType(string.IsNullOrWhiteSpace(val) || bool.Parse(val), t);
            else if (t == typeof(byte)) return (T)Convert.ChangeType(byte.Parse(val), t);

            Log.Error(string.Format("Type of {0} is not supported by this method, returning default value: {1}...", t, def));

            return def;
        }

        public static string GetBuildConfiguration()
        {
            string buildConfig;
#if DEBUG
            buildConfig = "debug";
#else
            buildConfig = "release";
#endif
            return buildConfig;
        }

        public static string GetDescription(this Enum value)
        {
            var type = value.GetType();
            var name = Enum.GetName(type, value);

            if (name != null)
            {
                var field = type.GetField(name);

                if (field != null)
                {
                    var attr = Attribute.GetCustomAttribute(field, typeof(DescriptionAttribute)) as DescriptionAttribute;
                    return attr?.Description;
                }
            }

            return null;
        }

        public static ConditionEffectIndex GetEffect(string val)
            => (ConditionEffectIndex)Enum.Parse(typeof(ConditionEffectIndex), val.Replace(" ", ""));

        public static int GetInt(string x) => x.Contains("x") ? Convert.ToInt32(x, 16) : int.Parse(x);

        public static T GetValue<T>(this XElement e, string n, T def = default)
        {
            if (e.Element(n) == null)
                return def;

            var val = e.Element(n).Value;
            var t = typeof(T);

            if (t == typeof(string))
                return (T)Convert.ChangeType(val, t);
            else if (t == typeof(ushort))
                return (T)Convert.ChangeType(Convert.ToUInt16(val, 16), t);
            else if (t == typeof(int))
                return (T)Convert.ChangeType(GetInt(val), t);
            else if (t == typeof(uint))
                return (T)Convert.ChangeType(Convert.ToUInt32(val, 16), t);
            else if (t == typeof(double))
                return (T)Convert.ChangeType(double.Parse(val, CultureInfo.InvariantCulture), t);
            else if (t == typeof(float))
                return (T)Convert.ChangeType(float.Parse(val, CultureInfo.InvariantCulture), t);
            else if (t == typeof(bool))
                return (T)Convert.ChangeType(string.IsNullOrWhiteSpace(val) || bool.Parse(val), t);
            Log.Error(string.Format("Type of {0} is not supported by this method, returning default value: {1}...", t, def));
            return def;
        }

        public static byte[] GZipCompress(this byte[] buffer)
        {
            using (var stream = new MemoryStream())
            using (var zip = new GZipStream(stream, CompressionMode.Compress))
            {
                zip.Write(buffer, 0, buffer.Length);
                zip.Close();
                return stream.ToArray();
            }
        }

        public static byte[] GZipDecompress(this byte[] buffer)
        {
            using (var zipStream = new MemoryStream(buffer))
            using (var stream = new MemoryStream())
            using (var unzip = new GZipStream(zipStream, CompressionMode.Decompress))
            {
                unzip.CopyTo(stream);
                return stream.ToArray();
            }
        }

        public static bool HasAttribute(this XElement e, string name) => e.Attribute(name) != null;
        public static bool HasAttribute(this XElement e, string name, out XAttribute attribute)
        {
            attribute = e.Attribute(name);
            return attribute != null;
        }

        public static bool HasElement(this XElement e, string name) => e.Element(name) != null;
        public static bool HasElement(this XElement e, string name, out XElement element)
        {
            element = e.Element(name);
            return element != null;
        }

        public static bool Invoke(bool showException, Action action)
        {
            try
            {
                action.Invoke();
                return true;
            }
            catch (Exception e)
            {
                if (showException) Log.Error(e.ToString());

                return false;
            }
        }

        public static bool IsInt(this string str) => int.TryParse(str, out int dummy);

        public static bool IsValidEmail(string strIn)
        {
            var invalid = false;

            if (string.IsNullOrEmpty(strIn)) return false;

            string domainMapper(Match match)
            {
                // IdnMapping class with default property values.
                var idn = new IdnMapping();
                var domainName = match.Groups[2].Value;

                try { domainName = idn.GetAscii(domainName); }
                catch (ArgumentException) { invalid = true; }

                return match.Groups[1].Value + domainName;
            }

            // Use IdnMapping class to convert Unicode domain names.
            strIn = Regex.Replace(strIn, @"(@)(.+)$", domainMapper);

            if (invalid) return false;

            // Return true if strIn is in valid e-mail format.
            return Regex.IsMatch(
                strIn,
                @"^(?("")(""[^""]+?""@)|(([0-9a-z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-z])@))" +
                @"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-z][-\w]*[0-9a-z]*\.)+[a-z0-9]{2,17}))$",
                RegexOptions.IgnoreCase
            );
        }

        public static T NextLength<T>(this Random rand, IList<T> list) => list.Count == 0 ? default : list[rand.Next(list.Count)];
        public static T NextLength<T>(this Random rand, T[] array) => array.Length == 0 ? default : array[rand.Next(array.Length)];

        public static string Read(string p)
        {
            var ret = "";

            Invoke(true, () => ret = File.ReadAllText(p));

            return ret;
        }

        public static void ReadAfter(string p, Action<string> c)
        {
            var ret = "";

            Invoke(true, () => ret = File.ReadAllText(p));

            c.Invoke(ret);
        }

        public static async Task<string> ReadAsync(string p)
        {
            var t1 = Task.Run(() =>
            {
                var ret = "";

                Invoke(true, () => ret = File.ReadAllText(p));

                return ret;
            });

            await t1;

            return t1.Result;
        }

        public static byte[] ReadBytes(string p)
        {
            var ret = new byte[0];

            Invoke(true, () => ret = File.ReadAllBytes(p));

            return ret;
        }

        public static T[] ResizeArray<T>(T[] array, int newSize)
        {
            var inventory = new T[newSize];
            for (int i = 0; i < array.Length; i++) 
                inventory[i] = array[i];
            return inventory;
        }

        public static byte[] SHA1(string val)
        {
            var sha1 = new SHA1Managed();
            return sha1.ComputeHash(Encoding.UTF8.GetBytes(val));
        }

        public static void Shuffle<T>(this IList<T> list)
        {
            var provider = new RNGCryptoServiceProvider();
            var n = list.Count;

            while (n > 1)
            {
                var box = new byte[1];

                do provider.GetBytes(box);
                while (!(box[0] < n * (byte.MaxValue / n)));

                var k = box[0] % n;
                n--;
                T value = list[k];
                list[k] = list[n];
                list[n] = value;
            }
        }

        public static IEnumerable<IEnumerable<T>> Split<T>(this T[] array, int size)
        {
            for (var i = 0; i < (float)array.Length / size; i++)
                yield return array.Skip(i * size).Take(size);
        }

        // https://www.codeproject.com/Articles/770323/How-to-Convert-a-Date-Time-to-X-minutes-ago-in-Csh
        public static string TimeAgo(DateTime dt)
        {
            var span = DateTime.Now - dt;

            if (span.Days > 365)
            {
                var years = span.Days / 365;

                if (span.Days % 365 != 0) years += 1;

                return $"{years} {(years == 1 ? "year" : "years")} ago";
            }

            if (span.Days > 30)
            {
                var months = span.Days / 30;

                if (span.Days % 31 != 0) months += 1;

                return $"{months} {(months == 1 ? "month" : "months")} ago";
            }

            if (span.Days > 0) return $"{span.Days} {(span.Days == 1 ? "day" : "days")} ago";

            if (span.Hours > 0) return $"{span.Hours} {(span.Hours == 1 ? "hour" : "hours")} ago";

            if (span.Minutes > 0) return $"{span.Minutes} {(span.Minutes == 1 ? "minute" : "minutes")} ago";

            if (span.Seconds > 5) return $"{span.Seconds} seconds ago";

            if (span.Seconds <= 5) return "just now";

            return string.Empty;
        }

        public static string To4Hex(this ushort x) => "0x" + x.ToString("x4");

        public static string ToCommaSepString<T>(this T[] arr)
        {
            var ret = new StringBuilder();
            for (var i = 0; i < arr.Length; i++)
            {
                if (i != 0)
                    ret.Append(", ");
                _ = ret.Append(arr[i].ToString());
            }
            return ret.ToString();
        }

        public static string ToCommaDotSepString<T>(this T[] arr)
        {
            var ret = new StringBuilder();

            for (var i = 0; i < arr.Length; i++)
            {
                if (i != 0) ret.Append(";");

                ret.Append(arr[i].ToString());
            }

            return ret.ToString();
        }

        public static int ToInt32(this string str) => GetInt(str);

        public static int ToUnixTimestamp(this DateTime dateTime) => (int)(dateTime - new DateTime(1970, 1, 1)).TotalSeconds;
    }
}
