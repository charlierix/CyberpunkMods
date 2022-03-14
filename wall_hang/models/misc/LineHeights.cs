using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.misc
{
    public record LineHeights
    {
        /// <summary>
        /// The height of a line
        /// </summary>
        public double line { get; init; }

        /// <summary>
        /// When there is more than one line, this is the distance between lines
        /// </summary>
        public double gap { get; init; }
    }
}
