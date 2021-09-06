namespace models
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
        public double? accel_compression { get; init; }
        public ValueUpdates accel_compression_update { get; init; }

        /// <summary>
        /// Acceleration to apply when trying to move farther from the anchor point than the desired radius
        /// </summary>
        /// <remarks>
        /// This would be used for grapple types that are like web swings
        /// 
        /// Use a large value to make it feel like a rope
        /// Use a small value to make it feel like a spring
        /// </remarks>
        public double? accel_tension { get; init; }
        public ValueUpdates accel_tension_update { get; init; }

        /// <summary>
        /// If |actualDist - desiredDist| is within this deadspot, accel drops to zero
        /// </summary>
        public double deadSpot { get; init; }

        public double experience { get; init; }
    }
}
