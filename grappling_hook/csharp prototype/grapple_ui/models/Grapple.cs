using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    /// <summary>
    /// This is the main class for grapple settings
    /// </summary>
    /// <remarks>
    /// NOTE: Any complex types could be null
    /// 
    /// It could be used to pull toward the anchor point, swing from the anchor point, some combination of those
    /// 
    /// This could be a template, or one of the live used settings.  Maybe even finish filling it in at the time
    /// of grappling (for settings like DesiredLength)
    /// </remarks>
    public record Grapple
    {
        public string name { get; init; }
        public string description { get; init; }      // it would be nice to have a place to describe the intention of various templates.  Or have the option to serialize grapples to file and share with others

        public string mappin_name { get; init; }

        /// <summary>
        /// Grapple will disengage when dot product of look direction and grapple line is less than this
        /// </summary>
        /// <remarks>
        /// If null, then grapple won't disengage based on where they look.  Good for grapples designed to make
        /// the player hang from a wall.  Set the desired length to something small, like .5 to 1
        /// </remarks>
        public double? minDot { get; init; } = 0;

        public AntiGravity anti_gravity { get; init; }

        /// <remarks>
        /// If this is set, then this is a fixed desired length (could be zero)
        /// 
        /// If null, then the desired length is the distance from the anchor point
        /// </remarks>
        public double? desired_length { get; init; }

        /// <summary>
        /// If set, then the grapple will exit if they get closer than this to the anchor point
        /// </summary>
        public double? stop_distance { get; init; }

        /// <summary>
        /// True: Grapple will exit if they touch a wall
        /// False: Grapple will ignore wall touching
        /// </summary>
        public bool stop_on_wallHit { get; init; }

        public ConstantAccel accel_alongGrappleLine { get; init; }
        public ConstantAccel accel_alongLook { get; init; }

        //TODO: Make this a class to get dead spots max speed, dead spots.  Also max values
        //Also may want different options for compressing and expanding.  Maybe even two
        //different instances of the same class
        /// <summary>
        /// If set, this will apply an accel equal to "normalized distance from ideal" * K
        /// </summary>
        public double? springAccel_k { get; init; }

        /// <summary>
        /// Adds an extra kick if current velocity is in the wrong direction (most useful to make a swing)
        /// </summary>
        public VelocityAway velocity_away { get; init; }

        /// <summary>
        /// How much it costs to spawn a grapple
        /// </summary>
        public double energy_cost { get; init; }

        // Exactly one of these will be populated
        public Aim_Straight aim_straight { get; init; }
        public Aim_Swing aim_swing { get; init; }

        /// <summary>
        /// 0 = min fall damage reduction
        /// 1 = full fall damage reduction
        /// </summary>
        /// <remarks>
        /// If value is greater than zero, do the safety fire logic, but then if less than 1, artificially apply
        /// speed based damage
        /// 
        /// Make it something like:
        /// dmg% = getScaled(80%, 0%, 0, 1, reduce%)
        /// health = health - (maxHealth * dmg%)
        /// 
        /// This way, they'll never die if they start with full health, but still take enough damage to be cautious
        /// </remarks>
        public double fallDamageReduction_percent { get; init; }

        /// <summary>
        /// This is how much experience was used to get these current values
        /// </summary>
        /// <remarks>
        /// Templates will start with zero experience
        /// 
        /// Each time an upgrade occurs, a new instance is made with a higher experience consumed
        /// 
        /// As they upgrade, keep a few previous versions, so they can try out changes and revert if they don't
        /// like it
        /// </remarks>
        public double experience { get; init; }



        //TODO: Energy regen boost
        //  Something like a wall hanger should allow standard energy regen

        //TODO: Pivot constraints
        //  SideToSide: This would make it a hinge joint
        //  FrontBack: This would make it feel like a pole stabbed into the wall.  If used, it would make most sense to be the same value as SideToSide


    }
}
