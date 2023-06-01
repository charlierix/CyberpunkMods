public record swarmbot_limits
{
    // ---------- primary props ----------

    public float min_speed { get; init; }
    public float max_speed { get; init; }

    public float max_dist_center { get; init; }

    public float max_accel { get; init; }

    // ---------- corrective props ----------

    public swarmbot_limits_maxby_playerspeed max_by_playerspeed { get; init; }
    public swarmbot_limits_maxby_distfromcenter max_by_distfromcenter { get; init; }

    // Input: (speed - max_speed) / max_speed
    // Output: % of max accel to apply against the direction of current velocity
    public property_mult drag_overspeed { get; init; }

    // This is only used when:
    //  out of bounds
    //  over speed
    //  velocity is away from player
    //
    // This allows an extra drag to slow the orb down when it's trying to travel further away from the player
    //
    // Input: (speed - max_speed) / max_speed
    // Output: % of max accel to apply against the direction of current velocity
    public property_mult drag_outofbounds_overspeed_velaway { get; init; }

    // Input: (dist - max_dist_center) / max_dist_center
    // Output: accel toward player
    public property_mult outofbounds_accel { get; init; }

    // Tries to reduce velocity component orthogonal to direction toward player (when out of bounds)
    // This is so the orb doesn't go into an orbit around the player
    // Input: speed of component of velocity that is perpendicular to direction toward player / max_speed
    //          0 would be orb's velocity aligned with direction to player
    //          1 would be max_speed perpendicular to direction to player
    // Output: % of max accel
    //          acceleration will be opposite of the perpendicular component of orb's velocity
    public property_mult drag_outofbounds_orthvelocity { get; init; }
}

public record swarmbot_limits_maxby_playerspeed
{
    // Input: player's speed
    // Output: % of max accel
    public property_mult accel { get; init; }

    // Input: player's speed
    // Output: % of max distance from player
    public property_mult dist { get; init; }

    // Input: player's speed
    // Output: % of orb's max speed
    public property_mult speed { get; init; }
}

public record swarmbot_limits_maxby_distfromcenter
{
    // These don't kick in until the orb is past max_dist_center.  So an input of zero is at max_dist_center

    // Input: (distance from player - max_dist_center) / max_dist_center
    // Output: % of max accel
    public property_mult accel { get; init; }

    // Input: (distance from player - max_dist_center) / max_dist_center
    // Output: % of orb's max speed
    public property_mult max_speed { get; init; }
}