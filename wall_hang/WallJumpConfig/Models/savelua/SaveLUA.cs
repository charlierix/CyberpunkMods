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
        public bool has_straightup { get; init; }

        public SaveLUA_Horizontal horizontal { get; init; }
        public SaveLUA_Vertical_StraightUp straight_up { get; init; }

        // ------------- Helper Methods -------------
        public static SaveLUA FromModel(SaveWPF_Horizontal horizontal, SaveWPF_Vertical_StraightUp vertical)
        {
            var lua_horz = SaveLUA_Horizontal.FromModel(horizontal);

            SaveLUA_Vertical_StraightUp lua_vert = null;
            if (vertical != null)
                lua_vert = SaveLUA_Vertical_StraightUp.FromModel(vertical, horizontal);

            return new SaveLUA()
            {
                has_straightup = lua_vert != null,
                horizontal = lua_horz,
                straight_up = lua_vert,
            };
        }
    }
}
