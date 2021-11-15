using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Models
{
    public record PlanePart
    {
        public PlanePartType PartType { get; init; }

        /// <summary>
        /// Only valid if this is a fuselage and the root part
        /// </summary>
        public bool IsCenterline { get; set; }

        public Point3D Position { get; set; }
        public Quaternion Orientation { get; set; }

        public PlanePart Parent { get; init; }
        public List<PlanePart> Children { get; } = new List<PlanePart>();
    }
}
