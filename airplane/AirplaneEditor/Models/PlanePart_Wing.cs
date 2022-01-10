using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Models
{
    /// <summary>
    /// This class holds all the information about a wing needed to fly
    /// </summary>
    public record PlanePart_Wing
    {
        public int ID { get; init; }
        public int? ParentID { get; init; }


        //NOTE: These are in rigid body's coords.  (the view model stores a link to parent and pos/rot are relative to the parent)
        public Point3D Position { get; init; }
        public Quaternion Orientation { get; init; }
    }
}
