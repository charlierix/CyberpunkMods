using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.ui
{
    public record UpDownButtons
    {
        // This text will sit next to the - and +.  They're used to tell how much the quantity
        // will change with each button press
        public string text_down { get; init; }
        public string text_up { get; init; }

        // True: It will be clickable and use the standard set of colors
        // False: Not clickable, uses disabled colors
        public bool isEnabled_down { get; init; }
        public bool isEnabled_up { get; init; }

        /// <summary>
        /// Tells where on the window to place the text
        /// </summary>
        public ControlPosition position { get; init; }

        /// <summary>
        /// True: Buttons are placed side by side (- then +)
        /// False: Buttons are placed on top of each other (+ above, - below)
        /// </summary>
        public bool isHorizontal { get; init; }
    }
}
