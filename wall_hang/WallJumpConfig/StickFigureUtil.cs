using Game.Math_WPF.WPF;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;
using System.Windows;
using Game.Core;
using Game.Math_WPF.Mathematics;
using WallJumpConfig.Models.misc;

namespace WallJumpConfig
{
    public static class StickFigureUtil
    {
        private const string COLOR_1 = "222";       // stationary,primary,static....?
        private const string COLOR_2 = "DDD";       // background,info....?

        private const double ARROW_LENGTH = 9;
        private const double ARROW_WIDTH = 7;

        private const double HORZ_INNER1_RADIUS = 54;
        private const double HORZ_OUTER1_RADIUS = 48;

        private const double HORZ_INNER2_RADIUS = 36;
        private const double HORZ_OUTER2_RADIUS = 90;

        private const double HORZ_RADIUS1 = HORZ_INNER1_RADIUS + HORZ_OUTER1_RADIUS;
        private const double HORZ_RADIUS2 = HORZ_INNER2_RADIUS + HORZ_OUTER2_RADIUS;

        private const double VERT_INNER1_RADIUS = 54;
        private const double VERT_OUTER1_RADIUS = 48;

        private const double VERT_INNER2_RADIUS = 36;
        private const double VERT_OUTER2_RADIUS = 90;

        private const double VERT_RADIUS1 = VERT_INNER1_RADIUS + VERT_OUTER1_RADIUS;
        private const double VERT_RADIUS2 = VERT_INNER2_RADIUS + VERT_OUTER2_RADIUS;

        public static FrameworkElement GetGraphic_Stickman(Point offset)
        {
            Brush brush = UtilityWPF.BrushFromHex(COLOR_1);
            double thickness = 1;

            var retVal = new Canvas()
            {
                HorizontalAlignment = HorizontalAlignment.Left,
                VerticalAlignment = VerticalAlignment.Top,
            };

            offset = new Point(offset.X - (46 / 2d), offset.Y - (83 / 2d));

            // Head
            retVal.Children.Add(new Ellipse()
            {
                Width = 20,
                Height = 20,
                HorizontalAlignment = HorizontalAlignment.Left,
                VerticalAlignment = VerticalAlignment.Top,
                Stroke = brush,
                StrokeThickness = thickness,
                Margin = new Thickness(offset.X + 23 - 10, offset.Y, 0, 0),
            });

            // Arms
            retVal.Children.Add(new Line()
            {
                X1 = offset.X + 0,
                Y1 = offset.Y + 31,
                X2 = offset.X + 46,
                Y2 = offset.Y + 31,
                Stroke = brush,
                StrokeThickness = thickness,
            });

            // Body
            retVal.Children.Add(new Line()
            {
                X1 = offset.X + 23,
                Y1 = offset.Y + 20,
                X2 = offset.X + 23,
                Y2 = offset.Y + 50,
                Stroke = brush,
                StrokeThickness = thickness,
            });

            // Left Leg
            retVal.Children.Add(new Line()
            {
                X1 = offset.X + 23,
                Y1 = offset.Y + 50,
                X2 = offset.X + 4,
                Y2 = offset.Y + 83,
                Stroke = brush,
                StrokeThickness = thickness,
            });

            // Right Leg
            retVal.Children.Add(new Line()
            {
                X1 = offset.X + 23,
                Y1 = offset.Y + 50,
                X2 = offset.X + 43,
                Y2 = offset.Y + 83,
                Stroke = brush,
                StrokeThickness = thickness,
            });

            return retVal;
        }

        public static FrameworkElement GetGraphic_Horizontal_Arrows_Four(Point offset)
        {
            Brush brush = UtilityWPF.BrushFromHex(COLOR_2);

            var retVal = new Canvas()
            {
                HorizontalAlignment = HorizontalAlignment.Left,
                VerticalAlignment = VerticalAlignment.Top,
            };

            // Left
            var line = GetGraphic_RotateableLine(offset, brush, HORZ_INNER1_RADIUS, HORZ_OUTER1_RADIUS, false);
            line.Rotate.Angle = -90;
            retVal.Children.Add(line.Line);

            // Right
            line = GetGraphic_RotateableLine(offset, brush, HORZ_INNER1_RADIUS, HORZ_OUTER1_RADIUS, false);
            line.Rotate.Angle = 90;
            retVal.Children.Add(line.Line);

            // Up
            line = GetGraphic_RotateableLine(offset, brush, HORZ_INNER1_RADIUS, HORZ_OUTER1_RADIUS, false);
            line.Rotate.Angle = 0;
            retVal.Children.Add(line.Line);

            // Down
            line = GetGraphic_RotateableLine(offset, brush, HORZ_INNER1_RADIUS, HORZ_OUTER1_RADIUS, false);
            line.Rotate.Angle = 180;
            retVal.Children.Add(line.Line);

            return retVal;
        }
        public static FrameworkElement GetGraphic_Vertical_Arrows_Three(Point offset)
        {
            Brush brush = UtilityWPF.BrushFromHex(COLOR_2);

            var retVal = new Canvas()
            {
                HorizontalAlignment = HorizontalAlignment.Left,
                VerticalAlignment = VerticalAlignment.Top,
            };

            // Right
            var line = GetGraphic_RotateableLine(offset, brush, VERT_INNER1_RADIUS, VERT_OUTER1_RADIUS, false);
            line.Rotate.Angle = 90;
            retVal.Children.Add(line.Line);

            // Up
            line = GetGraphic_RotateableLine(offset, brush, VERT_INNER1_RADIUS, VERT_OUTER1_RADIUS, false);
            line.Rotate.Angle = 0;
            retVal.Children.Add(line.Line);

            // Down
            line = GetGraphic_RotateableLine(offset, brush, VERT_INNER1_RADIUS, VERT_OUTER1_RADIUS, false);
            line.Rotate.Angle = 180;
            retVal.Children.Add(line.Line);

            return retVal;
        }

        private static FrameworkElement GetGraphic_Horizontal_Wall(Point offset)
        {
            Brush brush = UtilityWPF.BrushFromHex(COLOR_1);
            double thickness = 3;

            var retVal = new Canvas()
            {
                HorizontalAlignment = HorizontalAlignment.Left,
                VerticalAlignment = VerticalAlignment.Top,
            };

            double size = Math.Max(HORZ_RADIUS1, HORZ_RADIUS2) * 2 * 1.2;

            offset = new Point(offset.X - (size / 2), offset.Y);

            retVal.Children.Add(new Line()
            {
                X1 = offset.X + 0,
                Y1 = offset.Y,
                X2 = offset.X + size,
                Y2 = offset.Y,
                Stroke = brush,
                StrokeThickness = thickness,
            });

            return retVal;
        }
        private static FrameworkElement GetGraphic_Vertical_Wall(Point offset)
        {
            Brush brush = UtilityWPF.BrushFromHex(COLOR_1);
            double thickness = 3;

            var retVal = new Canvas()
            {
                HorizontalAlignment = HorizontalAlignment.Left,
                VerticalAlignment = VerticalAlignment.Top,
            };

            double size = Math.Max(VERT_RADIUS1, VERT_RADIUS2) * 2 * 1.2;

            offset = new Point(offset.X, offset.Y - (size / 2));

            retVal.Children.Add(new Line()
            {
                X1 = offset.X,
                Y1 = offset.Y + 0,
                X2 = offset.X,
                Y2 = offset.Y + size,
                Stroke = brush,
                StrokeThickness = thickness,
            });

            return retVal;
        }

        private static RotatableLine GetGraphic_RotateableLine(Point offset, Brush brush, double inner_radius, double outer_radius, bool show_arrow)
        {
            double thickness = 1;

            var transform = new TransformGroup();
            var rotate = new RotateTransform();
            transform.Children.Add(rotate);

            transform.Children.Add(new TranslateTransform(offset.X, offset.Y));

            var canvas = new Canvas()
            {
                HorizontalAlignment = HorizontalAlignment.Left,
                VerticalAlignment = VerticalAlignment.Top,
                RenderTransform = transform,
            };

            // Line
            var line = new Line()
            {
                X1 = 0,
                Y1 = -inner_radius,
                X2 = 0,
                Y2 = -(inner_radius + outer_radius),
                Stroke = brush,
                StrokeThickness = thickness,
            };
            canvas.Children.Add(line);

            // Arrow
            if (show_arrow)
            {
                var arrow = GetArrowCoords((Line)canvas.Children[^1], ARROW_LENGTH, ARROW_WIDTH);
                var polygon = new Polygon()
                {
                    Fill = brush,
                };
                polygon.Points.AddRange(new[] { arrow.tip, arrow.base1, arrow.base2 });
                canvas.Children.Add(polygon);
            }

            return new RotatableLine()
            {
                Line = canvas,
                Rotate = rotate,
            };
        }

        private static (Point tip, Point base1, Point base2) GetArrowCoords(Line line, double length, double width)
        {
            double magnitude = Math.Sqrt(Math2D.LengthSquared(line.X1, line.Y1, line.X2, line.Y2));

            // Get a unit vector that points from the to point back to the base of the arrow head
            double baseDir_x = (line.X1 - line.X2) / magnitude;
            double baseDir_y = (line.Y1 - line.Y2) / magnitude;

            // Now get two unit vectors that point from the shaft out to the tips
            double edgeDir1_x = -baseDir_y;
            double edgeDir1_y = baseDir_x;

            double edgeDir2_x = baseDir_y;
            double edgeDir2_y = -baseDir_x;

            // Get the point at the base of the arrow that is on the shaft
            double base_x = line.X2 + (baseDir_x * length);
            double base_y = line.Y2 + (baseDir_y * length);

            double halfWidth = width / 2;

            return
            (
                new Point(line.X2, line.Y2),
                new Point(base_x + (edgeDir1_x * halfWidth), base_y + (edgeDir1_y * halfWidth)),
                new Point(base_x + (edgeDir2_x * halfWidth), base_y + (edgeDir2_y * halfWidth))
            );
        }

    }
}
