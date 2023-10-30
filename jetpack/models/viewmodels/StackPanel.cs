namespace models.viewmodels
{
    /// <summary>
    /// This is a listbox shell (with scrollbar) containing scroll item controls
    /// </summary>
    /// <remarks>
    /// NOTE: This is currently hardcoded to having vertical scrollbar only
    ///
    /// It looks like imgui only supports Selectable() which takes string.  So I don't think the controls
    /// that this stackpanel contains will be selectable
    ///
    /// The effect could probably be manually emulated if necessary
    /// </remarks>
    public class StackPanel : IControl
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        public IStackPanelItem[] items { get; set; }

        public double width { get; set; }

        //NOTE: height isn't exact, it's a multiple of a line's height
        public double height { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }

    /// <summary>
    /// This is a class that acts like a user control, will be shown inside the listbox (using the listbox as
    /// a scrollable container)
    /// </summary>
    public interface IStackPanelItem
    {
        /// <summary>
        /// NOTE: This calls the draw method using colon (item:Draw instead of item.Draw)
        /// </summary>
        /// <param name="screenOffset_x">Used by graphics calls</param>
        /// <param name="screenOffset_y"></param>
        /// <param name="x">Used by SetCursorPos</param>
        /// <param name="y"></param>
        /// <param name="width">The width of the box that can be drawn in</param>
        /// <param name="scale">Sort of a dpi scaling.  Needs to be multiplied by defined sizes</param>
        /// <returns>The height of the box that was drawn in</returns>
        double Draw(screenOffset_x, screenOffset_y, x, y, width, scale)
    }
}