namespace models
{
    public record Aim_Straight
    {
        /// <summary>
        /// How far out to look
        /// </summary>
        public double max_distance { get; init; }
        public ValueUpdates max_distance_update { get; init; }

        /// <summary>
        /// How long to aim before giving up, or switching to air dash
        /// </summary>
        public double aim_duration { get; init; }
        public ValueUpdates aim_duration_update { get; init; }

        public string mappin_name { get; init; }

        public AirAnchor air_anchor { get; init; }

        // OBSOLETE
        public AirDash air_dash { get; init; }
    }
}
