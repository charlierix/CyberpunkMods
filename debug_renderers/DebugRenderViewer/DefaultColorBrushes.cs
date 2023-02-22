using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;
using System.Windows.Media.Media3D;

namespace DebugRenderViewer
{
    /// <summary>
    /// Items that need the default opposite color will use these materials.  Whenever the background color
    /// changes, these will get updated
    /// </summary>
    public record DefaultColorBrushes
    {
        public Material Dot_Material { get; init; }
        public SolidColorBrush Dot_Brush { get; init; }

        public Color Line_Color { get; set; }

        public Material Circle_Material { get; init; }
        public SolidColorBrush Circle_Brush { get; init; }

        public Material Square_Material { get; init; }
        public SolidColorBrush Square_Brush { get; init; }

        public SolidColorBrush Text_Brush { get; init; }
    }
}
