local this = {}

function DefineWindow_GrappleStraight_Visuals(vars_ui, const)
    local gst8_visuals = {}
    vars_ui.gst8_visuals = gst8_visuals

    gst8_visuals.changes = Changes:new()

    gst8_visuals.title = Define_Title("Grapple Straight - Visuals / Color", const)

    gst8_visuals.name = Define_Name(const)


    gst8_visuals.colorprim_value = this.Define_ColorPrimary_Value(const)
    gst8_visuals.colorprim_help = this.Define_ColorPrimary_Help(gst8_visuals.colorprim_value, const)
    gst8_visuals.colorprim_label = this.Define_ColorPrimary_Label(gst8_visuals.colorprim_help, const)
    gst8_visuals.colorprim_sample = this.Define_ColorPrimary_Sample(gst8_visuals.colorprim_value, const)


    gst8_visuals.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(gst8_visuals)
end

function ActivateWindow_GrappleStraight_Visuals(vars_ui, const)
    if not vars_ui.gst8_visuals then
        DefineWindow_GrappleStraight_Visuals(vars_ui, const)
    end

    vars_ui.gst8_visuals.changes:Clear()

    vars_ui.gst8_visuals.colorprim_value.text = nil
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

    this.Refresh_ColorPrimary_Value(gst8_visuals.colorprim_value, grapple)
    this.Refresh_ColorPrimary_Sample(gst8_visuals.colorprim_sample, gst8_visuals.colorprim_value)

    this.Refresh_IsDirty(gst8_visuals.okcancel, changes, gst8_visuals.colorprim_value, grapple)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(gst8_visuals.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(gst8_visuals.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_visuals.title, vars_ui.style.colors, vars_ui.scale)

    Draw_Label(gst8_visuals.name, vars_ui.style.colors, vars_ui.scale)

    Draw_Label(gst8_visuals.colorprim_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(gst8_visuals.colorprim_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_TextBox(gst8_visuals.colorprim_value, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_ColorSample(gst8_visuals.colorprim_sample, vars_ui.style.colorSample, window.left, window.top, vars_ui.scale)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_visuals.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, grapple, changes, gst8_visuals.colorprim_value)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_visuals.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_ColorPrimary_Value(const)
    -- TextBox
    return
    {
        invisible_name = "GrappleStraight_Visuals_ColorPrimary_Value",

        maxChars = 8,
        width = 120,

        isMultiLine = false,

        foreground_override = "edit_value",

        position =
        {
            pos_x = 0,
            pos_y = -100,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_ColorPrimary_Value(def, grapple)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    --NOTE: ActivateWindow_GrappleStraight_Visuals sets this to nil
    if not def.text then
        def.text = grapple.visuals.grappleline_color_primary
    end
end
function this.Define_ColorPrimary_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "GrappleStraight_Visuals_ColorPrimary_Help",

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
[[]]

    return retVal
end
function this.Define_ColorPrimary_Label(relative_to, const)
    -- Label
    return
    {
        text = "Color",

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
function this.Define_ColorPrimary_Sample(relative_to, const)
    -- ColorSample
    return
    {
        invisible_name = "GrappleStraight_Visuals_ColorPrimary_Sample",

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
function this.Refresh_ColorPrimary_Sample(def, def_value)
    def.color_hex = def_value.text
end

function this.Refresh_IsDirty(def, changes, def_colorprim, grapple)
    local isDirty = false

    if changes:IsDirty() then
        isDirty = true
    end

    if def_colorprim.text and def_colorprim.text ~= grapple.visuals.grappleline_color_primary then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, changes, def_colorprim)
    --grapple.aim_straight.aim_duration = grapple.aim_straight.aim_duration + changes:Get("aim_duration")

    grapple.visuals.grappleline_color_primary = def_colorprim.text

    player:Save()
end