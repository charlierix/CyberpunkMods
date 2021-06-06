local this = {}

function DefineWindow_GrappleStraight_Description(vars_ui, const)
    local gst8_descr = {}
    vars_ui.gst8_descr = gst8_descr

    gst8_descr.changes = Changes:new()

    gst8_descr.title = Define_Title("Grapple Straight - Aim Duration", const)

    gst8_descr.name = Define_Name(const)

    gst8_descr.description = this.Define_Description(const, vars_ui.mainWindow.width, vars_ui.mainWindow.height)


    --TODO: Note explaining that wordwrap isn't supported by textbox



    gst8_descr.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function DrawWindow_GrappleStraight_Description(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_GrappleStraight_Description: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local gst8_descr = vars_ui.gst8_descr

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_descr.name, grapple.name)

    this.Refresh_Description(gst8_descr.description, grapple)

    this.Refresh_IsDirty(gst8_descr.okcancel, gst8_descr.description, grapple)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_descr.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_descr.name, vars_ui.style.colors, window.width, window.height, const)

    Draw_TextBox(gst8_descr.description, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.line_heights, window.width, window.height, const)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_descr.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, gst8_descr.description)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_descr.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Description(const, parent_width, parent_height)
    -- TextBox
    return
    {
        invisible_name = "GrappleStraight_Description_Description",

        maxChars = 288,
        width = parent_width - (40 * 2),
        height = parent_height - (90 * 2),

        isMultiLine = true,

        --foreground_override = "subTitle",

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }
end
function this.Refresh_Description(def, grapple)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    --NOTE: TransitionWindows_Straight_Description sets this to nil
    if not def.text then
        def.text = grapple.description
    end
end

function this.Refresh_IsDirty(def, def_description, grapple)
    local isDirty = false

    if def_description.text and def_description.text ~= grapple.description then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, def_description)
    grapple.description = def_description.text

    player:Save()
end