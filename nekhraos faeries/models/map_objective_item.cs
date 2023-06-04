// This is made to be searchable by ai.  The ai will have a vector representing what it's interested in and can take the dot
// product with qualifier_unit to see how much this item aligns with its interests
public record map_objective_item
{
    public Vector4 pos { get; init; }

    // This is an ND vector that represents what the item is.  It is stored as a unit vector so a bot can take a dot product
    // between the bot's interest vector and this qualifier
    //
    // The axiis could represent things like npc, hostile/neutral, hackable, device, loot, etc...
    public float[] qualifier_unit { get; init; }

    // ------------------------------------------------------

    // This is the base of the specific object in case base props are needed, there's no need for a switch statement to find
    // the derived class
    //
    // Since lua doesn't know about inheritance, this is just a copy of the reference to the derived class
    public map_base_object base_object { get; init; }

    // These are links to the specific item type
    // Only one of these will be populated

    public map_body body { get; init; }

    public map_container container { get; init; }

    public map_device device { get; init; }

    public map_loot loot { get; init; }
}