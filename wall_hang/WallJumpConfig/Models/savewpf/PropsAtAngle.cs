using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig.Models.savewpf
{
    public record PropsAtAngle
    {
        public double Percent_Up { get; init; }
        public double Percent_Along { get; init; }
        public double Percent_Away { get; init; }

        public double Percent_YawTurn { get; init; }

        /// <summary>
        /// How much influence the player's look direction has vs the settings above
        /// </summary>
        public double Percent_Look { get; init; }
        /// <summary>
        /// The percent of the strength the look portion uses
        /// </summary>
        public double Percent_LookStrength { get; init; }

        public double Percent_LatchAfterJump { get; init; }
        public double WallAttract_DistanceMax { get; init; }
        public double WallAttract_Accel { get; init; }
        public double WallAttract_Pow { get; init; }
        public double WallAttract_Antigrav { get; init; }

        // ------------- Helper Methods -------------
        public static PropsAtAngle FromModel(VM_PropsAtAngle model)
        {
            return new PropsAtAngle()
            {
                Percent_Up = model.Percent_Up.Value,
                Percent_Along = model.Percent_Along.Value,
                Percent_Away = model.Percent_Away.Value,

                Percent_YawTurn = model.Percent_YawTurn.Value,

                Percent_Look = model.Percent_Look.Value,
                Percent_LookStrength = model.Percent_LookStrength.Value,

                Percent_LatchAfterJump = model.Percent_LatchAfterJump.Value,
                WallAttract_DistanceMax = model.WallAttract_DistanceMax.Value,
                WallAttract_Accel = model.WallAttract_Accel.Value,
                WallAttract_Pow = model.WallAttract_Pow.Value,
                WallAttract_Antigrav = model.WallAttract_Antigrav.Value,
            };
        }
    }
}
