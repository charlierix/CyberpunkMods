using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    public record Slider
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        public double value { get; init; }

        public double min { get; init; }
        public double max { get; init; }

        /// <summary>
        /// This only affects the displayed decimal places.  The actual value isn't rounded
        /// </summary>
        public int decimal_places { get; init; }

        // These are optional strings before and after the displayed value
        // WARNING: Be careful with potential special characters.  % should be %%
        public string prefix { get; init; }
        public string suffix { get; init; }

        public double width { get; init; }

        // These tell where to place the hint text when the user hovers over the slider control.  The reported
        // height of this control doesn't change when the hint is showing, so the hint won't cause the position
        // to change.  So place the hint where it won't clip other controls
        public AlignmentHorizontal ctrlclickhint_horizontal { get; init; }
        public AlignmentVertical ctrlclickhint_vertical { get; init; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
    }
}
