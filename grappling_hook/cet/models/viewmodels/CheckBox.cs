using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    public record CheckBox
    {
        public bool isChecked {get; init; }
        public string text { get; init; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }

        /// <summary>
        /// Optional named color (in stylesheet.colors)
        /// </summary>
        public string foreground_override { get; init; }
    }
}
