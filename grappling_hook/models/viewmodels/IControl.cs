using models.misc;

namespace models.viewmodels
{
    public interface IControl
    {
        ControlPosition position { get; init; }

        /// <summary>
        /// CalcSize function will populate width,height.  CalcPos will populate left,top.  These are done
        /// after the viewmodel is refreshed from model and before the call to Draw
        /// </summary>
        /// <remarks>
        /// This shouldn't be created manually, it's built in a post process step at the end of window creation
        /// </remarks>
        RenderPosition render_pos { get; init; }

        /// <summary>
        /// This will set render_pos.width and height
        /// </summary>
        Action<IControl, stylesheet.Stylesheet, LineHeights> CalcSize { get; init; }

        //TODO: Add a class that handles refresh interval.  That way some controls can be refreshed every frame, but others only half second or so
    }
}
