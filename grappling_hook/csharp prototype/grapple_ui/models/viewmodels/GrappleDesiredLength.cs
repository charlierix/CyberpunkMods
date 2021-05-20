using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    public record GrappleDesiredLength
    {
        public bool should_show { get; init; }

        /// <summary>
        /// True: Use the standard color
        /// False: Use the gray color
        /// </summary>
        public bool isStandardColor { get; init; }

        /// <summary>
        /// Set to true when they hover over options that will modify these lines
        /// </summary>
        public bool isHighlight { get; init; }

        /// <summary>
        /// This is the height of the line that actually gets drawn (half is above, half is below)
        /// </summary>
        public double height { get; init; }

        /// <summary>
        /// This is where to actually draw the line
        /// NOTE: percent of zero draws at to_x, since desired length is relative to the anchor point
        /// </summary>
        public double percent { get; init; }

        public double from_x { get; init; }
        public double to_x { get; init; }

        public double y { get; init; }
    }
}
