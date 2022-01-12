using AirplaneEditor.Models;
using AirplaneEditor.Models_viewmodels;
using AirplaneEditor.Views;
using Game.Core;
using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace AirplaneEditor
{
    public partial class MainWindow : Window
    {
        #region Declaration Section

        private readonly string _settingsFilename;

        private PlanePart_VM _root = null;

        private Viewer _viewer = null;
        private ForcesViewer _forcesViewer = null;

        private string _folder = null;

        #endregion

        #region Constructor

        public MainWindow()
        {
            InitializeComponent();

            Background = SystemColors.ControlBrush;

            _settingsFilename = System.IO.Path.Combine(Environment.CurrentDirectory, "last run.json");
        }

        #endregion

        #region Event Listeners

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                LoadSettings();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Window_Closed(object sender, EventArgs e)
        {
            try
            {
                SaveSettings();

                if (_viewer != null)
                    _viewer.Close();

                if (_forcesViewer != null)
                    _forcesViewer.Close();
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
                txtName.Text = "new aircraft";

                _root = new PlanePart_Fuselage_VM()
                {
                    Name = "root",
                    IsCenterline = true,
                };

                Blackboard.NewPlaneCreated(_root);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Load_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                using (var dialog = new System.Windows.Forms.OpenFileDialog()
                {
                    CheckPathExists = true,
                    CheckFileExists = true,
                })
                {
                    if (!string.IsNullOrWhiteSpace(_folder) && Directory.Exists(_folder))
                        dialog.InitialDirectory = _folder;

                    var result = dialog.ShowDialog();

                    if (result != System.Windows.Forms.DialogResult.OK)
                        return;

                    _folder = System.IO.Path.GetDirectoryName(dialog.FileName);

                    string jsonString = System.IO.File.ReadAllText(dialog.FileName);

                    var aircraft = JsonSerializer.Deserialize<Models.Airplane>(jsonString);

                    var vm = Util_ToModel.FromModel(aircraft);

                    txtName.Text = vm.name;
                    _root = vm.root;
                    Blackboard.NewPlaneCreated(_root);
                }
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
                if (_root == null)
                    return;

                // Convert to model
                var model = Util_ToModel.ToModel(_root, txtName.Text);

                // Get folder
                if (string.IsNullOrWhiteSpace(_folder) || !Directory.Exists(_folder))
                {
                    using (var dialog = new System.Windows.Forms.FolderBrowserDialog()
                    {
                        Description = "Save Folder",
                        ShowNewFolderButton = true,
                    })
                    {
                        var result = dialog.ShowDialog();

                        if (result != System.Windows.Forms.DialogResult.OK)
                            return;

                        _folder = dialog.SelectedPath;
                    }
                }

                // Get filename
                string filename = DateTime.Now.ToString("yyyyMMdd HHmmss");
                filename = UtilityCore.EscapeFilename_Windows(txtName.Text.Trim()) + " - " + filename;
                filename = System.IO.Path.Combine(_folder, filename + ".json");

                // Save File
                var options = new JsonSerializerOptions()
                {
                    WriteIndented = true,
                };

                string serialized = JsonSerializer.Serialize(model, options);

                File.WriteAllText(filename, serialized);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Viewer_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (_viewer == null)        // the user can close the viewer any time they want
                {
                    _viewer = new Viewer();
                    _viewer.Closed += Viewer_Closed;

                    _viewer.Show();
                }
                else
                {
                    _viewer.Activate();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Viewer_Closed(object sender, EventArgs e)
        {
            try
            {
                _viewer.Closed -= Viewer_Closed;
                _viewer = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ForcesViewer_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (_forcesViewer == null)        // the user can close the viewer any time they want
                {
                    _forcesViewer = new ForcesViewer();
                    _forcesViewer.Closed += ForcesViewer_Closed;

                    _forcesViewer.Show();
                }
                else
                {
                    _forcesViewer.Activate();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void ForcesViewer_Closed(object sender, EventArgs e)
        {
            try
            {
                _forcesViewer.Closed -= ForcesViewer_Closed;
                _forcesViewer = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Test_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (_root == null)
                {
                    MessageBox.Show("Need to create a plane first", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var model = Util_ToModel.ToModel(_root, "");

                string json = JsonSerializer.Serialize(model);

                var sim = new Flight.FlightSim();
                sim.LoadAirplane(json);
                sim.Show();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void UnitTests_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                new UnitTestes().Show();
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
            var settings = new SerializedLastRun()
            {
                Folder = _folder,
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

                _folder = settings.Folder;
            }
            catch (Exception) { }       // ignore errors, just show the window
        }

        #endregion
    }
}
