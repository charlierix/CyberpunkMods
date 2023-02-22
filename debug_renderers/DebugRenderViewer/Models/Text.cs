using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;

namespace DebugRenderViewer.Models
{
    public record Text
    {
        public string text { get; init; }

        public Color? color { get; init; }      // optional

        public double? fontsize_mult { get; init; }     // optional
    }
}
