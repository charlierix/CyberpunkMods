using models.misc;
using System;

namespace models.viewmodels
{
    public record MinDotGraphic : IControl
    {
        public double radians { get; init; }

        /// <summary>
        /// Width is radius
        /// Height is radius * 2
        /// </summary>
        public double radius { get; init; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
