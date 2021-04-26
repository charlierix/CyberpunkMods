using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    /// <summary>
    /// These are properties used by the UI
    /// </summary>
    /// <remarks>
    /// At runtime, all the color settings will be stored in both hex and r,g,b,a.  But the json
    /// will only have the hex version.  RGBA will be calculated as a post process of deserialization
    /// 
    /// Pattern is:
    /// ColorName = "hex value"
    /// ColorName_R = 0 to 1
    /// ColorName_G
    /// ColorName_B
    /// ColorName_A
    /// 
    /// NOTE: All color properties must have _color[^a-z0-9] in the name
    /// 
    /// NOTE: There is currently no mouse down color defined.  When CET allows ImGui to reliably report it, then add it at that time
    /// </remarks>
    public record Stylesheet
    {
        // ------------------ SummaryButton ------------------
        // This is a custom control that has a border, a list of text inside, acts like a button
        public double summaryButton_border_cornerRadius { get; init; }
        public double summaryButton_border_thickness { get; init; }

        public string summaryButton_border_color_standard { get; init; }
        public string summaryButton_border_color_hover { get; init; }

        public string summaryButton_background_color_standard { get; init; }
        public string summaryButton_background_color_hover { get; init; }

        /// <summary>
        /// The gap between the border and the content
        /// </summary>
        public double summaryButton_padding { get; init; }

        /// <summary>
        /// Header text
        /// </summary>
        /// <remarks>
        /// NOTE: It looks like the only way to change fontsize is to have multiple fonts, that sounds like
        /// more effort than its worth
        /// 
        /// It looks like bold is out of the question as well
        /// </remarks>
        public string summaryButton_header_color { get; init; }
        /// <summary>
        /// This is the gap between the header and the rest of the content
        /// </summary>
        public double summaryButton_header_gap { get; init; }

        /// <summary>
        /// Content text
        /// </summary>
        public string summaryButton_content_color_prompt { get; init; }
        public string summaryButton_content_color_value { get; init; }








    }
}
