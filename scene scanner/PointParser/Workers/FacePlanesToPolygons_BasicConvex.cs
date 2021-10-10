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
    public static class FacePlanesToPolygons_BasicConvex
    {
        /// <summary>
        /// This is the simplest possible implementation.  It makes convex polygons, throws out faces with too few
        /// points, papers over large gaps of no points
        /// </summary>
        public static SceneFace_Polygons ConvertToPolygons(SceneFace_Points faces)
        {
            // This is a copy of the SOM version, but made as simple as possible

            var polys = faces.Faces.
                AsParallel().
                Select(o => ConvertToPolygons(o)).
                Where(o => o != null).
                ToArray();

            return new SceneFace_Polygons()
            {
                Materials = faces.Materials,
                Faces = polys,
            };
        }

        private static Face3D_Polygon ConvertToPolygons(Face3D_Points face)
        {
            try
            {
                if (face.ContainedPoints.Length < 3)
                    return null;

                // Need to flatten all points to the plane, the GetConvexHull function's coplanar check is pretty strict
                var plane = Math3D.GetPlane(face.Center, face.Normal);

                var strictPoints = face.ContainedPoints.
                    Select(o => Math3D.GetClosestPoint_Plane_Point(plane, o)).
                    ToArray();

                QuickHull2DResult_wpf hull2D = Math2D.GetConvexHull(strictPoints);

                if (hull2D == null)     // saw this when there were only 3 points and 2 of them were the same
                    return null;

                // Only need to keep the points along the perimiter
                Point[] perimiterPoints2D = hull2D.PerimiterLines.
                    Select(o => hull2D.Points[o]).
                    ToArray();

                Point3D[] perimiterPoints3D = perimiterPoints2D.
                    Select(o => hull2D.GetTransformedPoint(o)).
                    ToArray();

                var triangles = Math2D.GetDelaunayTriangulation(perimiterPoints2D, perimiterPoints3D);

                if (triangles.Length == 0)
                    return null;

                return new Face3D_Polygon()
                {
                    MaterialIndex = face.MaterialIndex,
                    Center = Math3D.GetCenter(perimiterPoints3D),
                    Normal = face.Normal,
                    Edges = Enumerable.Range(0, perimiterPoints2D.Length).ToArray(),
                    //Mesh = UtilityWPF.GetMeshFromTriangles(triangles),
                    Mesh = triangles,
                };
            }
            catch(Exception)
            {
                // Delaunay threw an exception with duplicate points.  This would be really rare.  Probably possible to fix
                // but not worth the time
                return null;
            }
        }
    }
}
