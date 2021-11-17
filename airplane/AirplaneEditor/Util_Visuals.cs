using Game.Math_WPF.WPF;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor
{
    public static class Util_Visuals
    {
        #region record: CreatedVisual

        public record CreatedVisual
        {
            public Visual3D Visual { get; init; }
            public Transform3D Transform { get; init; }
            public TranslateTransform3D Translate { get; init; }
            public QuaternionRotation3D Rotate { get; init; }
            public ScaleTransform3D Scale { get; init; }
        }

        #endregion

        public static CreatedVisual Get_Fuselage(Transform3D parent_transform = null)
        {
            MaterialGroup material = new MaterialGroup();
            material.Children.Add(new DiffuseMaterial(UtilityWPF.BrushFromHex("606060")));
            material.Children.Add(new SpecularMaterial(UtilityWPF.BrushFromHex("40EEEEEE"), 1.5));

            var transform = GetTransform(parent_transform);

            GeometryModel3D model = new GeometryModel3D
            {
                Material = material,
                BackMaterial = material,
                Geometry = UtilityWPF.GetCylinder_AlongX(12, 0.5, 1, new RotateTransform3D(new AxisAngleRotation3D(new Vector3D(0, 0, 1), 90d))),
                Transform = transform.transform,
            };

            return new CreatedVisual()
            {
                Visual = new ModelVisual3D()
                {
                    Content = model,
                },
                Transform = transform.transform,
                Translate = transform.translate,
                Rotate = transform.rotate,
                Scale = transform.scale,
            };
        }
        public static CreatedVisual Get_Wing(Transform3D parent_transform = null)
        {
            const double HALF_HEIGHT = 0.05;

            MaterialGroup material = new MaterialGroup();
            material.Children.Add(new DiffuseMaterial(UtilityWPF.BrushFromHex("D8D8D8")));
            material.Children.Add(new SpecularMaterial(UtilityWPF.BrushFromHex("40EEEEEE"), 1.5));

            var transform = GetTransform(parent_transform);

            GeometryModel3D model = new GeometryModel3D
            {
                Material = material,
                BackMaterial = material,
                Geometry = UtilityWPF.GetCube_IndependentFaces(new Point3D(-0.5, -0.5, -HALF_HEIGHT), new Point3D(0.5, 0.5, HALF_HEIGHT)),
                Transform = transform.transform,
            };

            return new CreatedVisual()
            {
                Visual = new ModelVisual3D()
                {
                    Content = model,
                },
                Transform = transform.transform,
                Translate = transform.translate,
                Rotate = transform.rotate,
                Scale = transform.scale,
            };
        }
        public static CreatedVisual Get_Engine(Transform3D parent_transform = null)
        {
            MaterialGroup material = new MaterialGroup();
            material.Children.Add(new DiffuseMaterial(UtilityWPF.BrushFromHex("8BB058")));
            material.Children.Add(new SpecularMaterial(UtilityWPF.BrushFromHex("30C5C951"), 0.66));

            var transform = GetTransform(parent_transform);

            GeometryModel3D model = new GeometryModel3D
            {
                Material = material,
                BackMaterial = material,
                Geometry = UtilityWPF.GetCone_AlongX(12, 0.5, 1, new RotateTransform3D(new AxisAngleRotation3D(new Vector3D(0, 0, 1), 90d))),
                Transform = transform.transform,
            };

            return new CreatedVisual()
            {
                Visual = new ModelVisual3D()
                {
                    Content = model,
                },
                Transform = transform.transform,
                Translate = transform.translate,
                Rotate = transform.rotate,
                Scale = transform.scale,
            };
        }
        public static CreatedVisual Get_Bomb(Transform3D parent_transform = null)
        {
            MaterialGroup material = new MaterialGroup();
            material.Children.Add(new DiffuseMaterial(UtilityWPF.BrushFromHex("B85433")));
            material.Children.Add(new SpecularMaterial(UtilityWPF.BrushFromHex("30E88413"), 0.66));

            var transform = GetTransform(parent_transform);

            GeometryModel3D model = new GeometryModel3D
            {
                Material = material,
                BackMaterial = material,
                Geometry = UtilityWPF.GetCapsule_AlongZ(12, 6, 0.25, 1, new RotateTransform3D(new AxisAngleRotation3D(new Vector3D(1, 0, 0), 90d))),
                Transform = transform.transform,
            };

            return new CreatedVisual()
            {
                Visual = new ModelVisual3D()
                {
                    Content = model,
                },
                Transform = transform.transform,
                Translate = transform.translate,
                Rotate = transform.rotate,
                Scale = transform.scale,
            };
        }
        public static CreatedVisual Get_Gun(Transform3D parent_transform = null)
        {
            MaterialGroup material = new MaterialGroup();
            material.Children.Add(new DiffuseMaterial(UtilityWPF.BrushFromHex("C42121")));
            material.Children.Add(new SpecularMaterial(UtilityWPF.BrushFromHex("3065B4C2"), 0.66));

            var transform = GetTransform(parent_transform);

            //TODO: Use GetMultiRingedTube with hard sides

            GeometryModel3D model = new GeometryModel3D
            {
                Material = material,
                BackMaterial = material,
                Geometry = UtilityWPF.GetCylinder_AlongX(6, 0.125, 1, new RotateTransform3D(new AxisAngleRotation3D(new Vector3D(0, 0, 1), 90d))),
                Transform = transform.transform,
            };

            return new CreatedVisual()
            {
                Visual = new ModelVisual3D()
                {
                    Content = model,
                },
                Transform = transform.transform,
                Translate = transform.translate,
                Rotate = transform.rotate,
                Scale = transform.scale,
            };
        }

        #region Private Methods

        private static (Transform3DGroup transform, TranslateTransform3D translate, QuaternionRotation3D rotate, ScaleTransform3D scale) GetTransform(Transform3D parent_transform = null)
        {
            var translate = new TranslateTransform3D(0, 0, 0);
            var rotate = new QuaternionRotation3D(Quaternion.Identity);
            var scale = new ScaleTransform3D(1, 1, 1);

            var transform = new Transform3DGroup();

            if (parent_transform != null)
                transform.Children.Add(parent_transform);

            transform.Children.Add(scale);
            transform.Children.Add(new RotateTransform3D(rotate));
            transform.Children.Add(translate);

            return (transform, translate, rotate, scale);
        }

        #endregion
    }
}
