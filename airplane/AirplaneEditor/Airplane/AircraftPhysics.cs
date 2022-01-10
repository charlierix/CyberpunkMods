using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Airplane
{
    public class AircraftPhysics
    {
        #region Declaration Section

        //TODO: The original just had a thrust property.  This version should have a list of engines

        private readonly Vector3D _gravity = new Vector3D(0, 0, -AppSettings.Gravity);
        private readonly Vector3D _forward = new Vector3D(0, 1, 0);

        private readonly RigidBody _rb;
        private readonly AeroSurface[] _aerodynamicSurfaces;

        //private readonly Transform3D _transform_toworld;      // just use rigid body's
        //private readonly Transform3D _transform_tolocal;

        #endregion

        public AircraftPhysics(RigidBody rb, AeroSurface[] aerodynamicSurfaces)
        {
            _rb = rb;
            _aerodynamicSurfaces = aerodynamicSurfaces;
        }

        public Vector3D Wind { get; set; }
        public double AirDensity { get; set; } = 1.2;

        public void Tick()
        {
            Vector3D forward_world = _rb.Transform_ToWorld.Transform(_forward);      //TODO: Make sure transform only does rotation

            BiVector3 forceAndTorqueThisFrame = CalculateAerodynamicForces(_rb.Velocity, _rb.AngularVelocity, Wind, AirDensity, _rb.CenterOfMass_world, _aerodynamicSurfaces);


            //TODO: This looks like it would be useful, but this class has multiple sources of thrust (not just forward * scalar).  So the
            //prediction calculation would be a bit more involved
            //// This prediction is an attempt to smooth across frames (avoid instability when it's a low framerate).  See:
            //// https://youtu.be/p3jDJ9FtTyM?t=520
            //Vector3D velocityPrediction = PredictVelocity(forceAndTorqueThisFrame.p + /* forward_world * thrust * thrustPercent + */ _gravity * _rb.Mass);
            //Vector3D angularVelocityPrediction = PredictAngularVelocity(forceAndTorqueThisFrame.q);

            //BiVector3 forceAndTorquePrediction = CalculateAerodynamicForces(velocityPrediction, angularVelocityPrediction, Wind, AirDensity, _rb.CenterOfMass_world);


            //BiVector3 currentForceAndTorque = (forceAndTorqueThisFrame + forceAndTorquePrediction) * 0.5;
            BiVector3 currentForceAndTorque = forceAndTorqueThisFrame;


            _rb.AddForce(currentForceAndTorque.p);
            _rb.AddTorque(currentForceAndTorque.q);

            //_rb.AddForce(forward_world * thrust * thrustPercent);     // thrust is part of what was returned by CalculateAerodynamicForces
        }

        private static BiVector3 CalculateAerodynamicForces(Vector3D velocity, Vector3D angularVelocity, Vector3D wind, double airDensity, Point3D centerOfMass_world, AeroSurface[] aerodynamicSurfaces)
        {
            BiVector3 forceAndTorque = new BiVector3();

            foreach (var surface in aerodynamicSurfaces)
            {
                Vector3D relativePosition_world = surface.Position_world - centerOfMass_world;
                forceAndTorque += surface.CalculateForces(-velocity + wind - Vector3D.CrossProduct(angularVelocity, relativePosition_world), airDensity, relativePosition_world);
            }

            //TODO: Implement thrusters (prop based thrusters would be affected by air density, but rocket thrusters wouldn't care)
            //foreach(var thruster in thrusters)
            //{
            //}

            return forceAndTorque;
        }
    }
}
