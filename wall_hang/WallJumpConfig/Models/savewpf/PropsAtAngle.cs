﻿using System;
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
            };
        }
    }
}
