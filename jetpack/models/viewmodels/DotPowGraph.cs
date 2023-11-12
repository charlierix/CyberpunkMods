public class DotPowGraph : IControl
{
    public double width { get; set; }

    // The graph is a rectangle width x graph_height
    // The control itself will have a larger height, because X axis icons will be under the graph
    public double graph_height { get; set; }

    public double graph_icon_gap { get; set; }
    public double icon_size { get; set; }

    // This needs to be a copy of the slider's value
    public double power { get; set; }
}

