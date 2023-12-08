namespace models.stylesheet
{
    public record ColorSample
    {
        public double width { get; init; }
        public double height { get; init; }

        public double border_thickness { get; init; }
        public string border_color { get; init; }

        public double checker_size { get; init; }

        public string checker_color_dark { get; init; }
        public string checker_color_light { get; init; }
    }
}
