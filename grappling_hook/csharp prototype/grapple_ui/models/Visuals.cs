using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace models
{
    public record Visuals
    {
        // --------- grapple line ---------
        public Visuals_GrappleLine_Type grappleline_type { get; init; }

        // Hex code: RGB, RRGGBB, ARGB, AARRGGBB
        public string grappleline_color_primary { get; init; }

        // --------- anchor point ---------
        public bool show_anchorpoint { get; init; }

        //TODO: anchorpoint type

        public string anchorpoint_color_primary { get; init; }

        // --------- stop plane ---------
        public bool show_stopplane { get; init; }

        public string stopplane_color { get; init; }
    }

    public enum Visuals_GrappleLine_Type
    {
        SolidLine,
    }
}
