using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    /// <summary>
    /// This applies extra acceleration when the velocity is moving away from the desired radius (zero if moving toward)
    /// </summary>
    public record VelocityAway
    {
        /// <summary>
        /// The acceleration to apply if trying to compress closer to tha anchor point than the desired radius
        /// </summary>
        /// <remarks>
        /// This only makes sense when desired radius is greater than zero
        /// </remarks>
        public double? Accel_Compression { get; init; }

        /// <summary>
        /// Acceleration to apply when trying to move farther from the anchor point than the desired radius
        /// </summary>
        /// <remarks>
        /// This would be used for grapple types that are like web swings
        /// 
        /// Use a large value to make it feel like a rope
        /// Use a small value to make it feel like a spring
        /// </remarks>
        public double? Accel_Tension { get; init; }

        /// <summary>
        /// If |actualDist - desiredDist| is within this deadspot, accel drops to zero
        /// </summary>
        public double DeadSpot { get; init; }
    }
}
