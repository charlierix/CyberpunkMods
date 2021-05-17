local this = {}

function Define_Window_GrappleStraight_Distances(vars_ui, const)
    local gst8_dist = {}
    vars_ui.gst8_dist = gst8_dist

    gst8_dist.changes = {}        -- this will hold values that have changes to be applied

    gst8_dist.title = Define_Title("Grapple Straight - Distances", const)

    gst8_dist.name = Define_Name(const)


    gst8_dist.stickFigure = Define_StickFigure(true, const)
    gst8_dist.arrows = Define_GrappleArrows(true, const)





    gst8_dist.experience = Define_Experience(const, "grapple")

    gst8_dist.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function DrawWindow_GrappleStraight_Distances(vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_GrappleStraight_Distances: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local gst8_dist = vars_ui.gst8_dist

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_dist.name, grapple.name)

    Refresh_Arrows(gst8_dist.arrows, grapple, false, false, false)

    this.Refresh_Experience(gst8_dist.experience, player, grapple, gst8_dist.changes)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_dist.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_dist.name, vars_ui.style.colors, window.width, window.height, const)


    Draw_StickFigure(gst8_dist.stickFigure, vars_ui.style.graphics, window.left, window.top, window.width, window.height, const)
    Draw_GrappleArrows(gst8_dist.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)




    Draw_OrderedList(gst8_dist.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_dist.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        print("TODO: Save Grapple Straight Distance")
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Refresh_Experience(def, player, grapple, changes)
    def.content.available.value = tostring(math.floor(player.experience + changes.experience))
    def.content.used.value = tostring(Round(grapple.experience - changes.experience))
end


--TODO: this.Refresh_IsDirty()