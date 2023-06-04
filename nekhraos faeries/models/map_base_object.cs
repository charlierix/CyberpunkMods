public record map_base_object
{
    // Can be passed to Game.FindEntityByID()
    public entEntityID entityID { get; init; }

    // A string of the entityID.hash
    public string id_hash { get; init; }

    public Vector4 pos { get; init; }

    // ------------------------------------------------------
    public map_objective_item objective_item { get; init; }
}