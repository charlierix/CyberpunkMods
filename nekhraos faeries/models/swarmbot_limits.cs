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
}

public record swarmbot_limits_maxbyspeed
{
    public float percent_start { get; init; }

    public float speed_mult_rate { get; init; }
    public float speed_mult_cap { get; init; }

    public float dist_mult_rate { get; init; }
    public float dist_mult_cap { get; init; }
}

public record swarmbot_limits_maxbydist
{
    public float speed_mult_rate { get; init; }
    public float speed_mult_cap { get; init; }
}