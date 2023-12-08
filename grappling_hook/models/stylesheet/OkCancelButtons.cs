namespace models.stylesheet
{
    public record OkCancelButtons
    {
        // These values should be copied into position of each instance (putting here so all buttons are
        // in the same place
        public double pos_x { get; init; }
        public double pos_y { get; init; }

        // Size of a single button (make sure it's large enough to show the longest text "cancel" without resizing)
        public double width { get; init; }
        public double height { get; init; }

        // Gap between buttons
        public double gap { get; init; }

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
