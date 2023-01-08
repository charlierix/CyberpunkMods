local this = {}

-- def is models\viewmodels\MultiItemDisplayList
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_MultiItemDisplayList(def, style, const, line_heights, scale)
    def.render_pos.width = def.width * scale
    def.render_pos.height = def.height * scale
end

-- This shows a readonly list of items
-- def is models\viewmodels\MultiItemDisplayList
-- style_list is models\stylesheet\MultiItemDisplayList
function Draw_MultiItemDisplayList(def, style_list, screenOffset_x, screenOffset_y, line_heights, scale)
    local left = def.render_pos.left
    local top = def.render_pos.top

    -- Border
    Draw_Border(screenOffset_x, screenOffset_y, left + ((def.width / 2) * scale), top + ((def.height / 2) * scale), def.width * scale, def.height * scale, 0, false, style_list.background_color_argb, nil, style_list.border_color_argb, nil, style_list.border_cornerRadius * line_heights.line, style_list.border_thickness)

    -- Sets
    ImGui.PushStyleColor(ImGuiCol.Text, style_list.foreground_color_abgr)

    local y_offset = style_list.padding * scale
    local isFirstSet = true

    for _, setKey in ipairs(def.sets_keys) do       -- sets_keys is sorted
        if isFirstSet then
            isFirstSet = false
        else
            -- Draw divider line
            y_offset = y_offset + (style_list.separator_gap_vert * scale)
            Draw_Line(screenOffset_x, screenOffset_y, left + ((style_list.padding + style_list.separator_gap_horz) * scale), top + y_offset, left + ((def.width - style_list.padding - style_list.separator_gap_horz) * scale), top + y_offset, style_list.separator_color_abgr, style_list.separator_thickness)
            y_offset = y_offset + (style_list.separator_gap_vert * scale)
        end

        -- Items in this set
        ImGui.SetCursorPos(left + (style_list.padding * scale), top + y_offset)
        ImGui.BeginGroup()      -- new lines stay at the same x value instead of going to zero

        for _, item in ipairs(def.items_sorted[setKey]) do       -- this is sorted
            ImGui.Text(item)
            y_offset = y_offset + line_heights.line + line_heights.gap
        end

        ImGui.EndGroup()
    end

    ImGui.PopStyleColor()
end

-- If the list is modified, call this to rebuild the indices
-- NOTE: This shouldn't be called while adding each item.  Call it once when finished
function MultiItemDisplayList_SetsChanged(def)
    def.sets_keys = this.GetSetsIndex(def.sets)

    def.items_sorted = {}

    for key, value in pairs(def.sets) do
        def.items_sorted[key] = this.GetItemsIndex(value)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetSetsIndex(sets)
    local sorted = {}

    for key in pairs(sets) do
        table.insert(sorted, key)
    end

    table.sort(sorted)

    return sorted
end
function this.GetItemsIndex(items)
    local sorted = {}

    for i = 1, #items do
        table.insert(sorted, items[i])
    end

    table.sort(sorted)

    return sorted
end