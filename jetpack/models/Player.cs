public record Player
{
    public long playerKey { get; init; }

    /// <summary>
    /// This is an ID that gets tied to a playthrough
    /// </summary>
    /// <remarks>
    /// Thanks to bonaniki and NonameNonumber for the idea:
    /// 
    /// bonaniki — 03/21/2021
    /// How can i make a different persistent data for different playthroughs? Is there some kind of player ID assigned at the game start?
    /// 
    /// NonameNonumber — 03/21/2021
    /// there is a playthrough id but it's not always accessible
    /// you can generate your own
    /// 
    /// bonaniki — 03/21/2021
    /// How do i put something in a savefile then?
    /// 
    /// NonameNonumber — 03/21/2021
    /// Game.GetQuestsSystem():GetFactStr("my_mod_unique_id")
    /// Game.GetQuestsSystem():SetFactStr("my_mod_unique_id", 123)
    /// only integers, this is stored in the savefile
    /// </remarks>
    public int playerID { get; init; }

    // Primary Keys of the rows in Mode2 table
    public long[] mode_keys { get; init; }

    // This is the live version of mode (not the data version that dal takes)
    public Mode mode { get; set; }

    // The current mode that is in use
    public int mode_index { get; set; }     // one based
}