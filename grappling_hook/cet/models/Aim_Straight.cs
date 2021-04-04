using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    public record Aim_Straight
    {
        /// <summary>
        /// How far out to look
        /// </summary>
        public double MaxDistance { get; init; }

        /// <summary>
        /// How long to aim before giving up, or switching to air dash
        /// </summary>
        public double Aim_Duration { get; init; }

        public string MappinName { get; init; }


        public AirDash AirDash { get; init; }


        //TODO: PersonPull


    }
}
