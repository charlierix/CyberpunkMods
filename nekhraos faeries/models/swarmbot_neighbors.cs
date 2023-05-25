public record swarmbot_neighbors
{
    // How many of the nearby to consider (ignored if part of a pod)
    public int count { get; init; }

    public float search_radius { get; init; }

    public float nearbyscan_interval_seconds { get; init; }

    public swarmbot_acceleration_percents accel_percents { get; init; }

    // -------------- Mutable Props --------------

    public swarmbot_matchedneighbor[] nearby { get; set; }
    public float next_nearbyscan_time { get; set; }
}

public record swarmbot_acceleration_percents
{
    // Instead of going to the center of the flock, go to the projected center based on the flock's
    // average velocity
    public float center_project_seconds { get; init; }

    // Input: distance
    // Output: % of max accel
    public property_mult toward_flock_center { get; init; }

    //-----------------------------------------------------------------------------
    // These two properties get multiplied together when aligning velocities

    // Input: length(flock_vel - orb_vel) / max_speed
    //          0 would be matching flock speed
    //          1 would be max_speed above or below max_speed
    //          > 1 would be more that max_speed difference between orb's speed and flock's speed
    // Output: % of max accel
    //          acceleration will be along flock's velocity
    public property_mult align_flock_velocity_speed { get; init; }

    // Input: distance
    // Output: % of max accel
    public property_mult align_flock_velocity_distance { get; init; }
    //-----------------------------------------------------------------------------

    //-----------------------------------------------------------------------------
    // These two properties get multiplied together when canceling orth vel

    // Tries to reduce velocity component orthogonal to flock's velocity - helps reduce orbits
    // Input: speed of component of velocity that is perpendicular to flock's velocity / max_speed
    //          0 would be orb's velocity aligned with flock's velocity (they may not be going the same speed, but they are moving parallel with each other - maybe same direction or opposite directions)
    //          1 would be max_speed perpendicular to flock's velocity
    // Output: % of max accel
    //          acceleration will be opposite of the perpendicular component of orb's velocity
    public property_mult drag_orth_flock_velocity_speed { get; init; }

    // Input: distance
    // Output: % of max accel
    public property_mult drag_orth_flock_velocity_distance { get; init; }
    //-----------------------------------------------------------------------------

    // Input: distance
    // Output: % of max accel
    public property_mult repel_other_orb { get; init; }

    // This only gets applied opposite component of velocity when traveling toward the other orb.  It allows
    // a rapid deceleration, but no rebound kick
    // Input: distance
    // Output: % of max accel
    public property_mult repel_other_orb_velocitytoward { get; init; }
}

public record swarmbot_matchedneighbor
{
    public object orb { get; init; }
    public float dist_sqr { get; init; }
}