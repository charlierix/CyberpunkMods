using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WallJumpConfig.Models.wpf
{
    public record SaveWPF_Vertical_StraightUp
    {
        public double Degrees_StraightUp { get; init; }
        public double Degrees_Standard { get; init; }

        public double Strength { get; init; }

        public double Speed_FullStrength { get; init; }
        public double Speed_ZeroStrength { get; init; }
    }
}
