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
using System.Windows.Shapes;

namespace AirplaneEditor
{
    public partial class UnitTestes : Window
    {
        public UnitTestes()
        {
            InitializeComponent();

            Background = SystemColors.ControlBrush;
        }

        private void Inertia_Sphere_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 1,
                    },
                };

                var result = Util_InertiaTensor.GetInertiaTensor(shapes);

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, result);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Inertia_Box_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(0.3 / 2d, 1.8 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0, 0, 0),
                            Q = new Quaternion(new Vector3D(0,0,1), 30),
                        },
                    },
                };

                var result = Util_InertiaTensor.GetInertiaTensor(shapes);

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, result);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Inertia_Capsule_Click(object sender, RoutedEventArgs e)
        {

        }

        private void Inertia_3Spheres_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
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

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, result);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Inertia_2Boxes_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(0.3 / 2d, 1.8 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0, 0, 0),
                            Q = new Quaternion(new Vector3D(0,0,1), 30),
                        },
                    },

                    //new Util_InertiaTensor.ShapeBox()
                    //{
                    //    density = 1,
                    //    HalfWidths = new Vector3D(1 / 2d, 1 / 2d, 1 / 2d),
                    //    LocalPose = new Util_InertiaTensor.PxTransform()
                    //    {
                    //        P = new Vector3D(0, 2, 0),
                    //        Q = Quaternion.Identity,
                    //    },
                    //},
                };

                var result = Util_InertiaTensor.GetInertiaTensor(shapes);

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, result);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Inertia_2BoxesMirrored_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1 / 2d, 1 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-0.5, 0, 0),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1 / 2d, 1 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(1.5, 0, 0),
                            Q = Quaternion.Identity,
                        },
                    },
                };

                var result = Util_InertiaTensor.GetInertiaTensor(shapes);

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, result);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Inertia_3Boxes_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1 / 2d, 1 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0, 0, 0),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1 / 2d, 1 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-1, 0, 0),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1 / 2d, 1 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0, 1, 0),
                            Q = Quaternion.Identity,
                        },
                    },
                };

                var result = Util_InertiaTensor.GetInertiaTensor(shapes);

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, result);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Inertia_BoxCapsule_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(0.3 / 2d, 1.8 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0, 0, -1),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeCapsule()
                    {
                        density = 1,

                        Radius = 0.24,
                        Length = 2,
                        Direction = Game.Math_WPF.Mathematics.Axis.Y,

                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-1.6, 0.8, 0),
                            Q = new Quaternion(new Vector3D(1,0,0), 60),
                        },
                    },
                };

                var result = Util_InertiaTensor.GetInertiaTensor(shapes);

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, result);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
