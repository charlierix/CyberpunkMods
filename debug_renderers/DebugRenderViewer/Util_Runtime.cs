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
    /// These are functions that assist with changing of settings after a scene is showing
    /// </summary>
    /// <remarks>
    /// This was a bunch of the private static methods moved out of main window.  That file was getting way
    /// too big
    /// </remarks>
    public static class Util_Runtime
    {
        // Create copies with the filter applied
        public static LogScene Apply_EmptyFrameRemoval(LogScene scene, bool showEmptyFrames)
        {
            if (showEmptyFrames)
                return scene;

            return scene with
            {
                frames = scene.frames.
                    Where(o => o.items.Length > 0 || o.text.Length > 0).
                    ToArray(),
            };
        }
        public static LogScene Apply_Centering(LogScene scene, PointCentering centering)
        {
            switch (centering)
            {
                case PointCentering.None:
                    return scene;

                case PointCentering.AcrossFrames:
                    return scene with
                    {
                        frames = Center_AcrossFrames(scene.frames),
                    };

                case PointCentering.PerFrame:
                    return scene with
                    {
                        frames = scene.frames.
                            Select(o => Center_PerFrame(o)).
                            ToArray(),
                    };

                default:
                    throw new ApplicationException($"Unknown {nameof(PointCentering)}: {centering}");
            }
        }

        // These colors are used to stand out from the current background
        public static double GetComplementaryGray(double percent)
        {
            const double DISTANCE = 0.4;

            if (percent + DISTANCE <= 1)
                return percent + DISTANCE;
            else
                return percent - DISTANCE;
        }
        public static Color GetGray(double percent, double opacity = 1)
        {
            byte gray = Convert.ToByte(255 * percent);

            if (opacity < 1)
                return Color.FromArgb(Convert.ToByte(255 * opacity), gray, gray, gray);
            else
                return Color.FromRgb(gray, gray, gray);
        }

        // Returns the closest hit from a ray trace
        public static MainWindow.VisualEntry GetTooltipHit(IEnumerable<MainWindow.VisualEntry> entries, IEnumerable<MyHitTestResult> hits)
        {
            foreach (var hit in hits)		// hits are sorted by distance, so this method will only return the closest match
            {
                Visual3D visualHit = hit.ModelHit.VisualHit;
                if (visualHit == null)
                    continue;

                MainWindow.VisualEntry item = entries.FirstOrDefault(o => o.Visual == visualHit);
                if (item != null)
                    return item;
            }

            return null;
        }

        // Setting combo.SelectedValue doesn't work, so this finds the value's index and sets selected index
        public static int SelectComboBox_ByValue<Tkey, Tvalue>(ComboBox combo, Tvalue value)
        {
            for (int cntr = 0; cntr < combo.Items.Count; cntr++)
            {
                if (((KeyValuePair<Tkey, Tvalue>)combo.Items[cntr]).Value.Equals(value))
                    return cntr;
            }

            return 0;
        }

        #region Private Methods

        // These return frames with the items recentered around the origin
        private static LogFrame[] Center_AcrossFrames(LogFrame[] frames)
        {
            var points = frames.
                Where(o => o.items.Length > 0).
                SelectMany(o => ExtractPoints(o.items));

            Point3D center = Math3D.GetCenter(points);

            return frames.
                Select(o => o with
                {
                    items = o.items.
                        Select(p => TranslateItem(p, center)).
                        ToArray(),
                }).
                ToArray();
        }
        private static LogFrame Center_PerFrame(LogFrame frame)
        {
            Point3D center = Math3D.GetCenter(ExtractPoints(frame.items));

            return frame with
            {
                items = frame.items.
                    Select(o => TranslateItem(o, center)).
                    ToArray(),
            };
        }

        private static IEnumerable<Point3D> ExtractPoints(ItemBase[] items)
        {
            foreach (ItemBase item in items)
            {
                if (item is ItemDot dot)
                {
                    yield return dot.position;
                }
                else if (item is ItemLine line)
                {
                    yield return line.point1;
                    yield return line.point2;
                }
                else if (item is ItemCircle_Edge circle)
                {
                    yield return circle.center;
                }
                else if (item is ItemSquare_Filled square)
                {
                    yield return square.center;
                }
                else
                {
                    throw new ApplicationException($"Unknown item type: {item.GetType()}");
                }
            }
        }

        private static ItemBase TranslateItem(ItemBase item, Point3D center)
        {
            if (item is ItemDot dot)
            {
                return dot with
                {
                    position = TranslatePosition(dot.position, center),
                };
            }
            else if (item is ItemLine line)
            {
                return line with
                {
                    point1 = TranslatePosition(line.point1, center),
                    point2 = TranslatePosition(line.point2, center),
                };
            }
            else if (item is ItemCircle_Edge circle)
            {
                return circle with
                {
                    center = TranslatePosition(circle.center, center),
                };
            }
            else if (item is ItemSquare_Filled square)
            {
                return square with
                {
                    center = TranslatePosition(square.center, center),
                };
            }
            else
            {
                throw new ApplicationException($"Unknown item type: {item.GetType()}");
            }
        }

        private static Point3D TranslatePosition(Point3D position, Point3D center)
        {
            return position - center.ToVector();
        }

        #endregion
    }
}
