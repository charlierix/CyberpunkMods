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
        public double Accel { get; init; }
        public double Speed { get; init; }

        /// <summary>
        /// If distance to desired radius is less than this, accel linearly drops to zero
        /// </summary>
        public double DeadSpot_Distance { get; init; }
        /// <summary>
        /// If speed difference is less than this, accel linearly drops to zero
        /// </summary>
        public double DeadSpot_Speed { get; init; }
    }
}
