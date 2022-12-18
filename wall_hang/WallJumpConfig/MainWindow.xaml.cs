using Game.Math_WPF.WPF;
using System;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Effects;
using WallJumpConfig.Models.viewmodels;
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

        private void Test_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                SaveWPF sample = GetSampleSession();

                var horz_angle_0 = new NamedAngle()
                {
                    Name = "Directly Facing Wall",
                    Degrees = 0,
                    Color = "000",
                };

                var horz_angle_180 = new NamedAngle()
                {
                    Name = "Directly Away",
                    Degrees = 180,
                    Color = "FFF",
                };

                var viewmodel = new VM_Horizontal()
                {
                    DirectFaceWall = VM_Slider.FromModel(horz_angle_0),
                    DirectAway = VM_Slider.FromModel(horz_angle_180),
                };

                new VM_Horizontal();

                for(int i = 0; i < sample.Horizontal.Degrees_Extra.Length; i++)
                {
                    viewmodel.ExtraAngles.Add(VM_Slider.FromModel(sample.Horizontal.Degrees_Extra[i]));
                }

                horizontalControl.ViewModel = viewmodel;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

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

        private static SaveWPF GetSampleSession()
        {
            return new SaveWPF()
            {
                Horizontal = new SaveWPF_Horizontal()
                {
                    Degrees_Extra = new[]
                    {
                        new NamedAngle()
                        {
                            Name = "Face Wall",
                            Degrees = 20,
                            Color = "B3837F",
                        },
                        new NamedAngle()
                        {
                            Name = "Along Start",
                            Degrees = 60,
                            Color = "ADAC58",
                        },
                        new NamedAngle()
                        {
                            Name = "Along End",
                            Degrees = 120,
                            Color = "7BBDAA",
                        },
                    },

                    Props_DirectFaceWall = new PropsAtAngle()
                    {
                        Percent_Up = 0.7651404036440723,
                        Percent_Along = 0.04847767977036907,
                        Percent_Away = 0.06060892809185233,
                        YawTurn_Percent = 0,
                        Percent_Look = 0.5,
                    },

                    Props_Extra = new[]
                    {
                        new PropsAtAngle()
                        {
                            Percent_Up = 0.7439462042181489,
                            Percent_Along = 0.18559118552351608,
                            Percent_Away = 0.07197310210907464,
                            YawTurn_Percent = 0,
                            Percent_Look = 0.5,
                        },
                        new PropsAtAngle()
                        {
                            Percent_Up = 0.5704626102583347,
                            Percent_Along = 0.2083431903157424,
                            Percent_Away = 0.06362991179333226,
                            YawTurn_Percent = 0,
                            Percent_Look = 0.5,
                        },
                        new PropsAtAngle()
                        {
                            Percent_Up = 0.4272834803444462,
                            Percent_Along = 0.2999763432422181,
                            Percent_Away = 0.33000000000000007,
                            YawTurn_Percent = 0,
                            Percent_Look = 0.5,
                        },
                    },

                    Props_DirectAway = new PropsAtAngle()
                    {
                        Percent_Up = 0.23485959635592776,
                        Percent_Along = 0.4507315891675882,
                        Percent_Away = 0.719683707575183,
                        YawTurn_Percent = 0,
                        Percent_Look = 0.5,
                    },

                    Strength = 13,

                    Speed_FullStrength = 4,
                    Speed_ZeroStrength = 8,
                },

                Vertical_StraightUp = new SaveWPF_Vertical_StraightUp()
                {
                    Degrees_StraightUp = 60,
                    Degrees_Standard = 40,

                    Strength = 11,

                    Speed_FullStrength = 3,
                    Speed_ZeroStrength = 7,
                },
            };
        }

        #endregion
    }
}
