local this = {}

-- This shows a listbox that remembers the selected item
-- def is models\viewmodels\ListBox
-- style_list is models\stylesheet\ListBox
function Draw_ListBox(def, style_list, screenOffset_x, screenOffset_y, parent_width, parent_height, const)
    --TODO: Return a selection changed bool

    -- Calculate Position
    local left, top = GetControlPosition(def.position, def.width, def.height, parent_width, parent_height, const)

    -- Draw the listbox


    -- These don't do anything
    -- ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, style_list.background_color_hover_abgr)
    -- ImGui.PushStyleColor(ImGuiCol.FrameBgActive, style_list.background_color_click_abgr)
    -- ImGui.PushStyleColor(ImGuiCol.TextSelectedBg, 0xFFFF40FF)


    -- Header* colors are used for CollapsingHeader, TreeNode, Selectable, MenuItem
    -- ImGuiCol_Header,
    -- ImGuiCol_HeaderHovered,
    -- ImGuiCol_HeaderActive,

    -- ImGuiCol_ScrollbarBg,
    -- ImGuiCol_ScrollbarGrab,
    -- ImGuiCol_ScrollbarGrabHovered,
    -- ImGuiCol_ScrollbarGrabActive,


    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, style_list.padding, style_list.padding)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, style_list.border_cornerRadius)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, style_list.border_thickness)

    ImGui.PushStyleColor(ImGuiCol.Border, style_list.border_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBg, style_list.background_color_standard_abgr)

    ImGui.PushStyleColor(ImGuiCol.Header, style_list.background_color_selected_abgr)
    ImGui.PushStyleColor(ImGuiCol.HeaderHovered, style_list.background_color_hover_abgr)
    ImGui.PushStyleColor(ImGuiCol.HeaderActive, style_list.background_color_click_abgr)

    ImGui.PushStyleColor(ImGuiCol.Text, style_list.foreground_color_abgr)

    ImGui.PushStyleColor(ImGuiCol.ScrollbarBg, style_list.scrollbar_background_color_abgr)      -- NOTE: This color is applied over the background.  So if you want it the same color as background, it needs to be 0x00000000
    ImGui.PushStyleColor(ImGuiCol.ScrollbarGrab, style_list.scrollbar_grab_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.ScrollbarGrabHovered, style_list.scrollbar_grab_color_hover_abgr)
    ImGui.PushStyleColor(ImGuiCol.ScrollbarGrabActive, style_list.scrollbar_grab_color_click_abgr)

    ImGui.SetCursorPos(left, top)

    if ImGui.BeginListBox("##" .. def.invisible_name, def.width, def.height) then

        for i = 1, #def.items do
            if ImGui.Selectable(def.items[i] .. "##" .. def.invisible_name .. tostring(i), i == def.selected_index) then        -- the string must be unique, or the selected won't return true
                def.selected_index = i
            end

            -- if ImGui.IsItemClicked(ImGuiMouseButton.Left) then
            --     -- report a click?
            -- end
        end

        ImGui.EndListBox()
    end


    ImGui.PopStyleColor(10)
    ImGui.PopStyleVar(3)


    -- local x = left - 24
    -- Draw_Line(screenOffset_x, screenOffset_y, x, top, x, top + def.height, 0xFFFF40FF, 2)


end

----------------------------------- Private Methods -----------------------------------
