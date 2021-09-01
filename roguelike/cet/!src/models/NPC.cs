public record NPC
{
    // This is the class of character to spawn.  ex:
    // Character.arr_valentinos_grunt2_ranged2_ajax_wa
    public string entity_path { get; init; }
    // [Optional] This is the name of a specific appearance within that class
    public string appearance { get; init; }

	public double position_x { get; init; }
	public double position_y { get; init; }
	public double position_z { get; init; }

    // It's a 3D point, but the game uses vector4 for everything
    //NOTE: This doesn't need to be part of the json, it is created when deserializing
    public Vector4 position { get; init; }

	public double yaw { get; init; }
}