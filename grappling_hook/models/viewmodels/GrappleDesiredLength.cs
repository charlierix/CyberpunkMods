namespace models.viewmodels
{
    public class GrappleDesiredLength
    {

        //TODO: Dashed


        public bool should_show { get; set; }

        /// <summary>
        /// True: Use the standard color
        /// False: Use the gray color
        /// </summary>
        public bool isStandardColor { get; set; }

        /// <summary>
        /// Set to true when they hover over options that will modify these lines
        /// </summary>
        public bool isHighlight { get; set; }

        /// <summary>
        /// This is the height of the line that actually gets drawn (half is above, half is below)
        /// </summary>
        public double height { get; set; }

        /// <summary>
        /// This is where to actually draw the line
        /// NOTE: percent of zero draws at to_x, since desired length is relative to the anchor point
        /// </summary>
        public double percent { get; set; }

        public double from_x { get; set; }
        public double to_x { get; set; }

        public double y { get; set; }
    }
}
