function DrawWindow_Trackball(vars, vars_ui, o, window, const)
    local style_trackball = vars_ui.style.trackball

    -- Use this so the window will snap to this size
    local total_size = style_trackball.size + (style_trackball.margin * 2)
    ImGui.SetCursorPos(0, window.title_height)
    ImGui.Dummy(total_size, total_size)

    local offset = 5        -- for some reason, everything is drawing a little negative left and up

    local center = (style_trackball.size / 2) + style_trackball.margin + offset

    local isClicked, isHovered = Draw_InvisibleButton("Trackball_Background", center, center + window.title_height, style_trackball.size - offset, style_trackball.size - offset, 0)
 
    Draw_Circle(window.left, window.top, center, center + window.title_height, style_trackball.size / 2, isHovered, style_trackball.glass_color_back_standard_abgr, style_trackball.glass_color_back_hovered_abgr, style_trackball.glass_color_border_standard_abgr, style_trackball.glass_color_border_hovered_abgr, style_trackball.glass_thickness)
    
    --TODO: Draw a faint arc to simulate sphere glass reflection
    --ImDrawList::PathArcTo (see if this is this a standalone function.  Other functions have the word add in them)

end