// This is tied to a swarm instance and passed to the neighbor scan function.  It's used to remember results
// for a small amount of time
public record nearby_scan
{   
    // How long to cache a scan result
    public float interval_seconds { get; init; }

    // The time (according to o.timer) to do the next scan
    public float next_scan_time { get; set; }

    // The currently cached scan
    public matched_neighbor[] nearby { get; set; }
}

public record matched_neighbor
{
    public object orb { get; init; }
    public float dist_sqr { get; init; }
}