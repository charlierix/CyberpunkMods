-- def is models\viewmodels\ListBox
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_ListBox(def, style, const, line_heights, scale)
    def.render_pos.width = def.width * scale
    def.render_pos.height = def.height * scale
end

-- This shows a listbox that remembers the selected item
-- def is models\viewmodels\ListBox
-- style_list is models\stylesheet\ListBox
function Draw_ListBox(def, style_list, scale)
    --TODO: Return a selection changed bool (look for when the index changes after drawing a selectable)

    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, style_list.padding * scale, style_list.padding * scale)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, style_list.border_cornerRadius * scale)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, style_list.border_thickness)

    ImGui.PushStyleColor(ImGuiCol.Border, style_list.border_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBg, style_list.background_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.ScrollbarBg, style_list.scrollbar_background_color_abgr)      -- NOTE: This color is applied over the background.  So if you want it the same color as background, it needs to be 0x00000000
    ImGui.PushStyleColor(ImGuiCol.ScrollbarGrab, style_list.scrollbar_grab_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.ScrollbarGrabHovered, style_list.scrollbar_grab_color_hover_abgr)
    ImGui.PushStyleColor(ImGuiCol.ScrollbarGrabActive, style_list.scrollbar_grab_color_click_abgr)

    ImGui.SetCursorPos(def.render_pos.left, def.render_pos.top)

    if ImGui.BeginListBox("##" .. def.invisible_name, def.width * scale, def.height * scale) then
        if def.items then
            for i = 1, #def.items do
                local isSelectable = true
                if def.selectable and #def.selectable == #def.items and not def.selectable[i] then
                    -- The explicit array is populated and says this item can't be selected
                    isSelectable = false
                end

                if not isSelectable and def.selected_index == i then
                    -- It's not allowed to be selected, but was.  Set back to unselected
                    def.selected_index = 0
                end

                -- Don't want highlight color if an item can't be selected
                if isSelectable then
                    ImGui.PushStyleColor(ImGuiCol.Header, style_list.background_color_selected_abgr)
                    ImGui.PushStyleColor(ImGuiCol.HeaderHovered, style_list.background_color_hover_abgr)
                    ImGui.PushStyleColor(ImGuiCol.HeaderActive, style_list.background_color_click_abgr)
                else
                    ImGui.PushStyleColor(ImGuiCol.Header, 0x00000000)           -- this color is added over the listbox's background, so needs to be zero opactiy
                    ImGui.PushStyleColor(ImGuiCol.HeaderHovered, 0x00000000)
                    ImGui.PushStyleColor(ImGuiCol.HeaderActive, 0x00000000)
                end

                -- Foreground color
                local forecolor
                if isSelectable then
                    if def.selected_index == i then
                        forecolor = style_list.foreground_color_selected_abgr
                    else
                        forecolor = style_list.foreground_color_standard_abgr
                    end
                else
                    forecolor = style_list.foreground_color_disabled_abgr
                end
                ImGui.PushStyleColor(ImGuiCol.Text, forecolor)

                -- Show the item
                if ImGui.Selectable(def.items[i] .. "##" .. def.invisible_name .. tostring(i), def.selected_index == i) then        -- the string must be unique, or the selected won't return true
                    if isSelectable then
                        def.selected_index = i
                    end
                end

                ImGui.PopStyleColor(4)
            end
        end

        ImGui.EndListBox()
    end

    ImGui.PopStyleColor(6)
    ImGui.PopStyleVar(3)
end