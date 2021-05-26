using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    /// <summary>
    /// This applies a constant acceleration (unless dead zone conditions are met)
    /// </summary>
    public record ConstantAccel
    {
        public double accel { get; init; }
        public ValueUpdates accel_update { get; init; }

        public double speed { get; init; }
        public ValueUpdates speed_update { get; init; }

        /// <summary>
        /// If distance to desired radius is less than this, accel linearly drops to zero
        /// </summary>
        public double deadSpot_distance { get; init; }
        /// <summary>
        /// If speed difference is less than this, accel linearly drops to zero
        /// </summary>
        public double deadSpot_speed { get; init; }

        public double experience { get; init; }
    }
}
