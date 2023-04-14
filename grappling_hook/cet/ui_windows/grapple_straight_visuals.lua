local this = {}

function DefineWindow_GrappleStraight_Visuals(vars_ui, const)
    local gst8_visuals = {}
    vars_ui.gst8_visuals = gst8_visuals

    gst8_visuals.changes = Changes:new()

    gst8_visuals.title = Define_Title("Grapple Straight - Visuals / Color", const)

    gst8_visuals.name = Define_Name(const)




    gst8_visuals.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(gst8_visuals)
end

function ActivateWindow_GrappleStraight_Visuals(vars_ui, const)
    if not vars_ui.gst8_visuals then
        DefineWindow_GrappleStraight_Visuals(vars_ui, const)
    end

    vars_ui.gst8_visuals.changes:Clear()
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




    this.Refresh_IsDirty(gst8_visuals.okcancel, changes)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(gst8_visuals.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(gst8_visuals.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_visuals.title, vars_ui.style.colors, vars_ui.scale)

    Draw_Label(gst8_visuals.name, vars_ui.style.colors, vars_ui.scale)






    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_visuals.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, grapple, changes)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_visuals.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Refresh_IsDirty(def, changes)
    def.isDirty = changes:IsDirty()
end

function this.Save(player, grapple, changes)
    --grapple.aim_straight.aim_duration = grapple.aim_straight.aim_duration + changes:Get("aim_duration")

    player:Save()
end