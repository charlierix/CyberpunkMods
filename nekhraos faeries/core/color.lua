local this = {}

-- The hex can be in any of the standard hex formats (# is optional):
--  "444" becomes "FF444444" (very dark gray)
--  "806A" becomes "880066AA" (dusty blue)
--  "FF8040" becomes "FFFF8040" (sort of a coral)
--  "80FFFFFF" (50% transparent white)
--
-- Returns:
--  full int:  This is an int built from 0xAARRGGBB (this is how imgui's draw functions want color)
--  full int:  0xAABBGGRR
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
        return ConvertHexStringToNumbers_Magenta2()
    end

    local num_a = tonumber("0x" .. a)
    local num_r = tonumber("0x" .. r)
    local num_g = tonumber("0x" .. g)
    local num_b = tonumber("0x" .. b)

    if not (num_a and num_r and num_g and num_b) then
        -- At least one of them didn't convert to a byte
        return ConvertHexStringToNumbers_Magenta2()
    end

    return
        tonumber("0x" .. a .. r .. g .. b),     --NOTE: gmgui_draw.cpp rectangle uses this ARGB (maybe others), all other functions I've seen use ABGR
        tonumber("0x" .. a .. b .. g .. r),
        num_a / 255,
        num_r / 255,
        num_g / 255,
        num_b / 255
end
function ConvertHexStringToNumbers_Magenta()
    return 0xFFFF00FF, 1, 1, 0, 1
end
function ConvertHexStringToNumbers_Magenta2()
    return 0xFFFF00FF, 0xFFFF00FF, 1, 1, 0, 1
end

-- This takes in floating point values between 0 and 1, returns a single integer representing abgr
function ToABGR(a, r, g, b)
    local text_a = this.ByteToHex(a * 255)
    local text_r = this.ByteToHex(r * 255)
    local text_g = this.ByteToHex(g * 255)
    local text_b = this.ByteToHex(b * 255)

    return tonumber("0x" .. text_a .. text_b .. text_g .. text_r)
end

-- r,g,b are values between 0 and 1
-- h is 0 to 360.  s,v are 0 to 1
-- http://stackoverflow.com/questions/4123998/algorithm-to-switch-between-rgb-and-hsb-color-values
function RGB_HSV(r, g, b)
    local minValue = math.min(r, g, b)
    local maxValue = math.max(r, g, b)
    local delta = maxValue - minValue

    -- Hue (in degrees of a circle, between 0 and 360)
    local h = 0

    if r >= g and r >= b then
        if g >= b then
            if delta <= 0 then
                h = 0
            else
                h = 60 * (g - b) / delta
            end
        else
            h = 60 * (g - b) / delta + 360
        end
    elseif g >= r and g >= b then
        h = 60 * (b - r) / delta + 120
    else --if (b >= r and b >= g)
        h = 60 * (r - g) / delta + 240
    end

    -- Saturation (between 0 and 1)
    local s = 0

    if maxValue == 0 then
        s = 0
    else
        s = 1 - (minValue / maxValue)
    end

    -- Value (between 0 and 1)
    local v = maxValue

    return
        Clamp(0, 360, h),
        Clamp(0, 1, s),
        Clamp(0, 1, v)
end
function HSV_RGB(h, s, v)
    h = this.GetHueCapped(h)

    local r = 0
    local g = 0
    local b = 0

    if s <= 0 then
        -- Gray
        r = v
        g = v
        b = v
    else
        -- Calculate the appropriate sector of a 6-part color wheel
        local sectorPos = h / 60
        local sectorNumber = math.floor(sectorPos)

        -- Get the fractional part of the sector (that is, how many degrees into the sector you are)
        local fractionalSector = sectorPos - sectorNumber

        -- Calculate values for the three axes of the color
        local p = v * (1 - s)
        local q = v * (1 - (s * fractionalSector))
        local t = v * (1 - (s * (1 - fractionalSector)))

        -- Assign the fractional colors to red, green, and blue
        -- components based on the sector the angle is in
        if In(sectorNumber, 0, 6) then
                r = v
                g = t
                b = p
        elseif sectorNumber == 1 then
                r = q
                g = v
                b = p
        elseif sectorNumber == 2 then
                r = p
                g = v
                b = t
        elseif sectorNumber == 3 then
                r = p
                g = q
                b = v
        elseif sectorNumber == 4 then
                r = t
                g = p
                b = v
        elseif sectorNumber == 5 then
                r = v
                g = p
                b = q
        else
            _, _, r, g, b = ConvertHexStringToNumbers_Magenta()
        end
    end

    return
        Clamp(0, 1, r),
        Clamp(0, 1, g),
        Clamp(0, 1, b)
end

-- This returns the color that is betwen from and to
-- hue is 0 to 360, all the other values are 0 to 1
-- Returns a, h, s, v
function Color_LERP(from_a, from_h, from_s, from_v, to_a, to_h, to_s, to_v, percent)
    from_h = this.GetHueCapped(from_h)
    to_h = this.GetHueCapped(to_h)

    local h_diff = this.GetHueDiff(from_h, to_h)

    local a = from_a + ((to_a - from_a) * percent)
    local h = from_h + (h_diff * percent)
    local s = from_s + ((to_s - from_s) * percent)
    local v = from_v + ((to_v - from_v) * percent)

    return
        Clamp(0, 1, a),
        this.GetHueCapped(h),
        Clamp(0, 1, s),
        Clamp(0, 1, v)
end

function Color_LERP_Hex(from_hex, to_hex, percent)
    --ConvertHexStringToNumbers
    local _, _, from_a, from_r, from_g, from_b = ConvertHexStringToNumbers(from_hex)
    local _, _, to_a, to_r, to_g, to_b = ConvertHexStringToNumbers(to_hex)

    --RGB_HSV
    local from_h, from_s, from_v = RGB_HSV(from_r, from_g, from_b)
    local to_h, to_s, to_v = RGB_HSV(to_r, to_g, to_b)

    --Color_LERP
    local lerp_a, lerp_h, lerp_s, lerp_v = Color_LERP(from_a, from_h, from_s, from_v, to_a, to_h, to_s, to_v, percent)

    --HSV_RGB
    local lerp_r, lerp_g, lerp_b = HSV_RGB(lerp_h, lerp_s, lerp_v)

    return this.RGB_Hex(lerp_a, lerp_r, lerp_g, lerp_b)
end

-- This pulls the from/to colors out of the stylesheet, then returns an intermediate color
-- NOTE: using hsv because it makes a better transition
function ColorLERP_FromStyleSheet(style, key_from, key_to, percent)
    local from_a, from_h, from_s, from_v = this.GetHSVFromColorKey(style, key_from)
    local to_a, to_h, to_s, to_v = this.GetHSVFromColorKey(style, key_to)

    local a, h, s, v = Color_LERP(from_a, from_h, from_s, from_v, to_a, to_h, to_s, to_v, percent)

    local r, g, b = HSV_RGB(h, s, v)

    return a, r, g, b
end

-- Alpha params are optional.  If they aren't passed in, FF will be used
-- Values are 0 to 1
function GetRandomColor_RGB1_ToHex(min, max, a_min, a_max)
    return GetRandomColor_RGB2_ToHex(min, max, min, max, min, max, a_min, a_max)
end
function GetRandomColor_RGB2_ToHex(r_min, r_max, g_min, g_max, b_min, b_max, a_min, a_max)
    local a = 1
    if a_min and a_max then
        a = Clamp(0, 1, a_min + ((a_max - a_min) * math.random()))
    end

    local r = Clamp(0, 1, r_min + ((r_max - r_min) * math.random()))
    local g = Clamp(0, 1, g_min + ((g_max - g_min) * math.random()))
    local b = Clamp(0, 1, b_min + ((b_max - b_min) * math.random()))

    return this.RGB_Hex(a, r, g, b)
end
function GetRandomColor_HSV_ToHex(h_min, h_max, s_min, s_max, v_min, v_max, a_min, a_max)
    local a = 1
    if a_min and a_max then
        a = Clamp(0, 1, a_min + ((a_max - a_min) * math.random()))
    end

    local h = Clamp(0, 360, h_min + ((h_max - h_min) * math.random()))
    local s = Clamp(0, 1, s_min + ((s_max - s_min) * math.random()))
    local v = Clamp(0, 1, v_min + ((v_max - v_min) * math.random()))

    local r, g, b = HSV_RGB(h, s, v)

    return this.RGB_Hex(a, r, g, b)
end

-- percent is 0 to 1
-- Returns "00" to "FF"
function Color_PercentToHex(percent)
    return string.upper(this.ByteToHex(Clamp(0, 1, percent) * 255))
end

----------------------------------- Private Methods -----------------------------------

function this.GetHueCapped(hue)
    local retVal = hue

    while true do
        if retVal < 0 then
            retVal = retVal + 360
        elseif retVal >= 360 then
            retVal = retVal - 360
        else
            return retVal
        end
    end
end

-- This makes sure that abs(diff) <= 180
function this.GetHueDiff(from, to)
    local diff = to - from

    local abs = math.abs(to - from)
    if abs > 180 then
        if diff < 0 then
            return diff + 360
        else
            return diff - 360
        end
    else
        return diff
    end
end

-- Takes an int between 0 and 255, returns a string between "00" and "FF"
function this.ByteToHex(byte)
    return string.format("%02x", Clamp(0, 255, byte))
end

--NOTE: This expects the individual ints are stored (util_setup.lua this.FinishStylesheetColors)
function this.GetHSVFromColorKey(style, key)
    local a = style[key .. "_a"]
    local r = style[key .. "_r"]
    local g = style[key .. "_g"]
    local b = style[key .. "_b"]

    local h, s, v = RGB_HSV(r, g, b)

    return a, h, s, v
end

function this.RGB_Hex(a, r, g, b)
    return string.upper(this.ByteToHex(a * 255) .. this.ByteToHex(r * 255) .. this.ByteToHex(g * 255) .. this.ByteToHex(b * 255))
end