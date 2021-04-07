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
        public string Name { get; init; }

        public string MappinName { get; init; }

        /// <summary>
        /// Grapple will disengage when dot product of look direction and grapple line is less than this
        /// </summary>
        public double minDot { get; init; } = 0;

        public AntiGravity AntiGravity { get; init; }

        /// <remarks>
        /// If this is set, then this is a fixed desired length (could be zero)
        /// 
        /// If null, then the desired length is the distance from the anchor point
        /// </remarks>
        public double? DesiredLength { get; init; }

        public ConstantAccel Accel_AlongGrappleLine { get; init; }
        public ConstantAccel Accel_AlongLook { get; init; }

        /// <summary>
        /// If set, this will apply an accel equal to "normalized distance from ideal" * K
        /// </summary>
        public double? SpringAccel_K { get; init; }

        /// <summary>
        /// Adds an extra kick if current velocity is in the wrong direction (most useful to make a swing)
        /// </summary>
        public VelocityAway VelocityAway { get; init; }

        /// <summary>
        /// How much it costs to spawn a grapple
        /// </summary>
        public double EnergyCost { get; init; }

        // Exactly one of these will be populated
        public Aim_Straight Aim_Straight { get; init; }
        public Aim_Swing Aim_Swing { get; init; }

        /// <summary>
        /// null = no fall damage reduction (don't support null, that's too punative)
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
        public double FallDamageReductionPercent { get; init; }

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
        public double Experience { get; init; }


        //TODO: Pivot constraints
        //  SideToSide: This would make it a hinge joint
        //  FrontBack: This would make it feel like a pole stabbed into the wall.  If used, it would make most sense to be the same value as SideToSide


    }
}
