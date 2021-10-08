using Game.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PointParser
{
    /// <summary>
    /// This finds sets of populated cells that are completely surrounded by unpopulated cells
    /// </summary>
    public static class UtilityIslands
    {
        public static (int col, int row)[][] FindIslands(DivisionCell[][] cells)
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
                    if (UtilityGridCells.IsEmpty(row, col, cells))
                        continue;

                    foreach (var dir in directions)
                    {
                        if (!UtilityGridCells.IsEmpty(row + dir.row, col + dir.col, cells))
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

        #region Private Methods

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


        #endregion
    }
}
