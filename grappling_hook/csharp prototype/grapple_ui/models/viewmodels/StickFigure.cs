using models.misc;
using System;

namespace models.viewmodels
{
    public record StickFigure : IControl
    {
        /// <summary>
        /// True: Use the standard color
        /// False: Use the gray color
        /// </summary>
        public bool isStandardColor { get; init; }

        /// <summary>
        /// Set to true when they hover over options that will modify these lines
        /// </summary>
        public bool isHighlight { get; init; }

        public double width { get; init; }
        public double height { get; init; }

        /// <summary>
        /// Tells where on the parent to place the graphic
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
