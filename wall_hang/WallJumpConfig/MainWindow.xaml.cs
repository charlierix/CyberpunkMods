using Game.Math_WPF.WPF;
using System;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media.Effects;
using WallJumpConfig.Models.wpf;

namespace WallJumpConfig
{
    public partial class MainWindow : Window
    {
        #region record: WindowSettings

        private record WindowSettings
        {
            public string ModFolder { get; init; }

            public double? Width { get; init; }
            public double? Height { get; init; }

            public string PresetName { get; init; }
        }

        #endregion
        #region record: PresetEntry

        private record PresetEntry
        {
            public string Name { get; init; }
            public SaveWPF Settings { get; init; }
        }

        #endregion

        #region Declaration Section

        private readonly string _folder_presets;

        private readonly DropShadowEffect _errorEffect;

        private readonly string _settingsFilename;
        private WindowSettings _settings = null;

        private PresetEntry[] _presets = null;

        #endregion

        #region Constructor

        public MainWindow()
        {
            InitializeComponent();

            Background = SystemColors.ControlBrush;

            _errorEffect = new DropShadowEffect()
            {
                Color = UtilityWPF.ColorFromHex("C02020"),
                Direction = 0,
                ShadowDepth = 0,
                BlurRadius = 8,
                Opacity = .8,
            };

            string folder_exe = Environment.CurrentDirectory;
            _settingsFilename = System.IO.Path.Combine(folder_exe, "window settings.json");
            _folder_presets = System.IO.Path.Combine(folder_exe, "presets");
        }

        #endregion

        #region Event Listeners

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                PopulateNamesCombo();


                LoadSettings();

                txtModFolder_TextChanged(this, null);       // make sure "" is highlighted red
                expanderFolder.IsExpanded = txtModFolder.Text == "";
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            try
            {
                SaveSettings();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Window_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                if (Keyboard.Modifiers == ModifierKeys.Control && e.Key == Key.S)
                    SaveSession();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void txtModFolder_PreviewDragEnter(object sender, DragEventArgs e)
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
        private void txtModFolder_Drop(object sender, DragEventArgs e)
        {
            try
            {
                string[] filenames = e.Data.GetData(DataFormats.FileDrop) as string[];

                if (filenames == null || filenames.Length == 0)
                {
                    MessageBox.Show("No folders selected", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                else if (filenames.Length > 1)
                {
                    MessageBox.Show("Only one folder allowed", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                txtModFolder.Text = filenames[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void expanderFolder_ExpandedCollapsed(object sender, RoutedEventArgs e)
        {
            const string HEADER = "mod folder";

            try
            {
                if (expanderFolder.IsExpanded)
                {
                    expanderFolder.Header = "";
                    expanderFolder.ToolTip = $"hide {HEADER}";
                    panelFolder.Visibility = Visibility.Visible;

                    Grid.SetRow(content_grid, 2);
                    Grid.SetRowSpan(content_grid, 1);
                }
                else
                {
                    expanderFolder.Header = HEADER;
                    expanderFolder.ToolTip = null;
                    panelFolder.Visibility = Visibility.Collapsed;

                    Grid.SetRow(content_grid, 0);
                    Grid.SetRowSpan(content_grid, 3);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void txtModFolder_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                txtModFolder.Effect = Directory.Exists(txtModFolder.Text) ?
                    null :
                    _errorEffect;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Save_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                SaveSession();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private void SaveSettings()
        {
            var settings = (_settings ?? new WindowSettings()) with
            {
                ModFolder = txtModFolder.Text,
                PresetName = cboName.Text,
            };

            if (WindowState == WindowState.Normal)
            {
                settings = settings with
                {
                    Width = Width,
                    Height = Height,
                };
            }

            var options = new JsonSerializerOptions()
            {
                WriteIndented = true,
            };

            string serialized = JsonSerializer.Serialize(settings, options);

            File.WriteAllText(_settingsFilename, serialized);
        }
        private void LoadSettings()
        {
            if (!File.Exists(_settingsFilename))
                return;

            try
            {
                string jsonString = System.IO.File.ReadAllText(_settingsFilename);

                var settings = JsonSerializer.Deserialize<WindowSettings>(jsonString);

                txtModFolder.Text = settings.ModFolder;

                if (settings.Width != null && settings.Height != null)
                {
                    Width = settings.Width.Value;
                    Height = settings.Height.Value;
                }

                cboName.Text = settings.PresetName;

                _settings = settings;
            }
            catch (Exception) { }       // ignore errors, just show the window
        }

        private void SaveSession()
        {

        }

        private void PopulateNamesCombo()
        {
            _presets = Directory.GetFiles(_folder_presets, "*.json").
                Select(o =>
                {
                    SaveWPF save = null;
                    try
                    {
                        save = JsonSerializer.Deserialize<SaveWPF>(File.ReadAllText(o));
                    }
                    catch (Exception) { }

                    return new PresetEntry()
                    {
                        Name = System.IO.Path.GetFileNameWithoutExtension(o),
                        Settings = save,
                    };
                }).
                Where(o => o.Settings != null).
                ToArray();

            cboName.Items.Clear();

            foreach (var preset in _presets)
                cboName.Items.Add(preset.Name);
        }

        #endregion
    }
}
