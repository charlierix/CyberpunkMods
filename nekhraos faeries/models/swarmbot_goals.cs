public record swarmbot_goals
{
    // How often to scan the map for goals.  The items will be remembered between scans
    public float refresh_rate_seconds { get; init; }

    public float search_radius { get; init; }

    // This percent is used to see how much priority the goal's acceleration should have over
    // neighbor and wander accels.  When far away from the target, percent should be reasonable.
    // But when the orb gets close to the target, this value should approach 1, which will cause
    // the orb to only consider the goal and ignore neighbors
    // Input: distance
    // Output: percent
    public property_mult report_percent_distance { get; init; }

    // NOTE: It's possible to be farther from the goal than search_radius, since the scan is done periodically
    // and the orb and goal could both be moving
    // Input: distance
    // Output: % of max accel
    public property_mult accel_distance { get; init; }

    //-----------------------------------------------------------------------------
    // These two properties get multiplied together when canceling orth vel

    // Tries to reduce velocity component orthogonal to direction toward goal - helps reduce orbits
    // Input: speed of component of velocity that is perpendicular to goal / max_speed
    //          0 would be orb's velocity going directly toward or away from goal
    //          1 would be max_speed perpendicular to direction toward goal
    //          2 would be twice max_speed
    // Output: % of max accel
    //          acceleration will be opposite of the perpendicular component of orb's velocity
    public property_mult drag_orth_velocity_speed { get; init; }

    // This allows the accel to be zero when far away and stronger as the orb gets closer.  Otherwise, the
    // orb would cancel all orth velocity and fire at a straight line toward the goal from far away
    // Input: distance
    // Output: % of max accel
    public property_mult drag_orth_velocity_distance { get; init; }
    //-----------------------------------------------------------------------------
}