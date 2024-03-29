﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AirplaneEditor.Models
{
    public enum PlanePartType
    {
        /// <summary>
        /// This is structural
        /// </summary>
        /// <remarks>
        /// Don't allow a length longer than some percent of the radius
        /// 
        /// Don't allow too large of an item to be attached to too small of a fuselage
        /// 
        /// This shouldn't be too high of a density.  The components are what should have most of the mass
        /// 
        /// As far as the plane physics, this will be two aerofoils in a + (not the same radius as the visual,
        /// but still something)
        /// </remarks>
        Fuselage,

        //TODO: have 3 wing types: high_lift, normal_lift, zero_lift
        Wing,

        /// <summary>
        /// Thrust is based on the size/mass
        /// </summary>
        Engine,

        // Ammo capacity / refill rate will increase if these are made larger than normal

        /// <summary>
        /// heavy mg, auto rifle, homing rifle
        /// </summary>
        Gun,
        /// <summary>
        /// heavy (propane tank, but bigger expolsion), cluster (multiple grenades at once)
        /// </summary>
        Bomb,

        /// <summary>
        /// Fires an explosive rocket
        /// </summary>
        //Missile,

        /// <summary>
        /// Drop npc instead of bomb
        /// </summary>
        /// <remarks>
        /// I don't think the below would work, since ragdoll will likely make them stay down, even if it's a small fall
        /// 
        /// Make them a friendly npc, so if they survive the drop, they will fight for you
        /// 
        /// This would allow an interesting tactic of stalling near the ground, drop ally(s), turn off airplane mode.  If
        /// timed correctly, it would make a great way to enter a fight
        /// </remarks>
        //NPC,
    }
}
