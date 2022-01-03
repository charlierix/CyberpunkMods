using AirplaneEditor.Models;
using AirplaneEditor.Models_viewmodels;
using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
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

        private PlanePart_VM _root = null;

        private Viewer _viewer = null;

        #endregion

        #region Constructor

        public MainWindow()
        {
            InitializeComponent();

            Background = SystemColors.ControlBrush;
        }

        #endregion

        #region Event Listeners

        private void Window_Closed(object sender, EventArgs e)
        {
            try
            {
                if (_viewer != null)
                    _viewer.Close();
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
                _root = new PlanePart_Fuselage_VM()
                {
                    PartType = PlanePartType.Fuselage,
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

        private void Test_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (_root == null)
                {
                    MessageBox.Show("Need to create a plane first", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var model = Util_ToModel.BuildModel(_root);

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
    }
}
