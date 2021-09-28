using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace PointParser.Models
{
    public record SceneFace_Polygons
    {
        public string[] Materials { get; init; }
        public Face3D_Polygon[] Faces { get; init; }
    }

    /// <summary>
    /// This is a plane that has a hull of triangles
    /// </summary>
    public record Face3D_Polygon
    {
        public int MaterialIndex { get; init; }

        public Point3D Center { get; init; }
        public Vector3D Normal { get; init; }

        /// <summary>
        /// These are the triangles that fill in the polygon
        /// </summary>
        /// <remarks>
        /// Can't use mesh, because it's not threadsafe.  Call this to convert to a mesh:
        /// UtilityWPF.GetMeshFromTriangles
        /// </remarks>
        //public MeshGeometry3D Mesh { get; init; }
        public ITriangleIndexed_wpf[] Mesh { get; init; }

        /// <summary>
        /// This is the string of points that define the perimiter of the polygon
        /// </summary>
        public int[] Edges { get; init; }
    }
}
