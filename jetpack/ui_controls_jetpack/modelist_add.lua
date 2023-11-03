local this = {}
ModeList_Add = {}

function ModeList_Add:new(vars_ui, o, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.vars_ui = vars_ui
    obj.o = o
    obj.const = const

    obj.item = this.DefineWindow(vars_ui, const)

    -- See const.modelist_actions for what this could be (set when they push one of the buttons)
    obj.is_clicked = false

    return obj
end

function ModeList_Add:Draw(screenOffset_x, screenOffset_y, x, y, width, scale)
    local height = self.vars_ui.line_heights.line * scale

    self.is_clicked = this.DrawWindow(self.item, self.vars_ui, screenOffset_x, screenOffset_y, x, y, width, height, self.o, self.const)

    return height
end

--------------------------- Private Methods (Window Drawing) --------------------------

function this.DefineWindow(vars_ui, const)
    local item = {}

    item.invisbutton_invisname = "ModeList_Add_InvisibleButton"

    item.label = this.Define_Label(const)

    FinishDefiningWindow(item)

    return item
end

function this.DrawWindow(item, vars_ui, screenOffset_x, screenOffset_y, x, y, width, height, o, const)
    ------------------------- Finalize models for this frame -------------------------

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(item.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(item.render_nodes, width, height, const, vars_ui.scale)
    AdjustPositions(item.render_nodes, x, y)

    -------------------------------- Show ui elements --------------------------------

    local center_x = x + width / 2
    local center_y = y + height / 2

    local isClicked, isHovered = Draw_InvisibleButton(item.invisbutton_invisname, center_x, center_y, width, height, 0)

    if isHovered then
        Draw_Border(screenOffset_x, screenOffset_y, center_x, center_y, width, height, vars_ui.style.modelistitem.hover_padding, false, vars_ui.style.modelistitem.back_color_hover_abgr, nil, vars_ui.style.modelistitem.border_color_hover_abgr, nil, vars_ui.style.modelistitem.border_cornerRadius, vars_ui.style.modelistitem.border_thickness)
    end

    Draw_Label(item.label, vars_ui.style.colors, vars_ui.scale)

    return isClicked
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Label(const)
    -- Label
    return
    {
        text = "--- add ---",

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "modelistitem_add",

        CalcSize = CalcSize_Label,
    }
end