using models.misc;
using System;

namespace models.viewmodels
{
    public record TextBox : IControl
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        public string text { get; init; }

        public int maxChars { get; init; }

        public bool isMultiLine { get; init; }

        // Only populate one of these
        public double? min_width { get; init; }
        public double? width { get; init; }

        // Only looked at if min_width is used
        public double? max_width { get; init; }

        /// <summary>
        /// Height is only used if multi line
        /// </summary>
        public double? height { get; init; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        /// <summary>
        /// Optional named color (in stylesheet.colors)
        /// </summary>
        public string foreground_override { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
