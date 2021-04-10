using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    public record EnergyTank
    {
        public double max_energy { get; init; }

        public double recovery_rate { get; init; }

        /// <summary>
        /// This is how much experience was used to get these current values
        /// </summary>
        public double experience { get; init; }
    }
}
