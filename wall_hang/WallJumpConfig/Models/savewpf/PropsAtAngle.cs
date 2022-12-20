using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WallJumpConfig.Models.wpf
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
    }
}
