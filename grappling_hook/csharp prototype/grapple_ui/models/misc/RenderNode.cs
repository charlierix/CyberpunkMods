namespace models.misc
{
    public record RenderNode
    {
        public viewmodels.IControl control { get; init; }
        public RenderNode[] children { get; init; }
    }
}
