using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.stylesheet
{
    /// <summary>
    /// Storing information about various graphical elements here so they are together
    /// </summary>
    public record Graphics
    {
        public double line_thickness_main { get; init; }

        public string stickfigure_color { get; init; }
    }
}
