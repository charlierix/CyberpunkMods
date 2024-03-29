﻿using Game.Math_WPF.WPF;
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
using WallJumpConfig.Models.savewpf;
using WallJumpConfig.Models.savelua;
using Game.Core;
using System.Windows.Threading;

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
        #region record: CurrentViewModel

        private record CurrentViewModel
        {
            public VM_Horizontal Horizontal { get; init; }
            public VM_StraightUp StraightUp { get; init; }
        }

        #endregion

        #region Declaration Section

        private readonly string _folder_presets;
        private readonly string _folder_presets_history;

        private readonly DropShadowEffect _errorEffect;

        private readonly string _settingsFilename;
        private WindowSettings _settings = null;

        private PresetEntry[] _presets = null;

        private CurrentViewModel _viewmodel = null;

        private bool _adjusting_expander = false;

        private DispatcherTimer _popupTimer = null;

        #endregion

        #region Constructor

        public MainWindow()
        {
            InitializeComponent();

            Background = new SolidColorBrush(UtilityWPF.AlphaBlend(Colors.Black, SystemColors.ControlColor, 0.05));

            tabcontrol.Background = new SolidColorBrush(UtilityWPF.AlphaBlend(Colors.White, SystemColors.ControlColor, 0.09));

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
            _folder_presets_history = System.IO.Path.Combine(folder_exe, "presets - history");
        }

        #endregion

        #region Event Listeners

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                helpHorz.DataContext = new VM_Help() { HelpText = HelpMessages.Horizonal };
                helpVert.DataContext = new VM_Help() { HelpText = HelpMessages.Vertical };

                PopulateNamesCombo();

                LoadSettings();

                txtModFolder_TextChanged(this, null);       // make sure "" is highlighted red
                AdjustExpander(txtModFolder.Text == "");
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

        private void expanderFolderOutside_ExpandedCollapsed(object sender, RoutedEventArgs e)
        {
            try
            {
                if (_adjusting_expander)
                    return;

                AdjustExpander(expanderFolderOutside.IsExpanded);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void expanderFolderInside_ExpandedCollapsed(object sender, RoutedEventArgs e)
        {
            try
            {
                if (_adjusting_expander)
                    return;

                AdjustExpander(expanderFolderInside.IsExpanded);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void cboName_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                // Can't use cboName.Text, because it's the old value at the time this event fires
                string selected_text = cboName.SelectedValue as string;
                if (string.IsNullOrWhiteSpace(selected_text))
                    return;

                var preset = _presets.FirstOrDefault(o => o.Name == selected_text);
                if (preset != null)
                    LoadSession(preset.Settings);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void New_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                LoadSession(GetDefaultSession());
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        //NOTE: This isn't visible, since it auto loads on selection change
        private void Load_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var preset = _presets.FirstOrDefault(o => o.Name == cboName.Text);
                if (preset == null)
                {
                    MessageBox.Show("Item not found", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                LoadSession(preset.Settings);
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

        private void PopupTimer_Tick(object sender, EventArgs e)
        {
            try
            {
                _popupTimer.Stop();
                popupSaved.IsOpen = false;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void tabcontrol_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (!(e.Source is TabControl))
                    return;

                horizontalStickFigure.Visibility = tabHorizontal.IsSelected ?
                    Visibility.Visible :
                    Visibility.Collapsed;

                verticalStickFigure.Visibility = tabVertical.IsSelected ?
                    Visibility.Visible :
                    Visibility.Collapsed;
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
            try
            {
                if (!File.Exists(_settingsFilename))
                {
                    LoadSession(GetDefaultSession());
                    return;
                }

                string jsonString = System.IO.File.ReadAllText(_settingsFilename);

                var settings = JsonSerializer.Deserialize<WindowSettings>(jsonString);

                txtModFolder.Text = settings.ModFolder;

                if (settings.Width != null && settings.Height != null)
                {
                    Width = settings.Width.Value;
                    Height = settings.Height.Value;
                }

                cboName.Text = settings.PresetName;

                var preset = _presets.FirstOrDefault(o => o.Name == cboName.Text);
                if (preset != null)
                    LoadSession(preset.Settings);
                else
                    LoadSession(GetDefaultSession());

                _settings = settings;
            }
            catch (Exception) { }       // ignore errors, just show the window
        }

        private void SaveSession()
        {
            if (_viewmodel == null)
                return;

            if (!Directory.Exists(txtModFolder.Text))
            {
                MessageBox.Show("Please select the mod folder", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(cboName.Text))
            {
                MessageBox.Show("Please select a name to save as", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var options = new JsonSerializerOptions()
            {
                WriteIndented = true,
            };

            // Build snapshots
            SaveWPF savewpf = SaveWPF.FromModel(_viewmodel.Horizontal, _viewmodel.StraightUp);
            SaveLUA savelua = SaveLUA.FromModel(savewpf);

            // Save Preset
            string name = UtilityCore.EscapeFilename_Windows(cboName.Text);
            string filename = System.IO.Path.Combine(_folder_presets, name + ".json");

            string serialized = JsonSerializer.Serialize(savewpf, options);
            File.WriteAllText(filename, serialized);

            filename = System.IO.Path.Combine(_folder_presets_history, $"{name} - {DateTime.Now:yyyyMMdd HHmmss}.json");
            File.WriteAllText(filename, serialized);

            // Save lua version
            filename = System.IO.Path.Combine(txtModFolder.Text, "!settings", name + ".json");

            serialized = JsonSerializer.Serialize(savelua, options);
            File.WriteAllText(filename, serialized);

            PopulateNamesCombo();

            ShowSavedPopup();
        }
        private void LoadSession(SaveWPF model)
        {
            var horizontal = VM_Horizontal.FromModel(model.Horizontal, model.Description);
            var vertical = VM_StraightUp.FromModel(model.Vertical_StraightUp);

            horizontalControl.DataContext = horizontal;
            straightupControl.DataContext = vertical;
            txtDescription.DataContext = horizontal;

            horizontalStickFigure.ViewModelHorizontal = horizontal;
            verticalStickFigure.ViewModelStraightUp = vertical;

            circleplots.ViewModelHorizontal = horizontal;

            yawturnVisual.ViewModelHorizontal = horizontal;

            _viewmodel = new CurrentViewModel()
            {
                Horizontal = horizontal,
                StraightUp = vertical,
            };
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

            string text = cboName.Text;
            cboName.Items.Clear();

            foreach (var preset in _presets)
                cboName.Items.Add(preset.Name);

            cboName.Text = text;
        }

        private static SaveWPF GetDefaultSession()
        {
            return new SaveWPF()
            {
                Horizontal = new SaveWPF_Horizontal()
                {
                    HasHorizontal = true,

                    Degrees_Extra = new NamedAngle[0],

                    Props_DirectFaceWall = new PropsAtAngle()
                    {
                        Percent_Up = 0.75,
                        Percent_Along = 0.25,
                        Percent_Away = 0.1,
                        Percent_YawTurn = 0,
                        Percent_Look = 0.25,
                        Percent_LookStrength = 1,
                        Percent_LatchAfterJump = 1,
                        RelatchTime_Emoseconds = 1152,      // 800 dozenal, 2/3 second
                        WallAttract_DistanceMax = 8,
                        WallAttract_Accel = 8,
                        WallAttract_Pow = 3,
                        WallAttract_Antigrav = 0.75,
                    },

                    Props_DirectAway = new PropsAtAngle()
                    {
                        Percent_Up = 0,
                        Percent_Along = 0.5,
                        Percent_Away = 1,
                        Percent_YawTurn = 0,
                        Percent_Look = 0.75,
                        Percent_LookStrength = 1,
                        Percent_LatchAfterJump = 1,
                        RelatchTime_Emoseconds = 1152,
                        WallAttract_DistanceMax = 8,
                        WallAttract_Accel = 8,
                        WallAttract_Pow = 3,
                        WallAttract_Antigrav = 0.75,
                    },

                    Props_Extra = new PropsAtAngle[0],

                    Speed_FullStrength = 4,
                    Speed_ZeroStrength = 8,

                    Strength = 12,
                },

                Vertical_StraightUp = new SaveWPF_Vertical_StraightUp()
                {
                    HasStraightUp = false,

                    Degrees_StraightUp = 60,
                    Degrees_Standard = 50,

                    Strength = 11,

                    Speed_FullStrength = 3,
                    Speed_ZeroStrength = 7,

                    LatchAfterJump = true,
                    RelatchTime_Emoseconds = 1152,
                    WallAttract_DistanceMax = 8,
                    WallAttract_Accel = 8,
                    WallAttract_Pow = 3,
                    WallAttract_Antigrav = 0.75,
                },
            };
        }

        private void AdjustExpander(bool should_expand)
        {
            _adjusting_expander = true;

            if (should_expand)
            {
                expanderFolderOutside.IsExpanded = true;
                expanderFolderInside.IsExpanded = true;

                expanderFolderOutside.Visibility = Visibility.Visible;
                expanderFolderInside.Visibility = Visibility.Collapsed;

                panelFolder.Visibility = Visibility.Visible;

                Grid.SetRow(content_grid, 2);
                Grid.SetRowSpan(content_grid, 1);
            }
            else
            {
                expanderFolderOutside.IsExpanded = false;
                expanderFolderInside.IsExpanded = false;

                expanderFolderOutside.Visibility = Visibility.Collapsed;
                expanderFolderInside.Visibility = Visibility.Visible;

                panelFolder.Visibility = Visibility.Collapsed;

                Grid.SetRow(content_grid, 0);
                Grid.SetRowSpan(content_grid, 3);
            }

            _adjusting_expander = false;
        }

        private void ShowSavedPopup()
        {
            if (_popupTimer == null)
            {
                _popupTimer = new DispatcherTimer()
                {
                    Interval = TimeSpan.FromSeconds(0.5),
                    IsEnabled = false,
                };

                _popupTimer.Tick += PopupTimer_Tick;
            }

            popupSaved.IsOpen = true;

            _popupTimer.Start();
        }

        #endregion
    }
}
