namespace models.stylesheet
{
    public record MultiItemDisplayList
    {
        public double padding { get; init; }

        public double border_cornerRadius { get; init; }
        public double border_thickness { get; init; }

        public string border_color { get; init; }

        // This is the line betweeen sets
        /// <summary>
        /// The vertical space between text and line
        /// NOTE: The final gap will be double this (gap above, gap below)
        /// </summary>
        public double separator_gap_vert { get; init; }
        /// <summary>
        /// The distance between the left and the start of the line (the same gap is applied
        /// to the right as well)
        /// </summary>
        public double separator_gap_horz { get; init; }

        public double separator_thickness { get; init; }

        public string separator_color { get; init; }

        /// <summary>
        /// Color of the text
        /// </summary>
        public string foreground_color { get; init; }

        public string background_color { get; init; }
    }
}
