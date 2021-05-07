using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.stylesheet
{
    /// <summary>
    /// This is a custom control that has a border, a list of text inside, acts like a button
    /// </summary>
    public record SummaryButton
    {
        public double border_cornerRadius { get; init; }
        public double border_thickness { get; init; }

        public string border_color_standard { get; init; }
        public string border_color_hover { get; init; }

        public string background_color_standard { get; init; }
        public string background_color_hover { get; init; }

        /// <summary>
        /// The gap between the border and the content
        /// </summary>
        public double padding { get; init; }

        public string unused_color { get; init; }

        /// <summary>
        /// Header text
        /// </summary>
        /// <remarks>
        /// NOTE: It looks like the only way to change fontsize is to have multiple fonts, that sounds like
        /// more effort than its worth
        /// 
        /// It looks like bold is out of the question as well
        /// </remarks>
        public string header_color_prompt { get; init; }
        public string header_color_value { get; init; }
        /// <summary>
        /// This is the gap between the header and the rest of the content
        /// </summary>
        /// <remarks>
        /// If the summary button's min height is larger than calculated height, header and suffix gaps will absorb that
        /// So this is a min gap
        /// </remarks>
        public double header_gap { get; init; }

        /// <summary>
        /// Content text
        /// </summary>
        public string content_color_prompt { get; init; }
        public string content_color_value { get; init; }

        public string suffix_color { get; init; }
        /// <summary>
        /// The min gap above the suffix
        /// </summary>
        public double suffix_gap { get; init; }

        /// <summary>
        /// Minimum horizontal gap between prompt and header.  Applies to header or content
        /// </summary>
        /// <remarks>
        /// Header will always just use this gap
        /// 
        /// Content will be arranged in columns, so this is just a minimum width
        /// </remarks>
        public double prompt_value_gap { get; init; }
    }
}
