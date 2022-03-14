using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.misc
{
    public record RenderNode
    {
        public viewmodels.IControl control { get; init; }
        public RenderNode[] children { get; init; }
    }
}
