using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Airplane
{
    public class RigidBody
    {
        public double Mass { get; set; }

        public Point3D WorldCenterOfMass { get; set; }

        public Vector3D Velocity { get; set; }
        public Vector3D AngularVelocity { get; set; }

        public Quaternion Roation { get; set; }

        //https://answers.unity.com/questions/1484654/how-to-calculate-inertia-tensor-and-tensor-rotatio.html
        public Vector3D InertiaTensor { get; set; }

        public Quaternion InertiaTensorRotation { get; set; }

        public void AddForce(Vector3D force)
        {

        }

        public void AddTorque(Vector3D torque)
        {

        }
    }
}
