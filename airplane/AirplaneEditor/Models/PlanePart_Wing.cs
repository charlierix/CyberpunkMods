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
        //NOTE: These are in rigid body's coords.  (the view model stores a link to parent and pos/rot are relative to the parent)
        public Point3D Position { get; init; }
        public Quaternion Orientation { get; init; }

        public double chord { get; init; } = 1;
        public double span { get; init; } = 1;

        public double liftSlope { get; init; } = 6.28;
        public double skinFriction { get; init; } = 0.02;
        public double zeroLiftAoA { get; init; } = 0;

        public double stallAngleHigh { get; init; } = 15;
        public double stallAngleLow { get; init; } = -15;

        public double flapFraction { get; init; } = 0;

        //TODO: AeroSurfaceConfig and PlanePart_Wing are nearly identical.  c# will keep them separate so it's closer to the
        //original code, but the lua version should probably just have one class
        public AirplaneEditor.Airplane.AeroSurfaceConfig ToAeroConfig()
        {
            return new AirplaneEditor.Airplane.AeroSurfaceConfig()
            {
                liftSlope = liftSlope,
                skinFriction = skinFriction,
                zeroLiftAoA = zeroLiftAoA,
                stallAngleHigh = stallAngleHigh,
                stallAngleLow = stallAngleLow,
                chord = chord,
                flapFraction = flapFraction,
                span = span,
            };
        }
    }
}
