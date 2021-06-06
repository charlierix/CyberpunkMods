using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    public record CheckBox
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        public bool isChecked {get; init; }

        /// <summary>
        /// True: It will be clickable and use the standard set of colors
        /// False: Not clickable, uses disabled colors
        /// </summary>
        public bool isEnabled { get; init; }

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
