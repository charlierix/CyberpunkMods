using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WallJumpConfig.Models.savelua
{
    public record SaveLUA_Horizontal
    {
        public SaveLUA_KeyValue[] percent_up { get; init; }
        public SaveLUA_KeyValue[] percent_along { get; init; }
        public SaveLUA_KeyValue[] percent_away { get; init; }

        public SaveLUA_KeyValue[] percent_at_speed { get; init; }

        public SaveLUA_KeyValue[] percent_look { get; init; }

        public SaveLUA_KeyValue[] yaw_turn_percent { get; init; }

        public double strength { get; init; }
    }
}
