using models.misc;

namespace models.viewmodels
{
    /// <remarks>
    /// There is no property to hold a list of controls.  They are just added directly to this (key is the control
    /// name, value is the control)
    /// </remarks>
    public record Window
    {
        /// <summary>
        /// This gets set by init_ui.FinishDefiningWindow()
        /// </summary>
        public misc.RenderNode[] render_nodes { get; init; }
    }
}
