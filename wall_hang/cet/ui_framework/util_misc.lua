local this = {}

function GetScreenInfo()
    local width, height = GetDisplayResolution()

    return
    {
        width = width,
        height = height,
        center_x = width / 2,
        center_y = height / 2,
        scale = math.min(width / 1920, height / 1080)
    }
end

-- Called from draw each frame that the config is open
function Refresh_WindowPos(configWindow, vars_ui, const)
    local curLeft, curTop = ImGui.GetWindowPos()

    configWindow.left = curLeft
    configWindow.top = curTop

    configWindow.width = 800 * vars_ui.em
    configWindow.height = 600 * vars_ui.em
end
function Refresh_LineHeights(vars_ui, const, is_from_init)
    if not vars_ui.line_heights then
        vars_ui.line_heights = {}
    end

    if is_from_init then
        vars_ui.line_heights.line = 18        -- just using some reasonable results until the real call from draw event
        vars_ui.line_heights.gap = 4
        vars_ui.line_heights.frame_height = 24
    else
        vars_ui.line_heights.line = ImGui.GetTextLineHeight()       -- 18 (36 on 4k)
        vars_ui.line_heights.gap = ImGui.GetTextLineHeightWithSpacing() - vars_ui.line_heights.line     -- 22 (44 on 4k)
        vars_ui.line_heights.frame_height = ImGui.GetFrameHeight()       -- 24 (48 on 4k)
    end

    -- this will be used all over, so making the path shorter (also gives the option of making a small tweak if necessary)
    vars_ui.em = vars_ui.line_heights.line
end

-- There may be a way to call that enum natively, but for now, just hardcode the int
function Get_ImDrawFlags_RoundCornersAll()
    -- // Flags for ImDrawList functions
    -- // (Legacy: bit 0 must always correspond to ImDrawFlags_Closed to be backward compatible with old API using a bool. Bits 1..3 must be unused)
    -- enum ImDrawFlags_
    -- {
    --     ImDrawFlags_None                        = 0,
    --     ImDrawFlags_Closed                      = 1 << 0, // PathStroke(), AddPolyline(): specify that shape should be closed (Important: this is always == 1 for legacy reason)
    --     ImDrawFlags_RoundCornersTopLeft         = 1 << 4, // AddRect(), AddRectFilled(), PathRect(): enable rounding top-left corner only (when rounding > 0.0f, we default to all corners). Was 0x01.
    --     ImDrawFlags_RoundCornersTopRight        = 1 << 5, // AddRect(), AddRectFilled(), PathRect(): enable rounding top-right corner only (when rounding > 0.0f, we default to all corners). Was 0x02.
    --     ImDrawFlags_RoundCornersBottomLeft      = 1 << 6, // AddRect(), AddRectFilled(), PathRect(): enable rounding bottom-left corner only (when rounding > 0.0f, we default to all corners). Was 0x04.
    --     ImDrawFlags_RoundCornersBottomRight     = 1 << 7, // AddRect(), AddRectFilled(), PathRect(): enable rounding bottom-right corner only (when rounding > 0.0f, we default to all corners). Wax 0x08.
    --     ImDrawFlags_RoundCornersNone            = 1 << 8, // AddRect(), AddRectFilled(), PathRect(): disable rounding on all corners (when rounding > 0.0f). This is NOT zero, NOT an implicit flag!
    --     ImDrawFlags_RoundCornersTop             = ImDrawFlags_RoundCornersTopLeft | ImDrawFlags_RoundCornersTopRight,
    --     ImDrawFlags_RoundCornersBottom          = ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersBottomRight,
    --     ImDrawFlags_RoundCornersLeft            = ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersTopLeft,
    --     ImDrawFlags_RoundCornersRight           = ImDrawFlags_RoundCornersBottomRight | ImDrawFlags_RoundCornersTopRight,
    --     ImDrawFlags_RoundCornersAll             = ImDrawFlags_RoundCornersTopLeft | ImDrawFlags_RoundCornersTopRight | ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersBottomRight,
    --     ImDrawFlags_RoundCornersDefault_        = ImDrawFlags_RoundCornersAll, // Default to ALL corners if none of the _RoundCornersXX flags are specified.
    --     ImDrawFlags_RoundCornersMask_           = ImDrawFlags_RoundCornersAll | ImDrawFlags_RoundCornersNone
    -- };

    return
        Bit_LShift(1, 4) +  -- ImDrawFlags_RoundCornersTopLeft
        Bit_LShift(1, 5) +  -- ImDrawFlags_RoundCornersTopRight
        Bit_LShift(1, 6) +  -- ImDrawFlags_RoundCornersBottomLeft
        Bit_LShift(1, 7)    -- ImDrawFlags_RoundCornersBottomRight
end

function Get_ImGuiSliderFlags_AlwaysClamp_NoRoundToFormat(disable_ctrlclick)
    -- // Flags for DragFloat(), DragInt(), SliderFloat(), SliderInt() etc.
    -- // We use the same sets of flags for DragXXX() and SliderXXX() functions as the features are the same and it makes it easier to swap them.
    -- enum ImGuiSliderFlags_
    -- {
    --     ImGuiSliderFlags_None                   = 0,
    --     ImGuiSliderFlags_AlwaysClamp            = 1 << 4,       // Clamp value to min/max bounds when input manually with CTRL+Click. By default CTRL+Click allows going out of bounds.
    --     ImGuiSliderFlags_Logarithmic            = 1 << 5,       // Make the widget logarithmic (linear otherwise). Consider using ImGuiSliderFlags_NoRoundToFormat with this if using a format-string with small amount of digits.
    --     ImGuiSliderFlags_NoRoundToFormat        = 1 << 6,       // Disable rounding underlying value to match precision of the display format string (e.g. %.3f values are rounded to those 3 digits)
    --     ImGuiSliderFlags_NoInput                = 1 << 7,       // Disable CTRL+Click or Enter key allowing to input text directly into the widget

    local ctrl_click = 0
    if disable_ctrlclick then
        ctrl_click = Bit_LShift(1, 7)
    end

    return
        Bit_LShift(1, 4) +
        Bit_LShift(1, 6) +
        ctrl_click
end

-- This will return the left,top of the control based on the definition, control's size,
-- and parent's size
-- Params
--  def = models\viewmodels\ControlPosition
--  control_width, control_height = size of control
--  parent_width, parent_height = size of parent window or div container
function GetControlPosition(def, control_width, control_height, parent_width, parent_height, const, em)
    if def.relative_to then
        return this.GetControlPosition_Relative(def, control_width, control_height, const, em)
    else
        return this.GetControlPosition_Absolute(def, control_width, control_height, parent_width, parent_height, const, em)
    end
end

-- This returns the named color else magenta (style_colors is sylesheet.colors)
-- See models\stylesheet\NamedColor
function GetNamedColor(style_colors, name)
    local retVal = style_colors[name]
    if retVal then
        return retVal
    end

    -- Not found, use magenta
    local color, a, r, g, b = ConvertHexStringToNumbers_Magenta()

    return
    {
        the_color = color,
        the_color_a = a,
        the_color_r = r,
        the_color_g = g,
        the_color_b = b,
    }
end

-- This does an extra validation to make sure the value is between min and max (if they are populated)
-- The slider is supposed to do that, but doesn't if min and max are changed after value is set
function GetSliderValue(def)
    local retVal = def.value

    if def.min and retVal < def.min then
        retVal = def.min
    end

    if def.max and retVal > def.max then
        retVal = def.max
    end

    return retVal
end

----------------------------------- Private Methods -----------------------------------

function this.GetControlPosition_Absolute(def, control_width, control_height, parent_width, parent_height, const, em)
    -- Left
    local left = nil

    if def.horizontal then
        if def.horizontal == const.alignment_horizontal.left then
            left = def.pos_x * em

        elseif def.horizontal == const.alignment_horizontal.center then
            left = (parent_width / 2) - (control_width / 2) + (def.pos_x * em)

        elseif def.horizontal == const.alignment_horizontal.right then
            left = parent_width - control_width - (def.pos_x * em)

        else
            print("GetControlPosition_Absolute: Unknown horizontal: " .. tostring(def.horizontal))
            left = 0
        end
    else
        left = def.pos_x * em        -- default to left align
    end

    -- Top
    local top = nil

    if def.vertical then
        if def.vertical == const.alignment_vertical.top then
            top = def.pos_y * em

        elseif def.vertical == const.alignment_vertical.center then
            top = (parent_height / 2) - (control_height / 2) + (def.pos_y * em)

        elseif def.vertical == const.alignment_vertical.bottom then
            top = parent_height - control_height - (def.pos_y * em)

        else
            print("GetControlPosition_Absolute: Unknown vertical: " .. tostring(def.vertical))
            top = 0
        end
    else
        top = def.pos_y * em     -- default to top align
    end

    return left, top
end
function this.GetControlPosition_Relative(def, control_width, control_height, const, em)
    local parent_pos = def.relative_to.render_pos

    -- Left
    local left = 0

    if def.relative_horz then
        -- Pos of parent
        if def.relative_horz == const.alignment_horizontal.left then
            left = parent_pos.left

        elseif def.relative_horz == const.alignment_horizontal.center then
            left = parent_pos.left + (parent_pos.width / 2)

        elseif def.relative_horz == const.alignment_horizontal.right then
            left = parent_pos.left + parent_pos.width

        else
            print("GetControlPosition_Relative: Unknown relative_horz: " .. tostring(def.relative_horz))
        end

        -- Offset of this control's width
        if def.horizontal == const.alignment_horizontal.left then
            left = left + (def.pos_x * em)

        elseif def.horizontal == const.alignment_horizontal.center then
            left = left - (control_width / 2) + (def.pos_x * em)

        elseif def.horizontal == const.alignment_horizontal.right then
            left = left - control_width - (def.pos_x * em)

        else
            print("GetControlPosition_Relative: Unknown horizontal: " .. tostring(def.horizontal))
        end
    end

    -- Top
    local top = 0

    if def.relative_vert then
        -- Pos of parent
        if def.relative_vert == const.alignment_vertical.top then
            top = parent_pos.top

        elseif def.relative_vert == const.alignment_vertical.center then
            top = parent_pos.top + (parent_pos.height / 2)

        elseif def.relative_vert == const.alignment_vertical.bottom then
            top = parent_pos.top + parent_pos.height

        else
            print("GetControlPosition_Relative: Unknown relative_vert: " .. tostring(def.relative_vert))
        end

        -- Offset of this control's width
        if def.vertical == const.alignment_vertical.top then
            top = top + (def.pos_y * em)

        elseif def.vertical == const.alignment_vertical.center then
            top = top - (control_height / 2) + (def.pos_y * em)

        elseif def.vertical == const.alignment_vertical.bottom then
            top = top - control_height - (def.pos_y * em)

        else
            print("GetControlPosition_Relative: Unknown vertical: " .. tostring(def.vertical))
        end
    end

    return left, top
end