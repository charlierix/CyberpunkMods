using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DebugRenderViewer.Models
{
    public record Text
    {
        public string text { get; init; }

        public string color { get; init; }      // optional
        
        public double? fontsize_mult { get; init; }     // optional
    }
}
