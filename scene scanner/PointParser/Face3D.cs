using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace PointParser
{
    public record SceneFaces
    {
        public string[] Materials { get; init; }
        public Face3D[] Faces { get; init; }
    }

    /// <summary>
    /// This is a plane that contains sample points
    /// </summary>
    public record Face3D
    {
        public int MaterialIndex { get; init; }

        public Point3D Center { get; init; }
        public Vector3D Normal { get; init; }

        /// <summary>
        /// These are points contained in the plane
        /// </summary>
        /// <remarks>
        /// These points should all be coplanar
        /// </remarks>
        public Point3D[] ContainedPoints { get; init; }
    }
}
