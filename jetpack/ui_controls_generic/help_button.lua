local this = {}
local character = "?"       --"i"  (i might look better if it would be centered)

-- def is models\viewmodels\HelpButton
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_HelpButton(def, style, const, line_heights, scale)
    if not def.sizes then
        def.sizes = {}
    end

    this.Calculate_Sizes(def, style.helpButton, scale)

    def.render_pos.width = def.sizes.width
    def.render_pos.height = def.sizes.height
end

-- Draws a button that is a ? with a circle around it.  Used as a button to show additional
-- information
-- def is models\viewmodels\HelpButton
-- style_help is models\stylesheet\HelpButton
-- Returns:
--  isClicked, isHovered
function Draw_HelpButton(def, style_help, screenOffset_x, screenOffset_y, vars_ui, const)
    local left = def.render_pos.left
    local top = def.render_pos.top

    -- Invisible Button
    local clickableSize = (style_help.radius * 0.85 * 2) * vars_ui.scale
    local isClicked, isHovered = Draw_InvisibleButton(def.invisible_name, left + def.sizes.center_x, top + def.sizes.center_y, clickableSize, clickableSize, 0)

    -- Circle
    Draw_Circle(screenOffset_x, screenOffset_y, left + def.sizes.center_x, top + def.sizes.center_y, style_help.radius * vars_ui.scale, isHovered, style_help.back_color_standard_abgr, style_help.back_color_hover_abgr, style_help.border_color_standard_abgr, style_help.border_color_hover_abgr, style_help.border_thickness)

    -- Text
    ImGui.SetCursorPos(left + def.sizes.text_left, top + def.sizes.text_top)

    if isHovered then
        ImGui.PushStyleColor(ImGuiCol.Text, style_help.foreground_color_hover_abgr)
    else
        ImGui.PushStyleColor(ImGuiCol.Text, style_help.foreground_color_standard_abgr)
    end

    ImGui.Text(character)
    ImGui.PopStyleColor()

    if isHovered and def.tooltip then
        local notouch = (style_help.radius + 12) * vars_ui.scale
        Draw_Tooltip(def.tooltip, vars_ui.style.tooltip, screenOffset_x + left + def.sizes.center_x, screenOffset_y + top + def.sizes.center_y, notouch, notouch, vars_ui)
    end

    return isClicked, isHovered
end

----------------------------------- Private Methods -----------------------------------

function this.Calculate_Sizes(def, style_help, scale)
    local width, height = ImGui.CalcTextSize(character)

    local radius = style_help.radius * scale

    def.sizes.text_left = radius - (width / 2)
    def.sizes.text_top = radius - (height / 2)      -- NOTE: if radius is smaller than the text, this will be negative.  But that's ok, the control will be placed according to radius
    def.sizes.center_x = radius
    def.sizes.center_y = radius
    def.sizes.width = radius * 2
    def.sizes.height = radius * 2
end