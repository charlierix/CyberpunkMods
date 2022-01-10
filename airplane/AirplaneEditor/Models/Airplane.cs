using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Models
{
    public record Airplane
    {
        public string Name { get; init; }

        public double Mass { get; init; }

        public Point3D CenterOfMass { get; init; }

        public Vector3D InertiaTensor { get; init; }
        public Quaternion InertiaTensorRotation { get; init; }

        public PlanePart_Serialization[] Parts_Serialize { get; init; }

        public PlanePart_Wing[] Wings { get; init; }
        public PlanePart_Thrust[] Thrusters { get; init; }
    }
}
