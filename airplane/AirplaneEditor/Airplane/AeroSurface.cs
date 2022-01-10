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
    public class AeroSurface
    {
        #region Declaration Section

        private readonly AeroSurfaceConfig _config;

        private readonly Point3D _position_local;

        //TODO: These should be call rotate tranform.  C# only does rotations when passing vector, but lua doesn't know the difference between vector and point
        private readonly Transform3D _transform_toworld;
        private readonly Transform3D _transform_tolocal;

        private readonly Vector3D _forward = new Vector3D(0, 1, 0);

        private float _flapAngle = 0;

        #endregion

        #region Constructor

        public AeroSurface(AeroSurfaceConfig config, Point3D position_local, Transform3D transform_toworld, Transform3D transform_tolocal)
        {
            _config = AeroSurfaceConfig.Validate(config);
            _position_local = position_local;
            _transform_toworld = transform_toworld;
            _transform_tolocal = transform_tolocal;
        }

        #endregion

        public Point3D Position_world => _transform_toworld.Transform(_position_local);

        public void SetFlapAngle(float angle)
        {
            _flapAngle = Math.Clamp(angle, -50, 50);
        }

        public BiVector3 CalculateForces(Vector3D worldAirVelocity, double airDensity, Vector3D relativePosition_world)
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
    }
}
