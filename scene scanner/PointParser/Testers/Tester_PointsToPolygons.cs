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
        private static void Thoughts(Face3D_Points face, string filename)
        {
            var points2D = UtilityGridCells.ConvertTo2D(face);

            DrawPoints(points2D.points, filename);


            // --- IDEA ---
            // Find a convex polygon
            // Break the the area into a series of squares
            // Any square that has no points in it is something that must be blocked off
            //
            // Maybe create a voronoi out of the square centers?


            //DrawCountGrid_Basic(points2D.points, 18);
            DrawCountGrid_Basic(points2D.points, 0.75, filename);

            //DrawCountGrid_HighlightBoundries_CELLCOUNT(points2D.points, 9, filename);
            DrawCountGrid_HighlightBoundries(points2D.points, 0.75, filename);

            DrawCountGrid_SplitIslands(points2D.points, 0.75, filename);



            // In cells that are low populated and mostly standalone, add some random points around each of those points and redo the grid
            // This should give a clearer picture and make the polygon smoother
        }

        public static void JustPoints(Face3D_Points face, string filename)
        {
            var points2D = UtilityGridCells.ConvertTo2D(face);

            DrawPoints(points2D.points, filename);
        }
        public static void Grid_Basic(Face3D_Points face, string filename)
        {
            var points2D = UtilityGridCells.ConvertTo2D(face);

            DrawCountGrid_Basic(points2D.points, 0.75, filename);
        }
        /// <summary>
        /// Identify cells that are filled next to cells that are empty
        /// </summary>
        /// <remarks>
        /// Maybe identify the prominent points in those boundry cells --- may not be needed?
        /// </remarks>
        public static void Grid_Boundries(Face3D_Points face, string filename)
        {
            var points2D = UtilityGridCells.ConvertTo2D(face);

            // Identify cells that are filled next to cells that are empty
            //DrawCountGrid_HighlightBoundries_CELLCOUNT(points2D.points, 9, filename);
            DrawCountGrid_HighlightBoundries(points2D.points, 0.75, filename);

            // Identify the prominent points in those boundry cells --- may not be needed?

        }
        /// <summary>
        /// Identify cell sets that are completely separate from others
        /// </summary>
        public static void Grid_Islands(Face3D_Points face, string filename)
        {
            var points2D = UtilityGridCells.ConvertTo2D(face);

            // Identify cell sets that are completely separate from others
            DrawCountGrid_SplitIslands(points2D.points, 0.75, filename);
        }
        /// <summary>
        /// This looks for
        /// </summary>
        /// <remarks>
        /// This won't bother with islands, it will only focus on low population expansion
        /// </remarks>
        public static void Grid_LowPopulation(Face3D_Points face, string filename)
        {
            // Look for (these rules are close, but not the final):
            //  cells with count <= 3 and
            //  empty neighbor count >= 5 and
            //  not a simple corner

            var points2D = UtilityGridCells.ConvertTo2D(face);

            //DrawCountGrid_LowPopulation(points2D.points, 1, 0.3, filename, UtilityWPF.BrushFromHex("505050"));     // this doesn't improve things for low population, but could be useful for the final concave/hole pass

            DrawCountGrid_LowPopulation(points2D.points, 0.75, 0.08, filename, UtilityWPF.BrushFromHex("666"));
            //DrawCountGrid_LowPopulation(points2D.points, 0.75, 0.1, filename, UtilityWPF.BrushFromHex("777"));
            //DrawCountGrid_LowPopulation(points2D.points, 0.75, 0.12, filename, UtilityWPF.BrushFromHex("888"));
        }

        #region Private Methods

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
            var (cells, aabb_min, aabb_max, size) = UtilityGridCells.GetDivisionCells(points, cellSize);

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
            var (cells, aabb_min, aabb_max, size) = UtilityGridCells.GetDivisionCells_COUNT(points, count);

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

                    if (axiis.Any(o => UtilityGridCells.IsEmpty(row, col, cells, o)))
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
            var (cells, aabb_min, aabb_max, size) = UtilityGridCells.GetDivisionCells(points, cellSize);

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

                    if (axiis.Any(o => UtilityGridCells.IsEmpty(row, col, cells, o)))
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
            var (cells, aabb_min, aabb_max, size) = UtilityGridCells.GetDivisionCells(points, cellSize);

            //int maxCount = cells.
            //    SelectMany(o => o).
            //    Max(o => o.Count);

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

            var islands = UtilityIslands.FindIslands(cells);

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
                        Where(o => UtilityGridCells.ContainsPoint(cell.Min, cell.Max, o)).
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

        private static void DrawCountGrid_LowPopulation(Point[] points, double cellSize, double extrPointsRadius, string filename, Brush backbrush)
        {
            var (cells, aabb_min, aabb_max, size) = UtilityGridCells.GetDivisionCells(points, cellSize);

            Debug3DWindow window = new Debug3DWindow()
            {
                Title = $"Low Population Expansion: {filename}",
                Background = backbrush,
            };

            window.AddDots(points.Select(o => o.ToPoint3D()), 0.03, Colors.Gray);

            Color color;

            for (int row = 0; row < cells.Length; row++)
            {
                for (int col = 0; col < cells[row].Length; col++)
                {
                    // Draw Square
                    bool isLowPopulation = false;

                    if (cells[row][col].Count == 0)
                    {
                        color = UtilityWPF.ColorFromHex("08661111");
                    }
                    else if (UtilityLowPopulation.IsLowPopulationCell(col, row, cells))
                    {
                        isLowPopulation = true;
                        color = UtilityWPF.ColorFromHex("A484");
                    }
                    else
                    {
                        color = UtilityWPF.ColorFromHex("88B8");
                    }

                    window.AddSquare(cells[row][col].Min, cells[row][col].Max, color);

                    // Draw Points
                    if (isLowPopulation)
                    {
                        var extraPoints = points.
                            Where(o => UtilityGridCells.ContainsPoint(cells[row][col].Min, cells[row][col].Max, o)).
                            //SelectMany(o => GetExtraLowPopulationPoints(o, extrPointsRadius)).
                            SelectMany(o => UtilityLowPopulation.GetExtraLowPopulationPoints(o, StaticRandom.NextDouble(0.08, 0.12))).
                            Select(o => o.ToPoint3D());

                        window.AddDots(extraPoints, 0.03, Colors.Black);
                    }
                }
            }

            window.Show();
        }

        #endregion
    }
}
