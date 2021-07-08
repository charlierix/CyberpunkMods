using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.stylesheet
{
    public record ListBox
    {
        /// <summary>
        /// The gap between the border and the content
        /// </summary>
        public double padding { get; init; }

        public double border_cornerRadius { get; init; }
        public double border_thickness { get; init; }

        public string border_color { get; init; }

        public string background_color_standard { get; init; }

        // These are for the selected item
        public string background_color_selected { get; init; }

        public string background_color_hover { get; init; }
        public string background_color_click { get; init; }

        /// <summary>
        /// Color of the text
        /// </summary>
        public string foreground_color { get; init; }

        /// <summary>
        /// NOTE: The scrollbar's background color is applied over top of the listbox's background color.  So an opacity of
        /// zero would make this background the same as the listbox's
        /// </summary>
        /// <remarks>
        /// I didn't test the other scrollbar colors to see if they overwrite or lay over this background
        /// </remarks>
        public string scrollbar_color_background { get; init; }
        public string scrollbar_color_grab_standard { get; init; }
        public string scrollbar_color_grab_hover { get; init; }
        public string scrollbar_color_grab_click { get; init; }
    }
}
