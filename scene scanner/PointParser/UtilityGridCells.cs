using Game.Core;
using Game.Math_WPF.Mathematics;
using PointParser.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media.Media3D;

namespace PointParser
{
    /// <summary>
    /// These functions divide a 2D area into uniformly sized grid cells, keeps track of how many points are in each cell
    /// </summary>
    /// <remarks>
    /// This allows for crude ways to work with sets of points, finding how density areas, holes, islands
    /// </remarks>
    public static class UtilityGridCells
    {
        public static (Point[] points, TransformsToFrom2D_wpf transforms) ConvertTo2D(Face3D_Points face)
        {
            var plane = Math3D.GetPlane(face.Center, face.Normal);

            // Need to flatten all points to the plane, the GetConvexHull function's coplanar check is pretty strict
            // (I didn't notice the overload that takes plane in directly.  Leaving this here just in case)
            //var strictPoints = face.ContainedPoints.
            //    Select(o => Math3D.GetClosestPoint_Plane_Point(plane, o)).
            //    ToArray();

            TransformsToFrom2D_wpf transforms = Math2D.GetTransformTo2D(plane);

            return
            (
                face.ContainedPoints.
                    Select(o => transforms.From3D_To2D.Transform(o).ToPoint2D()).
                    ToArray(),
                transforms
            );
        }

        public static (DivisionCell[][] cells, Point aabb_min, Point aabb_max, double size) GetDivisionCells_COUNT_SQUARE(Point[] points, int numRowsColumns)
        {
            var aabb = Math2D.GetAABB(points);

            double size = Math.Max(aabb.max.X - aabb.min.X, aabb.max.Y - aabb.min.Y);
            size /= numRowsColumns;

            var retVal = new DivisionCell[numRowsColumns][];

            for (int row = 0; row < numRowsColumns; row++)
            {
                retVal[row] = new DivisionCell[numRowsColumns];

                for (int col = 0; col < numRowsColumns; col++)
                {
                    Point min = new Point(aabb.min.X + (size * col), aabb.min.Y + (size * row));
                    Point max = new Point(min.X + size, min.Y + size);

                    retVal[row][col] = new DivisionCell()
                    {
                        Size = size,
                        Min = min,
                        Max = max,
                        Count = GetCount(points, min, max),
                    };
                }
            }

            return (retVal, aabb.min, aabb.max, size);
        }
        public static (DivisionCell[][] cells, Point aabb_min, Point aabb_max, double size) GetDivisionCells_COUNT(Point[] points, int numRowsColumns)
        {
            var aabb = Math2D.GetAABB(points);

            double size = Math.Min(aabb.max.X - aabb.min.X, aabb.max.Y - aabb.min.Y);
            size /= numRowsColumns;

            var retVal = new List<List<DivisionCell>>();

            int row = 0;

            while (true)
            {
                double minY = aabb.min.Y + (size * row);
                if (minY > aabb.max.Y)
                    break;

                retVal.Add(new List<DivisionCell>());

                int col = 0;

                while (true)
                {
                    double minX = aabb.min.X + (size * col);
                    if (minX > aabb.max.X)
                        break;

                    Point min = new Point(minX, minY);
                    Point max = new Point(min.X + size, min.Y + size);

                    retVal[row].Add(new DivisionCell()
                    {
                        Size = size,
                        Min = min,
                        Max = max,
                        Count = GetCount(points, min, max),
                    });

                    col++;
                }

                row++;
            }

            return
            (
                retVal.
                    Select(o => o.ToArray()).
                    ToArray(),
                aabb.min,
                aabb.max,
                size
            );
        }
        public static (DivisionCell[][] cells, Point aabb_min, Point aabb_max, double size) GetDivisionCells(Point[] points, double cellSize)
        {
            var aabb = Math2D.GetAABB(points);

            var retVal = new List<List<DivisionCell>>();

            int row = 0;

            while (true)
            {
                double minY = aabb.min.Y + (cellSize * row);
                if (minY > aabb.max.Y)
                    break;

                retVal.Add(new List<DivisionCell>());

                int col = 0;

                while (true)
                {
                    double minX = aabb.min.X + (cellSize * col);
                    if (minX > aabb.max.X)
                        break;

                    Point min = new Point(minX, minY);
                    Point max = new Point(min.X + cellSize, min.Y + cellSize);

                    retVal[row].Add(new DivisionCell()
                    {
                        Size = cellSize,
                        Min = min,
                        Max = max,
                        Count = GetCount(points, min, max),
                    });

                    col++;
                }

                row++;
            }

            return
            (
                retVal.
                    Select(o => o.ToArray()).
                    ToArray(),
                aabb.min,
                aabb.max,
                cellSize
            );
        }

        public static bool ContainsPoint(Point min, Point max, Point test)
        {
            return test.X >= min.X && test.X <= max.X && test.Y >= min.Y && test.Y <= max.Y;
        }

        public static bool IsEmpty(int row, int col, DivisionCell[][] cells, AxisFor axis)
        {
            switch (axis.Axis)
            {
                case Axis.X:
                    col += axis.Increment;
                    break;

                case Axis.Y:
                    row += axis.Increment;
                    break;

                default:
                    throw new ApplicationException($"Unexpected axis: {axis.Axis}");
            }

            return IsEmpty(row, col, cells);
        }
        public static bool IsEmpty(int row, int col, DivisionCell[][] cells)
        {
            if (col < 0 || row < 0)
                return true;
            else if (row >= cells.Length)
                return true;
            else if (col >= cells[row].Length)
                return true;
            else if (cells[row][col].Count == 0)
                return true;
            else
                return false;
        }

        #region Private Methods

        /// <summary>
        /// Returns how many points are inside the rectangle
        /// </summary>
        private static int GetCount(Point[] points, Point min, Point max)
        {
            int retVal = 0;

            for (int cntr = 0; cntr < points.Length; cntr++)
            {
                if (ContainsPoint(min, max, points[cntr]))      // a point would be double counted if it sits on an edge, but that shouldn't skew results much
                    retVal++;
            }

            return retVal;
        }

        #endregion
    }

    #region record: DivisionCell

    public record DivisionCell
    {
        public double Size { get; init; }

        public Point Min { get; init; }
        public Point Max { get; init; }

        public int Count { get; init; }

        //TODO: May want to store a square set of children
    }

    #endregion

}
