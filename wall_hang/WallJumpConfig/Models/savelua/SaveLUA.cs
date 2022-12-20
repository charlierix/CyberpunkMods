using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WallJumpConfig.Models.savelua
{
    public record SaveLUA
    {
        public bool has_straightup { get; init; }

        public SaveLUA_Horizontal horizontal { get; init; }
        public SaveLUA_Vertical_StraightUp straight_up { get; init; }
    }
}
