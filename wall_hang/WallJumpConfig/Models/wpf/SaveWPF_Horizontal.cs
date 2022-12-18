using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WallJumpConfig.Models.wpf
{
    public record SaveWPF_Horizontal
    {
        // NOTE: if they have vertical_straightup, extra angles must have at least one (face wall)

        // 0 and 180 are implied
        public NamedAngle[] Degrees_Extra { get; init; }

        public PropsAtAngle Props_DirectFaceWall { get; init; }
        public PropsAtAngle[] Props_Extra { get; init; }
        public PropsAtAngle Props_DirectAway { get; init; }

        public double Strength { get; init; }

        public double Speed_FullStrength { get; init; }
        public double Speed_ZeroStrength { get; init; }
    }
}
