public record property_mult
{
    //TODO: have options for non linear, maybe an animation curve
    public float rate { get; init; }

    public float cap_min { get; init; }
    public float cap_max { get; init; }
}