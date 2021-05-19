using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.stylesheet
{
    public record Slider
    {
        public double border_cornerRadius { get; init; }
        public double border_thickness { get; init; }

        public string border_color { get; init; }

        /// <summary>
        /// Color of the text
        /// </summary>
        public string foreground_color { get; init; }

        public string highlight_text_background_color { get; init; }

        public string background_color_standard { get; init; }
        public string background_color_hover { get; init; }
        public string background_color_click { get; init; }

        public string grab_color_standard { get; init; }
        public string grab_color_click { get; init; }
    }
}
