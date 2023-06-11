public record interested_item
{
    public map_objective_item item { get; init; }

    // May need to break this into a couple categories: fly to percent, interact with percent
    //
    // Maybe just leave this as fly to percent, then ai class can decide whether to interact if distance is < threshold
    // and the mood is strong enough
    public float percent { get; init; }
}