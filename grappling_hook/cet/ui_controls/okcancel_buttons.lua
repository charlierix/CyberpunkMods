local this = {}

-- def is models\viewmodels\OkCancelButtons
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_OkCancelButtons(def, style, line_heights)
	if not def.sizes then
        def.sizes = {}
    end

    local text_ok, text_cancel = this.GetText(def)

    this.Calculate_Sizes(def, style.okcancelButtons, text_ok, text_cancel)

    def.render_pos.width = def.sizes.width
    def.render_pos.height = def.sizes.height
end

-- Draws buttons (should be placed at bottom right of window)
-- def is models\viewmodels\OkCancelButtons
-- style_updown is models\stylesheet\OkCancelButtons
-- Returns:
--  isOKClicked         this is only true if two buttons are showing and they click OK (def.isDirty==true)
--  isCancelClicked     this is true when they click the cancel button, or if there is a single button showing
function Draw_OkCancelButtons(def, style_okcancel)
    local text_ok, text_cancel = this.GetText(def)

	-- Common properties
    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, style_okcancel.border_cornerRadius)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, style_okcancel.border_thickness)

    ImGui.PushStyleColor(ImGuiCol.Button, style_okcancel.back_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_okcancel.back_color_hover_abgr)
    ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_okcancel.back_color_click_abgr)
    ImGui.PushStyleColor(ImGuiCol.Text, style_okcancel.foreground_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.Border, style_okcancel.border_color_abgr)

    -- Ok
    local isOKClicked = false
    if def.isDirty then
        ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, def.sizes.ok_pad_h, def.sizes.ok_pad_v)

        ImGui.SetCursorPos(def.render_pos.left + def.sizes.ok_left, def.render_pos.top + def.sizes.ok_top)

        isOKClicked = ImGui.Button(text_ok)

        ImGui.PopStyleVar(1)
    end

    -- Cancel
    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, def.sizes.cancel_pad_h, def.sizes.cancel_pad_v)

    ImGui.SetCursorPos(def.render_pos.left + def.sizes.cancel_left, def.render_pos.top + def.sizes.cancel_top)

    local isCancelClicked = ImGui.Button(text_cancel)

    ImGui.PopStyleVar(1)

	-- /Common properties
    ImGui.PopStyleColor(5)
    ImGui.PopStyleVar(2)

    return isOKClicked, isCancelClicked
end

----------------------------------- Private Methods -----------------------------------

function this.GetText(def)
    local ok = ""
    local cancel = ""

    if def.isDirty then
        ok = "OK"
        cancel = "Cancel"

    elseif def.isMainPage then
        cancel = "Close"

    else
        cancel = "Back"
    end

    return ok, cancel
end

function this.Calculate_Sizes(def, style_okcancel, text_ok, text_cancel)
    -- Text Sizes
    local ok_width = 0
    local ok_height = 0
    if def.isDirty then
        ok_width, ok_height = ImGui.CalcTextSize(text_ok)
    end

    local cancel_width, cancel_height = ImGui.CalcTextSize(text_cancel)

    -- Final Size
    local width_final = style_okcancel.width
    if def.isDirty then
        width_final = (width_final * 2) + style_okcancel.gap
    end

    local height_final = style_okcancel.height

    -- Locations
    local ok_left = 0
    local ok_top = 0
    local cancel_left = 0
    local cancel_top = 0

    if def.isDirty then
        cancel_left = style_okcancel.width + style_okcancel.gap
    end

    -- Store values
	def.sizes.width = width_final
	def.sizes.height = height_final

	def.sizes.ok_left = ok_left
	def.sizes.ok_top = ok_top
	def.sizes.cancel_left = cancel_left
	def.sizes.cancel_top = cancel_top

	def.sizes.ok_pad_h = ((style_okcancel.width + 1) - ok_width) / 2
	def.sizes.ok_pad_v = (style_okcancel.height - ok_height) / 2
	def.sizes.cancel_pad_h = ((style_okcancel.width + 1) - cancel_width) / 2
	def.sizes.cancel_pad_v = (style_okcancel.height - cancel_height) / 2
end