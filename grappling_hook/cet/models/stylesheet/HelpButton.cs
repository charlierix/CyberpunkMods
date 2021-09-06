namespace models.stylesheet
{
    public record HelpButton
    {
        /// <summary>
        /// The radius of the circle around the ?
        /// </summary>
        public double radius { get; init; }

        public double border_thickness { get; init; }

        /// <summary>
        /// Color of the ?
        /// </summary>
        public string foreground_color_standard { get; init; }
        public string foreground_color_hover { get; init; }

        public string border_color_standard { get; init; }
        public string border_color_hover { get; init; }

        public string back_color_standard { get; init; }
        public string back_color_hover { get; init; }
    }
}
