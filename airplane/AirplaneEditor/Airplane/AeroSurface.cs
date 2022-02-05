using Game.Core;
using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Airplane
{
    //TODO: This class is a mess.  He is bouncing between degrees and radians throughout the code.  I'm trying to use degrees until the
    //actual call that needs radians, but I think it would be better to just use radians throughout?
    public class AeroSurface
    {
        #region record: AeroResut

        public record AeroResut
        {
            public Vector3D force { get; init; }
            public Vector3D torque { get; init; }

            // These are exposed for debug/drawing reasons
            public Vector3D lift { get; init; }
            public Vector3D drag { get; init; }

            public string report { get; init; }
        }

        #endregion

        #region record: Coefficients

        private record Coefficients
        {
            public double lift { get; init; }
            public double drag { get; init; }
            public double torque { get; init; }

            public static Coefficients LERP(Coefficients c1, Coefficients c2, double percent)
            {
                return new Coefficients()
                {
                    lift = UtilityMath.LERP(c1.lift, c2.lift, percent),
                    drag = UtilityMath.LERP(c1.drag, c2.drag, percent),
                    torque = UtilityMath.LERP(c1.torque, c2.torque, percent),
                };
            }
        }

        #endregion

        #region Declaration Section

        private const double DEG_2_RAD = 0.0174532924;
        private const double RAD_2_DEG = 57.29578;

        private readonly AeroSurfaceConfig _config;

        //TODO: These should be call rotate tranform.  C# only does rotations when passing vector, but lua doesn't know the difference between vector and point
        private readonly Transform3D _transform_toworld;
        private readonly Transform3D _transform_tolocal;

        private readonly Vector3D _forward = new Vector3D(0, 1, 0);
        private readonly Vector3D _right = new Vector3D(1, 0, 0);
        private readonly Vector3D _up = new Vector3D(0, 0, 1);

        /// <summary>
        /// Flap is a control surface (flap, elevator, rudder, aileron).  This is in degrees, clamped -50 to 50
        /// </summary>
        private double _flapAngle = 0;

        #endregion

        #region Constructor

        public AeroSurface(AeroSurfaceConfig config, Transform3D transform_toworld, Transform3D transform_tolocal)
        {
            _config = AeroSurfaceConfig.ToValidAero(config);
            _transform_toworld = transform_toworld;
            _transform_tolocal = transform_tolocal;
        }

        #endregion

        public Point3D Position_world => _transform_toworld.Transform(new Point3D());

        public void SetFlapAngle(double angle)
        {
            _flapAngle = Math.Clamp(angle, -50, 50);
        }

        //NOTE: force is applied at the center of the aero surface.  torque is applied to the center of mass of the rigid body
        /// <param name="relativePosition_world">Position of aero surface in world coords - center of mass in world coords</param>
        public AeroResut CalculateForces_FLAWS(Vector3D airVelocity_world, double airDensity, Vector3D relativePosition_world)
        {
            Vector3D forward_world = _transform_toworld.Transform(_forward);
            Vector3D right_world = _transform_toworld.Transform(_right);

            //NOTE: FlapAngle is exposed publicly as an angle, but is used here internally as a radian
            double flapAngle = _flapAngle * DEG_2_RAD;

            // Accounting for aspect ratio effect on lift coefficient
            // Assuming liftSlope = 6.28...
            // aspect=1:    1.45
            // aspect=2:    2.51
            // aspect=3:    3.25
            // aspect=5:    4.15
            // aspect=8:    4.83
            // aspect=12:   5.28
            double correctedLiftSlope = _config.liftSlope * _config.aspectRatio / (_config.aspectRatio + 2 * (_config.aspectRatio + 4) / (_config.aspectRatio + 2));

            // If flaps are in use, lift could change a little (if flaps are zero, then delta will be zero)
            double deltaLift = GetDeltaLift(flapAngle, _config.flapFraction, correctedLiftSlope);




            double zeroLiftAoaBase = _config.zeroLiftAoA * DEG_2_RAD;
            double zeroLiftAoA = zeroLiftAoaBase - deltaLift / correctedLiftSlope;

            double stallAngleHighBase = _config.stallAngleHigh * DEG_2_RAD;
            double stallAngleLowBase = _config.stallAngleLow * DEG_2_RAD;

            double clMaxHigh = correctedLiftSlope * (stallAngleHighBase - zeroLiftAoaBase) + deltaLift * LiftCoefficientMaxFraction(_config.flapFraction);
            double clMaxLow = correctedLiftSlope * (stallAngleLowBase - zeroLiftAoaBase) + deltaLift * LiftCoefficientMaxFraction(_config.flapFraction);

            double stallAngleHigh = zeroLiftAoA + clMaxHigh / correctedLiftSlope;
            double stallAngleLow = zeroLiftAoA + clMaxLow / correctedLiftSlope;





            //TODO: Trying to guess isn't working.  Make some kind of live visual


            // Calculating air velocity relative to the surface's coordinate system.
            // Z component of the velocity is discarded. 
            Vector3D airVelocity_local = _transform_tolocal.Transform(airVelocity_world);       //NOTE: transforming vectors only does rotation

            Vector3D airVelocity_local_unmodified = airVelocity_local;

            airVelocity_local = new Vector3D(airVelocity_local.X, airVelocity_local.Y, 0);
            //airVelocity_local = new Vector3D(0, airVelocity_local.Y, airVelocity_local.Z);





            Vector3D dragDirection = _transform_toworld.Transform(airVelocity_local.ToUnit());



            //Vector3D liftDirection = Vector3D.CrossProduct(dragDirection, forward_world);     // when flying forward, drag would be reverse of forward, so cross is 0
            Vector3D liftDirection = Vector3D.CrossProduct(dragDirection, right_world);     // this almost works, but completely flips when airflow is slightly over vs under wing


            if (liftDirection.IsNearZero())
                liftDirection = _transform_toworld.Transform(_up);

            double area = _config.chord * _config.span;
            double dynamicPressure = 0.5 * airDensity * airVelocity_local.LengthSquared;





            // I don't know why unity threw out Z.  Why is unity not considering Z for angle of attack?
            // This should be taking max(x, y) compared with z --- or something like that, but definitely can't figure out angle of attack when only looking at the components in the wing's plane

            //double angleOfAttack = Math.Atan2(airVelocity_local.X, -airVelocity_local.Y);
            //double angleOfAttack = Math.Atan2(airVelocity_local.Z, -airVelocity_local.Y);

            double angleOfAttack = Math.Atan2(airVelocity_local_unmodified.Z, -airVelocity_local_unmodified.Y);





            Coefficients aerodynamicCoefficients = CalculateCoefficients(flapAngle, angleOfAttack, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, _config.aspectRatio, _config.skinFriction);


            Vector3D lift = liftDirection * aerodynamicCoefficients.lift * dynamicPressure * area;
            Vector3D drag = dragDirection * aerodynamicCoefficients.drag * dynamicPressure * area;
            Vector3D torque = -forward_world * aerodynamicCoefficients.torque * dynamicPressure * area * _config.chord;



            return new AeroResut()
            {
                force = lift + drag,
                torque = torque + Vector3D.CrossProduct(relativePosition_world, lift + drag),

                lift = lift,
                drag = drag,
            };
        }

        public AeroResut CalculateForces_MYWAY(Vector3D airVelocity_world, double airDensity, Vector3D relativePosition_world)
        {
            //NOTE: FlapAngle is exposed publicly as an angle, but is used here internally as a radian
            double flapAngle = _flapAngle * DEG_2_RAD;

            // Accounting for aspect ratio effect on lift coefficient
            // Assuming liftSlope = 6.28...
            // aspect=1:    1.45
            // aspect=2:    2.51
            // aspect=3:    3.25
            // aspect=5:    4.15
            // aspect=8:    4.83
            // aspect=12:   5.28
            double correctedLiftSlope = _config.liftSlope * _config.aspectRatio / (_config.aspectRatio + 2 * (_config.aspectRatio + 4) / (_config.aspectRatio + 2));

            // If flaps are in use, lift could change a little (if flaps are zero, then delta will be zero)
            double deltaLift = GetDeltaLift(flapAngle, _config.flapFraction, correctedLiftSlope);


            double zeroLiftAoaBase = _config.zeroLiftAoA * DEG_2_RAD;
            double zeroLiftAoA = zeroLiftAoaBase - deltaLift / correctedLiftSlope;

            double stallAngleHighBase = _config.stallAngleHigh * DEG_2_RAD;
            double stallAngleLowBase = _config.stallAngleLow * DEG_2_RAD;

            double clMaxHigh = correctedLiftSlope * (stallAngleHighBase - zeroLiftAoaBase) + deltaLift * LiftCoefficientMaxFraction(_config.flapFraction);
            double clMaxLow = correctedLiftSlope * (stallAngleLowBase - zeroLiftAoaBase) + deltaLift * LiftCoefficientMaxFraction(_config.flapFraction);

            double stallAngleHigh = zeroLiftAoA + clMaxHigh / correctedLiftSlope;
            double stallAngleLow = zeroLiftAoA + clMaxLow / correctedLiftSlope;


            var drag_direction = GetDragDirection(airVelocity_world);
            Vector3D lift_direction = GetLiftDirection(airVelocity_world);


            double area = _config.chord * _config.span;
            double dynamicPressure = 0.5 * airDensity * drag_direction.full.LengthSquared;



            double angleOfAttack = GetAngleOfAttack(airVelocity_world);

            //TODO: Reduce lift's effectiveness when the wing is slicing sideways into the wind (or backward)


            Coefficients aerodynamicCoefficients = CalculateCoefficients(flapAngle, angleOfAttack, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, _config.aspectRatio, _config.skinFriction);


            Vector3D lift = lift_direction * aerodynamicCoefficients.lift * dynamicPressure * area;
            Vector3D drag = drag_direction.unit * aerodynamicCoefficients.drag * dynamicPressure * area;
            //Vector3D torque = -forward_world * aerodynamicCoefficients.torque * dynamicPressure * area * _config.chord;

            return new AeroResut()
            {
                force = lift + drag,
                //torque = torque + Vector3D.CrossProduct(relativePosition_world, lift + drag),

                lift = lift,
                drag = drag,

                report = GetReport(angleOfAttack, correctedLiftSlope, zeroLiftAoA),
            };

        }

        #region Private Methods

        /// <summary>
        /// Calculating flap deflection influence on zero lift angle of attack and angles at which stall happens
        /// </summary>
        /// <param name="flapAngle">This is in radians</param>
        /// <param name="flapFraction">Percent of the wing that is movable flap</param>
        /// <param name="correctedLiftSlope">Lift slope run through an aspect ratio adjustment</param>
        /// <returns>?????</returns>
        private static double GetDeltaLift(double flapAngle, double flapFraction, double correctedLiftSlope)
        {
            if (flapAngle.IsNearZero())     // save a couple expensive sine calls
                return 0;

            // flapFraction is clamped from 0 to 0.4, which makes output from -pi to a little less than -pi/2
            double theta = Math.Acos(2 * flapFraction - 1);

            // flap% 0:     0.81
            // flap% 0.4:   0.92
            double flapEffectivness = 1 - (theta - Math.Sin(theta)) / Math.PI;

            // flap angle 0:    0.88
            // flap angle 50:   0.48
            double flapEffectivnessCorrection = UtilityMath.LERP(0.8, 0.4, (Math.Abs(flapAngle) * RAD_2_DEG - 10) / 50);

            return correctedLiftSlope * flapEffectivness * flapEffectivnessCorrection * flapAngle;
        }

        private (Vector3D full, Vector3D unit) GetDragDirection(Vector3D airVelocity_world)
        {
            Vector3D normal_world = _transform_toworld.Transform(_up);

            Vector3D full = GetProjectedVector(airVelocity_world, normal_world);

            if (full.IsNearZero())
                full = airVelocity_world;

            return (full, full.ToUnit());
        }
        private Vector3D GetLiftDirection(Vector3D airVelocity_world)
        {
            Vector3D normal_world = _transform_toworld.Transform(_up);

            Vector3D full = airVelocity_world.GetProjectedVector(normal_world);
            full = -full;

            if (full.IsNearZero())
                return normal_world;

            if (Vector3D.DotProduct(full, normal_world) < 0)        // angle of attack can be negative, and that is multiplied by this vector, so lift direction needs to stay positive only
                full = -full;

            return full.ToUnit();
        }

        private double GetAngleOfAttack(Vector3D airVelocity_world)
        {
            Vector3D forward_world = _transform_toworld.Transform(_forward);
            Vector3D right_world = _transform_toworld.Transform(_right);
            Vector3D up_world = _transform_toworld.Transform(_up);

            Vector3D in_vert_plane = GetProjectedVector(airVelocity_world, right_world);

            double angle = Vector3D.AngleBetween(forward_world, -in_vert_plane);

            if (Vector3D.DotProduct(in_vert_plane, up_world) < 0)
                angle = -angle;

            return angle * DEG_2_RAD;
        }

        private static Coefficients CalculateCoefficients(double flapAngle, double angleOfAttack, double correctedLiftSlope, double zeroLiftAoA, double stallAngleHigh, double stallAngleLow, double aspectRatio, double skinFriction)
        {
            Coefficients aerodynamicCoefficients;

            // Low angles of attack mode and stall mode curves are stitched together by a line segment
            double paddingAngleHigh = DEG_2_RAD * UtilityMath.LERP(15, 5, (RAD_2_DEG * flapAngle + 50) / 100);
            double paddingAngleLow = DEG_2_RAD * UtilityMath.LERP(15, 5, (-RAD_2_DEG * flapAngle + 50) / 100);
            double paddedStallAngleHigh = stallAngleHigh + paddingAngleHigh;
            double paddedStallAngleLow = stallAngleLow - paddingAngleLow;

            if (angleOfAttack < stallAngleHigh && angleOfAttack > stallAngleLow)
            {
                // Low angle of attack mode (I think this means standard level flight)
                aerodynamicCoefficients = CalculateCoefficients_LowAoA(angleOfAttack, correctedLiftSlope, zeroLiftAoA, aspectRatio, skinFriction);
            }
            else
            {
                if (angleOfAttack > paddedStallAngleHigh || angleOfAttack < paddedStallAngleLow)
                {
                    // Stall mode
                    aerodynamicCoefficients = CalculateCoefficients_Stall(angleOfAttack, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, aspectRatio, skinFriction, flapAngle);
                }
                else
                {
                    // Linear stitching in-between stall and low angles of attack modes
                    Coefficients aerodynamicCoefficientsLow;
                    Coefficients aerodynamicCoefficientsStall;
                    double lerpParam;

                    if (angleOfAttack > stallAngleHigh)
                    {
                        aerodynamicCoefficientsLow = CalculateCoefficients_LowAoA(stallAngleHigh, correctedLiftSlope, zeroLiftAoA, aspectRatio, skinFriction);
                        aerodynamicCoefficientsStall = CalculateCoefficients_Stall(paddedStallAngleHigh, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, aspectRatio, skinFriction, flapAngle);
                        lerpParam = (angleOfAttack - stallAngleHigh) / (paddedStallAngleHigh - stallAngleHigh);
                    }
                    else
                    {
                        aerodynamicCoefficientsLow = CalculateCoefficients_LowAoA(stallAngleLow, correctedLiftSlope, zeroLiftAoA, aspectRatio, skinFriction);
                        aerodynamicCoefficientsStall = CalculateCoefficients_Stall(paddedStallAngleLow, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, aspectRatio, skinFriction, flapAngle);
                        lerpParam = (angleOfAttack - stallAngleLow) / (paddedStallAngleLow - stallAngleLow);
                    }

                    aerodynamicCoefficients = Coefficients.LERP(aerodynamicCoefficientsLow, aerodynamicCoefficientsStall, lerpParam);
                }
            }

            return aerodynamicCoefficients;
        }
        private static Coefficients CalculateCoefficients_LowAoA(double angleOfAttack, double correctedLiftSlope, double zeroLiftAoA, double aspectRatio, double skinFriction)
        {
            double liftCoefficient = correctedLiftSlope * (angleOfAttack - zeroLiftAoA);
            double inducedAngle = liftCoefficient / (Math.PI * aspectRatio);
            double effectiveAngle = angleOfAttack - zeroLiftAoA - inducedAngle;

            double tangentialCoefficient = skinFriction * Math.Cos(effectiveAngle);

            double normalCoefficient = (liftCoefficient + Math.Sin(effectiveAngle) * tangentialCoefficient) / Math.Cos(effectiveAngle);
            double dragCoefficient = normalCoefficient * Math.Sin(effectiveAngle) + tangentialCoefficient * Math.Cos(effectiveAngle);
            double torqueCoefficient = -normalCoefficient * TorqCoefficientProportion(effectiveAngle);

            return new Coefficients()
            {
                lift = liftCoefficient,
                drag = dragCoefficient,
                torque = torqueCoefficient,
            };
        }
        private static Coefficients CalculateCoefficients_Stall(double angleOfAttack, double correctedLiftSlope, double zeroLiftAoA, double stallAngleHigh, double stallAngleLow, double aspectRatio, double skinFriction, double flapAngle)
        {
            double liftCoefficientLowAoA = angleOfAttack > stallAngleHigh ?
                correctedLiftSlope * (stallAngleHigh - zeroLiftAoA) :
                correctedLiftSlope * (stallAngleLow - zeroLiftAoA);

            double inducedAngle = liftCoefficientLowAoA / (Math.PI * aspectRatio);

            double lerpParam = angleOfAttack > stallAngleHigh ?
                (Math.PI / 2 - UtilityMath.Clamp(angleOfAttack, -Math.PI / 2, Math.PI / 2)) / (Math.PI / 2 - stallAngleHigh) :
                (-Math.PI / 2 - UtilityMath.Clamp(angleOfAttack, -Math.PI / 2, Math.PI / 2)) / (-Math.PI / 2 - stallAngleLow);

            inducedAngle = UtilityMath.LERP(0, inducedAngle, lerpParam);

            double effectiveAngle = angleOfAttack - zeroLiftAoA - inducedAngle;

            double sin_effectiveAngle = Math.Sin(effectiveAngle);
            double cos_effectiveAngle = Math.Cos(effectiveAngle);

            double normalCoefficient = FrictionAt90Degrees(flapAngle) * sin_effectiveAngle * (1 / (0.56 + 0.44 * Math.Abs(sin_effectiveAngle)) - 0.41 * (1 - Math.Exp(-17 / aspectRatio)));
            double tangentialCoefficient = 0.5 * skinFriction * cos_effectiveAngle;

            double liftCoefficient = normalCoefficient * cos_effectiveAngle - tangentialCoefficient * sin_effectiveAngle;
            double dragCoefficient = normalCoefficient * sin_effectiveAngle + tangentialCoefficient * cos_effectiveAngle;
            double torqueCoefficient = -normalCoefficient * TorqCoefficientProportion(effectiveAngle);

            return new Coefficients()
            {
                lift = liftCoefficient,
                drag = dragCoefficient,
                torque = torqueCoefficient,
            };
        }

        private static double TorqCoefficientProportion(double effectiveAngle)
        {
            return 0.25 - 0.175 * (1 - 2 * Math.Abs(effectiveAngle) / Math.PI);
        }

        private static double FrictionAt90Degrees(double flapAngle)
        {
            //NOTE: flapAngle is actually radians
            return 1.98 - 4.26e-2 * flapAngle * flapAngle + 2.1e-1 * flapAngle;
        }

        private double LiftCoefficientMaxFraction(double flapFraction)
        {
            return Math.Clamp(1 - 0.5 * (flapFraction - 0.1) / 0.3, 0, 1);
        }

        /// <summary>
        /// This returns the vector projected onto the plane
        /// </summary>
        /// <remarks>
        /// This was copied from Game.Math_WPF.Mathematics.Extenders.GetProjectedVector(this Vector3D vector, ITriangle_wpf alongPlane)
        /// </remarks>
        /// <param name="vector">The vector projected onto the plane</param>
        /// <param name="planes_normal">The plane's normal</param>
        /// <returns>The portion of the vector that is on the plane</returns>
        private static Vector3D GetProjectedVector(Vector3D vector, Vector3D planes_normal)
        {
            // Get a line that is parallel to the plane, but along the direction of the vector
            Vector3D alongLine = Vector3D.CrossProduct(planes_normal, Vector3D.CrossProduct(vector, planes_normal));

            // Use the other overload to get the portion of the vector along this line
            return vector.GetProjectedVector(alongLine);
        }

        #endregion

        private static string GetReport(double angleOfAttack, double correctedLiftSlope, double zeroLiftAoA)
        {
            StringBuilder retVal = new StringBuilder();

            //retVal.AppendLine($"aoa (rad)\t\t{Math.Round(angleOfAttack, 3)}");
            retVal.AppendLine($"aoa (deg)\t{Math.Round(angleOfAttack * RAD_2_DEG)}");

            //retVal.AppendLine($"cor lift\t{Math.Round(correctedLiftSlope, 3)}");

            retVal.AppendLine($"0 aoa (deg)\t{Math.Round(zeroLiftAoA * RAD_2_DEG)}");


            return retVal.ToString();
        }
    }
}
