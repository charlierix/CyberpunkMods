-- def is models\viewmodels\StackPanel
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_StackPanel(def, style, const, line_heights, scale)
    def.render_pos.width = def.width * scale
    def.render_pos.height = def.height * scale
end

-- This shows a listbox frame containing controls (StackPanelItem)
-- NOTE: reusing listbox's style to avoid duplication
-- def is models\viewmodels\StackPanel
-- style_list is models\stylesheet\ListBox
function Draw_StackPanel(def, style_list, screenOffset_x, screenOffset_y, scale)
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
            screenOffset_x = screenOffset_x + def.render_pos.left
            screenOffset_y = screenOffset_y + def.render_pos.top - ImGui.GetScrollY()

            -- Calculate available width

            --local scrollbar_width = ImGui.GetStyleVar(ImGuiStyleVar.ScrollbarSize)        -- this function doesn't exist (SetStyleVar does, but no get).  CET's imgui helper shows max as 20, so just going with that

            -- some other possibly helpful functions:
            --  GetItemRectMin()        -- these three are for the most recently created item
            --  GetItemRectMax()
            --  GetItemRectSize()

            --  GetScrollMaxY()         -- after all items are added, call this to see if it's > height.  Remember that for next frame


            local inner_width = (def.width - 20 - 6) * scale        -- scrollbar width + a gap



            for _, item in ipairs(def.items) do
                local inner_left, inner_top = ImGui.GetCursorPos()

                local height = item:Draw(screenOffset_x, screenOffset_y, inner_left, inner_top, inner_width, scale)

                ImGui.SetCursorPos(inner_left, inner_top + height)
                ImGui.Spacing()
            end
        end

        ImGui.EndListBox()
    end

    ImGui.PopStyleColor(6)
    ImGui.PopStyleVar(3)
end