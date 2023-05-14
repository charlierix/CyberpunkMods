public record swarmbot_limits
{
    public float min_speed { get; init; }

    public float max_speed { get; init; }

    public float max_dist_player { get; init; }

    public float max_accel { get; init; }
}