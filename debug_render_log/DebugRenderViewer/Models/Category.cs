using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DebugRenderViewer.Models
{
    public record Category
    {
        public string name { get; init; }

        public string color { get; init; }      // optional

        public double? size_mult { get; init; }      // optional
    }
}
