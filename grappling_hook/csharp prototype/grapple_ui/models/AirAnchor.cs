using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    /// <summary>
    /// When aim doesn't find a solid hit point, air anchor will serve as a virtual anchor point.  The air anchor point
    /// will be at the max aim distance from the player
    /// </summary>
    public record AirAnchor
    {
        /// <summary>
        /// This is a fixed extra cost of using the air anchor
        /// </summary>
        /// <remarks>
        /// This isn't modifiable, it is just a constant set from default
        /// </remarks>
        public double energyCost { get; init; }

        /// <summary>
        /// 0 to 1
        /// 0 will be full extra energy cost
        /// 1 will be no extra energy cost
        /// </summary>
        public double energyCost_reduction_percent { get; init; }
        public ValueUpdates energyCost_reduction_percent_update { get; init; }

        public double experience { get; init; }
    }
}
