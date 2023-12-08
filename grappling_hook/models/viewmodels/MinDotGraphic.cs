using models.misc;

namespace models.viewmodels
{
    public class MinDotGraphic : IControl
    {
        public double radians { get; set; }

        /// <summary>
        /// Width is radius
        /// Height is radius * 2
        /// </summary>
        public double radius { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
