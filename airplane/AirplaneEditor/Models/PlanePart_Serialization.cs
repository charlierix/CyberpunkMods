using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Models
{
    /// <summary>
    /// This class is meant to hold enough information to be able to serialize/deserialize
    /// </summary>
    /// <remarks>
    /// The lua code needs to be as simple and streamlined as possible.  So all the config and logic needed
    /// to convert high level concepts like fuselage, high lift/low lift wings, mirroring parts to port side,
    /// etc, are done in c#
    /// 
    /// So PlanePart_Wing, PlanePart_Thrust are only enough information for lua to fly the plane
    /// </remarks>
    public record PlanePart_Serialization
    {
        public int ID { get; init; }
        public int? ParentID { get; init; }

        public PlanePartType PartType { get; init; }

        public bool IsCenterline { get; init; }

        public string Name { get; init; }

        //NOTE: These are relative to parent
        public Point3D Position { get; init; }
        public Quaternion Orientation { get; init; }

        public double[] Sizes { get; init; }
    }
}
