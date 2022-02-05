using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Models
{
    public record PlanePart_Thrust
    {
        public string Name { get; init; }

        //NOTE: These are in rigid body's coords.  (the view model stores a link to parent and pos/rot are relative to the parent)
        public Point3D Position { get; init; }
        public Vector3D Direction { get; init; }
    }
}
