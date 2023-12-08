using models.misc;

namespace models.viewmodels
{
    /// <summary>
    /// This gets handed to a method that builds a control that looks like some text surrounded by
    /// a border, it behaves like a button
    /// </summary>
    /// <remarks>
    /// This will get mostly filled out with static data during init, then a few values get update
    /// each frame
    /// </remarks>
    public class SummaryButton : IControl
    {
        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        // This defines the min size of the inner portion.  It doesn't include the border's padding around the inner portion
        public int? min_width { get; set; }
        public int? min_height { get; set; }

        public double? border_cornerRadius_override { get; set; }

        // ************************* Use either this *************************

        // A gray text, horizontally and vertically centered
        public string unused_text { get; set; }

        // **************************** Or these *****************************

        // Horizontally centered along the top, needs a strong color
        public string header_prompt { get; set; }
        public string header_value { get; set; }

        // Info text, each is accessed by a key (the key isn't displayed, but the content is displayed based on alphabetical order of the keys)
        // It's actually dictionary content and sortedlist content_keys
        public SortedDictionary<string, SummaryButton_Content> content { get; set; }

        // *******************************************************************

        // Small bit of text in the bottom right corner
        public string suffix { get; set; }

        /// <summary>
        /// Name given to the invisible button (needs to be unique)
        /// </summary>
        public string invisible_name { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }

    public class SummaryButton_Content
    {
        public string prompt { get; set; }
        public string value { get; set; }
    }
}
