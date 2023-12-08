using models.misc;

namespace models.viewmodels
{
    public class StickFigure : IControl
    {
        /// <summary>
        /// True: Use the standard color
        /// False: Use the gray color
        /// </summary>
        public bool isStandardColor { get; set; }

        /// <summary>
        /// Set to true when they hover over options that will modify these lines
        /// </summary>
        public bool isHighlight { get; set; }

        public double width { get; set; }
        public double height { get; set; }

        /// <summary>
        /// Tells where on the parent to place the graphic
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
