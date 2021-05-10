using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.changes
{
    /// <summary>
    /// Fields used to modify the properties
    /// NOTE: This just happens to be the same as models\EnergyTank, but still putting here to be explicit
    /// </summary>
    /// <remarks>
    /// As the user changes property values, those deltas are stored in this intermediate class.  If
    /// they hit ok, the changes are committed and stored in the database.  If they hit cancel, the
    /// changes are ignored
    /// 
    /// The properties are reset when transitioning into the energy tank window
    /// </remarks>
    public class EnergyTank
    {
        public double max_energy { get; set; }
        public double recovery_rate { get; set; }
        public double flying_percent { get; set; }
        public int experience { get; set; }
    }
}
