using models.misc;

namespace models.viewmodels
{
    public class TextBox : IControl
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        public string text { get; set; }

        public int maxChars { get; set; }

        public bool isMultiLine { get; set; }

        // Only populate one of these
        public double? min_width { get; set; }
        public double? width { get; set; }

        // Only looked at if min_width is used
        public double? max_width { get; set; }

        /// <summary>
        /// Height is only used if multi line
        /// </summary>
        public double? height { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        /// <summary>
        /// Optional named color (in stylesheet.colors)
        /// </summary>
        public string foreground_override { get; set; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
