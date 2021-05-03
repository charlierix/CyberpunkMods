using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.ui
{
    public record Label
    {
        public string text { get; init; }

        /// <summary>
        /// Tells where on the window to place the text
        /// </summary>
        public ControlPosition position { get; init; }

        /// <summary>
        /// If this is set, then the text will be wordwrapped if it exceeds the length
        /// </summary>
        public int? max_width { get; init; }

        /// <summary>
        /// This is a named color from the stylesheet's colors list
        /// </summary>
        public string color { get; init; }
    }
}
