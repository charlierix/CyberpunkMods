using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WallJumpConfig.Models.savewpf;

namespace WallJumpConfig.Models.savelua
{
    public record SaveLUA
    {
        public string description { get; init; }

        public bool has_horizontal { get; init; }
        public bool has_straightup { get; init; }

        public SaveLUA_Horizontal horizontal { get; init; }
        public SaveLUA_Vertical_StraightUp straight_up { get; init; }

        // ------------- Helper Methods -------------
        public static SaveLUA FromModel(SaveWPF save)
        {
            var lua_horz = save.Horizontal.HasHorizontal ?
                SaveLUA_Horizontal.FromModel(save.Horizontal) :
                null;

            var lua_vert = save.Vertical_StraightUp.HasStraightUp ?
                SaveLUA_Vertical_StraightUp.FromModel(save.Vertical_StraightUp, save.Horizontal) :
                null;

            return new SaveLUA()
            {
                description = save.Description,

                has_horizontal = lua_horz != null,
                horizontal = lua_horz,

                has_straightup = lua_vert != null,
                straight_up = lua_vert,
            };
        }
    }
}
