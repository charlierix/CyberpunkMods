public record swarmbot_limits
{
    // ---------- primary props ----------

    public float min_speed { get; init; }

    public float max_speed { get; init; }

    public float max_dist_player { get; init; }

    public float max_accel { get; init; }

    // ---------- corrective props ----------

    public float boundary_percent_start { get; init; }
    public float speed_percent_start { get; init; }

    public swarmbot_limits_maxbyspeed maxbyspeed { get; init; }
    public swarmbot_limits_maxbydist maxbydist { get; init; }

    public swarmbot_limits_outofbounds_speedingaway outofbounds_speedingaway { get; init; }
    public swarmbot_limits_outofbounds outofbounds { get; init; }
    public swarmbot_limits_overspeed overspeed { get; init; }

    public swarmbot_limits_dragorthvelocity dragorthvelocity { get; init; }
}

public record swarmbot_limits_maxbyspeed
{
    public float percent_start { get; init; }

    public property_mult speed_mult { get; init; }

    public property_mult dist_mult { get; init; }
}

public record swarmbot_limits_maxbydist
{
    public property_mult speed_mult { get; init; }
}

public record swarmbot_limits_outofbounds_speedingaway
{
    public property_mult accel_mult_speed { get; init; }

    public property_mult accel_mult_bounds { get; init; }
}

public record swarmbot_limits_outofbounds
{
    public property_mult accel_mult { get; init; }
}

public record swarmbot_limits_overspeed
{
    public property_mult accel_mult { get; init; }
}

public record swarmbot_limits_dragorthvelocity
{
    public property_mult accel_mult { get; init; }
}