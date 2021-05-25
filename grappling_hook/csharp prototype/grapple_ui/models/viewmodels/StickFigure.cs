using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    public record StickFigure
    {
        /// <summary>
        /// True: Use the standard color
        /// False: Use the gray color
        /// </summary>
        public bool isStandardColor { get; init; }

        /// <summary>
        /// Set to true when they hover over options that will modify these lines
        /// </summary>
        public bool isHighlight { get; init; }

        public double width { get; init; }
        public double height { get; init; }

        /// <summary>
        /// Tells where on the parent to place the graphic
        /// </summary>
        public ControlPosition position { get; init; }
    }
}
