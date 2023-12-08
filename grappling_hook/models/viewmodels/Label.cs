using models.misc;
using System;

namespace models.viewmodels
{
    public class Label : IControl
    {
        public string text { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        /// <summary>
        /// If this is set, then the text will be wordwrapped if it exceeds the length
        /// </summary>
        public int? max_width { get; set; }

        /// <summary>
        /// This is a named color from the stylesheet's colors list
        /// </summary>
        public string color { get; set; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
