namespace models.viewmodels
{
    /// <summary>
    /// This is the arrow graphic drawn next to the stick figure graphic
    /// </summary>
    /// <remarks>
    /// NOTE: The positions are offsets from center
    /// </remarks>
    public class GrappleArrows
    {
        /// <summary>
        /// Whether to show the look arrow (should only show it when they have acceleration along look)
        /// </summary>
        public bool showLook { get; set; }

        // True: Use the standard color
        // False: Use the gray color
        public bool isStandardColor_primary { get; set; }
        public bool isStandardColor_look { get; set; }

        // Set to true when they hover over options that will modify these lines
        public bool isHighlight_primary { get; set; }
        public bool isHighlight_look { get; set; }

        // Positions
        public double primary_from_x { get; set; }
        public double primary_to_x { get; set; }

        public double primary_y { get; set; }      // if the primary was allowed a slope, it would complicate lots of other drawing (they would need to calculate perpendicular lines, parallel lines)

        public double look_from_x { get; set; }
        public double look_from_y { get; set; }

        public double look_to_x { get; set; }
        public double look_to_y { get; set; }
    }
}
