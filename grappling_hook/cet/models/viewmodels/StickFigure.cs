using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    public record StickFigure
    {
        public double width { get; init; }
        public double height { get; init; }

        /// <summary>
        /// Tells where on the parent to place the graphic
        /// </summary>
        public ControlPosition position { get; init; }
    }
}
