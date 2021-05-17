using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    /// <summary>
    /// This is the arrow graphic drawn next to the stick figure graphic
    /// </summary>
    /// <remarks>
    /// NOTE: The positions are offsets from center
    /// </remarks>
    public record GrappleArrows
    {
        /// <summary>
        /// True: Use the standard color
        /// False: Use the gray color
        /// </summary>
        public bool isStandardColor { get; init; }

        /// <summary>
        /// Set this to true when they hover over options that will modify this line
        /// </summary>
        public bool isHighlight_primary { get; init; }

        public double primary_from_x { get; init; }
        public double primary_from_y { get; init; }

        public double primary_to_x { get; init; }
        public double primary_to_y { get; init; }

        /// <summary>
        /// Whether to show the look arrow (should only show it when they have acceleration along look)
        /// </summary>
        public bool showLook { get; init; }

        public bool isHighlight_look { get; init; }

        public double look_from_x { get; init; }
        public double look_from_y { get; init; }

        public double look_to_x { get; init; }
        public double look_to_y { get; init; }
    }
}
