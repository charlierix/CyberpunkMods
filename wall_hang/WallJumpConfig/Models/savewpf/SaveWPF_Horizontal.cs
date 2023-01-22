using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig.Models.savewpf
{
    public record SaveWPF_Horizontal
    {
        public bool HasHorizontal { get; init; }

        // 0 and 180 are implied
        public NamedAngle[] Degrees_Extra { get; init; }

        public PropsAtAngle Props_DirectFaceWall { get; init; }
        public PropsAtAngle[] Props_Extra { get; init; }
        public PropsAtAngle Props_DirectAway { get; init; }

        public double Speed_FullStrength { get; init; }
        public double Speed_ZeroStrength { get; init; }

        public double Strength { get; init; }

        // ------------- Helper Methods -------------
        public static SaveWPF_Horizontal FromModel(VM_Horizontal horizontal)
        {
            if (horizontal.PropsAtAngles.Count < 2)
                throw new ArgumentException($"PropsAtAngles is incomplete.  Must be at least 2 entries: {horizontal.PropsAtAngles}");

            var props = horizontal.PropsAtAngles.
                Select(o => PropsAtAngle.FromModel(o)).
                ToArray();

            return new SaveWPF_Horizontal()
            {
                HasHorizontal = horizontal.HasHorizontal,

                Degrees_Extra = horizontal.ExtraAngles.
                    Select(o => NamedAngle.FromModel(o)).
                    ToArray(),

                Props_DirectFaceWall = props[0],

                Props_Extra = props.
                    Skip(1).
                    Take(props.Length - 2).
                    ToArray(),

                Props_DirectAway = props[^1],

                Speed_FullStrength = horizontal.Speed_FullStrength.Value,
                Speed_ZeroStrength = horizontal.Speed_ZeroStrength.Value,

                Strength = horizontal.Strength.Value,
            };
        }
    }
}
