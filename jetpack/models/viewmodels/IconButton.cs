public class IconButton : IControl
{
    public string invisible_name { get; set; }

    public string tooltip { get; set; }

    /// <summary>
    /// Instructions for drawing
    /// </summary>
    /// <remarks>
    /// This is a multiline string.  Each line will start with a type of item to draw, followed by space delimited params
    /// 
    /// Coordinates are percents of button size
    /// 
    /// Available commands:
    ///     line x1 y1 x2 y2 [thickness]
    ///     arrow x1 y1 x2 y2 [thickness]
    ///     circle centerX centerY radius [thickness]
    ///     rect x1 y1 x2 y2 [thickness]
    ///     triangle x1 y1 x2 y2 x3 y3 [thickness]
    /// 
    /// NOTE: at runtime, the control creates two other props based on this:
    ///     icon_data_parsed                - a list of { "qual", num, num ... } elements
    ///     icon_data_parsed_against        - a copy of icon_data
    /// </remarks>
    public string icon_data { get; set; }

    public bool isEnabled { get; set; }

    /// <summary>
    /// Gives a chance to override the style's value
    /// </summary>
    public double? width_height { get; set; }

    /// <summary>
    /// True: This is a circle
    /// False: This is a square (possibly rounded corners)
    /// </summary>
    public bool is_circle { get; set; }

    /// <summary>
    /// Tells where on the parent to place the buttons
    /// </summary>
    /// <remarks>
    /// The buttons are layed out horizontally, should be aligned to bottom/right of window
    /// 
    /// The xy are are stored in the stylesheet, and should be copied from there so all buttons are
    /// in the same position for any page
    /// </remarks>
    public ControlPosition position { get; init; }
    public RenderPosition render_pos { get; init; }

    public Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }
}
