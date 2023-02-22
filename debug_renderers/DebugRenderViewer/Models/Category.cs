using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;

namespace DebugRenderViewer.Models
{
    public record Category
    {
        public string name { get; init; }

        public Color? color { get; init; }      // optional

        public double? size_mult { get; init; }      // optional
    }
}
