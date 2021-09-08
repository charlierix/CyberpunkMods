using models.misc;
using System;

namespace models.viewmodels
{
    /// <summary>
    /// This is like an html table with columns and rows
    /// </summary>
    /// <remarks>
    /// This first draft isn't meant to be scrollable.  Maybe if it was placed in a parent that is scrollable, but
    /// efficiency of drawing lots of members isn't considered
    /// 
    /// Each column has an alignment (left,center,right).  Vertical alignment is always center
    /// </remarks>
    public record GridView : IControl
    {
        public GridView_Header[] headers { get; init; }

        /// <summary>
        /// This is all the cells
        /// cells[row][col]
        /// </summary>
        public GridView_Cell[][] cells { get; init; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }

    public record GridView_Header
    {
        public string text { get; init; }

        public double? min_width { get; init; }
        public double? max_width { get; init; }

        //NOTE: This is only for the cells.  The header's text is always centered
        public AlignmentHorizontal horizontal { get; init; }
    }
    public record GridView_Cell
    {
        public string text { get; init; }

        /// <summary>
        /// Optional named color (in stylesheet.colors)
        /// </summary>
        public string foreground_override { get; init; }
    }
}
