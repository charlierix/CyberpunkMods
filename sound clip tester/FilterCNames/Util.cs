using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Media;

namespace FilterCNames
{
    public static class Util
    {
        public static string CleanInputLine(string line)
        {
            if (string.IsNullOrWhiteSpace(line))
                return null;

            string retVal = line.
                Replace("\"", "").
                Replace(",", "").
                Trim();

            if (!Regex.IsMatch(retVal, @"^\w+$"))
                retVal = null;

            return retVal;
        }

        public static string[] Filter(IEnumerable<string> source, string filter, bool isRegex)
        {
            return source.
                Where(o => IsMatch(o, filter, isRegex)).
                Distinct().
                Select(o => "\"" + o + "\",").
                ToArray();
        }

        public static string[] RandomOrder(string[] items)
        {
            var retVal = new List<string>();

            foreach (int index in RandomRange(0, items.Length))
            {
                retVal.Add(items[index]);
            }

            return retVal.ToArray();
        }

        /// <summary>
        /// This is just a wrapper to the color converter (why can't they have a method off the color class with all
        /// the others?)
        /// </summary>
        public static Color ColorFromHex(string hexValue)
        {
            string final = hexValue;

            if (!final.StartsWith("#"))
            {
                final = "#" + final;
            }

            if (final.Length == 4)      // compressed format, no alpha
            {
                // #08F -> #0088FF
                final = new string(new[] { '#', final[1], final[1], final[2], final[2], final[3], final[3] });
            }
            else if (final.Length == 5)     // compressed format, has alpha
            {
                // #8A4F -> #88AA44FF
                final = new string(new[] { '#', final[1], final[1], final[2], final[2], final[3], final[3], final[4], final[4] });
            }

            return (Color)ColorConverter.ConvertFromString(final);
        }
        public static string ColorToHex(Color color, bool includeAlpha = true, bool includePound = true)
        {
            // I think color.ToString does the same thing, but this is explicit
            return string.Format("{0}{1}{2}{3}{4}",
                includePound ? "#" : "",
                includeAlpha ? color.A.ToString("X2") : "",
                color.R.ToString("X2"),
                color.G.ToString("X2"),
                color.B.ToString("X2"));
        }

        #region Private Methods

        private static bool IsMatch(string input, string filter, bool isRegex)
        {
            if(!isRegex)
                return input.Contains(filter, StringComparison.OrdinalIgnoreCase);

            try
            {
                return Regex.IsMatch(input, filter, RegexOptions.IgnoreCase);
            }
            catch (Exception)
            {
                return false;
            }
        }

        /// <summary>
        /// This acts like Enumerable.Range, but the values returned are in a random order
        /// </summary>
        private static IEnumerable<int> RandomRange(int start, int count)
        {
            // Prepare a list of indices (these represent what's left to return)
            //int[] indices = Enumerable.Range(start, count).ToArray();		// this is a smaller amount of code, but slower
            int[] indices = new int[count];
            for (int cntr = 0; cntr < count; cntr++)
            {
                indices[cntr] = start + cntr;
            }

            Random rand = StaticRandom.GetRandomForThread();

            for (int cntr = count - 1; cntr >= 0; cntr--)
            {
                // Come up with a random value that hasn't been returned yet
                int index1 = rand.Next(cntr + 1);
                int index2 = indices[index1];
                indices[index1] = indices[cntr];

                yield return index2;
            }
        }

        #endregion
    }
}
