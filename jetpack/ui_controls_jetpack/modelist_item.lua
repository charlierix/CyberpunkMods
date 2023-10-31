local this = {}
ModeList_Item = {}

function ModeList_Item:new(mode, vars_ui, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.mode = mode
    obj.vars_ui = vars_ui
    obj.const = const

    obj.item = this.DefineWindow(mode, vars_ui, const)

    return obj
end

function ModeList_Item:Draw(screenOffset_x, screenOffset_y, x, y, width, scale)
    local height = 45 * scale

    this.DrawWindow(self.item, self.mode, self.vars_ui, screenOffset_x, screenOffset_y, x, y, width, height, self.const)

    return height
end

----------------------------------- Private Methods -----------------------------------

function this.DefineWindow(mode, vars_ui, const)
    local item = {}

    local invisible_name_suffix = ""
    if mode then
        invisible_name_suffix = tostring(mode.mode_key)
    end

    item.modename = this.Define_ModeName(const)

    item.button_up = this.Define_Button_Up(invisible_name_suffix, const)
    item.button_down = this.Define_Button_Down(item.button_up, invisible_name_suffix, const)

    item.button_delete = this.Define_Button_Delete(item.button_up, invisible_name_suffix, const)
    item.button_clone = this.Define_Button_Clone(item.button_delete, invisible_name_suffix, const)
    item.button_edit = this.Define_Button_Edit(item.button_clone, invisible_name_suffix, const)

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

    --TODO: only draw buttons if mouse is over this entry

    if Draw_IconButton(item.button_up, vars_ui.style.iconbutton, screenOffset_x, screenOffset_y, vars_ui.scale) then
        --TODO: raise event
    end

    if Draw_IconButton(item.button_down, vars_ui.style.iconbutton, screenOffset_x, screenOffset_y, vars_ui.scale) then
        --TODO: raise event
    end

    if Draw_IconButton(item.button_delete, vars_ui.style.iconbutton, screenOffset_x, screenOffset_y, vars_ui.scale) then
        --TODO: raise event
    end

    if Draw_IconButton(item.button_clone, vars_ui.style.iconbutton, screenOffset_x, screenOffset_y, vars_ui.scale) then
        --TODO: raise event
    end

    if Draw_IconButton(item.button_edit, vars_ui.style.iconbutton, screenOffset_x, screenOffset_y, vars_ui.scale) then
        --TODO: raise event
    end
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

function this.Define_Button_Up(invisible_name_suffix, const)
    local icon_data =
    [[
    ]]

    -- IconButton
    return
    {
        invisible_name = "ModeList_Item_" .. invisible_name_suffix .. "_Up",

        tooltip = "Move up in the list",

        icon_data = icon_data,

        isEnabled = true,

        is_circle = false,

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_IconButton,
    }
end

function this.Define_Button_Down(relative_to, invisible_name_suffix, const)
    local icon_data =
    [[
    ]]

    -- IconButton
    return
    {
        invisible_name = "ModeList_Item_" .. invisible_name_suffix .. "_Down",

        tooltip = "Move down in the list",

        icon_data = icon_data,

        isEnabled = true,

        is_circle = false,

        position =
        {
            relative_to = relative_to,

            pos_x = 4,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_IconButton,
    }
end

function this.Define_Button_Delete(relative_to, invisible_name_suffix, const)
    local icon_data =
    [[
    ]]

    -- IconButton
    return
    {
        invisible_name = "ModeList_Item_" .. invisible_name_suffix .. "_Delete",

        tooltip = "Remove",

        icon_data = icon_data,

        isEnabled = true,

        is_circle = false,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 4,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_IconButton,
    }
end

function this.Define_Button_Clone(relative_to, invisible_name_suffix, const)
    local icon_data =
    [[
    ]]

    -- IconButton
    return
    {
        invisible_name = "ModeList_Item_" .. invisible_name_suffix .. "_Clone",

        tooltip = "Clone Mode",

        icon_data = icon_data,

        isEnabled = true,

        is_circle = false,

        position =
        {
            relative_to = relative_to,

            pos_x = 4,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_IconButton,
    }
end

function this.Define_Button_Edit(relative_to, invisible_name_suffix, const)
    local icon_data =
    [[
    ]]

    -- IconButton
    return
    {
        invisible_name = "ModeList_Item_" .. invisible_name_suffix .. "_Edit",

        tooltip = "Edit Mode",

        icon_data = icon_data,

        isEnabled = true,

        is_circle = false,

        position =
        {
            relative_to = relative_to,

            pos_x = 4,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_IconButton,
    }
end