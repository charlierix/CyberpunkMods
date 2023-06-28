public record swarmbot_obstacles
{
    // ----------------------- Scanning -----------------------

    // When performing a scan, choose a point along look, and slightly above that point
    // Zero is the distance when speed is zero.  Max is distance when speed is this.max_speed
    public float scan_from_look_offset_zero { get; init; }
    public float scan_from_look_offset_max { get; init; }
    public float scan_from_up_offset { get; init; }

    public float scan_radius { get; init; }

    // How far to space out the source of raycasts (1 would be every 1 meter)
    public float from_interval_xy { get; init; }
    public float from_interval_z { get; init; }

    // How often to see if a scan should be performed
    public float scan_refresh_seconds { get; init; }

    // If the player is moving too fast, don't bother scanning for obstacles
    public float max_speed { get; init; }

    // ----------------------- Scanning/Storage -----------------------

    // Throw away hits when they too far away, but keep them around for at least a small amount of time
    // The min time is probably unnecessary complexity, it just feels like it might be needed in some cases
    public float hit_remember_min_seconds { get; init; }
    // NOTE: The calculation is only to center, so this needs to be large enough for hit_max_radius and scan_radius
    public float hit_remember_max_distance { get; init; }

    // ----------------------- Storage -----------------------

    // Don't let hits merge into infinite size
    public float hit_max_radius { get; init; }

    // This allows walls to have a smaller radius than the ground
    // Input: degrees between hit's normal and the up vector
    //  values are in degrees.  0 would be a normal that is straight up, 90 is vertical wall, 180 is a ceiling
    // Output: radius of the hit
    public property_mult_gradientstop[] angle_hitradius { get; init; }


    public AnimationCurve dot_hitradius_animcurve => BuildAnimCurve_AngleToDot(angle_radiusmult);

    // ----------------------- Orb Processing -----------------------

    // This gets multiplied by swarmbot_limits.max_accel to get the maximum acceleration
    public float max_accel_mult { get; init; }

    // Input: angle between normal and direction
    //  values in degrees.  90 is perpendicular, 180 is directly behind
    // Output: multiplier of radius (max distance from hit center)
    public property_mult_gradientstop[] angle_radiusmult { get; init; }

    // How much accel to apply based on distance from edge of volume.  This allows a way for accel to smoothly
    // drop to zero at the edge of the volume.  An ideal would be something like 0% at 0%, 100% at 15%
    // Input: distance from edge / radius
    //  this isn't the radius * mult from previous property.  This is just the original radius
    // Output: percent of limits.max_accel
    public property_mult_gradientstop[] edge_percentradius_accelmult { get; init; }

    // How much accel to apply based on distance from hit plane.  This allows a way for accel to smoothly drop
    // to zero near the hit plane
    // Input: distance from plane / radius
    // Output: percent of limits.max_accel
    public property_mult_gradientstop[] depth_percentradius_accelmult { get; init; }


    public float max_radiusmult => angle_radiusmult.Max(o => o.output);

    public AnimationCurve dot_radiusmult_animcurve => BuildAnimCurve_AngleToDot(angle_radiusmult);
    public AnimationCurve edge_percentradius_accelmult_animcurve => BuildAnimCurve(edge_percentradius_accelmult);
    public AnimationCurve depth_percentradius_accelmult_animcurve => BuildAnimCurve(depth_percentradius_accelmult);
}