using Game.Core;
using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace PointParser
{
    public static class UtilityLowPopulation
    {
        #region Declaration Section

        private static Lazy<(AxisFor, AxisFor)[]> _edgeIterators = new Lazy<(AxisFor, AxisFor)[]>(() => new[]
            {
                (new AxisFor(Axis.X, -1, 1), new AxisFor(Axis.Y, -1, -1)),
                (new AxisFor(Axis.X, -1, 1), new AxisFor(Axis.Y, 1, 1)),
                (new AxisFor(Axis.X, -1, -1), new AxisFor(Axis.Y, -1, 1)),
                (new AxisFor(Axis.X, 1, 1), new AxisFor(Axis.Y, -1, 1)),
            });

        #endregion

        public static bool IsLowPopulationCell(int col, int row, DivisionCell[][] cells)
        {
            // Look for:
            //  cells with count <= 3 and
            //  empty neighbor count >= 5 and
            //  not a simple corner

            if (cells[row][col].Count > 3)
                return false;

            // Don't allow opposing filled cells (a straight line of 3 cells)
            if (!UtilityGridCells.IsEmpty(row - 1, col, cells) && !UtilityGridCells.IsEmpty(row + 1, col, cells))
                return false;

            if (!UtilityGridCells.IsEmpty(row, col - 1, cells) && !UtilityGridCells.IsEmpty(row, col + 1, cells))
                return false;

            // Don't allow all 3 in a corner
            if (IsLowPopulationCell_IsCornerPopulated(row, col, -1, -1, cells))
                return false;

            if (IsLowPopulationCell_IsCornerPopulated(row, col, -1, 1, cells))
                return false;

            if (IsLowPopulationCell_IsCornerPopulated(row, col, 1, -1, cells))
                return false;

            if (IsLowPopulationCell_IsCornerPopulated(row, col, 1, 1, cells))
                return false;

            // Don't allow three in a row next to this cell
            foreach (var axisPair in _edgeIterators.Value)
            {
                if (IsLowPopulationCell_IsEdgePopulated_TWOCONSECUTIVE(row, col, axisPair.Item1, axisPair.Item2, cells))
                    return false;
            }

            return true;
        }

        public static Point[] GetExtraLowPopulationPoints(Point center, double radius)
        {
            Vector[] staticPoint = new[] { new Vector() };
            double[] staticMult = new[] { 3d };

            // Makes either 5 or 6 points in a ring around the center.  Using a small iteration count so it's not
            // too uniform
            Vector[] points = Math3D.GetRandomVectors_Circular_EvenDist(StaticRandom.Next(5, 7), 1, stopIterationCount: 11, existingStaticPoints: staticPoint, staticRepulseMultipliers: staticMult);

            return points.
                Select(o => center + (o * radius)).
                ToArray();
        }

        #region Private Methods

        private static bool IsLowPopulationCell_IsCornerPopulated(int row, int col, int rowOffset, int colOffset, DivisionCell[][] cells)
        {
            return
                !UtilityGridCells.IsEmpty(row + rowOffset, col, cells) &&
                !UtilityGridCells.IsEmpty(row, col + colOffset, cells);
            //!IsEmpty(row + rowOffset, col + colOffset, cells);        // first attempt was all three needing to be filled, but just the two is enough to be considered a corner
        }
        private static bool IsLowPopulationCell_IsEdgePopulated_ALLTHREE(int row, int col, AxisFor axis1, AxisFor axis2, DivisionCell[][] cells)
        {
            foreach (int offset1 in axis1.Iterate())
            {
                foreach (int offset2 in axis2.Iterate())
                {
                    int offset_col = 0;
                    int offset_row = 0;
                    axis1.Set2DIndex(ref offset_col, ref offset_row, offset1);
                    axis2.Set2DIndex(ref offset_col, ref offset_row, offset2);

                    if (UtilityGridCells.IsEmpty(row + offset_row, col + offset_col, cells))
                        return false;       // one of the edge pieces is empty, so it's not a solid line
                }
            }

            return true;        // all are filled
        }
        private static bool IsLowPopulationCell_IsEdgePopulated_TWOCONSECUTIVE(int row, int col, AxisFor axis1, AxisFor axis2, DivisionCell[][] cells)
        {
            int consecutiveCount = 0;
            int maxCount = 0;

            foreach (int offset1 in axis1.Iterate())
            {
                foreach (int offset2 in axis2.Iterate())
                {
                    int offset_col = 0;
                    int offset_row = 0;
                    axis1.Set2DIndex(ref offset_col, ref offset_row, offset1);
                    axis2.Set2DIndex(ref offset_col, ref offset_row, offset2);

                    if (UtilityGridCells.IsEmpty(row + offset_row, col + offset_col, cells))
                        consecutiveCount = 0;
                    else
                        consecutiveCount++;

                    maxCount = Math.Max(consecutiveCount, maxCount);        // this is needed, because it could be 2 then 0, so the 2 needs to be remembered
                }
            }

            return maxCount > 1;        // filled empty filled is ok, but filled filled empty isn't (or empty filled filled)
        }

        #endregion
    }
}
