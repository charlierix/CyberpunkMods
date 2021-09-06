using models.misc;
using System;

namespace models.viewmodels
{
    public record OkCancelButtons : IControl
    {
        /// <summary>
        /// Controls the text of the single button (only used when not isDirty)
        /// True: Close
        /// False: Back
        /// </summary>
        public bool isMainPage { get; init; }
        /// <summary>
        /// True: There will be two buttons: OK, Cancel
        /// False: There will be one button: Close or Back
        /// </summary>
        public bool isDirty { get; init; }

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
