using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    /// <summary>
    /// This will set up a web swing
    /// </summary>
    /// <remarks>
    /// When they push the action button, this will:
    ///     Ensure Airborne
    ///     Find an arc that will:
    ///         continue the trajectory under tension
    ///         if velocity is shallower than about 45 degrees down:
    ///             allow a period of free fall.  The more velocity is uppward, the longer the freefall will be
    ///             calculate the trajectory.  The swing will apply when they are traveling down at a certain angle
    ///                 be sure to take the antigravity property into account
    ///                 
    /// Use some kind of graphic to indicate that the swing request registered, but it's in freefall mode
    /// 
    /// Otherwise, don't bother with the freefall stuff.  If they request a swing while velocity is up, they'll just
    /// get yanked along a new arc (probably a steeper arc)
    /// 
    /// Or do the opposite, and put them in an upside down arc.  So instead of a parabolic trajectory, they'll be forced
    /// into a circular one
    /// </remarks>
    public record Aim_Swing
    {
        //TODO: Implement this


        // Desired Swing Length
        public double SwingLength { get; init; }

        /// <summary>
        /// -90 to 90 (0 is horizontal)
        /// </summary>
        /// <remarks>
        /// If velocity is less than this angle, the swing will immediately apply
        /// 
        /// Otherwise, there will be a period of freefall.  Calculate their trajectory under freefall, and the elapsed
        /// time when they will be at this angle
        /// 
        /// During the first frame of aim, this will all be calculated.  If freefall is needed, it will stay in aim
        /// mode doing nothing until that elapsed time is up (or they hit something)
        /// </remarks>
        public double MinAngle { get; init; } = -45;


        // Velocity vs Look influence



    }
}
