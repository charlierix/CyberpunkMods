public record IconButton
{
    /// <summary>
    /// This will always have a 1:1 ratio of width and height
    /// </summary>
    public double width_height { get; set; }

    public double border_cornerRadius { get; init; }
    public double border_thickness { get; init; }

    public string border_color_standard { get; init; }
    public string border_color_hover { get; init; }
    public string border_color_click { get; init; }

    /// <summary>
    /// Color of the icon drawing
    /// TODO: May need a few predefined colors
    /// </summary>
    public string foreground_color_standard { get; init; }
    public string foreground_color_hover { get; init; }
    public string foreground_color_click { get; init; }

    // Background colors
    public string back_color_standard { get; init; }
    public string back_color_hover { get; init; }
    public string back_color_click { get; init; }

    public string disabled_back_color { get; init; }
    public string disabled_fore_color { get; init; }
    public string disabled_border_color { get; init; }
}