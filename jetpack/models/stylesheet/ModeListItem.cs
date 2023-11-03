/// <summary>
/// This is used by both modelist_item and modelist_add
/// </summary>
public record ModeListItem
{
    // Labels use the colors section, but if I could, the colors would be defined here
    // modelistitem_name
    // modelistitem_description
    // modelistitem_add

    // These are used to define the bar that appears when mouse is over the control
    public double hover_padding { get; init; }

    public double border_cornerRadius { get; init; }
    public double border_thickness { get; init; }

    public string back_color_hover { get; init; }
    public string border_color_hover { get; init; }
}