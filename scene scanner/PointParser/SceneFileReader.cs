using Game.Math_WPF.Mathematics;
using PointParser.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace PointParser
{
    public static class SceneFileReader
    {
        public static ScenePoints ParsePointsFile(string filename)
        {
            var materials = new List<string>();
            var points = new List<PointEntry>();

            bool sawMaterial = false;
            bool sawHit = false;

            using (StreamReader reader = new StreamReader(new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)))
            {
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    if (string.IsNullOrWhiteSpace(line))
                    {
                        continue;
                    }
                    else if (line == "--- Materials ---")
                    {
                        sawMaterial = true;
                        continue;
                    }
                    else if (line == "--- Hits ---")
                    {
                        sawHit = true;
                        continue;
                    }

                    if (sawHit)
                    {
                        AddHit(line, points);
                    }
                    else if (sawMaterial)
                    {
                        AddMaterial(line, materials);
                    }
                }
            }

            return new ScenePoints()
            {
                Materials = materials.ToArray(),
                Points = points.ToArray(),
            };
        }

        #region Private Methods

        private static void AddMaterial(string line, List<string> materials)
        {
            string[] split = line.Split('\t');

            if (split.Length != 2)
                throw new ApplicationException($"Unexpected Material:\r\n{line}");

            if (!int.TryParse(split[0], out int index))
                throw new ApplicationException($"Couldn't parse material index as an int:\r\n{line}");

            if (index != materials.Count + 1)        // lua is one based
                throw new ApplicationException($"Materials are out of order:\r\n{line}");

            materials.Add(split[1]);
        }

        private static void AddHit(string line, List<PointEntry> points)
        {
            string[] split = line.Split('|');

            if (split.Length != 7)
                throw new ApplicationException($"Unexpected Hit:\r\n{line}");

            double[] doubles = new double[6];
            for (int i = 0; i < 6; i++)
            {
                if (!double.TryParse(split[i], out double cast))
                    throw new ApplicationException($"Couldn't parse hit value as a double:\r\n{line}");

                doubles[i] = cast;
            }

            if (!int.TryParse(split[6], out int index))
                throw new ApplicationException($"Couldn't parse hit's material index as an int:\r\n{line}");

            points.Add(new PointEntry()
            {
                Hit = new Point3D(doubles[0], doubles[1], doubles[2]),
                Normal = new Vector3D(doubles[3], doubles[4], doubles[5]).ToUnit(),
                MaterialIndex = index - 1,      // lua is one based, but this needs to point into the c# zero based array
            });
        }

        private static void EXAMPLE_FILE()
        {
            string example =
@"--- Materials ---
1	default_material.physmat
2	metal.physmat
3	concrete.physmat
4	metal_semitransparent.physmat
5	metal_painted.physmat
6	cardboard.physmat
7	vehicle_chassis.physmat
8	metal_transparent.physmat
9	metal_car.physmat
10	plaster.physmat
11	plexiglass.physmat
12	metal_hollow.physmat
13	metal_techpiercable.physmat
14	trash_bag.physmat
15	plastic.physmat
16	glass_electronics.physmat
17	tiles.physmat
18	tire_car.physmat
19	fabrics.physmat
20	metal_heavypiercable.physmat
21	metal_catwalk.physmat
22	paper.physmat


--- Hits ---
-1123.887|1534.039|38.114|0.013|-0.001|-1|1
-1143.029|1538.179|30.468|0.997|-0.079|0|2
-1131.452|1539.708|28.249|-0.001|-0.069|0.998|3
-1131.939|1539.511|27.794|-0.006|-0.076|0.997|3
-1129.469|1540.164|30.812|-1|0.025|-0.001|4
-1122.298|1550.982|36.76|0.007|-0.001|-1|1
-1129.261|1548.438|30.134|-1|0.025|-0.001|4
-1134.852|1542.472|27.939|-0.002|-0.075|0.997|1
-1140.479|1531.861|36.154|0|0|-1|3
-1136.377|1542.033|27.903|-0.002|-0.075|0.997|1
-1137.215|1534.669|37.924|0.015|-0.001|-1|1
-1136.032|1538.15|27.611|-0.002|-0.075|0.997|1
-1129.446|1532.227|38.044|0.013|-0.001|-1|1
-1132.537|1536.822|37.993|0.015|-0.001|-1|1
-1140.298|1532.396|31.618|0.998|-0.067|0|3
-1142.273|1538.767|37.818|0.067|0.998|0|3
-1136.045|1538.213|27.616|-0.002|-0.075|0.997|1
-1137.179|1541.133|27.877|-0.006|-0.075|0.997|3
-1136.186|1543.815|28.038|-0.002|-0.075|0.997|1
-1148.682|1533.467|37.743|0.016|-0.001|-1|1
-1136.514|1540.716|27.804|-0.002|-0.075|0.997|1
-1137.849|1542.532|27.978|-0.006|-0.075|0.997|3
-1143.58|1549.183|37.455|-0.056|-0.84|-0.54|1
-1142.946|1540.293|29.462|0.997|-0.079|0|5
-1135.797|1538.688|27.652|-0.002|-0.075|0.997|1
-1131.35|1543.524|28.397|-0.999|0.038|0.001|3
-1140.297|1537.639|36.154|0|0|-1|3
-1138.882|1548.022|31.19|-0.087|-0.996|0.007|4
-1132.645|1545.353|28.234|-0.006|-0.076|0.997|3
-1140.03|1536.419|35.307|0.998|-0.067|0|3
-1127.981|1521.978|26.832|0.017|0.555|0.832|3
-1135.807|1542.527|27.941|-0.002|-0.075|0.997|1
-1133.372|1543.677|28.078|-0.66|-0.04|0.75|2
-1129.495|1539.065|29.863|-1|0.025|-0.001|4
-1139.189|1539.935|27.775|-0.006|-0.075|0.997|3
-1135.239|1542.85|27.967|-0.002|-0.075|0.997|1
-1133.358|1538.937|37.978|0.015|-0.001|-1|1
-1137.065|1543.736|28.073|-0.006|-0.075|0.997|3
";
        }

        #endregion
    }
}
