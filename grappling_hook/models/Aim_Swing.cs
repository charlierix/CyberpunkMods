namespace models
{
    /// <summary>
    /// This will set up a web swing
    /// </summary>
    /// <remarks>
    /// The aim function looks at current velocity, look direction, ray casts.  It then comes up with a
    /// custom grapple based on those conditions.  Sometimes straight line, sometimes a rope swing, sometimes
    /// a combo
    /// </remarks>
    public record Aim_Swing
    {
        /// <summary>
        /// Defines a reduction of absolute experience cost
        /// </summary>
        /// <remarks>
        /// Straight bases experience cost on xp, but swing should have an initial max that reduces to a min
        /// </remarks>
        public double cost_reduction_percent { get; init; }
        public ValueUpdates cost_reduction_percent_update { get; init; }

        /// <summary>
        /// Energy per second
        /// </summary>
        public double boost_cost_reduction_percent { get; init; }
        public ValueUpdates boost_cost_reduction_percent_update { get; init; }

        /// <summary>
        /// When they hold in the key that kicked off swing, apply this continuous acceleration along look direction
        /// </summary>
        public double boost_accel { get; init; }
        public ValueUpdates boost_accel_update { get; init; }

        /// <remarks>
        /// When boost is getting used a lot, air friction gets reduced
        /// 
        /// If air friction doesn't get reduced, terminal velocity is a bit over 20
        /// </remarks>
        public double boostedairfriction_reduction_percent { get; init; }
        public ValueUpdates boostedairfriction_reduction_percent_update { get; init; }
    }
}
