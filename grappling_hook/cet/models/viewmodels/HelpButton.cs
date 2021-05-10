using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    /// <summary>
    /// This is a ? with a circle around it.  Used to show extra information, probably just while the
    /// mouse is hovering over the button
    /// </summary>
    public record HelpButton
    {
        //TODO: May want some kind of tooltip property, but that will probably be fixed text known by the caller

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
    }
}
