using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace StringReplace_VeryLargeFiles
{
    public partial class FindDistinctStrings : Window
    {
        #region Declaration Section

        private readonly DropShadowEffect _errorEffect;

        #endregion

        #region Constructor

        public FindDistinctStrings()
        {
            InitializeComponent();

            Background = SystemColors.ControlBrush;

            _errorEffect = new DropShadowEffect()
            {
                Color = ColorFromHex("C02020"),
                Direction = 0,
                ShadowDepth = 0,
                BlurRadius = 8,
                Opacity = .8,
            };
        }

        #endregion

        #region Event Listeners

        private void txtFindWhat_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                RefreshScan();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void chkCaseSensitive_Checked(object sender, RoutedEventArgs e)
        {
            try
            {
                RefreshScan();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void chkRegex_Checked(object sender, RoutedEventArgs e)
        {
            try
            {
                RefreshScan();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void txtSource_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                RefreshScan();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private void RefreshScan()
        {
            string[] source = txtSource.Text.
                Replace("\r\n", "\n").
                Split('\n', StringSplitOptions.RemoveEmptyEntries);

            string[] results = null;
            try
            {
                results = GetMatches(source, txtFindWhat.Text, chkCaseSensitive.IsChecked.Value, chkRegex.IsChecked.Value);
            }
            catch (Exception)
            {
                txtFindWhat.Effect = _errorEffect;
                txtResults.Text = "";
                return;
            }

            txtFindWhat.Effect = null;

            var distinct = results.
                    Distinct().
                    OrderBy(o => o);

            txtResults.Text = string.Join("\r\n", distinct);
        }

        private static string[] GetMatches(string[] source, string find, bool caseSensitive, bool isRegex)
        {
            if (string.IsNullOrEmpty(find))
                return source;

            if (isRegex)
                return GetMatches_Regex(source, find, caseSensitive);
            else
                return GetMatches_Regex(source, Regex.Escape(find), caseSensitive);
        }

        private static string[] GetMatches_Regex(string[] source, string find, bool caseSensitive)
        {
            var retVal = new List<string>();

            RegexOptions options = caseSensitive ?
                RegexOptions.None :
                RegexOptions.IgnoreCase;

            foreach (string line in source)
            {
                foreach (Match match in Regex.Matches(line, find, options))
                {
                    retVal.Add(match.Value);
                }
            }

            return retVal.ToArray();
        }

        /// <summary>
        /// This is just a wrapper to the color converter (why can't they have a method off the color class with all
        /// the others?)
        /// </summary>
        private static Color ColorFromHex(string hexValue)
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
        private static string ColorToHex(Color color, bool includeAlpha = true, bool includePound = true)
        {
            // I think color.ToString does the same thing, but this is explicit
            return string.Format("{0}{1}{2}{3}{4}",
                includePound ? "#" : "",
                includeAlpha ? color.A.ToString("X2") : "",
                color.R.ToString("X2"),
                color.G.ToString("X2"),
                color.B.ToString("X2"));
        }

        #endregion
    }
}
