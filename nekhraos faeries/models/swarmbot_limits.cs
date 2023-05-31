public record swarmbot_limits
{
    // ---------- primary props ----------

    public float min_speed { get; init; }
    public float max_speed { get; init; }

    public float max_dist_player { get; init; }

    public float max_accel { get; init; }

    // ---------- corrective props ----------

    public swarmbot_limits_maxby_playerspeed max_by_playerspeed { get; init; }
    public swarmbot_limits_maxby_distfromplayer max_by_distfromplayer { get; init; }

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

    // Input: (dist - max_dist_player) / max_dist_player
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



    // ------------------------------ corrective props ORIG ------------------------------

    public float boundary_percent_start { get; init; }
    public float speed_percent_start { get; init; }

    public swarmbot_limits_maxbyspeed maxbyspeed { get; init; }
    public swarmbot_limits_maxbydist maxbydist { get; init; }

    //TODO: probably don't need speeding away have different mults from other.  Just have an extra drag apply when out of bounds and speeding away
    public swarmbot_limits_outofbounds_speedingaway outofbounds_speedingaway { get; init; }
    public swarmbot_limits_outofbounds outofbounds { get; init; }
    public swarmbot_limits_overspeed overspeed { get; init; }

    public swarmbot_limits_dragorthvelocity dragorthvelocity { get; init; }
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

public record swarmbot_limits_maxby_distfromplayer
{
    // These don't kick in until the orb is past max_dist_player.  So an input of zero is at max_dist_player

    // Input: (distance from player - max_dist_player) / max_dist_player
    // Output: % of max accel
    public property_mult accel { get; init; }

    // Input: (distance from player - max_dist_player) / max_dist_player
    // Output: % of orb's max speed
    public property_mult max_speed { get; init; }
}








// ------------------------------------ ORIG ------------------------------------

public record swarmbot_limits_maxbyspeed
{
    public float percent_start { get; init; }

    public property_mult_ORIG speed_mult { get; init; }

    public property_mult_ORIG dist_mult { get; init; }
}

public record swarmbot_limits_maxbydist
{
    public property_mult_ORIG speed_mult { get; init; }
}

public record swarmbot_limits_outofbounds_speedingaway
{
    public property_mult_ORIG accel_mult_speed { get; init; }
    public property_mult_ORIG accel_mult_bounds { get; init; }
}

public record swarmbot_limits_outofbounds
{
    public property_mult_ORIG accel_mult { get; init; }
}

public record swarmbot_limits_overspeed
{
    public property_mult_ORIG accel_mult { get; init; }
}

public record swarmbot_limits_dragorthvelocity
{
    public property_mult_ORIG accel_mult { get; init; }
}