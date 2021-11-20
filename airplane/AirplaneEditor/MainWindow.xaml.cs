using AirplaneEditor.Models_viewmodels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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

        private PlanePart _root = null;

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
                _root = new PlanePart()
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

                // convert to json



            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region THROW AWAY

        private void Inertia1_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                Util_InertiaTensor.ShapeBase[] shapes = new[]
                {
                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 1,
                    },
                };

                var result = Util_InertiaTensor.GetInertiaTensor(shapes);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Inertia2_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                Util_InertiaTensor.ShapeBase[] shapes = new[]
                {
                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 1,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0, 0, 0),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 0.25,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-0.7, 1, 0),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 0.25,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(1.5, 1, 0),
                            Q = Quaternion.Identity,
                        },
                    },
                };

                var result = Util_InertiaTensor.GetInertiaTensor(shapes);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion
    }
}
