namespace models.misc
{
    /// <summary>
    /// This gets created in init_ui.FinishDefiningWindow(), then gets populated each frame by util.layout.lua
    /// </summary>
    public record RenderPosition
    {
        // These get set in CalcSize
        public double width { get; init; }
        public double height { get; init; }

        // These get set in CalcPos
        public double left { get; init; }
        public double top { get; init; }
    }
}
