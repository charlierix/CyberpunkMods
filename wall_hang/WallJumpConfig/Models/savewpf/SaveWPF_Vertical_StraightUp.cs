using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig.Models.savewpf
{
    public record SaveWPF_Vertical_StraightUp
    {
        public double Degrees_StraightUp { get; init; }
        public double Degrees_Standard { get; init; }

        public double Speed_FullStrength { get; init; }
        public double Speed_ZeroStrength { get; init; }

        public double Strength { get; init; }

        // ------------- Helper Methods -------------
        public static SaveWPF_Vertical_StraightUp FromModel(VM_StraightUp model)
        {
            return new SaveWPF_Vertical_StraightUp()
            {
                Degrees_StraightUp = model.Angle_StraightUp.Value,
                Degrees_Standard = model.Angle_Standard.Value,

                Speed_FullStrength = model.Speed_FullStrength.Value,
                Speed_ZeroStrength = model.Speed_ZeroStrength.Value,

                Strength = model.Strength.Value,
            };
        }
    }
}
