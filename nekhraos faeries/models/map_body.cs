public record map_body
{
    // Can be passed to Game.FindEntityByID()
    public entEntityID entityID { get; init; }

    // A string of the entityID.hash
    public string id_hash { get; init; }

    public Vector4 pos { get; init; }

    // Can't find a list of values, probably just have to wander around and log distinct values
    public string affiliation { get; init; }

    // Only non zero for dead.  Not sure what the max is (100 per limb?)
    public float limb_damage { get; init; }
}