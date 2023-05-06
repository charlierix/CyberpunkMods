using models.misc;
using System;

namespace models.viewmodels
{
    public class ProgressBar_Slim : IControl
    {
        public double percent { get; set; }

        public double width { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        //TODO: All colors should be defined at the style level (for all controls), and if that same property
        //name is defined in the viewmodel, then it's an override

        // These are in named colors
        public string border_color { get; set; }
        public string background_color { get; set; }
        public string foreground_color { get; set; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
