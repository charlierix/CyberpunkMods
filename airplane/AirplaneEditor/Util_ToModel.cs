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

            shapes.Add(CreateShape(part, transform, true));
            if (!part.IsCenterline)
                shapes.Add(CreateShape(part, transform, false));


            //parts.Add();


            if (part.Children == null)
                return;

            foreach (PlanePart_VM child in part.Children)
            {
                BuildModel_AddPart(child, transform, shapes, parts, ref next_id);
            }
        }

        private static Util_InertiaTensor.ShapeBase CreateShape(PlanePart_VM part, Transform3DGroup parent_transform, bool is_starboard)
        {
            var local_pose = GetLocalPartPosition(part.Position, part.Orientation, is_starboard);

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

        private static Util_InertiaTensor.PxTransform GetLocalPartPosition(Point3D position, Quaternion orientation, bool is_starboard)
        {
            if (is_starboard)
            {
                return new Util_InertiaTensor.PxTransform()
                {
                    P = position.ToVector(),
                    Q = orientation,
                };
            }

            Vector3D rev_pos = new Vector3D(-position.X, position.Y, position.Z);

            if (orientation.IsIdentity)
            {
                return new Util_InertiaTensor.PxTransform()
                {
                    P = rev_pos,
                    Q = Quaternion.Identity,
                };
            }

            Vector3D axis = orientation.Axis;

            return new Util_InertiaTensor.PxTransform()
            {
                P = rev_pos,
                Q = new Quaternion(new Vector3D(-axis.X, axis.Y, axis.Z), -orientation.Angle),
            };
        }

        #endregion
    }
}
