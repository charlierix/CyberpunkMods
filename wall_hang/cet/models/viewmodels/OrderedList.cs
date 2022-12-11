using grapple_ui.models.misc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    /// <summary>
    /// This will lay out the prompts and values in columns
    /// </summary>
    public record OrderedList : IControl
    {
        /// <summary>
        /// Same concept as what is in summary button
        /// NOTE: Needs to be named content so the post process will create a content_keys property
        /// </summary>
        public SortedDictionary<string, OrderedList_Content> content { get; init; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        // Named colors from the stylesheet's colors list
        public string color_prompt { get; init; }
        public string color_value { get; init; }

        // Min gap between prompt and value columns
        public double gap { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }

    public record OrderedList_Content
    {
        public string prompt { get; init; }
        public string value { get; init; }
    }
}
