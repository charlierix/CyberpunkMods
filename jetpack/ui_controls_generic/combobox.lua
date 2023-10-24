local this = {}

-- def is models\viewmodels\ComboBox
-- style is models\stylesheet\ComboBox
-- line_heights is models\misc\LineHeights
function CalcSize_ComboBox(def, style, const, line_heights, scale)
    if not def.sizes then
        def.sizes = {}
    end

    this.Calculate_Sizes(def, style.combobox, line_heights, scale)

    def.render_pos.width = def.sizes.width
    def.render_pos.height = def.sizes.height
end

-- def is models\viewmodels\ComboBox
-- style is models\stylesheet\ComboBox
-- Returns
--  selected_item, selection_changed
function Draw_ComboBox(def, style_combo, scale)
    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, style_combo.padding * scale, style_combo.padding * scale)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, style_combo.border_cornerRadius * scale)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, style_combo.border_thickness)

    ImGui.PushStyleColor(ImGuiCol.NavHighlight, 0x00000000)
    ImGui.PushStyleColor(ImGuiCol.Border, style_combo.border_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBg, style_combo.background_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.PopupBg, style_combo.background_color_dropdown_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, style_combo.background_color_hover_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBgActive, style_combo.background_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.Text, style_combo.foreground_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.Header, style_combo.background_color_selected_abgr)
    ImGui.PushStyleColor(ImGuiCol.HeaderHovered, style_combo.background_color_hover_abgr)
    ImGui.PushStyleColor(ImGuiCol.HeaderActive, style_combo.background_color_click_abgr)
    ImGui.PushStyleColor(ImGuiCol.Button, style_combo.button_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_combo.button_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_combo.button_color_hover_abgr)
    ImGui.PushStyleColor(ImGuiCol.ScrollbarBg, style_combo.scrollbar_background_color_abgr)      -- NOTE: This color is applied over the background.  So if you want it the same color as background, it needs to be 0x00000000
    ImGui.PushStyleColor(ImGuiCol.ScrollbarGrab, style_combo.scrollbar_grab_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.ScrollbarGrabHovered, style_combo.scrollbar_grab_color_hover_abgr)
    ImGui.PushStyleColor(ImGuiCol.ScrollbarGrabActive, style_combo.scrollbar_grab_color_click_abgr)

    ImGui.SetCursorPos(def.render_pos.left, def.render_pos.top)
    ImGui.PushItemWidth(def.sizes.width)

    local prompt = def.preview_text
    if def.selected_item then
        prompt = def.selected_item
    end

    local selected_item = def.selected_item

    if ImGui.BeginCombo("##" .. def.invisible_name, prompt, ImGuiComboFlags.HeightLarge) then
        for _, item in ipairs(def.items) do
            if ImGui.Selectable(item, (item == def.selected_item)) then
                def.selected_item = item
            end
        end

        ImGui.EndCombo()
    end

    ImGui.PopItemWidth()

    ImGui.PopStyleColor(17)
    ImGui.PopStyleVar(3)

    return
        def.selected_item,
        def.selected_item ~= selected_item
end

----------------------------------- Private Methods -----------------------------------

function this.Calculate_Sizes(def, style_combo, line_heights, scale)
    -- Width
    local width = nil
    if def.width then
        -- An fixed width is defined
        width = def.width * scale

    else
        -- No fixed width, see how wide the text is
        width = 36 * scale

        if def.items then
            for i = 1, math.min(#def.items, 36), 1 do
                width = math.max(width, ImGui.CalcTextSize(def.items[i]))
            end
        end

        if def.selected_item then       -- selected_item is almost certainly one of items, but just in case items changes, it could be different
            width = math.max(width, ImGui.CalcTextSize(def.selected_item))
        elseif def.preview_text then
            width = math.max(width, ImGui.CalcTextSize(def.preview_text))
        end

        -- Accounting for down arrow (counted pixels)
        width = width + ((18 + (style_combo.padding * 2)) * scale)

        -- Grow if min_width says to
        if def.min_width and (def.min_width * scale) > width then
            width = def.min_width * scale
        end

        -- Shrink if larger than max
        if def.max_width and width > (def.max_width * scale) then
            width = def.max_width * scale
        end
    end

    -- Height
    local height = line_heights.line

    -- Store values
    def.sizes.width = width + ((style_combo.padding * 2) * scale)
    def.sizes.height = height + ((style_combo.padding * 2) * scale)
end