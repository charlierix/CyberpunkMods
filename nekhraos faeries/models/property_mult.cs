//TODO: get rid of this, replace with the improved version below
public record property_mult_ORIG
{
    public float rate { get; init; }

    public float cap_min { get; init; }
    public float cap_max { get; init; }
}




public record property_mult
{
    // If populated, then it's always this value, regardless of input
    public float? constant_value { get; init; }

    // Provides a way to set up a curve.  Inputs outside the range specified will have outputs clamped  to the first
    // and last entry of this array
    public property_mult_gradientstop[] animcurve_values { get; init; }

    // This will get instantiated with the values
    public AnimationCurve animcurve { get; set; }
}

public record property_mult_gradientstop
{
    public float input { get; init; }
    public float output { get; init; }
}