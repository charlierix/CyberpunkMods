public record swarmbot_obstacles
{
    // When performing a scan, choose a point along look, and slightly above that point
    // Zero is the distance when speed is zero.  Max is distance when speed is this.max_speed
    public float scan_from_look_offset_zero { get; init; }
    public float scan_from_look_offset_max { get; init; }
    public float scan_from_up_offset { get; init; }

    public float search_radius { get; init; }

    // How far to space out the source of raycasts (1 would be every 1 meter)
    public float from_interval_xy { get; init; }
    public float from_interval_z { get; init; }

    // How often to see if a scan should be performed
    public float scan_refresh_seconds { get; init; }

    // If the player is moving too fast, don't bother scanning for obstacles
    public float max_speed { get; init; }

    // How long hits should be remembered
    public float hit_remember_seconds { get; init; }
}