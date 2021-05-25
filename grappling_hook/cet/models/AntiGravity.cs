using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    public record AntiGravity
    {
        /// <summary>
        /// 0 has no antigravity, 1 is full antigravity
        /// </summary>
        public double antigrav_percent { get; init; }
        public ValueUpdates antigrav_percent_update { get; init; }

        /// <summary>
        /// After flight has ended, antigravity linearly fades to zero
        /// </summary>
        public double fade_duration { get; init; }
        public ValueUpdates fade_duration_update { get; init; }


        // May want a property that controls the antigrav% based on how in line velocity is with direction facing (see air dash)


        /// <summary>
        /// This is how much experience was used to get these current values
        /// </summary>
        public double experience { get; init; }
    }
}
