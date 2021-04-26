function InitializeUI(vars_ui)
    vars_ui.screen = GetScreenInfo()    --NOTE: This won't see changes if they mess with their video settings, but that should be super rare.  They just need to reload mods

    vars_ui.style = LoadStylesheet()

    vars_ui.mainWindow = LoadMainWindowStats(vars_ui.screen)

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

    --TODO: Convert color strings

    return style
end

function FinishStylesheetColors(style)
    local argb = { }

    for key, value in pairs(style) do
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

    a = tonumber("0x" .. a)
    r = tonumber("0x" .. r)
    g = tonumber("0x" .. g)
    b = tonumber("0x" .. b)

    if not (a and r and g and b) then
        -- At least one of them didn't convert to a byte
        return ConvertHexStringToNumbers_Magenta()
    end

    return
        tonumber("0x" .. a .. r .. g .. b),
        a / 255,
        r / 255,
        g / 255,
        b / 255
end
function ConvertHexStringToNumbers_Magenta()
    return 0xFFFF00FF, 1, 1, 0, 1
end

function LoadMainWindowStats(screen)
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