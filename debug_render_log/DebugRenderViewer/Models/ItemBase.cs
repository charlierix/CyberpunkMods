using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;

namespace DebugRenderViewer.Models
{
    public abstract record ItemBase
    {
        // All of these properties are optional

        public Category category { get; init; }

        public Color? color { get; init; }

        public double? size_mult { get; init; }

        public string tooltip { get; init; }
    }
}
