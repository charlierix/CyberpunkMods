using Game.Math_WPF.Mathematics;
using PointParser.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace PointParser.Workers
{
    public static class PointsToPlanes
    {
        public const double NORMAL_EPSILON = 0.03;
        public const double PLANEDIST_EPSILON = 0.03;

        #region class: ByNormal

        private record ByNormal
        {
            public Vector3D Normal { get; init; }
            public List<Point3D> Points { get; } = new List<Point3D>();

            public bool TryAdd(Point3D point, Vector3D normal)
            {
                double dot = Vector3D.DotProduct(Normal, normal);

                if (1 - dot <= NORMAL_EPSILON)
                {
                    Points.Add(point);
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        #endregion
        #region class: ByPlane

        private class ByPlane
        {
            public ITriangle_wpf Plane { get; init; }

            public List<Point3D> Points { get; } = new List<Point3D>();

            public bool TryAdd(Point3D point, Vector3D normal)
            {
                double dot = Vector3D.DotProduct(Plane.NormalUnit, normal);

                if (1 - dot > NORMAL_EPSILON)
                    return false;

                double distance = Math3D.DistanceFromPlane(Plane, point);
                if (Math.Abs(distance) > PLANEDIST_EPSILON)
                    return false;

                Points.Add(point);

                return true;
            }
        }

        #endregion

        public static SceneFace_Points ConvertToFaces(ScenePoints points)
        {
            var faceSets = points.Points.
                ToLookup(o => o.MaterialIndex).
                AsParallel().
                Select(o => GetFaces(o.Key, o.ToArray())).
                ToArray();

            return new SceneFace_Points()
            {
                Materials = points.Materials,
                Faces = faceSets.
                    SelectMany(o => o).
                    ToArray(),
            };
        }

        #region Private Methods

        private static Face3D_Points[] GetFaces(int materialIndex, PointEntry[] points)
        {
            ByPlane[] byPlanes = GroupByNormal(points).     // Doing by normal first to hopefully reduce the total number of compares
                SelectMany(o => GroupByPlane(o)).
                ToArray();

            //TODO: Cluster the points in each normal grouping and divide into multiple faces if there are distinct clusters far apart

            return byPlanes.
                Select(o => new Face3D_Points()
                {
                    MaterialIndex = materialIndex,
                    Center = Math3D.GetCenter(o.Points),
                    Normal = o.Plane.NormalUnit,
                    ContainedPoints = o.Points.ToArray(),
                }).
                ToArray();
        }

        private static ByNormal[] GroupByNormal(PointEntry[] points)
        {
            var retVal = new List<ByNormal>();

            foreach (PointEntry point in points)
            {
                bool wasAdded = false;

                foreach (ByNormal group in retVal)
                {
                    if (group.TryAdd(point.Hit, point.Normal))
                    {
                        wasAdded = true;
                        break;
                    }
                }

                if (!wasAdded)
                {
                    retVal.Add(new ByNormal()
                    {
                        Normal = point.Normal,
                    });

                    retVal[^1].Points.Add(point.Hit);
                }
            }

            return retVal.ToArray();
        }
        private static ByPlane[] GroupByPlane(ByNormal set)
        {
            var retVal = new List<ByPlane>();

            foreach (Point3D point in set.Points)
            {
                bool wasAdded = false;

                foreach (ByPlane group in retVal)
                {
                    if (group.TryAdd(point, set.Normal))
                    {
                        wasAdded = true;
                        break;
                    }
                }

                if (!wasAdded)
                {
                    retVal.Add(new ByPlane()
                    {
                        Plane = Math3D.GetPlane(point, set.Normal),
                    });

                    retVal[^1].Points.Add(point);
                }
            }

            return retVal.ToArray();
        }

        #endregion
    }
}
