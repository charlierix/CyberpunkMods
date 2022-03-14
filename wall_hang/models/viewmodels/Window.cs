using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    /// <remarks>
    /// There is no property to hold a list of controls.  They are just added directly to this (key is the control
    /// name, value is the control)
    /// </remarks>
    public record Window
    {
        /// <summary>
        /// This gets set by init_ui.FinishDefiningWindow()
        /// </summary>
        public misc.RenderNode[] render_nodes { get; init; }
    }
}
