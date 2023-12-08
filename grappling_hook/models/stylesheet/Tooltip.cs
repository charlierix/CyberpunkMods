namespace models.stylesheet
{
    public record Tooltip
    {
        /// <summary>
        /// This is the max width of the entire window (text max width is max_width-(padding*2))
        /// The text will wordwrap if it's wider
        /// 
        /// Height will be auto calculated based on how many lines of text there are
        /// </summary>
        public double max_width { get; init; }

        /// <summary>
        /// Gap between the edges of the window and the text
        /// </summary>
        public double padding { get; init; }

        public double border_cornerRadius { get; init; }
        public double border_thickness { get; init; }

        public string text_color { get; init; }
        public string back_color { get; init; }
        public string border_color { get; init; }
    }
}
