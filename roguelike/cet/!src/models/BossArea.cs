public record BossArea
{
    public string author { get; init; }
    public string description { get; init; }
    public string[] tags { get; init; }

    public ModdedParkour modded_parkour { get; init; }

	public double center_x { get; init; }
	public double center_y { get; init; }
	public double center_z { get; init; }

    // It's a 3D point, but the game uses vector4 for everything
    //NOTE: This doesn't need to be part of the json, it is created when deserializing
    public Vector4 center { get; init; }
}