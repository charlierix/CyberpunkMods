using grapple_ui.models.viewmodels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.misc
{
    /// <summary>
    /// This can be added to a control to tells how to place it
    /// </summary>
    public record ControlPosition
    {
        /// <summary>
        /// X is
        ///     left: distance from left
        ///     center: offset from center (negative values will be left of center)
        ///     right: offset from parent's width (so a positive 40 would give a gap of 40 between the right side of the label and the parent's right edge)
        ///
        /// Y is similar logic.  For center, the offset goes: negative=up, positive=down
        /// </summary>
        public double pos_x { get; init; }
        public double pos_y { get; init; }

        //TODO: optional bools that let x and y offsets be percent of the parent size instead of pixels

        public AlignmentHorizontal horizontal { get; init; }
        public AlignmentVertical vertical { get; init; }

        // ******************************************************************************
        // If these are populated, then this control will be placed relative to a control instead of absolute
        // position on the parent

        /// <summary>
        /// This is a link to the control that this will be placed relative to
        /// </summary>
        public IControl relative_to { get; init; }

        // These are what part of the parent control to align to
        public AlignmentHorizontal relative_horz { get; init; }
        public AlignmentVertical relative_vert { get; init; }

        // Examples:
        //
        // Place to the right of the parent, centered vertically
        //  relative_horz = right
        //  horizontal = left
        //  relative_vert = center
        //  vertical = center
        //
        // Place above parent, align left (like a label over a textbox)
        //  relative_horz = left
        //  horizontal = left
        //  relative_vert = top
        //  vertical = bottom

        // ******************************************************************************
    }

    public enum AlignmentHorizontal
    {
        left,
        center,
        right,
    }

    public enum AlignmentVertical
    {
        top,
        center,
        bottom,
    }
}
