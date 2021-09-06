using models.misc;
using System;

namespace models.viewmodels
{
    /// <summary>
    /// This is a ? with a circle around it.  Used to show extra information, probably just while the
    /// mouse is hovering over the button
    /// </summary>
    public record HelpButton : IControl
    {
        /// <summary>
        /// This is an optional property.  If set, then a tooltip will show while the mouse is over
        /// this control
        /// </summary>
        /// <remarks>
        /// Draw_HelpButton returns whether the button is clicked and hovered, so the caller can do
        /// more elaborate things if they don't want to use this built in tooltip functionality
        /// </remarks>
        public string tooltip { get; init; }

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
