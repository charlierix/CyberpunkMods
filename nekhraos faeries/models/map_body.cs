public record map_body : map_base_object
{
    public map_body_type body_type { get; init; }

    // Can't find a list of values, probably just have to wander around and log distinct values
    public string affiliation { get; init; }

    // Only non zero for dead.  Not sure what the max is (100 per limb?)
    public float limb_damage { get; init; }
}

public enum map_body_type
{
    CorpseContainer,
    NPC_Dead,
    NPC_Defeated,
    NPC_Alive,
}