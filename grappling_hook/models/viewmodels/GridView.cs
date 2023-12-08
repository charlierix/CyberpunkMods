using models.misc;

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
    public class GridView : IControl
    {
        public GridView_Header[] headers { get; set; }

        /// <summary>
        /// This is all the cells
        /// cells[row][col]
        /// </summary>
        public GridView_Cell[][] cells { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }

    public class GridView_Header
    {
        public string text { get; set; }

        public double? min_width { get; set; }
        public double? max_width { get; set; }

        //NOTE: This is only for the cells.  The header's text is always centered
        public AlignmentHorizontal horizontal { get; set; }
    }
    public class GridView_Cell
    {
        public string text { get; set; }

        /// <summary>
        /// Optional named color (in stylesheet.colors)
        /// </summary>
        public string foreground_override { get; set; }
    }
}
