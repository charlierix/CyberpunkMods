public record NPC
{
    //TODO: This whole optional list pointing can get a bit complex.  The npcs folder should stay with this
    //basic npc definition.  Then make an npcs_random folder:
    //  named lists of appearances
    //  named lists of spawn points
    //  a master sheet that gives counts based on level



    //TODO: Min level so that low level players won't see as many enemies
    //TODO: Idle Type: StandStill | Waypoints | Follow<name>

    //--------------------------------------
    //TODO: Instead of a single hardcoded, there should be named lists of npcs, then this will point to one of those lists

    // This is the class of character to spawn.  ex:
    // Character.arr_valentinos_grunt2_ranged2_ajax_wa
    public string entity_path { get; init; }
    // [Optional] This is the name of a specific appearance within that class
    public string appearance { get; init; }

    //--------------------------------------


    //--------------------------------------
    //TODO: Have an option to randomly spawn at one of multiple locations
    //There should be optional named lists of npc points, then this will just be the name of the list

	public double position_x { get; init; }
	public double position_y { get; init; }
	public double position_z { get; init; }

    // It's a 3D point, but the game uses vector4 for everything
    //NOTE: This doesn't need to be part of the json, it is created when deserializing
    public Vector4 position { get; init; }

	public double yaw { get; init; }

    //--------------------------------------
}