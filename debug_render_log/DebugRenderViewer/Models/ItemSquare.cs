using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace DebugRenderViewer.Models
{
    public record ItemSquare : ItemBase
    {
        public Point3D center { get; init; }

        public Vector3D normal { get; init; }

        public double size_x { get; init; }

        public double size_y { get; init; }
    }
}
