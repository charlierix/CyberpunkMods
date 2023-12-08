using models.misc;

namespace models.viewmodels
{
    public class Button : IControl
    {
        public string text { get; set; }

        public bool isEnabled { get; set; }

        public double? width_override { get; set; }

        /// <summary>
        /// Tells where on the parent to place the buttons
        /// </summary>
        /// <remarks>
        /// The buttons are layed out horizontally, should be aligned to bottom/right of window
        /// 
        /// The xy are are stored in the stylesheet, and should be copied from there so all buttons are
        /// in the same position for any page
        /// </remarks>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
