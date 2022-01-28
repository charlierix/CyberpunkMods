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

        public BiVector3 CalculateForces_ORIG(Vector3D worldAirVelocity, double airDensity, Vector3D relativePosition_world)
        {
            BiVector3 forceAndTorque = new BiVector3();

            Vector3D forward_world = _transform_toworld.Transform(_forward);      //TODO: Make sure transform only does rotation

            // Accounting for aspect ratio effect on lift coefficient.
            double correctedLiftSlope = _config.liftSlope * _config.aspectRatio / (_config.aspectRatio + 2 * (_config.aspectRatio + 4) / (_config.aspectRatio + 2));

            // Calculating flap deflection influence on zero lift angle of attack
            // and angles at which stall happens.
            double theta = Math.Acos(2 * _config.flapFraction - 1);
            double flapEffectivness = 1 - (theta - Math.Sin(theta)) / Math.PI;
            double deltaLift = correctedLiftSlope * flapEffectivness * FlapEffectivnessCorrection(_flapAngle) * _flapAngle;

            double zeroLiftAoaBase = _config.zeroLiftAoA;
            double zeroLiftAoA = zeroLiftAoaBase - deltaLift / correctedLiftSlope;

            double stallAngleHighBase = _config.stallAngleHigh;
            double stallAngleLowBase = _config.stallAngleLow;

            double clMaxHigh = correctedLiftSlope * (stallAngleHighBase - zeroLiftAoaBase) + deltaLift * LiftCoefficientMaxFraction(_config.flapFraction);
            double clMaxLow = correctedLiftSlope * (stallAngleLowBase - zeroLiftAoaBase) + deltaLift * LiftCoefficientMaxFraction(_config.flapFraction);

            double stallAngleHigh = zeroLiftAoA + clMaxHigh / correctedLiftSlope;
            double stallAngleLow = zeroLiftAoA + clMaxLow / correctedLiftSlope;

            // Calculating air velocity relative to the surface's coordinate system.
            // Z component of the velocity is discarded. 
            Vector3D airVelocity = _transform_tolocal.Transform(worldAirVelocity);       //NOTE: transforming vectors only does rotation
            airVelocity = new Vector3D(airVelocity.X, airVelocity.Y, 0);
            Vector3D dragDirection = _transform_toworld.Transform(airVelocity.ToUnit());
            Vector3D liftDirection = Vector3D.CrossProduct(dragDirection, forward_world);

            double area = _config.chord * _config.span;
            double dynamicPressure = 0.5 * airDensity * airVelocity.LengthSquared;
            double angleOfAttack = Math.Atan2(airVelocity.Y, -airVelocity.X);

            Vector3D aerodynamicCoefficients = CalculateCoefficients(_flapAngle, angleOfAttack, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, _config);

            Vector3D lift = liftDirection * aerodynamicCoefficients.X * dynamicPressure * area;
            Vector3D drag = dragDirection * aerodynamicCoefficients.Y * dynamicPressure * area;
            Vector3D torque = -forward_world * aerodynamicCoefficients.Z * dynamicPressure * area * _config.chord;

            forceAndTorque.p += lift + drag;
            forceAndTorque.q += Vector3D.CrossProduct(relativePosition_world, forceAndTorque.p);
            forceAndTorque.q += torque;

            return forceAndTorque;
        }
        // These seem to be rotated funny, like they are hard coded to an orientation other than Y

        // Drag only
        public BiVector3 CalculateForces_DRAG(Vector3D worldAirVelocity, double airDensity, Vector3D relativePosition_world)
        {
            BiVector3 forceAndTorque = new BiVector3();

            // Accounting for aspect ratio effect on lift coefficient.
            double correctedLiftSlope = _config.liftSlope * _config.aspectRatio / (_config.aspectRatio + 2 * (_config.aspectRatio + 4) / (_config.aspectRatio + 2));

            // Calculating air velocity relative to the surface's coordinate system.
            // Z component of the velocity is discarded. 
            Vector3D airVelocity = _transform_tolocal.Transform(worldAirVelocity);       //NOTE: transforming vectors only does rotation
            airVelocity = new Vector3D(airVelocity.X, airVelocity.Y, 0);
            Vector3D dragDirection = _transform_toworld.Transform(airVelocity.ToUnit());

            double area = _config.chord * _config.span;
            double dynamicPressure = 0.5 * airDensity * airVelocity.LengthSquared;
            double angleOfAttack = Math.Atan2(airVelocity.Y, -airVelocity.X);

            Vector3D aerodynamicCoefficients = CalculateCoefficients(_flapAngle, angleOfAttack, correctedLiftSlope, 0, 179, -179, _config);

            Vector3D drag = dragDirection * aerodynamicCoefficients.Y * dynamicPressure * area;

            forceAndTorque.p += drag;

            return forceAndTorque;
        }
        public BiVector3 CalculateForces_LIFT(Vector3D worldAirVelocity, double airDensity, Vector3D relativePosition_world)
        {
            BiVector3 forceAndTorque = new BiVector3();

            Vector3D forward_world = _transform_toworld.Transform(_forward);      //TODO: Make sure transform only does rotation

            // Accounting for aspect ratio effect on lift coefficient.
            double correctedLiftSlope = _config.liftSlope * _config.aspectRatio / (_config.aspectRatio + 2 * (_config.aspectRatio + 4) / (_config.aspectRatio + 2));

            // Calculating air velocity relative to the surface's coordinate system.
            // Z component of the velocity is discarded. 
            Vector3D airVelocity = _transform_tolocal.Transform(worldAirVelocity);       //NOTE: transforming vectors only does rotation
            airVelocity = new Vector3D(airVelocity.X, airVelocity.Y, 0);
            Vector3D dragDirection = _transform_toworld.Transform(airVelocity.ToUnit());
            Vector3D liftDirection = Vector3D.CrossProduct(dragDirection, forward_world);

            double area = _config.chord * _config.span;
            double dynamicPressure = 0.5 * airDensity * airVelocity.LengthSquared;
            double angleOfAttack = Math.Atan2(airVelocity.Y, -airVelocity.X);

            Vector3D aerodynamicCoefficients = CalculateCoefficients(_flapAngle, angleOfAttack, correctedLiftSlope, 0, 179, -179, _config);

            Vector3D lift = liftDirection * aerodynamicCoefficients.X * dynamicPressure * area;

            forceAndTorque.p += lift;

            return forceAndTorque;
        }

        // In unity, Y is up, wind is coming at along Z
        // But in this project, Z is up, wind coming along Y
        //
        // There is something wrong with this version, angle of attack is wrong.  It probably has something to do
        // with that 90 degree difference
        //
        // Even when a plane is rotated to face along Z, this still behaves the same when wind is coming down along
        // Z.  So the problem is independent of global orientation


        //NOTE: force is applied at the center of the aero surface.  torque is applied to the center of mass of the rigid body
        /// <param name="relativePosition_world">Position of aero surface in world coords - center of mass in world coords</param>
        public AeroResut CalculateForces_Attempt2(Vector3D airVelocity_world, double airDensity, Vector3D relativePosition_world)
        {
            Vector3D forward_world = _transform_toworld.Transform(_forward);      //TODO: Make sure transform only does rotation

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




            // Calculating air velocity relative to the surface's coordinate system.
            // Z component of the velocity is discarded. 
            Vector3D airVelocity_local = _transform_tolocal.Transform(airVelocity_world);       //NOTE: transforming vectors only does rotation
            airVelocity_local = new Vector3D(airVelocity_local.X, airVelocity_local.Y, 0);

            Vector3D dragDirection = _transform_toworld.Transform(airVelocity_local.ToUnit());

            Vector3D liftDirection = Vector3D.CrossProduct(dragDirection, forward_world);
            if (liftDirection.IsNearZero())
                liftDirection = _transform_toworld.Transform(_up);

            double area = _config.chord * _config.span;
            double dynamicPressure = 0.5 * airDensity * airVelocity_local.LengthSquared;





            /*
            ----------- wpf -----------
            airVelocity_world	0, -8, 0
            _transform_tolocal

            transform quat is identity


            ----------- unity -----------
            worldAirVelocity	-.1, 0, -30
            airVelocity		-30, .6, 0


            // this is just rotating about Y so that the flaps are lined up
            var quat = transform.rotation;
            quat.ToAngleAxis(out float quat_angle, out Vector3 quat_axis);

            quat_angle	90
            quat_axis	0, -1, 0
            */







            // X and Y are reversed from what unity has.  It might be because the wings here have the span rotated into
            // the wind (so the wing is rotated 90 degrees from what it should be)
            //
            // The best way to test is to finish the property panel so that span, coord, etc can be modified by textboxes
            double angleOfAttack = Math.Atan2(airVelocity_local.Y, -airVelocity_local.X);




            Coefficients aerodynamicCoefficients = CalculateCoefficients2(flapAngle, angleOfAttack, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, _config.aspectRatio, _config.skinFriction);


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

        #region Private Methods

        private static Vector3D CalculateCoefficients(double flapAngle, double angleOfAttack, double correctedLiftSlope, double zeroLiftAoA, double stallAngleHigh, double stallAngleLow, AeroSurfaceConfig config)
        {
            Vector3D aerodynamicCoefficients;

            // Low angles of attack mode and stall mode curves are stitched together by a line segment. 
            double paddingAngleHigh = UtilityMath.LERP(15, 5, (flapAngle + 50) / 100);
            double paddingAngleLow = UtilityMath.LERP(15, 5, (-flapAngle + 50) / 100);
            double paddedStallAngleHigh = stallAngleHigh + paddingAngleHigh;
            double paddedStallAngleLow = stallAngleLow - paddingAngleLow;

            if (angleOfAttack < stallAngleHigh && angleOfAttack > stallAngleLow)
            {
                // Low angle of attack mode.
                aerodynamicCoefficients = CalculateCoefficients_LowAoA(angleOfAttack, correctedLiftSlope, zeroLiftAoA, config);
            }
            else
            {
                if (angleOfAttack > paddedStallAngleHigh || angleOfAttack < paddedStallAngleLow)
                {
                    // Stall mode.
                    aerodynamicCoefficients = CalculateCoefficients_Stall(flapAngle, angleOfAttack, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, config);
                }
                else
                {
                    // Linear stitching in-between stall and low angles of attack modes.
                    Vector3D aerodynamicCoefficientsLow;
                    Vector3D aerodynamicCoefficientsStall;
                    double lerpParam;

                    if (angleOfAttack > stallAngleHigh)
                    {
                        aerodynamicCoefficientsLow = CalculateCoefficients_LowAoA(stallAngleHigh, correctedLiftSlope, zeroLiftAoA, config);
                        aerodynamicCoefficientsStall = CalculateCoefficients_Stall(flapAngle, paddedStallAngleHigh, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, config);
                        lerpParam = (angleOfAttack - stallAngleHigh) / (paddedStallAngleHigh - stallAngleHigh);
                    }
                    else
                    {
                        aerodynamicCoefficientsLow = CalculateCoefficients_LowAoA(stallAngleLow, correctedLiftSlope, zeroLiftAoA, config);
                        aerodynamicCoefficientsStall = CalculateCoefficients_Stall(flapAngle, paddedStallAngleLow, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, config);
                        lerpParam = (angleOfAttack - stallAngleLow) / (paddedStallAngleLow - stallAngleLow);
                    }

                    aerodynamicCoefficients = Math3D.LERP(aerodynamicCoefficientsLow, aerodynamicCoefficientsStall, lerpParam);
                }
            }

            return aerodynamicCoefficients;
        }
        private static Vector3D CalculateCoefficients_LowAoA(double angleOfAttack, double correctedLiftSlope, double zeroLiftAoA, AeroSurfaceConfig config)
        {
            double liftCoefficient = correctedLiftSlope * (angleOfAttack - zeroLiftAoA);
            double inducedAngle = liftCoefficient / config.aspectRatio;
            double effectiveAngle = angleOfAttack - zeroLiftAoA - inducedAngle;

            double cos_effectiveAngle = Math.Cos(Math1D.DegreesToRadians(effectiveAngle));
            double sin_effectiveAngle = Math.Sin(Math1D.DegreesToRadians(effectiveAngle));

            double tangentialCoefficient = config.skinFriction * cos_effectiveAngle;

            double normalCoefficient = (liftCoefficient + sin_effectiveAngle * tangentialCoefficient) / cos_effectiveAngle;
            double dragCoefficient = normalCoefficient * sin_effectiveAngle + tangentialCoefficient * cos_effectiveAngle;
            double torqueCoefficient = -normalCoefficient * TorqCoefficientProportion(effectiveAngle);

            return new Vector3D(liftCoefficient, dragCoefficient, torqueCoefficient);
        }
        private static Vector3D CalculateCoefficients_Stall(double flapAngle, double angleOfAttack, double correctedLiftSlope, double zeroLiftAoA, double stallAngleHigh, double stallAngleLow, AeroSurfaceConfig config)
        {
            double liftCoefficientLowAoA;
            if (angleOfAttack > stallAngleHigh)
            {
                liftCoefficientLowAoA = correctedLiftSlope * (stallAngleHigh - zeroLiftAoA);
            }
            else
            {
                liftCoefficientLowAoA = correctedLiftSlope * (stallAngleLow - zeroLiftAoA);
            }
            double inducedAngle = liftCoefficientLowAoA / config.aspectRatio;

            double lerpParam;
            if (angleOfAttack > stallAngleHigh)
            {
                //lerpParam = (Mathf.PI / 2 - Mathf.Clamp(angleOfAttack, -Mathf.PI / 2, Mathf.PI / 2)) / (Mathf.PI / 2 - stallAngleHigh);
                lerpParam = (90 - Math.Clamp(angleOfAttack, -90, 90)) / (90 - stallAngleHigh);
            }
            else
            {
                //lerpParam = (-Mathf.PI / 2 - Mathf.Clamp(angleOfAttack, -Mathf.PI / 2, Mathf.PI / 2)) / (-Mathf.PI / 2 - stallAngleLow);
                lerpParam = (-90 - Math.Clamp(angleOfAttack, -90, 90)) / (-90 - stallAngleLow);
            }
            inducedAngle = UtilityMath.LERP(0, inducedAngle, lerpParam);
            double effectiveAngle = angleOfAttack - zeroLiftAoA - inducedAngle;

            double cos_effectiveAngle = Math.Cos(Math1D.DegreesToRadians(effectiveAngle));
            double sin_effectiveAngle = Math.Sin(Math1D.DegreesToRadians(effectiveAngle));

            double normalCoefficient = FrictionAt90Degrees(flapAngle) * sin_effectiveAngle * (1 / (0.56f + 0.44f * Math.Abs(sin_effectiveAngle)) - 0.41f * (1 - Math.Exp(-17 / config.aspectRatio)));
            double tangentialCoefficient = 0.5f * config.skinFriction * cos_effectiveAngle;

            double liftCoefficient = normalCoefficient * cos_effectiveAngle - tangentialCoefficient * sin_effectiveAngle;
            double dragCoefficient = normalCoefficient * sin_effectiveAngle + tangentialCoefficient * cos_effectiveAngle;
            double torqueCoefficient = -normalCoefficient * TorqCoefficientProportion(effectiveAngle);

            return new Vector3D(liftCoefficient, dragCoefficient, torqueCoefficient);
        }

        private static double TorqCoefficientProportion(double effectiveAngle)
        {
            double effectiveRadians = Math1D.DegreesToRadians(effectiveAngle);

            return 0.25 - 0.175 * (1 - 2 * Math.Abs(effectiveRadians) / Math.PI);       //TODO: instead of working radians, see if removing the divide by pi is enough (are all these values already in terms of angle isntead of radians?)
        }

        private static double FrictionAt90Degrees(double flapAngle)
        {
            double flapRadians = Math1D.DegreesToRadians(flapAngle);

            return 1.98 - 4.26e-2 * flapRadians * flapRadians + 2.1e-1 * flapRadians;
        }

        private static double FlapEffectivnessCorrection(double flapAngle)
        {
            return UtilityMath.LERP(0.8, 0.4, (Math.Abs(flapAngle) - 10) / 50);
        }

        private double LiftCoefficientMaxFraction(double flapFraction)
        {
            return Math.Clamp(1 - 0.5 * (flapFraction - 0.1) / 0.3, 0, 1);
        }

        #endregion
        #region Private Methods - Attempt 2

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

        private static Coefficients CalculateCoefficients2(double flapAngle, double angleOfAttack, double correctedLiftSlope, double zeroLiftAoA, double stallAngleHigh, double stallAngleLow, double aspectRatio, double skinFriction)
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
                aerodynamicCoefficients = CalculateCoefficients2_LowAoA(angleOfAttack, correctedLiftSlope, zeroLiftAoA, aspectRatio, skinFriction);
            }
            else
            {
                if (angleOfAttack > paddedStallAngleHigh || angleOfAttack < paddedStallAngleLow)
                {
                    // Stall mode
                    aerodynamicCoefficients = CalculateCoefficients2_Stall(angleOfAttack, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, aspectRatio, skinFriction, flapAngle);
                }
                else
                {
                    // Linear stitching in-between stall and low angles of attack modes
                    Coefficients aerodynamicCoefficientsLow;
                    Coefficients aerodynamicCoefficientsStall;
                    double lerpParam;

                    if (angleOfAttack > stallAngleHigh)
                    {
                        aerodynamicCoefficientsLow = CalculateCoefficients2_LowAoA(stallAngleHigh, correctedLiftSlope, zeroLiftAoA, aspectRatio, skinFriction);
                        aerodynamicCoefficientsStall = CalculateCoefficients2_Stall(paddedStallAngleHigh, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, aspectRatio, skinFriction, flapAngle);
                        lerpParam = (angleOfAttack - stallAngleHigh) / (paddedStallAngleHigh - stallAngleHigh);
                    }
                    else
                    {
                        aerodynamicCoefficientsLow = CalculateCoefficients2_LowAoA(stallAngleLow, correctedLiftSlope, zeroLiftAoA, aspectRatio, skinFriction);
                        aerodynamicCoefficientsStall = CalculateCoefficients2_Stall(paddedStallAngleLow, correctedLiftSlope, zeroLiftAoA, stallAngleHigh, stallAngleLow, aspectRatio, skinFriction, flapAngle);
                        lerpParam = (angleOfAttack - stallAngleLow) / (paddedStallAngleLow - stallAngleLow);
                    }

                    aerodynamicCoefficients = Coefficients.LERP(aerodynamicCoefficientsLow, aerodynamicCoefficientsStall, lerpParam);
                }
            }

            return aerodynamicCoefficients;
        }
        private static Coefficients CalculateCoefficients2_LowAoA(double angleOfAttack, double correctedLiftSlope, double zeroLiftAoA, double aspectRatio, double skinFriction)
        {
            double liftCoefficient = correctedLiftSlope * (angleOfAttack - zeroLiftAoA);
            double inducedAngle = liftCoefficient / (Math.PI * aspectRatio);
            double effectiveAngle = angleOfAttack - zeroLiftAoA - inducedAngle;

            double tangentialCoefficient = skinFriction * Math.Cos(effectiveAngle);

            double normalCoefficient = (liftCoefficient + Math.Sin(effectiveAngle) * tangentialCoefficient) / Math.Cos(effectiveAngle);
            double dragCoefficient = normalCoefficient * Math.Sin(effectiveAngle) + tangentialCoefficient * Math.Cos(effectiveAngle);
            double torqueCoefficient = -normalCoefficient * TorqCoefficientProportion2(effectiveAngle);

            return new Coefficients()
            {
                lift = liftCoefficient,
                drag = dragCoefficient,
                torque = torqueCoefficient,
            };
        }
        private static Coefficients CalculateCoefficients2_Stall(double angleOfAttack, double correctedLiftSlope, double zeroLiftAoA, double stallAngleHigh, double stallAngleLow, double aspectRatio, double skinFriction, double flapAngle)
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

            double normalCoefficient = FrictionAt90Degrees2(flapAngle) * sin_effectiveAngle * (1 / (0.56 + 0.44 * Math.Abs(sin_effectiveAngle)) - 0.41 * (1 - Math.Exp(-17 / aspectRatio)));
            double tangentialCoefficient = 0.5 * skinFriction * cos_effectiveAngle;

            double liftCoefficient = normalCoefficient * cos_effectiveAngle - tangentialCoefficient * sin_effectiveAngle;
            double dragCoefficient = normalCoefficient * sin_effectiveAngle + tangentialCoefficient * cos_effectiveAngle;
            double torqueCoefficient = -normalCoefficient * TorqCoefficientProportion2(effectiveAngle);

            return new Coefficients()
            {
                lift = liftCoefficient,
                drag = dragCoefficient,
                torque = torqueCoefficient,
            };
        }

        private static double TorqCoefficientProportion2(double effectiveAngle)
        {
            return 0.25 - 0.175 * (1 - 2 * Math.Abs(effectiveAngle) / Math.PI);
        }

        private static double FrictionAt90Degrees2(double flapAngle)
        {
            //NOTE: flapAngle is actually radians
            return 1.98 - 4.26e-2 * flapAngle * flapAngle + 2.1e-1 * flapAngle;
        }

        #endregion
    }
}
