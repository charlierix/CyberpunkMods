namespace models.stylesheet
{
    public record UpDownButtons
    {
        // Internal spacing between text and edge of button
        public double padding_horizontal { get; init; }
        public double padding_vertical { get; init; }

        /// <summary>
        /// Gap between buttons (horizontal or vertical)
        /// </summary>
        public double gap { get; init; }

        public double border_cornerRadius { get; init; }
        public double border_thickness { get; init; }

        public string border_color { get; init; }

        /// <summary>
        /// Color of the text
        /// </summary>
        public string foreground_color { get; init; }

        // Background colors
        public string down_color_standard { get; init; }
        public string down_color_hover { get; init; }
        public string down_color_click { get; init; }

        public string up_color_standard { get; init; }
        public string up_color_hover { get; init; }
        public string up_color_click { get; init; }

        public string free_color_standard { get; init; }
        public string free_color_hover { get; init; }
        public string free_color_click { get; init; }

        public string disabled_back_color { get; init; }
        public string disabled_fore_color { get; init; }
        public string disabled_border_color { get; init; }
    }
}
