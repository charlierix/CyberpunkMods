local this = {}
ModeList_Item = {}

function ModeList_Item:new(mode, vars_ui, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.mode = mode
    obj.vars_ui = vars_ui
    obj.const = const

    obj.item = this.DefineWindow(vars_ui, const)

    ------- TEMP -------
    local color_hex = GetRandomColor_RGB1_ToHex(0.4, 0.85)
    local _, color_abgr = ConvertHexStringToNumbers(color_hex)
    obj.color1 = color_abgr

    color_hex = GetRandomColor_RGB1_ToHex(0.4, 0.85)
    _, color_abgr = ConvertHexStringToNumbers(color_hex)
    obj.color2 = color_abgr
    --------------------

    return obj
end

-- Takes in x,y
-- Returns
--  used height
function ModeList_Item:Draw_ORIG(screenOffset_x, screenOffset_y, x, y, width, scale)
    local height = 35 * scale

    local icon_size = 18


    -- topleft, bottomright
    Draw_Border(screenOffset_x, screenOffset_y, x + icon_size / 2, y + icon_size / 2, icon_size, icon_size, 0, false, self.color1, nil, nil, nil, 0, 1)
    Draw_Border(screenOffset_x, screenOffset_y, x + width - icon_size / 2, y + height - icon_size / 2, icon_size, icon_size, 0, false, self.color1, nil, nil, nil, 0, 1)



    -- boundry line
    Draw_Border(screenOffset_x, screenOffset_y, x + width / 2, y + height / 2, width, height, 0, false, nil, nil, self.color2, nil, 0, 1)

    return height
end

function ModeList_Item:Draw(screenOffset_x, screenOffset_y, x, y, width, scale)
    local height = 35 * scale

    this.DrawWindow(self.item, self.mode, self.vars_ui, screenOffset_x, screenOffset_y, x, y, width, height, self.const)

    return height
end

----------------------------------- Private Methods -----------------------------------

function this.DefineWindow(vars_ui, const)
    local item = {}

    item.modename = this.Define_ModeName(const)

    -- four buttons

    FinishDefiningWindow(item)

    return item
end

function this.DrawWindow(item, mode, vars_ui, screenOffset_x, screenOffset_y, x, y, width, height, const)
    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_ModeName(item.modename, mode)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(item.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(item.render_nodes, width, height, const, vars_ui.scale)
    AdjustPositions(item.render_nodes, x, y)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(item.modename, vars_ui.style.colors, vars_ui.scale)
end

function this.Define_ModeName(const)
    -- Label
    return
    {
        text = "",

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.top,
        },

        color = "instruction",

        CalcSize = CalcSize_Label,
    }
end
function this.Refresh_ModeName(def, mode)
    def.text = mode.name
end
