using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace DebugRenderViewer.Models
{
    public record ItemLine : ItemBase
    {
        public Point3D point1 { get; init; }
        public Point3D point2 { get; init; }
    }
}
