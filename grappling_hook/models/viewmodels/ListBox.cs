using models.misc;

namespace models.viewmodels
{
    /// <summary>
    /// This is a list of items, one of them can be selected
    /// </summary>
    public class ListBox : IControl
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        public string[] items { get; set; }

        /// <summary>
        /// Optional array, same size as items.  If present, this will determine which items can be selected
        /// </summary>
        public bool[] selectable { get; set; }

        /// <summary>
        /// Use zero for nothing selected
        /// </summary>
        public int selected_index { get; set; }

        public double width { get; set; }

        //NOTE: height isn't exact, it's a multiple of a line's height
        public double height { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
