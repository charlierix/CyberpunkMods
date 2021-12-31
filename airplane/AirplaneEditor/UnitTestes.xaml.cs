using AirplaneEditor.Airplane;
using AirplaneEditor.Airplane.temp;
using Game.Core;
using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using Game.Math_WPF.WPF.Controls3D;
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




                // Neither of these recreates the original.  Probably because they are transforms, not scales
                PxMat33 rotated_back1 = PxMat33.createDiagonal(result.InertiaTensor) * PxMat33.from_rot(result.InertiaTensor_Rotation);
                PxMat33 rotated_back2 = PxMat33.from_rot(result.InertiaTensor_Rotation) * PxMat33.createDiagonal(result.InertiaTensor);

                VisualizeMatrix33(rotated_back1, "diag * rot");
                VisualizeMatrix33(rotated_back2, "rot * diag");
                VisualizeMatrix33(result.InertiaTensor_Matrix, "orig");


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

        private void TorqueAccel_ReallyBasic_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Inputs (not dealing with rotations for this test)
                Vector3D inertia_tensor = new Vector3D(2, 1, 0.5);
                Vector3D[] torques = new[]
                {
                    new Vector3D(1, 0, 0),
                    new Vector3D(0, 1, 0),
                    new Vector3D(0, 0, 1),
                    new Vector3D(1, 1, 1),
                };

                // Intermediate objects
                Vector3D inverse_inertia_tensor = GetInverseInertiaTensor(inertia_tensor);
                PxMat33 transform = TestTensorRotation.TEST_GetTransform(inverse_inertia_tensor);

                foreach (Vector3D torque in torques)
                {
                    // Output
                    Vector3D ang_accel = transform * torque;

                    // Draw
                    var window = new Debug3DWindow();

                    var sizes = Debug3DWindow.GetDrawSizes(2);

                    window.AddAxisLines(1, sizes.line / 4);

                    window.AddLine(new Point3D(), new Point3D(inertia_tensor.X, 0, 0), sizes.line, Colors.Red);
                    window.AddLine(new Point3D(), new Point3D(0, inertia_tensor.Y, 0), sizes.line, Colors.Green);
                    window.AddLine(new Point3D(), new Point3D(0, 0, inertia_tensor.Z), sizes.line, Colors.Blue);


                    window.AddLine(new Vector3D(), torque, sizes.line, Colors.Black);
                    window.AddLine(new Vector3D(), ang_accel, sizes.line, Colors.White);

                    window.AddText($"torque: {torque.ToStringSignificantDigits(3)}");
                    window.AddText($"ang accel: {ang_accel.ToStringSignificantDigits(3)}");


                    window.Show();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void TorqueAccel_BasicLocalQuat_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Inputs (not dealing with rotations for this test)
                Vector3D inertia_tensor = new Vector3D(2, 1, 0.5);
                Vector3D inertia_axis = new Vector3D(1, 0, 0);
                double inertia_angle = 30;

                Vector3D[] torques = new[]
                {
                    new Vector3D(1, 0, 0),
                    new Vector3D(0, 1, 0),
                    new Vector3D(0, 0, 1),
                    new Vector3D(1, 1, 1),
                };

                // Intermediate objects
                Vector3D inverse_inertia_tensor = GetInverseInertiaTensor(inertia_tensor);
                Quaternion inertia_quat = new Quaternion(inertia_axis, inertia_angle);
                RotateTransform3D inertia_rot = new RotateTransform3D(new QuaternionRotation3D(inertia_quat));


                // I don't think this is the right approach
                //
                // This seems to be transforming the accel to be different than the torque
                //
                // The output accel needs to be the same line as the torque, but be modified by the rotated inertia

                PxMat33 transform1 = TestTensorRotation.TEST_GetTransform1(inverse_inertia_tensor, inertia_quat);
                PxMat33 transform2 = TestTensorRotation.TEST_GetTransform2(inverse_inertia_tensor, inertia_quat);



                foreach (Vector3D torque in torques)
                {
                    // Output
                    Vector3D ang_accel1 = transform1 * torque;
                    Vector3D ang_accel2 = transform2 * torque;

                    // Draw
                    var window = new Debug3DWindow();

                    var sizes = Debug3DWindow.GetDrawSizes(2);

                    window.AddAxisLines(1, sizes.line / 4);

                    window.AddLine(new Point3D(), inertia_rot.Transform(new Point3D(inertia_tensor.X, 0, 0)), sizes.line, Colors.Red);
                    window.AddLine(new Point3D(), inertia_rot.Transform(new Point3D(0, inertia_tensor.Y, 0)), sizes.line, Colors.Green);
                    window.AddLine(new Point3D(), inertia_rot.Transform(new Point3D(0, 0, inertia_tensor.Z)), sizes.line, Colors.Blue);


                    window.AddLine(new Vector3D(), torque, sizes.line, Colors.Black);
                    window.AddLine(new Vector3D(), ang_accel1, sizes.line, Colors.White);
                    window.AddLine(new Vector3D(), ang_accel2, sizes.line, Colors.White);

                    window.AddText($"torque: {torque.ToStringSignificantDigits(3)}");
                    window.AddText($"ang accel 1: {ang_accel1.ToStringSignificantDigits(3)}");
                    window.AddText($"ang accel 2: {ang_accel2.ToStringSignificantDigits(3)}");


                    window.Show();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void TorqueAccel_BasicLocalQuat2_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Inputs (not dealing with rotations for this test)
                Vector3D inertia_tensor = new Vector3D(2, 1, 0.5);
                Vector3D inertia_axis = new Vector3D(1, 0, 0);
                double inertia_angle = 30;

                Vector3D[] torques = new[]
                {
                    new Vector3D(1, 0, 0),
                    new Vector3D(0, 1, 0),
                    new Vector3D(0, 0, 1),
                    new Vector3D(1, 1, 1),
                };

                // Intermediate objects
                Vector3D inverse_inertia_tensor = GetInverseInertiaTensor(inertia_tensor);
                PxMat33 inverse_inertia_tensor_mat = PxMat33.createDiagonal(inverse_inertia_tensor);

                Quaternion inertia_quat = new Quaternion(inertia_axis, inertia_angle);
                RotateTransform3D inertia_rot = new RotateTransform3D(new QuaternionRotation3D(inertia_quat));
                RotateTransform3D inertia_rot_reverse = new RotateTransform3D(new QuaternionRotation3D(inertia_quat.ToReverse()));

                foreach (Vector3D torque in torques)        // torques are already in local coords for this tester
                {
                    //NOTE: When trying to rotate the inverse inertia tensor matrix, it seems to act like a rotate transform.
                    //So instead, leave that matrix as a pure diagonal and over rotate the torque so it comes in the same as
                    //if the tensor were rotated
                    Vector3D torque_prepped = inertia_rot_reverse.Transform(torque);        // put the torque in the inertia tensor's coords (leaving the inertia tensor alone as axis aligned)
                    Vector3D ang_accel = inverse_inertia_tensor_mat * torque_prepped;       // scale the torque, turning it into an acceleration
                    ang_accel = inertia_rot.Transform(ang_accel);                           // rotate the accel out of inertia's coords into rigid body's coords

                    // Draw
                    var window = new Debug3DWindow();

                    var sizes = Debug3DWindow.GetDrawSizes(2);

                    window.AddAxisLines(1, sizes.line / 4);

                    window.AddLine(new Point3D(), inertia_rot.Transform(new Point3D(inertia_tensor.X, 0, 0)), sizes.line, Colors.Red);
                    window.AddLine(new Point3D(), inertia_rot.Transform(new Point3D(0, inertia_tensor.Y, 0)), sizes.line, Colors.Green);
                    window.AddLine(new Point3D(), inertia_rot.Transform(new Point3D(0, 0, inertia_tensor.Z)), sizes.line, Colors.Blue);

                    window.AddLine(new Vector3D(), torque, sizes.line, Colors.Black);
                    window.AddLine(new Vector3D(), ang_accel, sizes.line, Colors.White);

                    window.AddText($"torque: {torque.ToStringSignificantDigits(3)}");
                    window.AddText($"ang accel: {ang_accel.ToStringSignificantDigits(3)}");

                    window.Show();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void TorqueAccel_TorqueWorldCoords_Click(object sender, RoutedEventArgs e)
        {

            // same concept as TorqueAccel_BasicLocalQuat2_Click
            // just need to rotate from world into local to get accel, then rotate back out to world (or leave in local?)


            try
            {
                // Inputs (not dealing with rotations for this test)
                Vector3D inertia_tensor = new Vector3D(2, 1, 0.5);
                Vector3D inertia_axis = new Vector3D(1, 0, 0);
                double inertia_angle = 30;

                // Intermediate objects
                Vector3D inverse_inertia_tensor = GetInverseInertiaTensor(inertia_tensor);
                PxMat33 inverse_inertia_tensor_mat = PxMat33.createDiagonal(inverse_inertia_tensor);

                Quaternion inertia_quat = new Quaternion(inertia_axis, inertia_angle);
                RotateTransform3D inertia_rot = new RotateTransform3D(new QuaternionRotation3D(inertia_quat));
                RotateTransform3D inertia_rot_reverse = new RotateTransform3D(new QuaternionRotation3D(inertia_quat.ToReverse()));

                // Draw
                var window = new Debug3DWindow();

                var sizes = Debug3DWindow.GetDrawSizes(2);

                window.AddAxisLines(1, sizes.line / 4);

                window.AddLine(new Point3D(), inertia_rot.Transform(new Point3D(inertia_tensor.X, 0, 0)), sizes.line, Colors.Red);
                window.AddLine(new Point3D(), inertia_rot.Transform(new Point3D(0, inertia_tensor.Y, 0)), sizes.line, Colors.Green);
                window.AddLine(new Point3D(), inertia_rot.Transform(new Point3D(0, 0, inertia_tensor.Z)), sizes.line, Colors.Blue);


                Vector3D torque_base = Math3D.GetRandomVector_Spherical_Shell(1);

                Vector3D world_axis = Math3D.GetRandomVector_Spherical_Shell(1);
                window.AddLine(new Point3D(), world_axis.ToPoint(), sizes.line / 3, Colors.Magenta);

                for (int angle = 0; angle < 360; angle += 30)
                {
                    Vector3D torque_world = new Quaternion(world_axis, angle).GetRotatedVector(torque_base);

                    Vector3D torque_local = new Quaternion(world_axis, -angle).GetRotatedVector(torque_world);

                    //NOTE: When trying to rotate the inverse inertia tensor matrix, it seems to act like a rotate transform.
                    //So instead, leave that matrix as a pure diagonal and over rotate the torque so it comes in the same as
                    //if the tensor were rotated
                    Vector3D torque_prepped = inertia_rot_reverse.Transform(torque_local);        // put the torque in the inertia tensor's coords (leaving the inertia tensor alone as axis aligned)
                    Vector3D ang_accel_prepped = inverse_inertia_tensor_mat * torque_prepped;       // scale the torque, turning it into an acceleration
                    Vector3D ang_accel_local = inertia_rot.Transform(ang_accel_prepped);                           // rotate the accel out of inertia's coords into rigid body's coords

                    Vector3D ang_accel_world = new Quaternion(world_axis, angle).GetRotatedVector(ang_accel_local);

                    window.AddLine(new Vector3D(), torque_world, sizes.line, Colors.Black);
                    window.AddLine(new Vector3D(), ang_accel_world, sizes.line, Colors.White);

                    window.AddText3D(angle.ToString(), (torque_world * 1.2).ToPoint(), torque_world, 0.07, Colors.Black, false);
                    window.AddText3D(angle.ToString(), (ang_accel_world * 1.2).ToPoint(), ang_accel_world, 0.07, Colors.White, false);
                }

                window.Show();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #region Private Methods

        private static Vector3D GetInverseInertiaTensor(Vector3D inertia_tensor)
        {
            return new Vector3D(
                inertia_tensor.X.IsNearZero() ? 0d : 1d / inertia_tensor.X,
                inertia_tensor.Y.IsNearZero() ? 0d : 1d / inertia_tensor.Y,
                inertia_tensor.Z.IsNearZero() ? 0d : 1d / inertia_tensor.Z);
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

        private static void VisualizeMatrix33(PxMat33 matrix, string title)
        {
            var window = new Debug3DWindow()
            {
                Title = title,
            };

            string[] values = new string[]
            {
                " ",
                "col 0",
                "col 1",
                "col 2",

                "row 0",
                Math.Round(matrix.column0.X, 4).ToString(),
                Math.Round(matrix.column1.X, 4).ToString(),
                Math.Round(matrix.column2.X, 4).ToString(),

                "row 1",
                Math.Round(matrix.column0.Y, 4).ToString(),
                Math.Round(matrix.column1.Y, 4).ToString(),
                Math.Round(matrix.column2.Y, 4).ToString(),

                "row 2",
                Math.Round(matrix.column0.Z, 4).ToString(),
                Math.Round(matrix.column1.Z, 4).ToString(),
                Math.Round(matrix.column2.Z, 4).ToString(),
            };

            var cells = Math2D.GetCells_InvertY(1, 4, 4);

            for (int i = 0; i < cells.Length; i++)
            {
                window.AddText3D(values[i], cells[i].center.ToPoint3D(), new Vector3D(0, 0, 1), 0.2, Colors.Black, true, new Vector3D(1, 0, 0));
            }

            window.AddSquare(cells[5].rect.BottomLeft, cells[15].rect.TopRight, UtilityWPF.ColorFromHex("1AAA"), z: 0.05);

            window.Show();
        }

        #endregion
    }
}
