using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.stylesheet
{
    public record RemoveButton
    {
        /// <summary>
        /// The radius of the circle around the X
        /// </summary>
        public double radius { get; init; }

        public double border_thickness { get; init; }
        public double x_thickness { get; init; }

        //NOTE: There's no point in defining a clicked color.  The invisible button only reports click for one frame (not on mouse down)

        // Color of the X
        public string foreground_color_standard { get; init; }
        public string foreground_color_hover { get; init; }

        public string border_color_standard { get; init; }
        public string border_color_hover { get; init; }

        public string back_color_standard { get; init; }
        public string back_color_hover { get; init; }
    }
}
