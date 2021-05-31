using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.stylesheet
{
    public record MinDotGraphic
    {
        //NOTE: Line thickness, arrow size come from the graphics style

        /// <summary>
        /// Color of the line that represents straight up
        /// </summary>
        public string up_color { get; init; }
        /// <summary>
        /// Color of the line that is zero degrees (perpendicular to the up line)
        /// </summary>
        public string zero_color { get; init; }

        /// <summary>
        /// The line that is the current break angle
        /// </summary>
        public string angle_color { get; init; }
    }
}
