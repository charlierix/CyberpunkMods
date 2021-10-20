using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace DebugRenderViewer.Models
{
    public record ItemCircle : ItemBase
    {
        public Point3D center { get; init; }

        public Vector3D normal { get; init; }

        public double radius { get; init; }
    }
}
