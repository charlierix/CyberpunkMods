using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AirplaneEditor.Airplane
{
    public record AeroSurfaceConfig
    {
        /// <summary>
        /// This is the wing's lift when thickness is maxxed out
        /// </summary>
        /// <remarks>
        /// Thickness is stored from 0 to 1, lift is just this constant times that percent
        /// </remarks>
        public const double MAX_LIFT = -6;

        /// <summary>
        /// Depth (not thickness)
        /// </summary>
        public double chord { get; init; } = 1;
        /// <summary>
        /// Width of the wing (wing span)
        /// </summary>
        public double span { get; init; } = 1;

        /// <summary>
        /// Angle of attack at which surface creates zero lift
        /// </summary>
        /// <remarks>
        /// cessna 172's regular wings use -3, horz stabalizers use 1.53, vert stabalizer is 0
        /// </remarks>
        public double zeroLiftAoA { get; init; } = 0;

        /// <summary>
        /// Percent of wing that is control surface (flap, rudder, aileron) 0 to 1
        /// </summary>
        /// <remarks>
        /// How much of the surface is movable as a control surface
        /// </remarks>
        public double flapFraction { get; init; } = 0;

        /// <summary>
        /// Slope angle of the lift coefficient in low angle of attack mode
        /// </summary>
        public double liftSlope { get; init; } = 6.28;
        /// <summary>
        /// Determines how much drag the surface creates due to friction (note, that drag is also created
        /// due to lift)
        /// </summary>
        public double skinFriction { get; init; } = 0.02;

        // Angles of attack at which stall starts
        public double stallAngleHigh { get; init; } = 15;       // body pieces have this at zero.  wing/tail surfaces used -15 to 15
        public double stallAngleLow { get; init; } = -15;

        //public bool autoAspectRatio { get; init; } = true;
        //public double aspectRatio { get; init; } = 2;
        public double aspectRatio => span / chord;

        /// <summary>
        /// Returns a copy with constrained props
        /// </summary>
        public static AeroSurfaceConfig ToValidAero(AeroSurfaceConfig config)
        {
            return config with
            {
                flapFraction = Math.Clamp(config.flapFraction, 0, 0.4),

                stallAngleHigh = Math.Max(config.stallAngleHigh, 0),

                stallAngleLow = Math.Min(config.stallAngleLow, 0),

                chord = Math.Max(config.chord, 0.001),

                //aspectRatio = config.autoAspectRatio ?
                //    config.span / config.chord :
                //    config.aspectRatio,
            };
        }

        public static double Convert_ThicknessToLift(double thickness)
        {
            return UtilityMath.GetScaledValue_Capped(0, MAX_LIFT, 0, 1, thickness);
        }
        public static double Convert_LiftToThickness(double lift)
        {
            return UtilityMath.GetScaledValue_Capped(0, 1, 0, MAX_LIFT, lift);
        }
    }
}
