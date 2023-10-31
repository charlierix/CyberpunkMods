local this = {}

-- def is models\viewmodels\IconButton
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_IconButton(def, style, const, line_heights, scale)
    if not def.sizes then
        def.sizes = {}
    end

    this.Calculate_Sizes(def, style.iconbutton, scale)

    def.render_pos.width = def.sizes.width_height
    def.render_pos.height = def.sizes.width_height
end

-- def is models\viewmodels\IconButton
-- style_button is models\stylesheet\IconButton
-- Returns:
--  isClicked
function Draw_IconButton(def, style_iconbutton, screenOffset_x, screenOffset_y, scale)
    local left = def.render_pos.left
    local top = def.render_pos.top

    -- Invisible Button
    local clickableSize
    if def.is_circle then
        clickableSize = def.sizes.width_height * 0.85
    else
        clickableSize = def.sizes.width_height
    end

    local isClicked, isHovered = Draw_InvisibleButton(def.invisible_name, left + def.sizes.center_x, top + def.sizes.center_y, clickableSize, clickableSize, 0)

    local color_back, color_fore, color_border = this.GetColors(def.isEnabled, isClicked, isHovered, style_iconbutton)

    -- Border
    if def.is_circle then
        Draw_Circle(screenOffset_x, screenOffset_y, left + def.sizes.center_x, top + def.sizes.center_y, def.sizes.radius, false, color_back, nil, color_border, nil, style_iconbutton.border_thickness)
    else
        Draw_Border(screenOffset_x, screenOffset_y, left + def.sizes.center_x, top + def.sizes.center_y, def.sizes.width_height, def.sizes.width_height, 0, false, color_back, nil, color_border, nil, style_iconbutton.border_cornerRadius, style_iconbutton.border_thickness)
    end





    --TODO: show tooltip




    return isClicked, isHovered
end

----------------------------------- Private Methods -----------------------------------

-- Returns back, fore, border
function this.GetColors(isEnabled, isClicked, isHovered, style_iconbutton)
    if not isEnabled then
        return
            style_iconbutton.disabled_back_color_abgr,
            style_iconbutton.disabled_fore_color_abgr,
            style_iconbutton.disabled_border_color_abgr

    elseif isClicked then
        return
            style_iconbutton.back_color_click_abgr,
            style_iconbutton.foreground_color_click_abgr,
            style_iconbutton.border_color_abgr

    elseif isHovered then
        return
            style_iconbutton.back_color_hover_abgr,
            style_iconbutton.foreground_color_hover_abgr,
            style_iconbutton.border_color_abgr

    else
        return
            style_iconbutton.back_color_standard_abgr,
            style_iconbutton.foreground_color_standard_abgr,
            style_iconbutton.border_color_abgr
    end
end

function this.Calculate_Sizes(def, style_iconbutton, scale)
    local width_height = style_iconbutton.width_height
    if def.width_height then
        width_height = def.width_height
    end

    def.sizes.width_height = width_height * scale
    def.sizes.radius = def.sizes.width_height / 2

    def.sizes.center_x = def.sizes.width_height / 2
    def.sizes.center_y = def.sizes.width_height / 2
end