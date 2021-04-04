using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    public record AirDash
    {
        public double EnergyBurnRate { get; init; }

        public ConstantAccel Accel { get; init; }
    }
}
