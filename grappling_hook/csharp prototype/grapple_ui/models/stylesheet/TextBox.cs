namespace models.stylesheet
{
    public record TextBox
    {
        public double padding { get; init; }

        public double border_cornerRadius { get; init; }
        public double border_thickness { get; init; }

        public string border_color { get; init; }

        /// <summary>
        /// Color of the text
        /// </summary>
        public string foreground_color { get; init; }

        public string background_color { get; init; }

        //TODO: May need scrollbar props
    }
}
