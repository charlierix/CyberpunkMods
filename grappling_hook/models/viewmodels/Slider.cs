using models.misc;

namespace models.viewmodels
{
    public class Slider : IControl
    {
        /// <summary>
        /// This isn't shown, it just needs to be a unique string
        /// </summary>
        public string invisible_name { get; init; }

        public double value { get; set; }

        public double min { get; set; }
        public double max { get; set; }

        /// <summary>
        /// If true, the value displayed will be dozenal
        /// </summary>
        public bool is_dozenal { get; set; }

        /// <summary>
        /// This only affects the displayed decimal places.  The actual value isn't rounded
        /// </summary>
        public int decimal_places { get; set; }

        // These are optional strings before and after the displayed value
        // WARNING: Be careful with potential special characters.  % should be %%
        public string prefix { get; set; }
        public string suffix { get; set; }

        /// <summary>
        /// If this is populated, it will ignore is_dozenal, decimal_places, prefix, suffix
        /// </summary>
        public Func<double, string> get_custom_text { get; init; }

        public double width { get; set; }

        // These tell where to place the hint text when the user hovers over the slider control.  The reported
        // height of this control doesn't change when the hint is showing, so the hint won't cause the position
        // to change.  So place the hint where it won't clip other controls
        public AlignmentHorizontal ctrlclickhint_horizontal { get; set; }
        public AlignmentVertical ctrlclickhint_vertical { get; set; }

        /// <summary>
        /// Tells where on the parent to place the text
        /// </summary>
        public ControlPosition position { get; init; }
        public RenderPosition render_pos { get; init; }

        public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
    }
}
