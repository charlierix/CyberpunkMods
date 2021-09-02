public record SpawnPoint
{
    // ------------------------------------------------------
    // This section is only used for standalone spawn points (BossArea's about json already has this)

    public string author { get; init; }
    public string description { get; init; }
    public string[] tags { get; init; }

    public ModdedParkour modded_parkour { get; init; }

    // ------------------------------------------------------

	public double position_x { get; init; }
	public double position_y { get; init; }
	public double position_z { get; init; }

    // It's a 3D point, but the game uses vector4 for everything
    //NOTE: This doesn't need to be part of the json, it is created when deserializing
    public Vector4 position { get; init; }

	public double yaw { get; init; }
}