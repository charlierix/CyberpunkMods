using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    /// <summary>
    /// NOTE: There is a lot copied from GrappleDesiredLength.  But adding this functionality
    /// to that would make it harder to use (and this control is shown much less often)
    /// </summary>
    public record GrappleAccelToDesired
    {
        public bool show_accel_left { get; init; }
        public bool show_accel_right { get; init; }
        public bool show_dead { get; init; }

        // True: Use the standard color
        // False: Use the gray color
        public bool isStandardColor_accel { get; init; }
        public bool isStandardColor_dead { get; init; }

        // Set to true when they hover over options that will modify these lines
        public bool isHighlight_accel_left { get; init; }
        public bool isHighlight_accel_right { get; init; }
        public bool isHighlight_dead { get; init; }

        // Where to draw the accel lines and dead lines.  Use negative if it should be above
        public double yOffset_accel { get; init; }
        public double yOffset_dead { get; init; }

        /// <summary>
        /// This is where to actually draw the line
        /// NOTE: percent of zero draws at to_x, since desired length is relative to the anchor point
        /// </summary>
        public double percent { get; init; }

        public double from_x { get; init; }
        public double to_x { get; init; }

        public double y { get; init; }

        public double length_accel { get; init; }
        public double length_dead { get; init; }

        /// <summary>
        /// This is the distance from the tip of the arrow to the desired line (adding a gap so it doesn't
        /// look like a bow tie)
        /// </summary>
        public double length_accel_halfgap { get; init; }

        /// <summary>
        /// Height of the end caps:    |-------------|
        /// </summary>
        public double deadHeight { get; init; }
    }
}
