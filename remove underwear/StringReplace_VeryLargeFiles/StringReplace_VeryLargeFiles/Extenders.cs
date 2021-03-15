using System;
using System.Collections.Generic;
using System.Numerics;
using System.Text;
using System.Text.RegularExpressions;

namespace StringReplace_VeryLargeFiles
{
    public static class Extenders
    {
        /// <summary>
        /// This is a string.Join, but written to look like a linq statement
        /// </summary>
        public static string ToJoin(this IEnumerable<string> strings, string separator)
        {
            return string.Join(separator, strings);
        }
        public static string ToJoin(this IEnumerable<string> strings, char separator)
        {
            return string.Join(separator.ToString(), strings);
        }

        /// <summary>
        /// This is useful for displaying a double value in a textbox when you don't know the range (could be
        /// 1000001 or .1000001 or 10000.5 etc)
        /// </summary>
        public static string ToStringSignificantDigits(this double value, int significantDigits, bool shouldRound = true)
        {
            if (shouldRound)
                value = Math.Round(value, significantDigits);

            int numDecimals = GetNumDecimals(value);

            if (numDecimals < 0)
            {
                return ToStringSignificantDigits_PossibleScientific(value, significantDigits);
            }
            else
            {
                return ToStringSignificantDigits_Standard(value, significantDigits, true);
            }
        }

        #region Private Methods

        private static int GetNumDecimals(float value)
        {
            return GetNumDecimals_ToString(value.ToString(System.Globalization.CultureInfo.InvariantCulture));      // I think this forces decimal to always be a '.' ?
        }
        private static int GetNumDecimals(double value)
        {
            return GetNumDecimals_ToString(value.ToString(System.Globalization.CultureInfo.InvariantCulture));      // I think this forces decimal to always be a '.' ?
        }
        private static int GetNumDecimals(decimal value)
        {
            return GetNumDecimals_ToString(value.ToString(System.Globalization.CultureInfo.InvariantCulture));
        }
        private static int GetNumDecimals_ToString(string text)
        {
            if (Regex.IsMatch(text, "[a-z]", RegexOptions.IgnoreCase))
            {
                // This is in exponential notation, just give up (or maybe NaN)
                return -1;
            }

            int decimalIndex = text.IndexOf(".");

            if (decimalIndex < 0)
            {
                // It's an integer
                return 0;
            }
            else
            {
                // Just count the decimals
                return (text.Length - 1) - decimalIndex;
            }
        }

        private static string ToStringSignificantDigits_PossibleScientific(float value, int significantDigits)
        {
            return ToStringSignificantDigits_PossibleScientific_ToString(
                value.ToString(System.Globalization.CultureInfo.InvariantCulture),      // I think this forces decimal to always be a '.' ?
                value.ToString(),
                significantDigits);
        }
        private static string ToStringSignificantDigits_PossibleScientific(double value, int significantDigits)
        {
            return ToStringSignificantDigits_PossibleScientific_ToString(
                value.ToString(System.Globalization.CultureInfo.InvariantCulture),      // I think this forces decimal to always be a '.' ?
                value.ToString(),
                significantDigits);
        }
        private static string ToStringSignificantDigits_PossibleScientific(decimal value, int significantDigits)
        {
            return ToStringSignificantDigits_PossibleScientific_ToString(
                value.ToString(System.Globalization.CultureInfo.InvariantCulture),      // I think this forces decimal to always be a '.' ?
                value.ToString(),
                significantDigits);
        }
        private static string ToStringSignificantDigits_PossibleScientific_ToString(string textInvariant, string text, int significantDigits)
        {
            Match match = Regex.Match(textInvariant, @"^(?<num>(-|)\d\.\d+)(?<exp>E(-|)\d+)$");
            if (!match.Success)
            {
                // Unknown
                return text;
            }

            string standard = ToStringSignificantDigits_Standard(Convert.ToDouble(match.Groups["num"].Value), significantDigits, false);

            return standard + match.Groups["exp"].Value;
        }

        private static string ToStringSignificantDigits_Standard(float value, int significantDigits, bool useN)
        {
            return ToStringSignificantDigits_Standard(Convert.ToDecimal(value), significantDigits, useN);
        }
        private static string ToStringSignificantDigits_Standard(double value, int significantDigits, bool useN)
        {
            return ToStringSignificantDigits_Standard(Convert.ToDecimal(value), significantDigits, useN);
        }
        private static string ToStringSignificantDigits_Standard(decimal value, int significantDigits, bool useN)
        {
            // Get the integer portion
            //long intPortion = Convert.ToInt64(Math.Truncate(value));		// going directly against the value for this (min could go from 1 to 1000.  1 needs two decimal places, 10 needs one, 100+ needs zero)
            BigInteger intPortion = new BigInteger(Math.Truncate(value));       // ran into a case that didn't fit in a long
            int numInt;
            if (intPortion == 0)
            {
                numInt = 0;
            }
            else
            {
                numInt = intPortion.ToString().Length;
            }

            // Limit the number of significant digits
            int numPlaces;
            if (numInt == 0)
            {
                numPlaces = significantDigits;
            }
            else if (numInt >= significantDigits)
            {
                numPlaces = 0;
            }
            else
            {
                numPlaces = significantDigits - numInt;
            }

            // I was getting an exception from round, but couldn't recreate it, so I'm just throwing this in to avoid the exception
            if (numPlaces < 0)
            {
                numPlaces = 0;
            }
            else if (numPlaces > 15)
            {
                numPlaces = 15;
            }

            // Show a rounded number
            decimal rounded = Math.Round(value, numPlaces);
            int numActualDecimals = GetNumDecimals(rounded);
            if (numActualDecimals < 0 || !useN)
            {
                return rounded.ToString();		// it's weird, don't try to make it more readable
            }
            else
            {
                return rounded.ToString("N" + numActualDecimals);
            }
        }

        #endregion
    }
}
