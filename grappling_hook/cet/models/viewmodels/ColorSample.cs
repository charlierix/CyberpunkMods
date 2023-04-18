using models.misc;
using System;

namespace models.viewmodels
{
    public class ColorSample
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        /// <summary>
        /// This is the color that shows over top of the checkerboard (the checkerboard will be visible if the color
        /// defines an alpha
        /// </summary>
        /// <remarks>
        /// The color props that other controls are defined in the spreadsheet json as hex, but get converted to int at
        /// runtime as an optimization.  But the whole point of this control is to set a color that changes dynamically,
        /// so this is the hex string
        /// </remarks>
        public string color_hex { get; set; }

        public double? width_override { get; set; }
        public double? height_override { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
