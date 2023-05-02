local this = {}

function DefineWindow_GrappleStraight_Visuals(vars_ui, const)
    local gst8_visuals = {}
    vars_ui.gst8_visuals = gst8_visuals

    gst8_visuals.changes = Changes:new()

    gst8_visuals.title = Define_Title("Grapple Straight - Visuals / Color", const)

    gst8_visuals.name = Define_Name(const)

    --TODO: line style { solid, energy }

    gst8_visuals.line_colorprim_value = this.Define_Line_ColorPrimary_Value(const)
    gst8_visuals.line_colorprim_help = this.Define_Line_ColorPrimary_Help(gst8_visuals.line_colorprim_value, const)
    gst8_visuals.line_colorprim_label = this.Define_Line_ColorPrimary_Label(gst8_visuals.line_colorprim_help, const)
    gst8_visuals.line_colorprim_sample = this.Define_Line_ColorPrimary_Sample(gst8_visuals.line_colorprim_value, const)

    gst8_visuals.line_default = this.Define_Line_Default(gst8_visuals.line_colorprim_value, const)

    -- anchor style { none, diamond, circle }
    gst8_visuals.anchorstyle_combo = this.Define_AnchorStyle_Combo(gst8_visuals.line_colorprim_value, const)
    gst8_visuals.anchorstyle_help = this.Define_AnchorStyle_Help(gst8_visuals.anchorstyle_combo, const)
    gst8_visuals.anchorstyle_label = this.Define_AnchorStyle_Label(gst8_visuals.anchorstyle_help, const)

    gst8_visuals.anchor_color1_value = this.Define_Anchor_Color1_Value(gst8_visuals.anchorstyle_combo, const)
    gst8_visuals.anchor_color1_help = this.Define_Anchor_Color1_Help(gst8_visuals.anchor_color1_value, const)
    gst8_visuals.anchor_color1_label = this.Define_Anchor_Color1_Label(gst8_visuals.anchor_color1_help, const)
    gst8_visuals.anchor_color1_sample = this.Define_Anchor_Color1_Sample(gst8_visuals.anchor_color1_value, const)

    gst8_visuals.anchor_color2_value = this.Define_Anchor_Color2_Value(gst8_visuals.anchor_color1_value, const)
    gst8_visuals.anchor_color2_help = this.Define_Anchor_Color2_Help(gst8_visuals.anchor_color2_value, const)
    gst8_visuals.anchor_color2_label = this.Define_Anchor_Color2_Label(gst8_visuals.anchor_color2_help, const)
    gst8_visuals.anchor_color2_sample = this.Define_Anchor_Color2_Sample(gst8_visuals.anchor_color2_value, const)

    gst8_visuals.anchor_default = this.Define_Anchor_Default(gst8_visuals.anchorstyle_combo, const)

    gst8_visuals.colorurl = this.Define_ColorURL_TextBox(vars_ui, const)

    gst8_visuals.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(gst8_visuals)
end

function ActivateWindow_GrappleStraight_Visuals(vars_ui, const)
    if not vars_ui.gst8_visuals then
        DefineWindow_GrappleStraight_Visuals(vars_ui, const)
    end

    vars_ui.gst8_visuals.changes:Clear()

    vars_ui.gst8_visuals.line_colorprim_value.text = nil
    vars_ui.gst8_visuals.anchorstyle_combo.selected_item = nil
    vars_ui.gst8_visuals.anchor_color1_value.text = nil
    vars_ui.gst8_visuals.anchor_color2_value.text = nil
end

function DrawWindow_GrappleStraight_Visuals(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        LogError("DrawWindow_GrappleStraight_Visuals: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local gst8_visuals = vars_ui.gst8_visuals

    local changes = gst8_visuals.changes

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_visuals.name, grapple.name)

    this.Refresh_Line_ColorPrimary_Value(gst8_visuals.line_colorprim_value, grapple)
    this.Refresh_Line_ColorPrimary_Sample(gst8_visuals.line_colorprim_sample, gst8_visuals.line_colorprim_value)

    this.Refresh_AnchorStyle_Combo(gst8_visuals.anchorstyle_combo, grapple)

    this.Refresh_Anchor_Color1_Value(gst8_visuals.anchor_color1_value, grapple)
    this.Refresh_Anchor_Color1_Sample(gst8_visuals.anchor_color1_sample, gst8_visuals.anchor_color1_value)

    this.Refresh_Anchor_Color2_Value(gst8_visuals.anchor_color2_value, grapple)
    this.Refresh_Anchor_Color2_Sample(gst8_visuals.anchor_color2_sample, gst8_visuals.anchor_color2_value)

    this.Refresh_IsDirty(gst8_visuals.okcancel, changes, gst8_visuals.line_colorprim_value, gst8_visuals.anchorstyle_combo, gst8_visuals.anchor_color1_value, gst8_visuals.anchor_color2_value, grapple)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(gst8_visuals.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(gst8_visuals.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_visuals.title, vars_ui.style.colors, vars_ui.scale)

    Draw_Label(gst8_visuals.name, vars_ui.style.colors, vars_ui.scale)

    -- Line
    Draw_Label(gst8_visuals.line_colorprim_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(gst8_visuals.line_colorprim_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_TextBox(gst8_visuals.line_colorprim_value, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_ColorSample(gst8_visuals.line_colorprim_sample, vars_ui.style.colorSample, window.left, window.top, vars_ui.scale)

    if Draw_Button(gst8_visuals.line_default, vars_ui.style.button, vars_ui.scale) then
        this.Restore_Line_Default(gst8_visuals.line_colorprim_value, const)
    end

    -- Anchor
    Draw_ComboBox(gst8_visuals.anchorstyle_combo, vars_ui.style.combobox, vars_ui.scale)
    Draw_HelpButton(gst8_visuals.anchorstyle_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Label(gst8_visuals.anchorstyle_label, vars_ui.style.colors, vars_ui.scale)

    Draw_Label(gst8_visuals.anchor_color1_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(gst8_visuals.anchor_color1_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_TextBox(gst8_visuals.anchor_color1_value, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_ColorSample(gst8_visuals.anchor_color1_sample, vars_ui.style.colorSample, window.left, window.top, vars_ui.scale)

    Draw_Label(gst8_visuals.anchor_color2_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(gst8_visuals.anchor_color2_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_TextBox(gst8_visuals.anchor_color2_value, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_ColorSample(gst8_visuals.anchor_color2_sample, vars_ui.style.colorSample, window.left, window.top, vars_ui.scale)

    if Draw_Button(gst8_visuals.anchor_default, vars_ui.style.button, vars_ui.scale) then
        this.Restore_Anchor_Default(gst8_visuals.anchorstyle_combo, gst8_visuals.anchor_color1_value, gst8_visuals.anchor_color2_value, const)
    end

    Draw_TextBox(gst8_visuals.colorurl, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_visuals.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, grapple, changes, gst8_visuals.line_colorprim_value, gst8_visuals.anchorstyle_combo, gst8_visuals.anchor_color1_value, gst8_visuals.anchor_color2_value)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_visuals.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Line_ColorPrimary_Value(const)
    -- TextBox
    return
    {
        invisible_name = "GrappleStraight_Visuals_Line_ColorPrimary_Value",

        maxChars = 8,
        width = 120,

        isMultiLine = false,

        foreground_override = "edit_value",

        position =
        {
            pos_x = 60,
            pos_y = -100,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Line_ColorPrimary_Value(def, grapple)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    --NOTE: ActivateWindow_GrappleStraight_Visuals sets this to nil
    if not def.text then
        def.text = grapple.visuals.grappleline_color_primary
    end
end
function this.Define_Line_ColorPrimary_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "GrappleStraight_Visuals_Line_ColorPrimary_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[The grapple rope's color

]] .. this.GetColorTooltipText()

    return retVal
end
function this.Define_Line_ColorPrimary_Label(relative_to, const)
    -- Label
    return
    {
        text = "Grapple Line Color",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Line_ColorPrimary_Sample(relative_to, const)
    -- ColorSample
    return
    {
        invisible_name = "GrappleStraight_Visuals_Line_ColorPrimary_Sample",

        color_hex = "8F00",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_ColorSample,
    }
end
function this.Refresh_Line_ColorPrimary_Sample(def, def_value)
    def.color_hex = def_value.text
end

function this.Define_Line_Default(relative_to, const)
    -- Button
    return
    {
        text = "Default Line",

        width_override = 140,

        position =
        {
            relative_to = relative_to,

            pos_x = 200,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        color = "hint",

        isEnabled = true,

        CalcSize = CalcSize_Button,
    }
end
function this.Restore_Line_Default(def_line_colorprim, const)
    def_line_colorprim.text = "AAAAAAAA"
end

function this.Define_AnchorStyle_Combo(relative_to, const)
    -- ComboBox
    return
    {
        preview_text = const.Visuals_AnchorPoint_Type.none,
        selected_item = nil,

        items =
        {
            const.Visuals_AnchorPoint_Type.none,
            const.Visuals_AnchorPoint_Type.diamond,
            const.Visuals_AnchorPoint_Type.circle,
        },

        width = 120,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 48,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        invisible_name = "GrappleStraight_Visuals_AnchorStyle_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_AnchorStyle_Combo(def, grapple)
    if not def.selected_item then
        def.selected_item = grapple.visuals.anchorpoint_type
    end
end
function this.Define_AnchorStyle_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "GrappleStraight_Visuals_AnchorStyle_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip = ""

    return retVal
end
function this.Define_AnchorStyle_Label(relative_to, const)
    -- Label
    return
    {
        text = "Anchor Point",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end

function this.Define_Anchor_Color1_Value(relative_to, const)
    -- TextBox
    return
    {
        invisible_name = "GrappleStraight_Visuals_Anchor_Color1_Value",

        maxChars = 8,
        width = 120,

        isMultiLine = false,

        foreground_override = "edit_value",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 12,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Anchor_Color1_Value(def, grapple)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    --NOTE: ActivateWindow_GrappleStraight_Visuals sets this to nil
    if not def.text then
        def.text = grapple.visuals.anchorpoint_color_1
    end
end
function this.Define_Anchor_Color1_Help(relative_to, const)
    -- HelpButton
    return
    {
        invisible_name = "GrappleStraight_Visuals_Anchor_Color1_Help",

        tooltip = this.GetColorTooltipText(),

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Define_Anchor_Color1_Label(relative_to, const)
    -- Label
    return
    {
        text = "Color (dot)",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Anchor_Color1_Sample(relative_to, const)
    -- ColorSample
    return
    {
        invisible_name = "GrappleStraight_Visuals_Anchor_Color1_Sample",

        color_hex = "8F00",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_ColorSample,
    }
end
function this.Refresh_Anchor_Color1_Sample(def, def_value)
    def.color_hex = def_value.text
end

function this.Define_Anchor_Color2_Value(relative_to, const)
    -- TextBox
    return
    {
        invisible_name = "GrappleStraight_Visuals_Anchor_Color2_Value",

        maxChars = 8,
        width = 120,

        isMultiLine = false,

        foreground_override = "edit_value",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 12,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Anchor_Color2_Value(def, grapple)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    --NOTE: ActivateWindow_GrappleStraight_Visuals sets this to nil
    if not def.text then
        def.text = grapple.visuals.anchorpoint_color_2
    end
end
function this.Define_Anchor_Color2_Help(relative_to, const)
    -- HelpButton
    return
    {
        invisible_name = "GrappleStraight_Visuals_Anchor_Color2_Help",

        tooltip = this.GetColorTooltipText(),

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Define_Anchor_Color2_Label(relative_to, const)
    -- Label
    return
    {
        text = "Color (outer)",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Anchor_Color2_Sample(relative_to, const)
    -- ColorSample
    return
    {
        invisible_name = "GrappleStraight_Visuals_Anchor_Color2_Sample",

        color_hex = "8F00",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_ColorSample,
    }
end
function this.Refresh_Anchor_Color2_Sample(def, def_value)
    def.color_hex = def_value.text
end

function this.Define_Anchor_Default(relative_to, const)
    -- Button
    return
    {
        text = "Default Anchor",        -- can't just name it Default, because the button text needs to be unique

        width_override = 140,

        position =
        {
            relative_to = relative_to,

            pos_x = 200,
            pos_y = 40,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        color = "hint",

        isEnabled = true,

        CalcSize = CalcSize_Button,
    }
end
function this.Restore_Anchor_Default(def_anchorstyle, def_anchor_color1, def_anchor_color2, const)
    def_anchorstyle.selected_item = const.Visuals_AnchorPoint_Type.none
    def_anchor_color1.text = "90E6E18E"
    def_anchor_color2.text = "D0E2EB7F"
end

function this.Define_ColorURL_TextBox(vars_ui, const)
    -- TextBox
    return
    {
        invisible_name = "GrappleStraight_Visuals_ColorURL_TextBox",

        text ="https://color.adobe.com/create/color-wheel",

        maxChars = 80,
        width = 400,

        isMultiLine = false,

        foreground_override = "edit_prompt",

        position =
        {
            pos_x = vars_ui.style.okcancelButtons.pos_x,
            pos_y = vars_ui.style.okcancelButtons.pos_y,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
        },

        CalcSize = CalcSize_TextBox,
    }
end

function this.GetColorTooltipText()
    return
    [[ARBG as hex (alpha is optional)

    Values go from 00 to FF (hex for 0 to 255)
    
    FF0000 would be red, 00FF00 green, 0000FF blue
    
    80FF0000 would be 50% transparent red]]
end

function this.Refresh_IsDirty(def, changes, def_line_colorprim, def_anchorstyle, def_anchor_color1, def_anchor_color2, grapple)
    local isDirty = false

    if changes:IsDirty() then
        isDirty = true
    end

    if def_line_colorprim.text and def_line_colorprim.text ~= grapple.visuals.grappleline_color_primary then
        isDirty = true

    elseif def_anchorstyle.selected_item ~= grapple.visuals.anchorpoint_type then
        isDirty = true

    elseif def_anchor_color1.text and def_anchor_color1.text ~= grapple.visuals.anchorpoint_color_1 then
        isDirty = true

    elseif def_anchor_color2.text and def_anchor_color2.text ~= grapple.visuals.anchorpoint_color_2 then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, changes, def_line_colorprim, def_anchorstyle, def_anchor_color1, def_anchor_color2)
    --grapple.aim_straight.aim_duration = grapple.aim_straight.aim_duration + changes:Get("aim_duration")

    grapple.visuals.grappleline_color_primary = def_line_colorprim.text
    grapple.visuals.anchorpoint_type = def_anchorstyle.selected_item
    grapple.visuals.anchorpoint_color_1 = def_anchor_color1.text
    grapple.visuals.anchorpoint_color_2 = def_anchor_color2.text

    player:Save()
end