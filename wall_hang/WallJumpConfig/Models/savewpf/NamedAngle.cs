using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WallJumpConfig.Models.wpf
{
    public record NamedAngle
    {
        public string Name { get; init; }
        public double Degrees { get; init; }
        public string Color { get; init; }
    }
}
