using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.viewmodels
{
    public record MultiItemDisplayList
    {
        /// <summary>
        /// The outer sets list is sorted by key
        /// Each set is then a list of strings (that will be sorted when displaying)
        /// </summary>
        public SortedDictionary<string, List<string>> sets { get; init; }

        public double width { get; init; }
        public double height { get; init; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }

        // These are populated by MultiItemDisplayList_SetsChanged()
        /// <summary>
        /// Index of the outer list
        /// </summary>
        private string[] sets_keys { get; init; }
        /// <summary>
        /// Index of each inner set (dict's key is the set)
        /// </summary>
        private Dictionary<string, string[]> items_sorted { get; set; }
    }
}
