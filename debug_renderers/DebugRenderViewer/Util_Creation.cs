using DebugRenderViewer.Models;
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
using System.Windows.Media;
using System.Windows.Media.Media3D;

namespace DebugRenderViewer
{
    /// <summary>
    /// These are functions that create items to display
    /// </summary>
    /// <remarks>
    /// This was a bunch of the private static methods moved out of main window.  That file was getting way
    /// too big
    /// </remarks>
    public static class Util_Creation
    {
        private const double SIZE_DOT = 0.06;
        private const double SIZE_LINE = 0.025;
        private const double SIZE_CIRCLE = 0.025;
        private const double FONTSIZE = 11;

        /// <summary>
        /// Creates an individual 3D item
        /// </summary>
        public static Visual3D GetVisual(ItemBase item, DefaultColorBrushes defaultBrushes, List<BillboardLine3DSet> lines_defaultColor)
        {
            if (item is ItemDot dot)
                return GetVisual_Dot(dot, defaultBrushes.Dot_Brush);

            if (item is ItemCircle_Edge circle)
                return GetVisual_Circle(circle, defaultBrushes.Circle_Brush);

            if (item is ItemSquare_Filled square)
                return GetVisual_Square(square, defaultBrushes.Square_Brush);

            if (item is ItemLine line)
            {
                var lineVisual = GetVisual_Line(line, defaultBrushes.Line_Color);

                if (lineVisual.isDefaultColor)
                    lines_defaultColor.Add(lineVisual.line);

                return lineVisual.line;
            }

            //return null;
            throw new ApplicationException($"Unexpected type: {item.GetType()}");
        }

        /// <summary>
        /// This populates a stackpanel with log text
        /// </summary>
        public static void ShowText(StackPanel panel, Text[] text, SolidColorBrush defaultBrush)
        {
            panel.Children.Clear();

            if (text == null || text.Length == 0)
                return;

            foreach (Text entry in text)
            {
                TextBlock control = new TextBlock()
                {
                    Text = entry.text,
                    TextWrapping = TextWrapping.Wrap,
                    FontSize = FONTSIZE * (entry.fontsize_mult ?? 1),
                    Margin = new Thickness(0, 1, 0, 3),
                    Foreground = entry.color != null ?
                        new SolidColorBrush(entry.color.Value) :
                        defaultBrush,
                    HorizontalAlignment = HorizontalAlignment.Left,
                };

                panel.Children.Add(control);
            }
        }

        public static Material GetMaterial(Brush brush)
        {
            MaterialGroup retVal = new MaterialGroup();

            retVal.Children.Add(new DiffuseMaterial(brush));
            retVal.Children.Add(new SpecularMaterial(new SolidColorBrush(UtilityWPF.ColorFromHex("40989898")), 2));

            return retVal;
        }

        #region Private Methods

        private static Visual3D GetVisual_Dot(ItemDot dot, Brush defaultBrush)
        {
            Material material = GetMaterial(GetBrush(dot, defaultBrush));

            GeometryModel3D geometry = new GeometryModel3D();
            geometry.Material = material;
            geometry.BackMaterial = material;
            geometry.Geometry = UtilityWPF.GetSphere_Ico(SIZE_DOT * (dot.size_mult ?? 1), 1, true);
            geometry.Transform = new TranslateTransform3D(dot.position.ToVector());

            var retVal = new ModelVisual3D
            {
                Content = geometry,
            };


            //TODO: There probably needs to be a global mouse handler.  Store tooltipped items in their own list so that
            //it's faster
            //if(dot.tooltip)
            //    retVal.


            return retVal;
        }
        private static (BillboardLine3DSet line, bool isDefaultColor) GetVisual_Line(ItemLine line, Color defaultColor)
        {
            var color = GetColor(line, defaultColor);

            BillboardLine3DSet visual = new BillboardLine3DSet();
            visual.Color = color.color;
            visual.BeginAddingLines();

            visual.AddLine(line.point1, line.point2, SIZE_LINE * (line.size_mult ?? 1));

            visual.EndAddingLines();

            return (visual, color.isDefault);
        }
        private static Visual3D GetVisual_Circle(ItemCircle_Edge circle, Brush defaultBrush)
        {
            Material material = GetMaterial(GetBrush(circle, defaultBrush));

            GeometryModel3D geometry = new GeometryModel3D();
            geometry.Material = material;
            geometry.BackMaterial = material;

            geometry.Geometry = UtilityWPF.GetTorus(30, 7, SIZE_CIRCLE * (circle.size_mult ?? 1), circle.radius);

            geometry.Transform = GetTransform_2D_to_3D(circle.center, circle.normal);

            return new ModelVisual3D
            {
                Content = geometry
            };
        }
        private static Visual3D GetVisual_Square(ItemSquare_Filled square, Brush defaultBrush)
        {
            Material material = GetMaterial(GetBrush(square, defaultBrush));

            double half_x = square.size_x / 2;
            double half_y = square.size_y / 2;

            return new ModelVisual3D
            {
                Content = new GeometryModel3D
                {
                    Material = material,
                    BackMaterial = material,
                    Geometry = UtilityWPF.GetSquare2D(new Point(-half_x, -half_y), new Point(half_x, half_y)),
                    Transform = GetTransform_2D_to_3D(square.center, square.normal),
                },
            };
        }

        private static Transform3D GetTransform_2D_to_3D(Point3D center, Vector3D normal)
        {
            Transform3DGroup transform = new Transform3DGroup();

            var transform2D = Math2D.GetTransformTo2D(new Triangle_wpf(normal, center));

            // Transform the center point down to 2D
            Point3D center2D = transform2D.From3D_To2D.Transform(center);

            // Add a translate along the 2D plane
            transform.Children.Add(new TranslateTransform3D(center2D.ToVector()));

            // Now that it's positioned correctly in 2D, transform the whole thing into 3D (to line up with the 3D plane that was passed in)
            transform.Children.Add(transform2D.From2D_BackTo3D);

            return transform;
        }

        private static Brush GetBrush(ItemBase item, Brush defaultBrush)
        {
            if (item.color != null)
                return new SolidColorBrush(item.color.Value);
            else if (item.category?.color != null)
                return new SolidColorBrush(item.category.color.Value);
            else
                return defaultBrush;
        }

        private static (Color color, bool isDefault) GetColor(ItemBase item, Color defaultColor)
        {
            if (item.color != null)
                return (item.color.Value, false);
            else if (item.category?.color != null)
                return (item.category.color.Value, false);
            else
                return (defaultColor, true);
        }

        #endregion
    }
}
