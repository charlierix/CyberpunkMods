using models.misc;

namespace models.viewmodels
{
    public class RemoveButton : IControl
    {
        //TODO: May want a tooltip

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        /// <summary>
        /// Name given to the invisible button (needs to be unique)
        /// </summary>
        public string invisible_name { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
