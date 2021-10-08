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

namespace PointParser.Workers
{
    public static class PointIslandSeparator
    {
        private const double CELLSIZE = 0.75;

        public static SceneFace_Points SeparateAndCleanPoints(SceneFace_Points faces_point)
        {
            // Iterate the faces in parallel
            // Each face has a chance of splitting into many

            var retVal = faces_point.Faces.
                SelectMany(o => ProcessPoints(o)).
                ToArray();

            return faces_point with
            {
                Faces = retVal,
            };
        }

        #region Private Methods

        private static Face3D_Points[] ProcessPoints(Face3D_Points face)
        {
            var (points, transforms) = UtilityGridCells.ConvertTo2D(face);

            var (cells, aabb_min, aabb_max, size) = UtilityGridCells.GetDivisionCells(points, CELLSIZE);

            var islands = UtilityIslands.FindIslands(cells);

            var retVal = new List<Face3D_Points>();

            foreach (var island in islands)
            {
                // Low Population
                Point[] islandPoints2D = GetIslandPoints_LowPopulation(island, points, cells);

                Point3D[] islandPoints3D = islandPoints2D.
                    Select(o => transforms.From2D_BackTo3D.Transform(o.ToPoint3D())).
                    ToArray();

                retVal.Add(face with
                {
                    Center = Math3D.GetCenter(islandPoints3D),
                    ContainedPoints = islandPoints3D,
                });
            }

            return retVal.ToArray();
        }

        /// <summary>
        /// This adds some extra points around points in low population cells
        /// </summary>
        /// <remarks>
        /// Low population cells are cells with almost no points in them, and almost all neighbor cells are
        /// empty
        /// 
        /// This way, proper polygons can be built with these tiny sample points.  It will still be small
        /// fragment polygons, but should be better than not doing anything
        /// </remarks>
        private static Point[] GetIslandPoints_LowPopulation((int col, int row)[] island, Point[] allPoints, DivisionCell[][] cells)
        {
            var retVal = new List<Point>();

            foreach (var islandCell in island)
            {
                DivisionCell cell = cells[islandCell.row][islandCell.col];

                if (cell.Count == 0)        // it shouldn't be empty when coming from the get islands function, but the check doesn't hurt
                    continue;

                Point[] points = allPoints.
                    Where(o => UtilityGridCells.ContainsPoint(cell.Min, cell.Max, o)).
                    ToArray();

                if (UtilityLowPopulation.IsLowPopulationCell(islandCell.col, islandCell.row, cells))
                {
                    foreach (Point point in points)
                    {
                        retVal.AddRange(UtilityLowPopulation.GetExtraLowPopulationPoints(point, StaticRandom.NextDouble(0.08, 0.12)));
                    }
                }

                retVal.AddRange(points);
            }

            return retVal.ToArray();
        }

        #endregion
    }
}
