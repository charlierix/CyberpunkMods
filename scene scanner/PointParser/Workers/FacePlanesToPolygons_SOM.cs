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
using System.Windows.Media.Media3D;

namespace PointParser.Workers
{
    public static class FacePlanesToPolygons_SOM
    {
        public static SceneFace_Polygons ConvertToPolygons(SceneFace_Points faces)
        {
            var cleaned = faces.Faces.

                //OrderByDescending(o => o.ContainedPoints.Length).
                //Take(12).

                AsParallel().

                SelectMany(o => CleanFace(o)).
                Where(o => o != null).
                ToArray();

            return new SceneFace_Polygons()
            {
                Materials = faces.Materials,
                Faces = cleaned,
            };
        }

        #region Private Methods

        private static Face3D_Polygon[] CleanFace(Face3D_Points face)
        {
            var retVal = new List<Face3D_Polygon>();


            if (face.ContainedPoints.Length < 3)
            {
                retVal.AddRange(ExpandToPolygons(face));
            }
            else
            {
                //retVal.Add(SimplifyToPolygon(face));

                //TODO: Need to isolate clusters of points into their own faces
                //GetHull(face);

                //TestSOM(face);

                //string filename = System.IO.Path.Combine(@"D:\SteamLibrary\steamapps\common\Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\mods\scene scanner\scan recordings\extracts", Guid.NewGuid().ToString() + ".json");
                //System.IO.File.WriteAllText(filename, System.Text.Json.JsonSerializer.Serialize(face));



                foreach (Face3D_Points split in SplitSOM(face))
                {
                    if (split.ContainedPoints.Length < 3)
                    {
                        retVal.AddRange(ExpandToPolygons(split));
                    }
                    else
                    {
                        Face3D_Polygon[] subResults = SimplifyToPolygon(split);
                        if (subResults != null)
                            retVal.AddRange(subResults);
                    }
                }
            }

            return retVal.ToArray();
        }

        private static Face3D_Points[] SplitSOM(Face3D_Points face)
        {
            SOMRules rules = new SOMRules(48, 3500, 0.5, 0.1, SOMAttractionFunction.Guassian);      // this runs really quick, so it's probably not using the full 3500 iterations

            var inputs = face.ContainedPoints.
                Select(o => new SOMInput<Point3D>()
                {
                    Source = o,
                    Weights = o.ToVectorND(),
                }).
                ToArray();

            SOMResult result = SelfOrganizingMaps.TrainSOM(inputs, rules, true, false);

            var retVal = new Face3D_Points[result.Nodes.Length];

            for (int cntr = 0; cntr < result.Nodes.Length; cntr++)
            {
                Point3D[] points = result.InputsByNode[cntr].
                    Select(o => ((SOMInput<Point3D>)o).Source).
                    ToArray();

                retVal[cntr] = face with
                {
                    Center = Math3D.GetCenter(points),
                    ContainedPoints = points,
                };
            }

            return retVal;
        }

        private static Face3D_Polygon[] ExpandToPolygons(Face3D_Points face)
        {
            //TODO: Implement this
            return new Face3D_Polygon[0];
        }

        private static Face3D_Polygon[] SimplifyToPolygon(Face3D_Points face)
        {
            // Need to flatten all points to the plane, the GetConvexHull function's coplanar check is pretty strict
            var plane = Math3D.GetPlane(face.Center, face.Normal);

            var strictPoints = face.ContainedPoints.
                Select(o => Math3D.GetClosestPoint_Plane_Point(plane, o)).
                ToArray();

            QuickHull2DResult_wpf hull2D = Math2D.GetConvexHull(strictPoints);

            // Only need to keep the points along the perimiter
            Point[] perimiterPoints2D = hull2D.PerimiterLines.
                Select(o => hull2D.Points[o]).
                ToArray();

            Point3D[] perimiterPoints3D = perimiterPoints2D.
                Select(o => hull2D.GetTransformedPoint(o)).
                ToArray();

            var triangles = Math2D.GetDelaunayTriangulation(perimiterPoints2D, perimiterPoints3D);



            //TODO: Repair these
            if (triangles.Length == 0)
            {
                // Most weren't colinear, they seemed to be long strips that delanauy is throwing out

                //Debug3DWindow window = new Debug3DWindow()
                //{
                //    Title = "Made no triangles",
                //};

                //Point3D center = Math3D.GetCenter(perimiterPoints3D);

                //var sizes = Debug3DWindow.GetDrawSizes(Math.Sqrt(perimiterPoints3D.Max(o => (o - center).LengthSquared)));

                //window.AddDots(perimiterPoints3D.Select(o => o - center), sizes.dot, Colors.Red);

                //window.Show();

                return null;
            }



            return new[]
            {
                new Face3D_Polygon()
                {
                    MaterialIndex = face.MaterialIndex,
                    Center = Math3D.GetCenter(perimiterPoints3D),
                    Normal = face.Normal,
                    Edges = Enumerable.Range(0, perimiterPoints2D.Length).ToArray(),
                    //Mesh = UtilityWPF.GetMeshFromTriangles(triangles),
                    Mesh = triangles,
                }
            };
        }

        #endregion
        #region Private Methods - test visualizations

        // This was just a temp function to figure out how to write the final version
        private static ITriangleIndexed_wpf[] GetHull(Face3D_Points face)
        {
            Brush background = new SolidColorBrush(UtilityWPF.GetRandomColor(192, 205));

            // Need to flatten all points to the plane, the GetConvexHull function's coplanar check is pretty strict
            var plane = Math3D.GetPlane(face.Center, face.Normal);

            var strictPoints = face.ContainedPoints.
                Select(o => Math3D.GetClosestPoint_Plane_Point(plane, o)).
                ToArray();

            QuickHull2DResult_wpf hull2D = Math2D.GetConvexHull(strictPoints);

            #region draw quickhull

            Debug3DWindow window = new Debug3DWindow()
            {
                Title = "QuickHull2DResult_wpf",
                Background = background,
            };


            var points3D = hull2D.Points.
                Select(o => hull2D.GetTransformedPoint(o)).
                ToArray();

            Point3D center = Math3D.GetCenter(points3D);

            points3D = points3D.
                Select(o => (o - center).ToPoint()).
                ToArray();

            var sizes = Debug3DWindow.GetDrawSizes(points3D);

            window.AddAxisLines(1, sizes.line);

            window.AddDots(points3D, sizes.dot, Colors.Yellow);

            window.AddLines(hull2D.PerimiterLines.Select(o => points3D[o]), sizes.line, Colors.White);


            window.Show();

            #endregion

            Point[] perimiterPoints2D = hull2D.PerimiterLines.
                Select(o => hull2D.Points[o]).
                ToArray();

            Point3D[] perimiterPoints3D = perimiterPoints2D.
                Select(o => hull2D.GetTransformedPoint(o)).
                ToArray();

            var triangles = Math2D.GetDelaunayTriangulation(perimiterPoints2D, perimiterPoints3D);

            #region draw triangles

            window = new Debug3DWindow()
            {
                Title = "ITriangleIndexed_wpf",
                Background = background,
            };

            window.AddAxisLines(1, sizes.line);

            var triangles_centered = triangles.
                Select(o => new TriangleIndexed_wpf(o.Index0, o.Index1, o.Index2, o.AllPoints.Select(p => (p - center).ToPoint()).ToArray())).
                ToArray();

            window.AddHull(triangles_centered, Colors.Yellow, Colors.White, sizes.line, isIndependentFaces: false);

            window.Show();

            #endregion

            return triangles;
        }

        // This sort of works, but since it's convex, it still sometimes papers over gaps
        // Need to come up with a custom algorithm that punches holes and/or breaks up when it sees regions with no points
        private static void TestSOM(Face3D_Points face)
        {
            //TODO: Reduce the number of iterations to something more reasonable
            SOMRules rules = new SOMRules(48, 3500, 0.5, 0.1, SOMAttractionFunction.Guassian);

            var inputs = face.ContainedPoints.
                Select(o => new SOMInput<Point3D>()
                {
                    Source = o,
                    Weights = o.ToVectorND(),
                }).
                ToArray();

            SOMResult result = SelfOrganizingMaps.TrainSOM(inputs, rules, true, false);

            Debug3DWindow window = new Debug3DWindow()
            {
                Title = "Face SOM",
            };

            var sizes = Debug3DWindow.GetDrawSizes(face.ContainedPoints);

            Color[] colors = UtilityWPF.GetRandomColors(result.Nodes.Length, 120, 200);

            for (int cntr = 0; cntr < result.Nodes.Length; cntr++)
            {
                var points = result.InputsByNode[cntr].
                    Select(o => ((SOMInput<Point3D>)o).Source);

                window.AddDots(points, sizes.dot, colors[cntr]);
            }

            window.Show();
        }

        #endregion
    }
}
