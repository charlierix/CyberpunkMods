namespace models.stylesheet
{
    public record NamedColor
    {
        // Instead of storing name here, it needs to be the name of this instance
        //public string name { get; init; }

        /// <summary>
        /// There is a find in the json post process to find all strings that contain "_color" and
        /// convert the value into a color.  Also add _a, _r, _g, _b float properties between 0 and 1
        /// </summary>
        public string the_color { get; init; }
    }
}
