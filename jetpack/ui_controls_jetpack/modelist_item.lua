local this = {}
ModeList_Item = {}

function ModeList_Item:new(mode)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.mode = mode

    local color_hex = GetRandomColor_RGB1_ToHex(0.4, 0.85)
    local _, color_abgr = ConvertHexStringToNumbers(color_hex)
    obj.color1 = color_abgr

    color_hex = GetRandomColor_RGB1_ToHex(0.4, 0.85)
    _, color_abgr = ConvertHexStringToNumbers(color_hex)
    obj.color2 = color_abgr

    return obj
end

-- Takes in x,y
-- Returns
--  used height
function ModeList_Item:Draw(screenOffset_x, screenOffset_y, x, y, width, scale)
    local height = 35 * scale

    local icon_size = 18


    -- topleft, bottomright
    Draw_Border(screenOffset_x, screenOffset_y, x + icon_size / 2, y + icon_size / 2, icon_size, icon_size, 0, false, self.color1, nil, nil, nil, 0, 1)
    Draw_Border(screenOffset_x, screenOffset_y, x + width - icon_size / 2, y + height - icon_size / 2, icon_size, icon_size, 0, false, self.color1, nil, nil, nil, 0, 1)



    -- boundry line
    Draw_Border(screenOffset_x, screenOffset_y, x + width / 2, y + height / 2, width, height, 0, false, nil, nil, self.color2, nil, 0, 1)

    return height
end

----------------------------------- Private Methods -----------------------------------




