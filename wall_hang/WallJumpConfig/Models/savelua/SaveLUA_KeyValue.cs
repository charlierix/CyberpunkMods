using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WallJumpConfig.Models.savelua
{
    public record SaveLUA_KeyValue
    {
        public double key { get; init; }
        public double value { get; init; }
    }
}
