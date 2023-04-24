namespace models
{
    public record Visuals
    {
        // --------- grapple line ---------
        public Visuals_GrappleLine_Type grappleline_type { get; init; }

        // Hex code: RGB, RRGGBB, ARGB, AARRGGBB
        public string grappleline_color_primary { get; init; }

        // --------- anchor point ---------
        public Visuals_AnchorPoint_Type anchorpoint_type { get; init; }

        public string anchorpoint_color_primary { get; init; }

        // --------- stop plane ---------
        public bool show_stopplane { get; init; }

        public string stopplane_color { get; init; }
    }

    public enum Visuals_GrappleLine_Type
    {
        solid_line,
    }

    public enum Visuals_AnchorPoint_Type
    {
        none,
        diamond,
        circle,
    }
}
