namespace models
{
    public record EnergyTank
    {
        public double max_energy { get; init; }
        public ValueUpdates max_energy_update { get; init; }

        public double recovery_rate { get; init; }
        public ValueUpdates recovery_rate_update { get; init; }

        /// <summary>
        /// The recovery rate is slowed by this percent
        /// 0 = No recovery while grappling/flying
        /// 1 = Full recovery rate while grappling/flying
        /// </summary>
        public double flying_percent { get; init; }
        public ValueUpdates flying_percent_update { get; init; }

        /// <summary>
        /// This is how much experience was used to get these current values
        /// </summary>
        public double experience { get; init; }
    }
}
