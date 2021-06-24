using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    public record ProgressBar_Slim
    {
        public double percent { get; init; }

        public double width { get; init; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }

        //TODO: All colors should be defined at the style level (for all controls), and if that same property
        //name is defined in the viewmodel, then it's an override

        // These are in named colors
        public string border_color { get; init; }
        public string background_color { get; init; }
        public string foreground_color { get; init; }
    }
}
