using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    /// <summary>
    /// This represents a player profile
    /// </summary>
    public record Player
    {
        public string Name { get; init; }

        /// <summary>
        /// This is an ID that gets tied to a playthrough (will be null for templates)
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
        public int? PlayerUniqueID { get; init; }

        /// <summary>
        /// This is used to know the active profile (will be null for templates)
        /// </summary>
        /// <remarks>
        /// They may have multiple entries for the same play through.  This helps know the exact one
        /// to use
        /// </remarks>
        public DateTime? LastUsed { get; init; }

        public EnergyTank EnergyTank { get; init; }

        // action mappings

        /// <summary>
        /// How many experience points are available
        /// </summary>
        public double Experience { get; init; }
    }
}
