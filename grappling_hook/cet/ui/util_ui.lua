-- The hex can be in any of the standard hex formats (# is optional):
--  "444" becomes "FF444444" (very dark gray)
--  "806A" becomes "880066AA" (dusty blue)
--  "FF8040" becomes "FFFF8040" (sort of a coral)
--  "80FFFFFF" (50% transparent white)
--
-- Returns:
--  full int:  This is an int built from 0xAARRGGBB (this is how imgui's draw functions want color)
--  a float:   alpha from 0 to 1 (this is how imgui's other functions want color)
--  r float
--  g float
--  b float
function ConvertHexStringToNumbers(hex)
    hex = hex:gsub("#","")

    local len = string.len(hex)

    local a = nil
    local r = nil
    local g = nil
    local b = nil

    if len == 3 then
        -- RGB, compressed into single numbers
        a = "FF"
        r = string.sub(hex, 1, 1)
        g = string.sub(hex, 2, 2)
        b = string.sub(hex, 3, 3)

        r = r .. r
        g = g .. g
        b = b .. b

    elseif len == 4 then
        -- ARGB, compressed into single numbers
        a = string.sub(hex, 1, 1)
        r = string.sub(hex, 2, 2)
        g = string.sub(hex, 3, 3)
        b = string.sub(hex, 4, 4)

        a = a .. a
        r = r .. r
        g = g .. g
        b = b .. b

    elseif len == 6 then
        -- RRGGBB
        a = "FF"
        r = string.sub(hex, 1, 2)
        g = string.sub(hex, 3, 4)
        b = string.sub(hex, 5, 6)

    elseif len == 8 then
        -- AARRGGBB
        a = string.sub(hex, 1, 2)
        r = string.sub(hex, 3, 4)
        g = string.sub(hex, 5, 6)
        b = string.sub(hex, 7, 8)

    else
        -- Invalid color, use magenta
        return ConvertHexStringToNumbers_Magenta()
    end

    local num_a = tonumber("0x" .. a)
    local num_r = tonumber("0x" .. r)
    local num_g = tonumber("0x" .. g)
    local num_b = tonumber("0x" .. b)

    if not (num_a and num_r and num_g and num_b) then
        -- At least one of them didn't convert to a byte
        return ConvertHexStringToNumbers_Magenta()
    end

    return
        tonumber("0x" .. a .. r .. g .. b),     --NOTE: Functions in draw gmgui_draw.cpp use this ARGB, but ImGui.PushStyleColor (and maybe all functions in imgui.h that take a single color?) needed AGBR
        tonumber("0x" .. a .. b .. g .. r),
        num_a / 255,
        num_r / 255,
        num_g / 255,
        num_b / 255
end
function ConvertHexStringToNumbers_Magenta()
    return 0xFFFF00FF, 1, 1, 0, 1
end

-- Called from draw each frame that the config is open
function Refresh_WindowPos(mainWindow)
    local curLeft, curTop = ImGui.GetWindowPos()

    mainWindow.left = curLeft
    mainWindow.top = curTop
end
function Refresh_LineHeights(vars_ui)
    if not vars_ui.line_heights then
        vars_ui.line_heights = {}
    end

    vars_ui.line_heights.line = ImGui.GetTextLineHeight()
    vars_ui.line_heights.gap = ImGui.GetTextLineHeightWithSpacing() - vars_ui.line_heights.line
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

function Get_ImGuiSliderFlags_AlwaysClamp_NoRoundToFormat()
    -- // Flags for DragFloat(), DragInt(), SliderFloat(), SliderInt() etc.
    -- // We use the same sets of flags for DragXXX() and SliderXXX() functions as the features are the same and it makes it easier to swap them.
    -- enum ImGuiSliderFlags_
    -- {
    --     ImGuiSliderFlags_None                   = 0,
    --     ImGuiSliderFlags_AlwaysClamp            = 1 << 4,       // Clamp value to min/max bounds when input manually with CTRL+Click. By default CTRL+Click allows going out of bounds.
    --     ImGuiSliderFlags_Logarithmic            = 1 << 5,       // Make the widget logarithmic (linear otherwise). Consider using ImGuiSliderFlags_NoRoundToFormat with this if using a format-string with small amount of digits.
    --     ImGuiSliderFlags_NoRoundToFormat        = 1 << 6,       // Disable rounding underlying value to match precision of the display format string (e.g. %.3f values are rounded to those 3 digits)
    --     ImGuiSliderFlags_NoInput                = 1 << 7,       // Disable CTRL+Click or Enter key allowing to input text directly into the widget

    return
        Bit_LShift(1, 4) +
        Bit_LShift(1, 6)
end

-- This will return the left,top of the control based on the definition, control's size,
-- and parent's size
-- Params
--  def = models\viewmodels\ControlPosition
--  control_width, control_height = size of control
--  parent_width, parent_height = size of parent window or div container
function GetControlPosition(def, control_width, control_height, parent_width, parent_height, const)
    -- Left
    local left = nil

    if def.horizontal then
        if def.horizontal == const.alignment_horizontal.left then
            left = def.pos_x

        elseif def.horizontal == const.alignment_horizontal.center then
            left = (parent_width / 2) - (control_width / 2) + def.pos_x

        elseif def.horizontal == const.alignment_horizontal.right then
            left = parent_width - def.pos_x - control_width

        else
            print("GetControlPosition: Unknown horizontal: " .. tostring(def.horizontal))
            left = 0
        end
    else
        left = def.pos_x        -- default to left align
    end

    -- Top
    local top = nil
        if def.vertical then
        if def.vertical == const.alignment_vertical.top then
            top = def.pos_y

        elseif def.vertical == const.alignment_vertical.center then
            top = (parent_height / 2) - (control_height / 2) + def.pos_y

        elseif def.vertical == const.alignment_vertical.bottom then
            top = parent_height - def.pos_y - control_height

        else
            print("GetControlPosition: Unknown vertical: " .. tostring(def.vertical))
            top = 0
        end
    else
        top = def.pos_y     -- default to top align
    end

    return left, top
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