using Game.Math_WPF.WPF;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig.Models.savewpf
{
    public record NamedAngle
    {
        public string Name { get; init; }
        public double Degrees { get; init; }
        public string Color { get; init; }

        // ------------- Helper Methods -------------
        public static NamedAngle FromModel(VM_Slider model)
        {
            return new NamedAngle()
            {
                Name = model.Name,
                Degrees = model.Value,
                Color = model.Color == Colors.Transparent ?
                    null :
                    UtilityWPF.ColorToHex(model.Color),
            };
        }
    }
}
