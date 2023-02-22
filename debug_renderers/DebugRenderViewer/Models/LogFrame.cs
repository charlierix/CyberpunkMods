using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;

namespace DebugRenderViewer.Models
{
    public record LogFrame
    {
        public string name { get; init; }       // optional

        public Color? back_color { get; init; }     // optional

        public ItemBase[] items { get; init; }

        public Text[] text { get; init; }
    }
}
