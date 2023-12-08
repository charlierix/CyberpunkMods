namespace models.stylesheet
{
    public record GridView
    {
        public string foreground_color_header { get; init; }
        public string foreground_color_cell { get; init; }

        // Gaps between cells
        public double gap_horizontal { get; init; }
        public double gap_vertical { get; init; }

        // If a row contains no text, then this doesn't count (also the gap isn't applied, or there
        // would be extra gaps.  This is also applied to the header
        public double? min_row_height { get; init; }
    }
}
