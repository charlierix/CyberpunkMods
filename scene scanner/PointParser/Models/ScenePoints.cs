using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace PointParser.Models
{
    public record ScenePoints
    {
        public string[] Materials { get; init; }
        public PointEntry[] Points { get; init; }
    }

    public record PointEntry
    {
        public Point3D Hit { get; init; }
        public Vector3D Normal { get; init; }
        public int MaterialIndex { get; init; }
    }
}
