function InitializeUI(vars_ui)
    vars_ui.screen = GetScreenInfo()    --NOTE: This won't see changes if they mess with their video settings, but that should be super rare.  They just need to reload mods

    vars_ui.style = LoadStylesheet()

    vars_ui.mainWindow = Define_MainWindow(vars_ui.screen)

    Define_SummaryButtons(vars_ui)      -- this must come after vars_ui.mainWindow is defined

    --ReportTable_lite(vars_ui)
end

function GetScreenInfo()
    local width, height = GetDisplayResolution()

    return
    {
        width = width,
        height = height,
        center_x = width / 2,
        center_y = height / 2,
    }
end

function LoadStylesheet()
    local file = io.open("ui/stylesheet.json", "r")
    if not file then
        print("GRAPPLING HOOK ERROR: Can't find file: ui/stylesheet.json")
        return nil
    end

    local json = file:read("*all")

    local style = extern_json.decode(json)

    -- Convert color strings
    FinishStylesheetColors(style)

    return style
end

function FinishStylesheetColors(style)
    local argb = { }

    for key, value in pairs(style) do
        local type = type(value)

        if type == "string" then
            if string.find(key, "_color") then
                local color, a, r, g, b = ConvertHexStringToNumbers(value)

                -- Change from string to a full int
                style[key] = color

                -- Store these off so there's no chance of interfering with the for loop
                argb[key .. "_a"] = a
                argb[key .. "_r"] = r
                argb[key .. "_g"] = g
                argb[key .. "_b"] = b
            end

        elseif type == "table" then
            -- Recurse
            FinishStylesheetColors(value)
        end
    end

    for key, value in pairs(argb) do
        style[key] = value
    end
end

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
        tonumber("0x" .. a .. r .. g .. b),
        num_a / 255,
        num_r / 255,
        num_g / 255,
        num_b / 255
end
function ConvertHexStringToNumbers_Magenta()
    return 0xFFFF00FF, 1, 1, 0, 1
end

function Define_MainWindow(screen)
    local width = 1000
    local height = 800

    return
    {
        width = width,
        height = height,
        left = screen.center_x - width / 2,
        top = screen.center_y - height / 2,
    }
end
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

function CalcTextSize(text, max_width, line_heights)
    -- Looks like this overload wasn't implemented.  It's still safe to call ImGui.PushTextWrapPos(left + max_width)
    -- sol: no matching function call takes this number of arguments and the specified types
    --  in function 'CalcTextSize'
    --ImGui.CalcTextSize(text, "12345 don't match this string 67890", false, max_width)

    local width, height = ImGui.CalcTextSize(text)
    if (not max_width) or width <= max_width then
        return width, height
    end

    -- It will need to be word wrapped.  Figure out how many lines there will be
    local division = width / max_width
    local numLines = math.ceil(division)

    if numLines - division < 0.03 then
        -- It nearly fills all available lines, add an extra line to be safe (because there will be early
        -- splits on whole words)
        --
        -- This is crude and will fail with words longer than a single line, but that could only be detected
        -- if the word wrap was manually replicated
        numLines = numLines + 1
    end

    height = (numLines * line_heights.line) + ((numLines - 1) * line_heights.gap)

    return max_width, height
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

-- This will return the left,top of the control based on the definition, control's size,
-- and window's size
-- Params
--  def = models\ui\ControlPosition
--  control_width, control_height = size of control
--  window_width, window_height = size of parent window
function GetControlPosition(def, control_width, control_height, window_width, window_height, const)
    -- Left
    local left = nil

    if def.horizontal then
        if def.horizontal == const.alignment_horizontal.left then
            left = def.pos_x

        elseif def.horizontal == const.alignment_horizontal.center then
            left = (window_width / 2) - (control_width / 2) + def.pos_x

        elseif def.horizontal == const.alignment_horizontal.right then
            left = window_width - def.pos_x - control_width

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
            top = (window_height / 2) - (control_height / 2) + def.pos_y

        elseif def.vertical == const.alignment_vertical.bottom then
            top = window_height - def.pos_y - control_height

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