using grapple_ui.models.misc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    public record UpDownButtons : IControl
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        // This text will sit next to the - and +.  They're used to tell how much the quantity
        // will change with each button press
        public string text_down { get; init; }
        public string text_up { get; init; }

        // These are used when the button is clicked, but not shown to the user
        public double? value_down { get; init; }
        public double? value_up { get; init; }

        // True: It will be clickable and use the standard set of colors
        // False: Not clickable, uses disabled colors
        public bool isEnabled_down { get; init; }
        public bool isEnabled_up { get; init; }

        // These only have meaning when the corresponding button is enabled
        // True: Pushing the button will change the value, but there is no change in experience
        // False: Each push of the button is 1 xp
        public bool isFree_down { get; init; }
        public bool isFree_up { get; init; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        /// <summary>
        /// True: Buttons are placed side by side (- then +)
        /// False: Buttons are placed on top of each other (+ above, - below)
        /// </summary>
        public bool isHorizontal { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
