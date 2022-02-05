using AirplaneEditor.Models;
using AirplaneEditor.Models_viewmodels;
using Game.Core;
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
        public static Models.Airplane ToModel(PlanePart_VM root, string name)
        {
            var shapes = new List<Util_InertiaTensor.ShapeBase>();
            var parts_serialize = new List<PlanePart_Serialization>();
            var wings = new List<PlanePart_Wing>();
            var thrusters = new List<PlanePart_Thrust>();

            int next_id = 0;

            BuildModel_AddPart(root, new Transform3DGroup(), null, shapes, parts_serialize, wings, thrusters, ref next_id);

            var inertia = Util_InertiaTensor.GetInertiaTensor(shapes.ToArray());

            //Util_InertiaTensor.VisualizeInertiaTensor(shapes.ToArray(), inertia);

            return new Models.Airplane()
            {
                Name = name,

                Mass = inertia.TotalMass,
                CenterOfMass = inertia.CenterMass,

                InertiaTensor = inertia.InertiaTensor,
                InertiaTensorRotation = inertia.InertiaTensor_Rotation,

                Parts_Serialize = parts_serialize.ToArray(),

                Wings = wings.ToArray(),
                Thrusters = thrusters.ToArray(),
            };
        }

        public static (PlanePart_VM root, string name) FromModel(Models.Airplane model)
        {
            if (model?.Parts_Serialize == null || model.Parts_Serialize.Length == 0)
                return (null, model?.Name ?? "");

            PlanePart_Serialization[] roots = model.Parts_Serialize.
                Where(o => o.ParentID == null).
                ToArray();

            if (roots.Length == 0)
                throw new ApplicationException("Didn't find any root parts");
            else if (roots.Length > 1)
                throw new ApplicationException($"Found more than one root part: {roots.Length}");

            var remaining_parts = model.Parts_Serialize.
                Where(o => o.ParentID != null).
                ToArray();

            PlanePart_VM root = CreateVM(null, roots[0]);

            AddVMChildren(root, roots[0].ID, ref remaining_parts);

            return (root, model.Name ?? "");
        }

        /// <summary>
        /// This is needed in a couple places, so putting it in this util
        /// </summary>
        /// <param name="position">Position of the part relative to the parent</param>
        /// <param name="orientation">Orientation of the part relative to the parent</param>
        /// <param name="parent">This would be the rigid body's transform (or whatever transform the part is tied to)</param>
        public static (Transform3D to_world, Transform3D to_local) GetTransforms(Point3D position, Quaternion orientation, Transform3D parent = null)
        {
            var to_world = new Transform3DGroup();

            if(parent != null)
                to_world.Children.Add(parent);

            if (!orientation.IsIdentity)
                to_world.Children.Add(new RotateTransform3D(new QuaternionRotation3D(orientation)));

            if (!position.IsNearZero())
                to_world.Children.Add(new TranslateTransform3D(position.ToVector()));

            Matrix3D matrix = to_world.Value;
            matrix.Invert();

            var to_local = new Transform3DGroup();
            to_local.Children.Add(new MatrixTransform3D(matrix));

            return (to_world, to_local);
        }

        #region Private Methods

        private static void BuildModel_AddPart(PlanePart_VM part, Transform3D parent_transform, int? parent_id, List<Util_InertiaTensor.ShapeBase> shapes, List<PlanePart_Serialization> parts_serialize, List<PlanePart_Wing> wings, List<PlanePart_Thrust> thrusters, ref int next_id)
        {
            // Serialize Part
            PlanePart_Serialization serialize = CreateSerializePart(part, parent_id, ref next_id);
            parts_serialize.Add(serialize);

            // Transform so it's directly off of the rigid body
            Transform3DGroup transform = new Transform3DGroup();
            transform.Children.Add(parent_transform);

            transform.Children.Add(new RotateTransform3D(new QuaternionRotation3D(part.Orientation)));
            transform.Children.Add(new TranslateTransform3D(part.Position.ToVector()));

            var rot_translate = GetRotate_Translate(transform.Value);

            // Shape
            shapes.Add(CreateShape(part, rot_translate.rotate, rot_translate.translate, true));
            if (!part.IsCenterline)
                shapes.Add(CreateShape(part, rot_translate.rotate, rot_translate.translate, false));

            // Direct Flying Pars
            CreateFlyable(part, rot_translate.rotate, rot_translate.translate, wings, thrusters, true);
            if (!part.IsCenterline)
                CreateFlyable(part, rot_translate.rotate, rot_translate.translate, wings, thrusters, false);

            if (part.Children == null)
                return;

            foreach (PlanePart_VM child in part.Children)
            {
                BuildModel_AddPart(child, transform, serialize.ID, shapes, parts_serialize, wings, thrusters, ref next_id);
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
        #region Private Methods - serialize

        private static PlanePart_Serialization CreateSerializePart(PlanePart_VM part, int? parent_id, ref int next_id)
        {
            int id = next_id;
            next_id++;

            return new PlanePart_Serialization()
            {
                ID = id,
                ParentID = parent_id,

                PartType = part.PartType,

                IsCenterline = part.IsCenterline,

                Name = part.Name,

                Position = part.Position,
                Orientation = part.Orientation,

                Sizes = part.ToSizesArr(),
            };
        }

        #endregion
        #region Private Methods - shape

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
                    HalfWidths = new Vector3D(wing.Span / 2, wing.Chord / 2, AppSettings.Wing_Thickness_Visual / 2),
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

        #endregion
        #region Private Methods - flyable

        private static void CreateFlyable(PlanePart_VM part, Quaternion rotate, Vector3D translate, List<PlanePart_Wing> wings, List<PlanePart_Thrust> thrusters, bool is_starboard)
        {
            var local_pose = GetLocalPartPosition(rotate, translate, is_starboard);     //NOTE: part.Position and part.Orientation are already included in the rotate and translate passed in

            if (part is PlanePart_Fuselage_VM fuselage)
            {
                wings.AddRange(CreateFlyable_Fuselage(fuselage, local_pose.P, local_pose.Q));
            }
            else if (part is PlanePart_Wing_VM wing)
            {
                wings.Add(CreateFlyable_Wing(wing, local_pose.P, local_pose.Q));
            }
            else if (part is PlanePart_Engine_VM engine)
            {
                thrusters.Add(CreateFlyable_Engine(engine, local_pose.P, local_pose.Q));
            }


            // bomb

            // gun

        }

        private static PlanePart_Wing[] CreateFlyable_Fuselage(PlanePart_Fuselage_VM fuselage, Vector3D position, Quaternion rotation)
        {
            //TODO: Make three wings
            return new PlanePart_Wing[0];
        }

        private static PlanePart_Wing CreateFlyable_Wing(PlanePart_Wing_VM wing, Vector3D position, Quaternion rotation)
        {
            return new PlanePart_Wing()
            {
                Name = wing.Name,

                Position = position.ToPoint(),
                Orientation = rotation,

                chord = wing.Chord,
                span = wing.Span,
                zeroLiftAoA = wing.Lift,        // this is derived from the wing's thickness
            };
        }

        private static PlanePart_Thrust CreateFlyable_Engine(PlanePart_Engine_VM engine, Vector3D position, Quaternion rotation)
        {
            return new PlanePart_Thrust()
            {
                Name = engine.Name,

                Position = position.ToPoint(),
                Direction = rotation.GetRotatedVector(new Vector3D(0, 1, 0)),
            };
        }

        #endregion
        #region Private Methods - view model

        private static PlanePart_VM CreateVM(PlanePart_VM parent, PlanePart_Serialization part)
        {
            PlanePart_VM retVal;

            switch (part.PartType)
            {
                case PlanePartType.Bomb:
                    retVal = new PlanePart_Bomb_VM() { Parent = parent };
                    break;

                case PlanePartType.Engine:
                    retVal = new PlanePart_Engine_VM() { Parent = parent };
                    break;

                case PlanePartType.Fuselage:
                    retVal = new PlanePart_Fuselage_VM() { Parent = parent };
                    break;

                case PlanePartType.Gun:
                    retVal = new PlanePart_Gun_VM() { Parent = parent };
                    break;

                case PlanePartType.Wing:
                    retVal = new PlanePart_Wing_VM() { Parent = parent };
                    break;

                default:
                    throw new ApplicationException($"Unknown PlanePartType: {part.PartType}");
            }

            retVal.Name = part.Name ?? "";
            retVal.IsCenterline = part.IsCenterline;
            retVal.Position = part.Position;
            retVal.Orientation = part.Orientation;
            retVal.FromSizesArr(part.Sizes);

            return retVal;
        }

        private static void AddVMChildren(PlanePart_VM part, int part_id, ref PlanePart_Serialization[] remaining_parts)
        {
            var children = remaining_parts.
                Where(o => o.ParentID == part_id).
                ToArray();

            remaining_parts = remaining_parts.
                Where(o => o.ParentID != part_id).
                ToArray();

            foreach (PlanePart_Serialization child_serialize in children)
            {
                var child_vm = CreateVM(part, child_serialize);

                part.Children.Add(child_vm);

                AddVMChildren(child_vm, child_serialize.ID, ref remaining_parts);
            }
        }

        #endregion
    }
}
