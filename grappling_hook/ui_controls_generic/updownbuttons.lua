local this = {}

-- def is models\viewmodels\UpDownButtons
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_UpDownButtons(def, style, const, line_heights, scale)
    if not def.sizes then
        def.sizes = {}
    end

    local text_down, text_up = this.FinalText(def)

    this.Calculate_Sizes(def, style.updownButtons, text_down, text_up, scale)

    def.render_pos.width = def.sizes.width
    def.render_pos.height = def.sizes.height
end

-- Draws a pair of + - buttons, either horizontal or vertical orientations
-- def is models\viewmodels\UpDownButtons
-- style_updown is models\stylesheet\UpDownButtons
-- Returns:
--  isDownClicked, isUpClicked, isHovered
function Draw_UpDownButtons(def, style_updown, scale)
    -- Invisible Buttons (needed because text must be unique across the window for click to register)
    local isDownClicked, isDownHovered = Draw_InvisibleButton(def.invisible_name .. "Down", def.render_pos.left + def.sizes.down_left + (def.sizes.down_width / 2), def.render_pos.top + def.sizes.down_top + (def.sizes.down_height / 2), def.sizes.down_width, def.sizes.down_height, 0)
    local isUpClicked, isUpHovered = Draw_InvisibleButton(def.invisible_name .. "Up", def.render_pos.left + def.sizes.up_left + (def.sizes.up_width / 2), def.render_pos.top + def.sizes.up_top + (def.sizes.up_height / 2), def.sizes.up_width, def.sizes.up_height, 0)

    -- Concatenate +- with model's text
    local text_down, text_up = this.FinalText(def)

    -- Common properties
    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, style_updown.border_cornerRadius * scale)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, style_updown.border_thickness)

    ImGui.PushStyleColor(ImGuiCol.NavHighlight, 0x00000000)

    -- Down
    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, def.sizes.down_pad_h, def.sizes.down_pad_v)

    if def.isEnabled_down then
        if def.isFree_down then
            local color = this.GetButtonColor(isDownClicked, isDownHovered, style_updown.free_color_standard_abgr, style_updown.free_color_hover_abgr, style_updown.free_color_click_abgr)
            ImGui.PushStyleColor(ImGuiCol.Button, color)
            --ImGui.PushStyleColor(ImGuiCol.Button, style_updown.free_color_standard_abgr)
            ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_updown.free_color_hover_abgr)        -- this will never get used (because invisible is covering), but there's no harm in setting it
            ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_updown.free_color_click_abgr)
        else
            local color = this.GetButtonColor(isDownClicked, isDownHovered, style_updown.down_color_standard_abgr, style_updown.down_color_hover_abgr, style_updown.down_color_click_abgr)
            ImGui.PushStyleColor(ImGuiCol.Button, color)
            --ImGui.PushStyleColor(ImGuiCol.Button, style_updown.down_color_standard_abgr)
            ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_updown.down_color_hover_abgr)
            ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_updown.down_color_click_abgr)
        end

        ImGui.PushStyleColor(ImGuiCol.Text, style_updown.foreground_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.Border, style_updown.border_color_abgr)
    else
        ImGui.PushStyleColor(ImGuiCol.Button, style_updown.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_updown.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_updown.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.Text, style_updown.disabled_fore_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.Border, style_updown.disabled_border_color_abgr)
    end

    ImGui.SetCursorPos(def.render_pos.left + def.sizes.down_left, def.render_pos.top + def.sizes.down_top)

    --NOTE: can't rely on this button's click, because text must be unique across the entire window
    ImGui.Button(text_down)       -- this bool is ANDed with isEnabled at the bottom of this function

    ImGui.PopStyleColor(5)
    ImGui.PopStyleVar(1)

    -- Up
    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, def.sizes.up_pad_h, def.sizes.up_pad_v)

    if def.isEnabled_up then
        if def.isFree_up then
            local color = this.GetButtonColor(isUpClicked, isUpHovered, style_updown.free_color_standard_abgr, style_updown.free_color_hover_abgr, style_updown.free_color_click_abgr)
            ImGui.PushStyleColor(ImGuiCol.Button, color)
            --ImGui.PushStyleColor(ImGuiCol.Button, style_updown.free_color_standard_abgr)
            ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_updown.free_color_hover_abgr)
            ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_updown.free_color_click_abgr)
        else
            local color = this.GetButtonColor(isUpClicked, isUpHovered, style_updown.up_color_standard_abgr, style_updown.up_color_hover_abgr, style_updown.up_color_click_abgr)
            ImGui.PushStyleColor(ImGuiCol.Button, color)
            --ImGui.PushStyleColor(ImGuiCol.Button, style_updown.up_color_standard_abgr)
            ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_updown.up_color_hover_abgr)
            ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_updown.up_color_click_abgr)
        end

        ImGui.PushStyleColor(ImGuiCol.Text, style_updown.foreground_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.Border, style_updown.border_color_abgr)
    else
        ImGui.PushStyleColor(ImGuiCol.Button, style_updown.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_updown.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_updown.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.Text, style_updown.disabled_fore_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.Border, style_updown.disabled_border_color_abgr)
    end

    ImGui.SetCursorPos(def.render_pos.left + def.sizes.up_left, def.render_pos.top + def.sizes.up_top)

    ImGui.Button(text_up)

    ImGui.PopStyleColor(5)
    ImGui.PopStyleVar(1)

    -- /Common properties
    ImGui.PopStyleColor(1)
    ImGui.PopStyleVar(2)

    return
        isDownClicked and def.isEnabled_down,
        isUpClicked and def.isEnabled_up,
        isDownHovered or isUpHovered
end

-- This tells what values should go in the decrement and increment (called each frame)
-- Params:
--  valueUpdates: models\ValueUpdates
--  currentValue: this is the current value of the property that the up/down buttons will modify
-- Returns:
--  decrement or nil
--  increment or nil
--  isFree_down
--  isFree_up
function GetDecrementIncrement(valueUpdates, currentValue, currentExperience)
    local dec = nil
    local inc = nil

    if valueUpdates.getDecrementIncrement then
        -- The values are defined by a function
        -- NOTE: valueUpdates.getDecrementIncrement is a string that is a reference to the actual function to call
        dec, inc = CallReferenced_DecrementIncrement(valueUpdates.getDecrementIncrement, currentValue)
    else
        -- The values are simple constants
        dec = valueUpdates.amount
        inc = valueUpdates.amount
    end

    if inc and valueUpdates.min and currentValue + inc <= valueUpdates.min then
        -- Even after incrementing, the value will be less than min (which means there's min_abs).  So inc can stay
        -- populated
    elseif (not IsNearValue(currentExperience, 1)) and currentExperience < 1 then
        -- There's not enough experience to apply the increment
        inc = nil
    end

    if dec then
        if valueUpdates.min_abs and currentValue - dec < valueUpdates.min_abs and not IsNearValue(currentValue - dec, valueUpdates.min_abs) then
            -- Decrementing would make it less than min_abs
            dec  = nil
        elseif not valueUpdates.min_abs and valueUpdates.min and currentValue - dec < valueUpdates.min and not IsNearValue(currentValue - dec, valueUpdates.min) then
            -- Decrementing would make it less than min (and there's no min_abs)
            dec = nil
        end
    end

    if inc and valueUpdates.max and currentValue + inc > valueUpdates.max and not IsNearValue(currentValue + inc, valueUpdates.max) then
        -- Incrementing would make it greater than max
        inc = nil
    end

    local isFree_down = true
    if dec and valueUpdates.min and currentValue > valueUpdates.min then        -- not subtracting dec in this compare, because it's enough that they start above min.  It doesn't matter if the subtraction puts them below/at/above min
        -- Decrementing will cause the player to gain xp (selling stats for xp)
        isFree_down = false
    end

    local isFree_up = true
    if inc and valueUpdates.min and currentValue + inc > valueUpdates.min then      -- it doesn't matter where the starting point was
        -- Incrementing will cause the player to lose xp (buying stats with xp)
        isFree_up = false
    end

    return dec, inc, isFree_down, isFree_up
end

------------------------------------------- Private Methods -------------------------------------------

function this.FinalText(def)
    local text_down = "-"
    if def.text_down and def.text_down ~= "" then
        text_down = text_down .. def.text_down
    end

    local text_up = "+"
    if def.text_up and def.text_up ~= "" then
        text_up = text_up .. def.text_up
    end

    return text_down, text_up
end

-- Since the invisible buttons cover the regular buttons, the standard color is the only style that's looked at
function this.GetButtonColor(isClicked, isHovered, color_standard_abgr, color_hover_abgr, color_click_abgr)
    if isClicked then
        return color_click_abgr
    elseif isHovered then
        return color_hover_abgr
    else
        return color_standard_abgr
    end
end

function this.Calculate_Sizes(def, style_updown, text_down, text_up, scale)
    -- Individual Sizes
    local down_width, down_height = this.Calculate_Sizes_Single(text_down, style_updown, scale)
    local up_width, up_height = this.Calculate_Sizes_Single(text_up, style_updown, scale)

    -- The buttons need to be the same size, so take the larger values
    local width = math.max(down_width, up_width)
    local height = math.max(down_height, up_height)

    -- Store filler size
    local down_width_extra = width - down_width
    local down_height_extra = height - down_height
    local up_width_extra = width - up_width
    local up_height_extra = height - up_height

    -- Final Size/Position
    local down_left = 0
    local down_top = 0
    local up_left = 0
    local up_top = 0
    local width_final = width
    local height_final = height

    if def.isHorizontal then
        up_left = width + (style_updown.gap * scale)        -- down gap up
        width_final = (width * 2) + (style_updown.gap * scale)
    else
        down_top = height + (style_updown.gap * scale)      -- up gap down
        height_final = (height * 2) + (style_updown.gap * scale)
    end

    -- Store values
    def.sizes.width = width_final
    def.sizes.height = height_final

    def.sizes.down_left = down_left
    def.sizes.down_top = down_top
    def.sizes.down_width = down_width
    def.sizes.down_height = down_height
    def.sizes.up_left = up_left
    def.sizes.up_top = up_top
    def.sizes.up_width = up_width
    def.sizes.up_height = up_height

    def.sizes.down_pad_h = (style_updown.padding_horizontal * scale) + (down_width_extra / 2)
    def.sizes.down_pad_v = (style_updown.padding_vertical * scale) + (down_height_extra / 2)
    def.sizes.up_pad_h = (style_updown.padding_horizontal * scale) + (up_width_extra / 2)
    def.sizes.up_pad_v = (style_updown.padding_vertical * scale) + (up_height_extra / 2)
end
function this.Calculate_Sizes_Single(text, style_updown, scale)
    -- Ignoring border size, because it's more of an after effect.  Half the border thickness goes
    -- into the button, half goes beyond the button.  Button placement ignores border size.  If
    -- border thickness were extreme, it may need to get accounted for, but for standard sizes, it
    -- would be a hassle for no real gain

    local width, height = ImGui.CalcTextSize(text)

    width = width + ((style_updown.padding_horizontal * 2) * scale) - 1
    height = height + ((style_updown.padding_vertical * 2) * scale)

    return width, height
end