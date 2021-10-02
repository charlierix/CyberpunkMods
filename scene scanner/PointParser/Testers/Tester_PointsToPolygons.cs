using Game.Core;
using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using Game.Math_WPF.WPF.Controls3D;
using PointParser.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media;

namespace PointParser.Testers
{
    public static class Tester_PointsToPolygons
    {
        #region record: DivisionCell

        private record DivisionCell
        {
            public double Size { get; init; }

            public Point Min { get; init; }
            public Point Max { get; init; }

            public int Count { get; init; }

            //TODO: May want to store a square set of children
        }

        #endregion

        private static void Thoughts(Face3D_Points face, string filename)
        {
            var points2D = ConvertTo2D(face);

            DrawPoints(points2D.points, filename);


            // There doesn't seem to be a single ideal count.  Make something that identifies too course/fine
            //  Maybe try a couple resolutions and pick the best one


            // --- IDEA ---
            // Find a convex polygon
            // Break the the area into a series of squares
            // Any square that has no points in it is something that must be blocked off
            //
            // Maybe create a voronoi out of the square centers?
            //DrawCountGrid_Basic(points2D.points, 18);
            DrawCountGrid_Basic(points2D.points, 0.75, filename);

            // Identify cells that are filled next to cells that are empty
            //DrawCountGrid_HighlightBoundries_CELLCOUNT(points2D.points, 9, filename);
            DrawCountGrid_HighlightBoundries(points2D.points, 0.75, filename);

            // Identify the prominent points in those boundry cells --- may not be needed?


            // Identify cell sets that are completely separate from others
            DrawCountGrid_SplitIslands(points2D.points, 0.75, filename);



            // In cells that are low populated and mostly standalone, add some random points around each of those points and redo the grid
            // This should give a clearer picture and make the polygon smoother
        }

        public static void JustPoints(Face3D_Points face, string filename)
        {
            var points2D = ConvertTo2D(face);

            DrawPoints(points2D.points, filename);
        }
        public static void Grid_Basic(Face3D_Points face, string filename)
        {
            var points2D = ConvertTo2D(face);

            DrawCountGrid_Basic(points2D.points, 0.75, filename);
        }
        public static void Grid_Boundries(Face3D_Points face, string filename)
        {
            var points2D = ConvertTo2D(face);

            // Identify cells that are filled next to cells that are empty
            //DrawCountGrid_HighlightBoundries_CELLCOUNT(points2D.points, 9, filename);
            DrawCountGrid_HighlightBoundries(points2D.points, 0.75, filename);

            // Identify the prominent points in those boundry cells --- may not be needed?

        }
        public static void Grid_Islands(Face3D_Points face, string filename)
        {
            var points2D = ConvertTo2D(face);

            // Identify cell sets that are completely separate from others
            DrawCountGrid_SplitIslands(points2D.points, 0.75, filename);
        }

        #region Private Methods - drawings

        private static void DrawPoints(Point[] points, string filename)
        {
            Debug3DWindow window = new Debug3DWindow()
            {
                Title = $"Points: {filename}",
            };

            var sizes = Debug3DWindow.GetDrawSizes(points);

            window.AddDots(points.Select(o => o.ToPoint3D()), sizes.dot, Colors.Gray);

            window.Show();
        }

        private static void DrawCountGrid_Basic(Point[] points, double cellSize, string filename)
        {
            var (cells, aabb_min, aabb_max, size) = GetDivisionCells(points, cellSize);

            int maxCount = cells.
                SelectMany(o => o).
                Max(o => o.Count);

            Debug3DWindow window = new Debug3DWindow()
            {
                Title = $"Count Grid: {filename}",
            };

            var sizes = Debug3DWindow.GetDrawSizes(points);

            window.AddDots(points.Select(o => o.ToPoint3D()), sizes.dot, Colors.Gray);

            for (int row = 0; row < cells.Length; row++)
            {
                for (int col = 0; col < cells[row].Length; col++)
                {
                    //window.AddLines(cells[row][col].Min.ToPoint3D(), cells[row][col].Max.ToPoint3D(), sizes.line, UtilityWPF.ColorFromHex("AAA"));

                    Color color = UtilityWPF.ColorFromHex("88B8");

                    if (cells[row][col].Count == 0)
                        color = UtilityWPF.ColorFromHex("8B44");
                    else if (cells[row][col].Count < maxCount * 0.666)
                        color = UtilityWPF.ColorFromHex("8888");

                    window.AddSquare(cells[row][col].Min, cells[row][col].Max, color);
                }
            }

            window.Show();
        }

        static void DrawCountGrid_HighlightBoundries_CELLCOUNT(Point[] points, int count, string filename)
        {
            var (cells, aabb_min, aabb_max, size) = GetDivisionCells_COUNT(points, count);

            int maxCount = cells.
                SelectMany(o => o).
                Max(o => o.Count);

            Debug3DWindow window = new Debug3DWindow()
            {
                Title = $"Highlight Boundries {count}: {filename}",
            };

            var sizes = Debug3DWindow.GetDrawSizes(Math.Min(aabb_max.X - aabb_min.X, aabb_max.Y - aabb_min.Y));

            var axiis = new[]
            {
                new AxisFor(Axis.X, 0, -1),
                new AxisFor(Axis.X, 0, 1),
                new AxisFor(Axis.Y, 0, -1),
                new AxisFor(Axis.Y, 0, 1),
            };

            for (int row = 0; row < cells.Length; row++)
            {
                for (int col = 0; col < cells[row].Length; col++)
                {
                    if (cells[row][col].Count == 0)
                    {
                        window.AddSquare(cells[row][col].Min, cells[row][col].Max, UtilityWPF.ColorFromHex("6B44"));
                        continue;
                    }

                    if (axiis.Any(o => IsEmpty(row, col, cells, o)))
                    {
                        window.AddSquare(cells[row][col].Min, cells[row][col].Max, UtilityWPF.ColorFromHex("88B8"));
                        continue;
                    }
                }
            }

            window.Show();
        }
        static void DrawCountGrid_HighlightBoundries(Point[] points, double cellSize, string filename)
        {
            var (cells, aabb_min, aabb_max, size) = GetDivisionCells(points, cellSize);

            int maxCount = cells.
                SelectMany(o => o).
                Max(o => o.Count);

            Debug3DWindow window = new Debug3DWindow()
            {
                Title = $"Highlight Boundries: {filename}",
            };

            //var sizes = Debug3DWindow.GetDrawSizes(Math.Min(aabb_max.X - aabb_min.X, aabb_max.Y - aabb_min.Y));

            window.AddDots(points.Select(o => o.ToPoint3D()), 0.03, Colors.Gray);

            var axiis = new[]
            {
                new AxisFor(Axis.X, 0, -1),
                new AxisFor(Axis.X, 0, 1),
                new AxisFor(Axis.Y, 0, -1),
                new AxisFor(Axis.Y, 0, 1),
            };

            for (int row = 0; row < cells.Length; row++)
            {
                for (int col = 0; col < cells[row].Length; col++)
                {
                    if (cells[row][col].Count == 0)
                    {
                        window.AddSquare(cells[row][col].Min, cells[row][col].Max, UtilityWPF.ColorFromHex("6B44"));
                        continue;
                    }

                    if (axiis.Any(o => IsEmpty(row, col, cells, o)))
                    {
                        window.AddSquare(cells[row][col].Min, cells[row][col].Max, UtilityWPF.ColorFromHex("88B8"));
                        continue;
                    }
                }
            }

            window.Show();
        }

        private static void DrawCountGrid_SplitIslands(Point[] points, double cellSize, string filename)
        {
            var (cells, aabb_min, aabb_max, size) = GetDivisionCells(points, cellSize);

            int maxCount = cells.
                SelectMany(o => o).
                Max(o => o.Count);

            #region draw orig

            Debug3DWindow window = new Debug3DWindow()
            {
                Title = $"Split Islands - Orig: {filename}",
            };

            window.AddDots(points.Select(o => o.ToPoint3D()), 0.03, Colors.Gray);

            for (int row = 0; row < cells.Length; row++)
            {
                for (int col = 0; col < cells[row].Length; col++)
                {
                    Color color = cells[row][col].Count == 0 ?
                        UtilityWPF.ColorFromHex("6B44") :
                        UtilityWPF.ColorFromHex("88B8");

                    window.AddSquare(cells[row][col].Min, cells[row][col].Max, color);
                }
            }

            window.Show();

            #endregion

            // if count > 1 ; foreach island

            var islands = FindIslands(cells);

            foreach (var island in islands)
            {
                #region draw island

                window = new Debug3DWindow()
                {
                    Title = $"Island: {filename}",
                    Background = UtilityWPF.BrushFromHex("444"),
                };

                foreach (var cellIndex in island)
                {
                    DivisionCell cell = cells[cellIndex.row][cellIndex.col];

                    var cellPoints = points.
                        Where(o => ContainsPoint(cell.Min, cell.Max, o)).
                        Select(o => o.ToPoint3D());

                    window.AddDots(cellPoints, 0.04, Colors.Gray);

                    Color color = cell.Count == 0 ?
                        UtilityWPF.ColorFromHex("6B44") :
                        UtilityWPF.ColorFromHex("88B8");

                    window.AddSquare(cell.Min, cell.Max, color);
                }

                window.Show();

                #endregion
            }
        }

        #endregion
        #region Private Methods

        private static (Point[] points, TransformsToFrom2D_wpf transforms) ConvertTo2D(Face3D_Points face)
        {
            // Need to flatten all points to the plane, the GetConvexHull function's coplanar check is pretty strict
            var plane = Math3D.GetPlane(face.Center, face.Normal);

            var strictPoints = face.ContainedPoints.
                Select(o => Math3D.GetClosestPoint_Plane_Point(plane, o)).
                ToArray();

            TransformsToFrom2D_wpf transforms = Math2D.GetTransformTo2D(face.ContainedPoints);

            return
            (
                face.ContainedPoints.
                    Select(o => transforms.From3D_To2D.Transform(o).ToPoint2D()).
                    ToArray(),
                transforms
            );
        }

        private static (DivisionCell[][] cells, Point aabb_min, Point aabb_max, double size) GetDivisionCells_COUNT_SQUARE(Point[] points, int numRowsColumns)
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
        private static (DivisionCell[][] cells, Point aabb_min, Point aabb_max, double size) GetDivisionCells_COUNT(Point[] points, int numRowsColumns)
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
        private static (DivisionCell[][] cells, Point aabb_min, Point aabb_max, double size) GetDivisionCells(Point[] points, double cellSize)
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

        private static (int col, int row)[][] FindIslands(DivisionCell[][] cells)
        {
            //TODO: Since the scan will walk in a specific direction, only half of these are needed
            var directions = new (int col, int row)[]
            {
                (-1, -1),
                (-1, 0),
                (-1, 1),

                (0, -1),
                (0, 0),       // self is needed for single celled islands
                (0, 1),

                (1, -1),
                (1, 0),
                (1, 1),
            };

            int stride = cells[0].Length;
            if (!cells.All(o => o.Length == stride))
                throw new ApplicationException("Cells aren't a rectangle: " + cells.Select(o => o.Length.ToString()).ToJoin(", "));

            var neighbors = new List<(int cell1, int cell2)>();

            for (int row = 0; row < cells.Length; row++)
            {
                for (int col = 0; col < cells[row].Length; col++)
                {
                    if (IsEmpty(row, col, cells))
                        continue;

                    foreach (var dir in directions)
                    {
                        if (!IsEmpty(row + dir.row, col + dir.col, cells))
                            neighbors.Add(GetSortedPair(row, col, row + dir.row, col + dir.col, stride));
                    }
                }
            }

            var islands = new List<List<int>>();

            foreach (var pair in neighbors.Distinct())
            {
                AddToIslands(islands, pair.cell1, pair.cell2);
            }

            var finalIslands = TryMergeIslands(islands);

            return finalIslands.
                Select(o => o.
                    Select(p =>
                    (
                        p % stride,     // col
                        p / stride      // row
                    )).
                    ToArray()).
                ToArray();
        }
        private static (int cell1, int cell2) GetSortedPair(int row1, int col1, int row2, int col2, int stride)
        {
            if (row1 < row2)
                return ((row1 * stride) + col1, (row2 * stride) + col2);
            else
                return ((row2 * stride) + col2, (row1 * stride) + col1);
        }
        private static void AddToIslands(List<List<int>> islands, int index1, int index2)
        {
            foreach (var island in islands)
            {
                if (island.Contains(index1))
                {
                    island.Add(index2);
                    return;
                }

                if (island.Contains(index2))
                {
                    island.Add(index1);
                    return;
                }
            }

            islands.Add(new List<int>() { index1, index2 });
        }
        private static int[][] TryMergeIslands(List<List<int>> islands)
        {
            List<int[]> retVal = islands.
                Select(o => o.Distinct().OrderBy().ToArray()).
                ToList();

            int i1 = 0;
            while (i1 < retVal.Count - 1)
            {
                bool hadMerge = false;
                int i2 = i1 + 1;
                while (i2 < retVal.Count)
                {
                    if (TryMergeIslands_HasCommon(retVal[i1], retVal[i2]))
                    {
                        retVal[i1] = retVal[i1].
                            Concat(retVal[i2]).
                            Distinct().
                            OrderBy().
                            ToArray();

                        retVal.RemoveAt(i2);
                        hadMerge = true;
                    }
                    else
                    {
                        i2++;
                    }
                }

                if (!hadMerge)       // this probably isn't needed, but rescanning to make sure one of the merged values doesn't match
                    i1++;
            }

            return retVal.ToArray();
        }
        //NOTE: This is optimized by the fact that both sets are sorted
        private static bool TryMergeIslands_HasCommon(int[] set1, int[] set2)
        {
            int i2 = 0;

            for (int i1 = 0; i1 < set1.Length; i1++)
            {
                while (true)
                {
                    if (i2 >= set2.Length)
                        return false;

                    else if (set2[i2] > set1[i1])
                        break;

                    else if (set1[i1] == set2[i2])
                        return true;

                    else
                        i2++;
                }
            }

            return false;
        }

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
        private static bool ContainsPoint(Point min, Point max, Point test)
        {
            return test.X >= min.X && test.X <= max.X && test.Y >= min.Y && test.Y <= max.Y;
        }

        private static bool IsEmpty(int row, int col, DivisionCell[][] cells, AxisFor axis)
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
        private static bool IsEmpty(int row, int col, DivisionCell[][] cells)
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

        #endregion
    }
}
