public record BossArea
{
    public BossArea_About about { get; init; }

    public NPC[] npcs { get; init; }

    // These are required if about.modded_parkour == heavy
    public SpawnPoint[] spawns { get; init; }
}