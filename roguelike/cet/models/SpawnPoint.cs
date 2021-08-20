public record SpawnPoint
{
    public string author { get; init; }
    public string description { get; init; }
    public string[] tags { get; init; }

    public ModdedParkour modded_parkour { get; init; }

	public double position_x { get; init; }
	public double position_y { get; init; }
	public double position_z { get; init; }

    // It's a 3D point, but the game uses vector4 for everything
    public Vector4 position { get; init; }

	public double yaw { get; init; }
}