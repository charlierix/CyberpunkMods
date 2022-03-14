using grapple_ui.models.misc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    /// <summary>
    /// This is a multiline wordwrapped label that is made to look like a textbox
    /// </summary>
    /// <remarks>
    /// ImGui.InputTextMultiline (multiline textbox) doesn't support word wrap, so this label is a compromise
    /// 
    /// It uses the style of the textbox, but is a label.  Then when the user clicks on it, a much larger textbox
    /// can be shown that isn't word wrapped.  The user can type and commit, then go back to showing this control
    /// 
    /// Not the best design, but good enough
    /// </remarks>
    public record LabelClickable : IControl
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        public string text { get; init; }

        public double max_width { get; init; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        /// <summary>
        /// Optional named color (in stylesheet.colors)
        /// </summary>
        public string foreground_override { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
