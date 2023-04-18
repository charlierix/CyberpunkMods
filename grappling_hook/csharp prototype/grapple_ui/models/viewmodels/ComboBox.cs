using models.misc;
using System;

namespace models.viewmodels
{
    public class ComboBox
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        public string preview_text { get; set; }
        public string selected_item { get; set; }

        public string[] items { get; set; }

        // Only populate one of these
        public double? min_width { get; set; }
        public double? width { get; set; }

        // Only looked at if min_width is used
        public double? max_width { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
