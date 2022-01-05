using AirplaneEditor.Models;
using AirplaneEditor.Models_viewmodels;
using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor
{
    public static class Util_ToModel
    {
        public static Models.Airplane BuildModel(PlanePart_VM root)
        {
            var shapes = new List<Util_InertiaTensor.ShapeBase>();
            var parts = new List<PlanePart>();

            int next_id = 0;

            BuildModel_AddPart(root, new Transform3DGroup(), shapes, parts, ref next_id);

            var inertia = Util_InertiaTensor.GetInertiaTensor(shapes.ToArray());



            Util_InertiaTensor.VisualizeInertiaTensor(shapes.ToArray(), inertia);



            return new Models.Airplane()
            {
                //Name = 

                Mass = inertia.TotalMass,
                CenterOfMass = inertia.CenterMass,

                InertiaTensor = inertia.InertiaTensor,
                InertiaTensorRotation = inertia.InertiaTensor_Rotation,

                Parts = parts.ToArray(),
            };
        }

        #region Private Methods

        private static void BuildModel_AddPart(PlanePart_VM part, Transform3D parent_transform, List<Util_InertiaTensor.ShapeBase> shapes, List<PlanePart> parts, ref int next_id)
        {
            Transform3DGroup transform = new Transform3DGroup();
            transform.Children.Add(parent_transform);

            transform.Children.Add(new RotateTransform3D(new QuaternionRotation3D(part.Orientation)));
            transform.Children.Add(new TranslateTransform3D(part.Position.ToVector()));

            var rot_translate = GetRotate_Translate(transform.Value);

            shapes.Add(CreateShape(part, rot_translate.rotate, rot_translate.translate, true));
            if (!part.IsCenterline)
                shapes.Add(CreateShape(part, rot_translate.rotate, rot_translate.translate, false));


            //parts.Add();


            if (part.Children == null)
                return;

            foreach (PlanePart_VM child in part.Children)
            {
                BuildModel_AddPart(child, transform, shapes, parts, ref next_id);
            }
        }

        //https://answers.unity.com/questions/11363/converting-matrix4x4-to-quaternion-vector3.html
        public static (Quaternion rotate, Vector3D translate) GetRotate_Translate(Matrix3D m)
        {
            if (m.IsIdentity)
                return (Quaternion.Identity, new Vector3D());

            // Adapted from: http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/index.htm
            //NOTE: The quaternion automatically gets marked as identity if there is no rotation (x y z w = 0 0 0 1)

            Quaternion q = new Quaternion();

            //q.W = Math.Sqrt(Math.Max(0, 1 + m.M11 + m.M22 + m.M33)) / 2;
            //q.X = Math.Sqrt(Math.Max(0, 1 + m.M11 - m.M22 - m.M33)) / 2;
            //q.Y = Math.Sqrt(Math.Max(0, 1 - m.M11 + m.M22 - m.M33)) / 2;
            //q.Z = Math.Sqrt(Math.Max(0, 1 - m.M11 - m.M22 + m.M33)) / 2;
            //q.X *= Math.Sign(q.X * (m.M32 - m.M23));
            //q.Y *= Math.Sign(q.Y * (m.M13 - m.M31));
            //q.Z *= Math.Sign(q.Z * (m.M21 - m.M12));

            // WPF's matrix seems to be backward (row,col instead of col,row)
            q.W = Math.Sqrt(Math.Max(0, 1 + m.M11 + m.M22 + m.M33)) / 2;
            q.X = Math.Sqrt(Math.Max(0, 1 + m.M11 - m.M22 - m.M33)) / 2;
            q.Y = Math.Sqrt(Math.Max(0, 1 - m.M11 + m.M22 - m.M33)) / 2;
            q.Z = Math.Sqrt(Math.Max(0, 1 - m.M11 - m.M22 + m.M33)) / 2;
            q.X *= Math.Sign(q.X * (m.M23 - m.M32));
            q.Y *= Math.Sign(q.Y * (m.M31 - m.M13));
            q.Z *= Math.Sign(q.Z * (m.M12 - m.M21));

            return (q, new Vector3D(m.OffsetX, m.OffsetY, m.OffsetZ));
        }

        private static Util_InertiaTensor.ShapeBase CreateShape(PlanePart_VM part, Quaternion rotate, Vector3D translate, bool is_starboard)
        {
            var local_pose = GetLocalPartPosition(rotate, translate, is_starboard);     //NOTE: part.Position and part.Orientation are already included in the rotate and translate passed in

            if (part is PlanePart_Fuselage_VM fuselage)
                return new Util_InertiaTensor.ShapeCapsule()
                {
                    LocalPose = local_pose,
                    density = AppSettings.Density_Fuselage,
                    Direction = Axis.Y,
                    Height = fuselage.Length,
                    Radius = fuselage.Diameter / 2d,
                };

            else if (part is PlanePart_Wing_VM wing)
                return new Util_InertiaTensor.ShapeBox()
                {
                    LocalPose = local_pose,
                    density = AppSettings.Density_Wing,
                    HalfWidths = new Vector3D(wing.Span / 2, wing.Chord / 2, AppSettings.Wing_Thickness / 2),
                };

            else if (part is PlanePart_Engine_VM engine)
                return new Util_InertiaTensor.ShapeSphere()
                {
                    LocalPose = local_pose,
                    density = AppSettings.Density_Engine,
                    Radius = engine.Size * AppSettings.Engine_Radius,
                };

            else if (part is PlanePart_Bomb_VM bomb)
                return new Util_InertiaTensor.ShapeCapsule()
                {
                    LocalPose = local_pose,
                    density = AppSettings.Density_Bomb,
                    Direction = Axis.Y,
                    Height = bomb.Size * AppSettings.Bomb_Length,
                    Radius = bomb.Size * AppSettings.Bomb_Radius,
                };

            else if (part is PlanePart_Gun_VM gun)
                return new Util_InertiaTensor.ShapeCylinder()
                {
                    LocalPose = local_pose,
                    density = AppSettings.Density_Gun,
                    Direction = Axis.Y,
                    Height = gun.Size * AppSettings.Gun_Length,
                    Radius = gun.Size * AppSettings.Gun_Radius,
                };

            else
                throw new ApplicationException($"Unknown PlanePartType: {part.PartType}");
        }

        private static void CreateModel(PlanePart_VM part, Transform3DGroup parent_transform, bool is_starboard)
        {

        }

        private static Util_InertiaTensor.PxTransform GetLocalPartPosition(Quaternion rotate, Vector3D translate, bool is_starboard)
        {
            if (is_starboard)
            {
                return new Util_InertiaTensor.PxTransform()
                {
                    P = translate,
                    Q = rotate,
                };
            }

            Vector3D rev_pos = new Vector3D(-translate.X, translate.Y, translate.Z);

            if (rotate.IsIdentity)
            {
                return new Util_InertiaTensor.PxTransform()
                {
                    P = rev_pos,
                    Q = Quaternion.Identity,
                };
            }

            Vector3D axis = rotate.Axis;

            return new Util_InertiaTensor.PxTransform()
            {
                P = rev_pos,
                Q = new Quaternion(new Vector3D(-axis.X, axis.Y, axis.Z), -rotate.Angle),
            };
        }

        #endregion
    }
}
