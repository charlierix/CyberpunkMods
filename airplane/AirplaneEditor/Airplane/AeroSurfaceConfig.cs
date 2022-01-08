using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AirplaneEditor.Airplane
{
    public record AeroSurfaceConfig
    {
        public double liftSlope { get; init; } = 6.28;
        public double skinFriction { get; init; } = 0.02;
        public double zeroLiftAoA { get; init; } = 0;
        public double stallAngleHigh { get; init; } = 15;
        public double stallAngleLow { get; init; } = -15;
        public double chord { get; init; } = 1;
        public double flapFraction { get; init; } = 0;
        public double span { get; init; } = 1;

        public bool autoAspectRatio { get; init; } = true;
        public double aspectRatio { get; init; } = 2;

        public static AeroSurfaceConfig Validate(AeroSurfaceConfig config)
        {
            return config with
            {
                flapFraction = Math.Clamp(config.flapFraction, 0, 0.4),

                stallAngleHigh = Math.Max(config.stallAngleHigh, 0),

                stallAngleLow = Math.Min(config.stallAngleLow, 0),

                chord = Math.Max(config.chord, 0.001),

                aspectRatio = config.autoAspectRatio ?
                    config.span / config.chord :
                    config.aspectRatio,
            };
        }
    }
}
