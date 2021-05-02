using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    /// <summary>
    /// This gets handed to a method that builds a control that looks like some text surrounded by
    /// a border, it behaves like a button
    /// </summary>
    /// <remarks>
    /// This will get mostly filled out with static data during init, then a few values get update
    /// each frame
    /// </remarks>
    public record SummaryButton
    {
        // These are in window coords (coords relative to the parent window)
        public int center_x { get; init; }
        public int center_y { get; init; }

        // This defines the min size of the inner portion.  It doesn't include the border's padding around the inner portion
        public int? min_width { get; init; }
        public int? min_height { get; init; }

        // ************************* Use either this *************************

        // A gray text, horizontally and vertically centered
        public string unused_text { get; set; }

        // **************************** Or these *****************************

        // Horizontally centered along the top, needs a strong color
        public string header_prompt { get; init; }
        public string header_value { get; init; }

        // Info text, each is accessed by a key (the key isn't displayed)
        public SortedDictionary<string, SummaryButton_Content> content { get; init; }

        // *******************************************************************

        // Small bit of text in the bottom right corner
        public string suffix { get; init; }
    }

    public record SummaryButton_Content
    {
        public string prompt { get; init; }
        public string value { get; init; }
    }
}
