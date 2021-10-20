using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace DebugRenderViewer.Models
{
    public record ItemDot : ItemBase
    {
        public Point3D position { get; init; }
    }
}
