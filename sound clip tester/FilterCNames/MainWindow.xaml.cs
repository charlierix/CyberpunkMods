using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace FilterCNames
{
    public partial class MainWindow : Window
    {
        #region enum: SortType

        private enum SortType
        {
            Ascending,
            Descending,
            Random,
        }

        #endregion

        #region Declaration Section

        private string _inputFile = null;

        private List<string> _source = new List<string>();
        private List<string> _results = new List<string>();

        private readonly string _settingsFilename;

        private readonly DropShadowEffect _errorEffect;

        private bool _initialized = false;

        #endregion

        #region Constructor

        public MainWindow()
        {
            InitializeComponent();

            Background = SystemColors.ControlBrush;

            _errorEffect = new DropShadowEffect()
            {
                Color = Util.ColorFromHex("C02020"),
                Direction = 0,
                ShadowDepth = 0,
                BlurRadius = 8,
                Opacity = .8,
            };

            _settingsFilename = System.IO.Path.Combine(Environment.CurrentDirectory, "last run.json");

            foreach (SortType type in Enum.GetValues(typeof(SortType)))
            {
                cboSort.Items.Add(type);
            }

            cboSort.SelectedIndex = 0;
        }

        #endregion

        #region Event Listeners

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                LoadSettings();

                _initialized = true;

                RefreshResults();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void txtSource_PreviewDragEnter(object sender, DragEventArgs e)
        {
            if (e.Data.GetDataPresent(DataFormats.FileDrop))
            {
                e.Effects = DragDropEffects.Copy;
            }
            else
            {
                e.Effects = DragDropEffects.None;
            }

            e.Handled = true;
        }
        private void txtSource_Drop(object sender, DragEventArgs e)
        {
            try
            {
                string[] filenames = e.Data.GetData(DataFormats.FileDrop) as string[];

                if (filenames == null || filenames.Length == 0)
                {
                    MessageBox.Show("No files selected", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                else if (filenames.Length > 1)
                {
                    MessageBox.Show("Only one file allowed", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                _inputFile = filenames[0];

                LoadInputFile();
                SaveSettings();
                RefreshResults();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void cboSort_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (!_initialized)
                    return;

                RefreshResults();
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
                if (!_initialized)
                    return;

                RefreshResults();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void txtFilter_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                if (!_initialized)
                    return;

                RefreshResults();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Copy_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                Clipboard.SetText(txtResults.Text);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private void RefreshResults()
        {
            // Validate Regex
            if(chkRegex.IsChecked.Value)
            {
                try
                {
                    Regex.IsMatch("hello", txtFilter.Text, RegexOptions.IgnoreCase);
                }
                catch(Exception ex)
                {
                    txtFilter.Effect = _errorEffect;
                    _results.Clear();
                    txtResults.Text = "";
                    lblCountPrompt.Visibility = Visibility.Collapsed;
                    lblCount.Text = ex.Message;
                    return;
                }
            }

            lblCountPrompt.Visibility = Visibility.Visible;
            txtFilter.Effect = null;

            // Filter
            string[] results = Util.Filter(_source, txtFilter.Text, chkRegex.IsChecked.Value);

            // Sort
            IEnumerable<string> sorted = null;

            SortType sort = (SortType)cboSort.SelectedValue;
            switch (sort)
            {
                case SortType.Ascending:
                    sorted = results.
                        OrderBy(o => o);
                    break;

                case SortType.Descending:
                    sorted = results.
                        OrderByDescending(o => o);
                    break;

                case SortType.Random:
                    sorted = Util.RandomOrder(results);
                    break;
            }

            // Store results
            _results.Clear();
            _results.AddRange(sorted);

            txtResults.Text = string.Join("\r\n", _results);

            lblCount.Text = _results.Count.ToString("N0");
        }

        private void LoadInputFile()
        {
            txtSource.Text = "";
            _source.Clear();

            if (_inputFile == null || !File.Exists(_inputFile))
                return;

            StringBuilder contents = new StringBuilder();

            using (StreamReader reader = new StreamReader(new FileStream(_inputFile, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)))
            {
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    string cleaned = Util.CleanInputLine(line);

                    if (cleaned != null)
                    {
                        contents.AppendLine(cleaned);
                        _source.Add(cleaned);
                    }
                }
            }

            txtSource.Text = contents.ToString();
        }

        private void SaveSettings()
        {
            var settings = new SerializedLastRun()
            {
                InputFile = _inputFile,
            };

            var options = new JsonSerializerOptions()
            {
                WriteIndented = true,
            };

            string serialized = JsonSerializer.Serialize<SerializedLastRun>(settings, options);

            File.WriteAllText(_settingsFilename, serialized);
        }
        private void LoadSettings()
        {
            if (!File.Exists(_settingsFilename))
                return;

            try
            {
                string jsonString = System.IO.File.ReadAllText(_settingsFilename);

                SerializedLastRun settings = JsonSerializer.Deserialize<SerializedLastRun>(jsonString);

                _inputFile = settings.InputFile;

                LoadInputFile();
            }
            catch (Exception) { }       // ignore errors, just show the window
        }

        #endregion
    }
}
