namespace models
{
    /// <summary>
    /// This represents a player profile
    /// </summary>
    public record Player
    {
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

        public EnergyTank energy_tank { get; init; }

        //TODO: May want an extra class to hold a link between action mapping and grapple.  Then turn all these
        //columns into (mapping, grapple)[]

        // action mapping 1,2,3,4,5,6

        public Grapple grapple1 { get; init; }      // default: pull
        public Grapple grapple2 { get; init; }      // default: rigid
        public Grapple grapple3 { get; init; }      // default: web swing
        public Grapple grapple4 { get; init; }      // extra slots for whatever they want.  There's more than people will probably ever use
        public Grapple grapple5 { get; init; }
        public Grapple grapple6 { get; init; }

        /// <summary>
        /// How many experience points are available
        /// </summary>
        /// <remarks>
        /// EnergyTank and Grapple also have experience properties, but those are cost
        /// 
        /// This experience is how much is available to spend
        /// </remarks>
        public double experience { get; init; }

        //-------------- DB Only --------------

        /// <summary>
        /// This is used to know the active profile
        /// </summary>
        /// <remarks>
        /// They may have multiple entries for the same play through.  This helps know the exact one
        /// to use
        /// </remarks>
        //public DateTime last_used { get; init; }
    }
}
