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

        public StackPanelItem[] items { get; set; }

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

    public class StackPanelItem
    {
        // Probably not needed
        //public double height { get; set; }

        // Probably need a draw function
    }
}