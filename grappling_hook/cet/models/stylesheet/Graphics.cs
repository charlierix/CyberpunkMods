﻿using System;
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

        // These are the triangle portion of an arrow head ----->
        public double arrow_length { get; init; }
        public double arrow_width { get; init; }

        public string stickfigure_color_standard { get; init; }
        public string stickfigure_color_gray { get; init; }

        public string arrow_color_standard { get; init; }
        public string arrow_color_gray { get; init; }
        public string arrow_color_highlight { get; init; }
    }
}