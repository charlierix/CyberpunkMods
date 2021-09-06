namespace models.stylesheet
{
    //NOTE: These should probably be the same values OkCancelButtons, so that everything looks the same
    public record Button
    {
        public double width { get; init; }
        public double height { get; init; }

        public double border_cornerRadius { get; init; }
        public double border_thickness { get; init; }

        public string border_color { get; init; }

        /// <summary>
        /// Color of the text
        /// </summary>
        public string foreground_color { get; init; }

        // Background colors
        public string back_color_standard { get; init; }
        public string back_color_hover { get; init; }
        public string back_color_click { get; init; }
    }
}
