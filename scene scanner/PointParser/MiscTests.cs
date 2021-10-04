using Game.Core;
using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF.Controls3D;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Media3D;

namespace PointParser
{
    public static class MiscTests
    {
        public static void RandomCirclePoints()
        {
            for (int cntr = 6; cntr <= 18; cntr += 6)
            {
                RandomCirclePoints_DoIt(cntr);
            }
        }

        #region Private Methods

        private static void RandomCirclePoints_DoIt(int stopCount)
        {
            Debug3DWindow window = new Debug3DWindow()
            {
                Title = $"Random Circle Points: {stopCount}",
            };

            Vector[] staticPoint = new[] { new Vector() };
            double[] staticMult = new[] { 3d };


            var cells = Math2D.GetCells(4, 8, 8);

            foreach (var cell in cells)
            {
                Vector[] points = Math3D.GetRandomVectors_Circular_EvenDist(StaticRandom.Next(5, 7), 1, stopIterationCount: stopCount, existingStaticPoints: staticPoint, staticRepulseMultipliers: staticMult);

                window.AddDot(cell.center.ToPoint3D(), 0.05, Colors.White);

                window.AddDots(points.Select(o => (cell.center + o).ToPoint3D()), 0.07, Colors.Navy);
            }

            window.Show();
        }

        #endregion
    }
}
