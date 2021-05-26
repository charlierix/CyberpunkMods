using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    public record AirDash
    {
        public double energyBurnRate { get; init; }

        public double burnReducePercent { get; init; }
        public ValueUpdates burnReducePercent_update { get; init; }

        public ConstantAccel accel { get; init; }

        public string mappin_name { get; init; }

        //NOTE: accel.experience isn't used, because accel is always non null for air dash
        public double experience { get; init; }
    }
}
