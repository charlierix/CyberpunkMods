local this = {}
ModeList_Item = {}

function ModeList_Item:new(token, mode, vars_ui, o, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.token = token
    obj.mode = mode
    obj.vars_ui = vars_ui
    obj.o = o
    obj.const = const

    obj.item = this.DefineWindow(token, mode, vars_ui, const)

    -- See const.modelist_actions for what this could be (set when they push one of the buttons)
    obj.action_instruction = nil

    return obj
end

function ModeList_Item:Draw(screenOffset_x, screenOffset_y, x, y, width, scale)
    local height = this.GetItemHeight(self.item, screenOffset_y, y, scale)

    self.action_instruction = this.DrawWindow(self.item, self.mode, self.vars_ui, screenOffset_x, screenOffset_y, x, y, width, height, self.o, self.const)

    return height
end

--------------------------- Private Methods (Window Drawing) --------------------------

function this.DefineWindow(token, mode, vars_ui, const)
    local item = {}

    local invisible_name_suffix = tostring(token)
    item.invisbutton_invisname = "ModeList_Item_" .. invisible_name_suffix .. "_InvisibleButton"

    item.modename = this.Define_ModeName(const)

    item.description = this.Define_Description(item.modename, const)

    --TODO: indicate if currently selected

    item.button_up = this.Define_Button_Up(invisible_name_suffix, const)
    item.button_down = this.Define_Button_Down(item.button_up, invisible_name_suffix, const)

    item.button_delete = this.Define_Button_Delete(item.button_up, invisible_name_suffix, const)
    item.button_clone = this.Define_Button_Clone(item.button_delete, invisible_name_suffix, const)
    item.button_edit = this.Define_Button_Edit(item.button_clone, invisible_name_suffix, const)

    FinishDefiningWindow(item)

    item.height = (vars_ui.style.iconbutton.width_height * 2) + 4       -- icons are the tallest part without description (2 + gap).  Draw function will fall back on this if render_pos and render_size are unknown

    return item
end

function this.DrawWindow(item, mode, vars_ui, screenOffset_x, screenOffset_y, x, y, width, height, o, const)
    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_ModeName(item.modename, mode)

    this.Refresh_Description(item.description, mode, item.button_edit, width, vars_ui.scale)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(item.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(item.render_nodes, width, height, const, vars_ui.scale)
    AdjustPositions(item.render_nodes, x, y)

    -------------------------------- Show ui elements --------------------------------

    local center_x = x + width / 2
    local center_y = y + height / 2

    local isClicked, isHovered = Draw_InvisibleButton(item.invisbutton_invisname, center_x, center_y, width, height, 0)
    ImGui.SetItemAllowOverlap()     -- without this, the iconbuttons won't get click event

    if isClicked or isHovered then
        item.is_mouse_over = o.timer     -- need the buttons to stay visible for the mouse down and up to occur.  While this works, it has a side effect of leaving the buttons up while they mouse over a different item
    end

    if isHovered then
        --Draw_Border(screenOffset_x, screenOffset_y, center_x, center_y, width, height, vars_ui.style.modelistitem.hover_padding, false, vars_ui.style.modelistitem.back_color_hover_abgr, nil, vars_ui.style.modelistitem.border_color_hover_abgr, nil, vars_ui.style.modelistitem.border_cornerRadius, vars_ui.style.modelistitem.border_thickness)
        Draw_Border(screenOffset_x, screenOffset_y, center_x, center_y, width, height, vars_ui.style.modelistitem.hover_padding, false, vars_ui.style.modelistitem.back_color_hover_abgr, nil, vars_ui.style.modelistitem.border_color_hover_abgr, nil, vars_ui.style.modelistitem.border_cornerRadius, vars_ui.style.modelistitem.border_thickness)
    end

    Draw_Label(item.modename, vars_ui.style.colors, vars_ui.scale)

    Draw_Label(item.description, vars_ui.style.colors, vars_ui.scale)

    local action_instruction = nil

    -- Only draw buttons if mouse is over this entry
    if item.is_mouse_over and o.timer - item.is_mouse_over < 0.18 then
        local bar_center_x, bar_center_y, bar_width, bar_height = this.GetIconBarBounds(vars_ui.style.modelistitem.iconbar_margin, 1, vars_ui.scale, item.button_up, item.button_down, item.button_delete, item.button_clone, item.button_edit)
        if bar_center_x then
            Draw_Border(screenOffset_x, screenOffset_y, bar_center_x, bar_center_y, bar_width, bar_height, 0, false, vars_ui.style.modelistitem.iconbar_color_abgr, nil, nil, nil, vars_ui.style.modelistitem.border_cornerRadius, nil)
        end

        if Draw_IconButton(item.button_up, vars_ui, screenOffset_x, screenOffset_y, vars_ui.scale) then
            action_instruction = const.modelist_actions.move_up
        end

        if Draw_IconButton(item.button_down, vars_ui, screenOffset_x, screenOffset_y, vars_ui.scale) then
            action_instruction = const.modelist_actions.move_down
        end

        if Draw_IconButton(item.button_delete, vars_ui, screenOffset_x, screenOffset_y, vars_ui.scale) then
            action_instruction = const.modelist_actions.delete
        end

        if Draw_IconButton(item.button_clone, vars_ui, screenOffset_x, screenOffset_y, vars_ui.scale) then
            action_instruction = const.modelist_actions.clone
        end

        if Draw_IconButton(item.button_edit, vars_ui, screenOffset_x, screenOffset_y, vars_ui.scale) then
            action_instruction = const.modelist_actions.edit
        end

        if isClicked then
            action_instruction = const.modelist_actions.edit        -- if they click on the entry background, also consider that as an edit
        end
    end

    return action_instruction
end

----------------------------------- Private Methods -----------------------------------

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

        color = "modelistitem_name",

        CalcSize = CalcSize_Label,
    }
end
function this.Refresh_ModeName(def, mode)
    def.text = mode.name
end

function this.Define_Description(relative_to, const)
    -- Label
    return
    {
        text = "Sample Description",

        position =
        {
            relative_to = relative_to,

            pos_x = 8,
            pos_y = 4,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "modelistitem_description",

        CalcSize = CalcSize_Label,
    }
end
function this.Refresh_Description(def, mode, leftmost_button, width, scale)
    def.text = mode.description

    local max_width = nil

    ---------------------------------- Attempt 1 ----------------------------------

    -- This works, but it leaves a big empty space along the right.  It would be better if the description went the full width,
    -- and the buttons just draw over top


    -- Width is passed into the draw
    -- max_right needs to account for the width of the icons
    --  item.button_edit.def.render_pos.left, which won't be populated until a frame has fully drawn
    -- max_width is max_right - def.left
    -- be sure to account for scale
    -- may need to wait a frame before def.render_pos.left is populated

    -- if def.render_pos and def.render_pos.left and leftmost_button.render_pos and leftmost_button.render_pos.left then
    --     local gap = 4

    --     if leftmost_button.render_pos.left > def.render_pos.left + gap then
    --         max_width = (leftmost_button.render_pos.left - def.render_pos.left - gap) / scale
    --     end
    -- end

    ---------------------------------- Attempt 2 ----------------------------------

    if def.render_pos and def.render_pos.left then
        local margin = def.render_pos.left * 2

        if width - margin > 0 then
            max_width = (width - margin) / scale
        end
    end

    -------------------------------------------------------------------------------

    def.max_width = max_width
end

function this.Define_Button_Up(invisible_name_suffix, const)
    local icon_data =
    [[
        arrow 0.5 0.85 0.5 0.15 2.3
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
        arrow 0.5 0.15 0.5 0.85 2.3
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
    local shift = 0.025     -- the border circle is shifted by a pixel, which makes the X seem off center
    local xy = 0.27

    local xy1 = tostring(xy - shift)
    local xy2 = tostring(1 - xy - shift)

    local icon_data = ""
    icon_data = icon_data .. "line " .. xy1 .. " " .. xy1 .. " " .. xy2 .. " " .. xy2 .. " 3 "
    icon_data = icon_data .. "line " .. xy1 .. " " .. xy2 .. " " .. xy2 .. " " .. xy1 .. " 3"

    -- IconButton
    return
    {
        invisible_name = "ModeList_Item_" .. invisible_name_suffix .. "_Delete",

        tooltip = "Remove",

        icon_data = icon_data,

        isEnabled = true,

        is_circle = true,

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
        rect 0.35 0.35 0.9 0.9 2
        line 0.625 0.45 0.625 0.8 1.5
        line 0.45 0.625 0.8 0.625 1.5

        line 0.1 0.1 0.65 0.1 2
        line 0.65 0.1 0.65 0.25 2

        line 0.1 0.1 0.1 0.65 2
        line 0.1 0.65 0.25 0.65 2
    ]]

    -- IconButton
    return
    {
        invisible_name = "ModeList_Item_" .. invisible_name_suffix .. "_Clone",

        tooltip = "Clone",

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
        line 0.1 0.9 0.1 0.25 2
        line 0.1 0.25 0.55 0.25 2

        line 0.1 0.9 0.75 0.9 2
        line 0.75 0.9 0.75 0.45 2
    ]]

    local pencil = this.GetPencilCoords(0.87, 0.13, 0.3, 0.7, 0.1)

    local thickness = 1.5
    for _, coords in ipairs(pencil) do
        icon_data = icon_data .. "\nline " .. tostring(coords[1]) .. " " .. tostring(coords[2]) .. " " .. tostring(coords[3]) .. " " .. tostring(coords[4]) .. " " .. tostring(thickness)
    end

    -- IconButton
    return
    {
        invisible_name = "ModeList_Item_" .. invisible_name_suffix .. "_Edit",

        tooltip = "Edit",

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

-- Copied from util_controls GetArrowCoords()
-- Returns
--  List of 4 element arrays { {x1, y1, x2, y2}, {x1, y1, x2, y2}, ... }
function this.GetPencilCoords(x1, y1, x2, y2, width)
    local half_width = width / 2

    local magnitude = GetVectorLength2D(x2 - x1, y2 - y1)

    -- Get a unit vector that goes 1 -> 2
    local along_unit_x = (x2 - x1) / magnitude
    local along_unit_y = (y2 - y1) / magnitude

    -- Now get two unit vectors that point away
    local orth_unit_x1 = -along_unit_y
    local orth_unit_y1 = along_unit_x

    local orth_unit_x2 = along_unit_y
    local orth_unit_y2 = -along_unit_x

    -- Figure out the length of the tip.  Keep the width=7 length=10 ratio
    local tip_len = width * (10 / 7)

    -- Subtract back from the tip (base of the triangle portion)
    local base_x = x2 - along_unit_x * tip_len
    local base_y = y2 - along_unit_y * tip_len

    local retVal = {}

    -- Eraser Edge
    table.insert(retVal,
    {
        x1 + orth_unit_x1 * half_width,
        y1 + orth_unit_y1 * half_width,
        x1 + orth_unit_x2 * half_width,
        y1 + orth_unit_y2 * half_width,
    })

    -- Shaft Top
    table.insert(retVal,
    {
        x1 + orth_unit_x1 * half_width,
        y1 + orth_unit_y1 * half_width,
        base_x + orth_unit_x1 * half_width,
        base_y + orth_unit_y1 * half_width,
    })

    -- Shaft Bottom
    table.insert(retVal,
    {
        x1 + orth_unit_x2 * half_width,
        y1 + orth_unit_y2 * half_width,
        base_x + orth_unit_x2 * half_width,
        base_y + orth_unit_y2 * half_width,
    })

    -- Tip Top
    table.insert(retVal,
    {
        x2,
        y2,
        base_x + orth_unit_x1 * half_width,
        base_y + orth_unit_y1 * half_width,
    })

    -- Tip Bottom
    table.insert(retVal,
    {
        x2,
        y2,
        base_x + orth_unit_x2 * half_width,
        base_y + orth_unit_y2 * half_width,
    })

    return retVal
end

-- Takes in the icon buttons and returns dimensions to draw a bar under them
function this.GetIconBarBounds(margin_left_down, margin_right_up, scale, ...)
    local min_x = nil
    local min_y = nil
    local max_x = nil
    local max_y = nil

    for i = 1, select("#", ...) do
        local button = select(i, ...)

        if button.render_pos then
            local left = button.render_pos.left
            local top = button.render_pos.top
            local right = left + button.render_pos.width
            local bottom = top + button.render_pos.height

            if min_x then
                min_x = math.min(min_x, left)
            else
                min_x = left
            end

            if min_y then
                min_y = math.min(min_y, top)
            else
                min_y = top
            end

            if max_x then
                max_x = math.max(max_x, right)
            else
                max_x = right
            end

            if max_y then
                max_y = math.max(max_y, bottom)
            else
                max_y = bottom
            end
        end
    end

    if not min_x then
        return nil, nil, nil, nil
    end

    min_x = min_x - (margin_left_down * scale)
    min_y = min_y - (margin_right_up * scale)
    max_x = max_x + (margin_right_up * scale)
    max_y = max_y + (margin_left_down * scale)

    local width = max_x - min_x
    local height = max_y - min_y

    return
        min_x + width / 2,
        min_y + height / 2,
        width,
        height
end

function this.GetItemHeight(item, screenOffset_y, y, scale)
    local max_y = this.GetMaxY(item.render_nodes)

    local height = 0

    if max_y > 0 then       -- stuff will be nil the first frame, then positions will stabalize
        height = max_y - y
    else
        height = item.height * scale
    end

    height = height + (8 * scale)       -- add gap to the bottom

    return height
end

function this.GetMaxY(render_nodes)
    if not render_nodes or #render_nodes == 0 then
        return 0
    end

    local max_y = 0

    for _, node in ipairs(render_nodes) do
        local render_pos = node.control.render_pos

        if render_pos then      -- this will be nil the first frame
            local current_y = render_pos.top + render_pos.height

            max_y = math.max(max_y, current_y)
        end

        -- Recurse
        if node.children then
            max_y = math.max(max_y, this.GetMaxY(node.children))
        end
    end

    return max_y
end