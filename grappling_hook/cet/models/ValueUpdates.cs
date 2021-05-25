using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    /// <summary>
    /// This tells how an individual property should be updated
    /// </summary>
    /// <remarks>
    /// For certain properties, the values used might not be universal.  Certain types of grappling hooks may
    /// prioritize properties differently and set up the caps as part of the template
    /// 
    /// For example, a pull style grapple would have fairly standard settings, but a wall hanger may not allow
    /// certain properties at all, essentially designed to be cheap and not very upgradable
    /// </remarks>
    public record ValueUpdates
    {
        // The value can't exceed these
        public double? min { get; init; }
        public double? max { get; init; }

        // Either use the fixed value, or define a function that returns the values based on current state (allowing for exponential growth)
        /// <summary>
        /// How much to increment/decrement the value when getting back one experience (selling capability
        /// for experience)
        /// </summary>
        public double? amount { get; init; }

        /// <summary>
        /// Calculates the amounts based on the current value
        /// </summary>
        /// <remarks>
        /// Can't serialize deserialize the actual function call, so this just holds a unique string that
        /// points to the actual function
        /// 
        /// The function to call is in defaults.lua: CallReferenced_DecrementIncrement()
        /// </remarks>
        public string getDecrementIncrement { get; init; }

        private Func<double, (double dec, double inc)> Called_DecInc_Func { get; init; }
    }
}
