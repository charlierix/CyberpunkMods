using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.stylesheet
{
    public record CheckBox
    {
        /// <summary>
        /// Color of the text
        /// </summary>
        public string foreground_color { get; init; }

        public string background_color_standard { get; init; }
        public string background_color_hover { get; init; }
        public string background_color_click { get; init; }

        public string checkmark_color { get; init; }

        public string disabled_back_color { get; init; }
        public string disabled_fore_color { get; init; }
        public string disabled_checkmark_color { get; init; }
    }
}
