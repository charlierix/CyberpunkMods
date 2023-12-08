using models.misc;

namespace models.viewmodels
{
    public class MultiItemDisplayList : IControl
    {
        /// <summary>
        /// The outer sets list is sorted by key
        /// Each set is then a list of strings (that will be sorted when displaying)
        /// </summary>
        public SortedDictionary<string, List<string>> sets { get; set; }

        public double width { get; set; }
        public double height { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        // These are populated by MultiItemDisplayList_SetsChanged()
        /// <summary>
        /// Index of the outer list
        /// </summary>
        private string[] sets_keys { get; set; }
        /// <summary>
        /// Index of each inner set (dict's key is the set)
        /// </summary>
        private Dictionary<string, string[]> items_sorted { get; set; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
