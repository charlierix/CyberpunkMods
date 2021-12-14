using Game.Core;
using Game.Math_WPF.Mathematics;
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
                        Radius = 2,
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
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeCapsule()
                    {
                        density = 1,
                        Direction = Axis.Y,
                        Radius = 0.5,
                        Height = 2,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0, 0, 0),
                            Q = new Quaternion(new Vector3D(0, 0, 1), 45),
                            //Q = Quaternion.Identity,
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
        private void Inertia_Cylinder_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeCylinder()
                    {
                        density = 1,
                        Direction = Axis.Y,
                        Radius = 0.5,
                        Height = 2,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0, 0, 0),
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
        private void Inertia_Ellipsoid_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeEllipsoid()
                    {
                        density = 1,
                        RadiusX = 0.5,
                        RadiusY = 1,
                        RadiusZ = 1,
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

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1 / 2d, 1 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0, 2, 0),
                            Q = Quaternion.Identity,
                        },
                    },
                };

                var result = Util_InertiaTensor.GetInertiaTensor(shapes);

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, result);



                var unityResult = new Util_InertiaTensor.Result()
                {
                    TotalMass = 1.54,
                    InertiaTensor = new Vector3D(1.727179, 0.248601, 1.719114),
                    InertiaTensor_Rotation = new Quaternion(new Vector3D(0, 0, 1), 2.381236),
                    CenterMass = new Point3D(0, 1.298701, 0),
                };

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, unityResult, "unity");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Inertia_2BoxesMirroredX_Click(object sender, RoutedEventArgs e)
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
        private void Inertia_2BoxesMirroredY_Click(object sender, RoutedEventArgs e)
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
                            P = new Vector3D(0, -0.5, 0),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1 / 2d, 1 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0, 1.5, 0),
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
        private void Inertia_2BoxesMirroredZ_Click(object sender, RoutedEventArgs e)
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
                            P = new Vector3D(0, 0, -0.5),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1 / 2d, 1 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0, 0, 1.5),
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
        private void Inertia_2BoxesMirroredRot_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(2 / 2d, 2 / 2d, 2 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-0.5, 0, 0),
                            //Q = new Quaternion(new Vector3D(0, 1, 0), 30),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1 / 2d, 1 / 2d, 1 / 2d),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(16, 0, 0),
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
                        Height = 2,
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

        private void Inertia_SphereCloud_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 2.3,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-8.3, 8.3, 2.7),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 1.6,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-0.6, -0.8, -0.4),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 0.7,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(4.7, -0.2, -11.1),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 0.5,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-1.9, -10.2, -6.4),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 2.6,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-6.6, 3.6, -9.3),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 1.7,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(6.4, 3.4, 9),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 1.1,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(10.8, 4.9, -2.5),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 1.5,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-4.7, 1.2, 11),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 2.4,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(1.7, 11.3, -1.2),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 0.8,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-11.3, -4.7, 0.6),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 2.7,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(9.8, -7, 0.2),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = 1.6,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0.1, -9.7, 7.3),
                            Q = Quaternion.Identity,
                        },
                    },
                };

                var result = Util_InertiaTensor.GetInertiaTensor(shapes);

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, result);



                var unityResult = new Util_InertiaTensor.Result()
                {
                    TotalMass = 343.65,
                    InertiaTensor = new Vector3D(18436, 38321, 35154),
                    InertiaTensor_Rotation = Quaternion.Identity,       // would need to implement from euler: 336.72, 2.33, 313.23
                    CenterMass = new Point3D(0.27917, 1.9894, -0.50318),
                };

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, unityResult, "unity");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Inertia_BoxCloud_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var shapes = new Util_InertiaTensor.ShapeBase[]
                {
                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(2.3, 2.3, 2.3),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-8.3, 8.3, 2.7),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1.6, 1.6, 1.6),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-0.6, -0.8, -0.4),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(0.7, 0.7, 0.7),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(4.7, -0.2, -11.1),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(0.5, 0.5, 0.5),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-1.9, -10.2, -6.4),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(2.6, 2.6, 2.6),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-6.6, 3.6, -9.3),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1.7, 1.7, 1.7),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(6.4, 3.4, 9),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1.1, 1.1, 1.1),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(10.8, 4.9, -2.5),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1.5, 1.5, 1.5),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-4.7, 1.2, 11),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(2.4, 2.4, 2.4),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(1.7, 11.3, -1.2),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(0.8, 0.8, 0.8),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(-11.3, -4.7, 0.6),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(2.7, 2.7, 2.7),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(9.8, -7, 0.2),
                            Q = Quaternion.Identity,
                        },
                    },

                    new Util_InertiaTensor.ShapeBox()
                    {
                        density = 1,
                        HalfWidths = new Vector3D(1.6, 1.6, 1.6),
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(0.1, -9.7, 7.3),
                            Q = Quaternion.Identity,
                        },
                    },
                };

                var result = Util_InertiaTensor.GetInertiaTensor(shapes);

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, result);





                var unityResult = new Util_InertiaTensor.Result()
                {
                    TotalMass = 656.33,
                    InertiaTensor = new Vector3D(36173, 74152, 68102),
                    InertiaTensor_Rotation = Quaternion.Identity,       // would need to implement from euler: 336.72, 2.33, 313.23
                    CenterMass = new Point3D(0.27917, 1.9894, -0.50318),
                };

                Util_InertiaTensor.VisualizeInertiaTensor(shapes, unityResult, "unity");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void SphereTree_Click(object sender, RoutedEventArgs e)
        {
            const double MAX_HEIGHT = 12;
            const double SPHERE_RADIUS = 1;
            const double PLANE_RADIUS = 8;
            const double HEIGHT_DRIFT = 2;
            const double HEIGHT_INC = 0.6;

            try
            {
                Random rand = StaticRandom.GetRandomForThread();

                var spheres = new List<Util_InertiaTensor.ShapeBase>();

                double height = 0;

                while (height < MAX_HEIGHT)
                {
                    // Sphere Radius
                    double scaled_height = height / MAX_HEIGHT;

                    double min = 1 - Math.Pow(scaled_height, 0.4);
                    double max = 1 - Math.Pow(scaled_height, 0.6);
                    UtilityMath.MinMax(ref min, ref max);

                    double sphere_radius = SPHERE_RADIUS * rand.NextDouble(min, max);

                    // Position Radius
                    min = Math.Pow(scaled_height, 4);
                    max = Math.Pow(scaled_height, 2.5);
                    UtilityMath.MinMax(ref min, ref max);

                    double plane_radius = PLANE_RADIUS * rand.NextDouble(min, max);

                    // Position Z
                    min = 1 - Math.Pow(scaled_height, 0.12);
                    max = 1 - Math.Pow(scaled_height, 0.2);
                    UtilityMath.MinMax(ref min, ref max);

                    double pole_height = rand.NextDrift(height, HEIGHT_DRIFT * rand.NextDouble(min, max));

                    // Height Increment
                    min = 1 - Math.Pow(scaled_height, 0.18);
                    max = 1 - Math.Pow(scaled_height, 0.22);
                    UtilityMath.MinMax(ref min, ref max);

                    height += Math.Max(0.01, HEIGHT_INC * rand.NextDouble(min, max));

                    // Create
                    Vector3D plane_point = Math3D.GetRandomVector_Circular(plane_radius);

                    spheres.Add(new Util_InertiaTensor.ShapeSphere()
                    {
                        density = 1,
                        Radius = sphere_radius,
                        LocalPose = new Util_InertiaTensor.PxTransform()
                        {
                            P = new Vector3D(plane_point.X, plane_point.Y, pole_height),
                            Q = Quaternion.Identity,
                        },
                    });
                }

                var result = Util_InertiaTensor.GetInertiaTensor(spheres.ToArray());

                Util_InertiaTensor.VisualizeInertiaTensor(spheres.ToArray(), result);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private static void GetRandomPoints()
        {
            Random rand = StaticRandom.GetRandomForThread();

            var points = Math3D.GetRandomVectors_Spherical_EvenDist(12, 12).
                Select(o => new
                {
                    position = o.ToPoint(),
                    size = rand.NextDouble(0.5, 3),
                }).
                //ToArray();
                Select(o => string.Format("pos: {0}, {1}, {2} | size: {3}", Math.Round(o.position.X, 1), Math.Round(o.position.Y, 1), Math.Round(o.position.Z, 1), Math.Round(o.size, 1))).
                ToJoin("\r\n");
        }
    }
}
