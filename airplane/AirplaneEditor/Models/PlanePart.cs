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
        public int ID { get; init; }
        public int? ParentID { get; init; }

        public Location Location { get; init; }

        public PlanePartType PartType { get; init; }

        public string Name { get; init; }

        //NOTE: These are in rigid body's coords.  (the view model stores a link to parent and pos/rot are relative to the parent)
        public Point3D Position { get; init; }
        public Quaternion Orientation { get; init; }
    }
}
