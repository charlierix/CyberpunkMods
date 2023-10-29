using models.misc;
using System;

namespace models.viewmodels
{
    public class CheckBox : IControl
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        public bool isChecked { get; set; }

        /// <summary>
        /// True: It will be clickable and use the standard set of colors
        /// False: Not clickable, uses disabled colors
        /// </summary>
        public bool isEnabled { get; set; }

        public string text { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        /// <summary>
        /// Optional named color (in stylesheet.colors)
        /// </summary>
        public string foreground_override { get; set; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
