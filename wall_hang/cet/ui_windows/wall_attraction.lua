local this = {}

function DefineWindow_WallAttraction(vars_ui, const)
    local wall_attraction = {}
    vars_ui.wall_attraction = wall_attraction

    wall_attraction.changes = Changes:new()

    wall_attraction.title = Define_Title("Wall Attraction", const)



    wall_attraction.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(wall_attraction)
end

function ActivateWindow_WallAttraction(vars_ui, const)
    if not vars_ui.wall_attraction then
        DefineWindow_WallAttraction(vars_ui, const)
    end

    vars_ui.wall_attraction.changes:Clear()
end

function DrawWindow_WallAttraction(isCloseRequested, vars, vars_ui, window, const, player, player_arcade)
    local wall_attraction = vars_ui.wall_attraction

    ------------------------- Finalize models for this frame -------------------------


    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(wall_attraction.render_nodes, vars_ui.style, vars_ui.line_heights)
    CalculatePositions(wall_attraction.render_nodes, window.width, window.height, const)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(wall_attraction.title, vars_ui.style.colors)




    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(wall_attraction.okcancel, vars_ui.style.okcancelButtons)
    if isOKClicked then
        this.Save(wall_attraction.latch_wallhang, wall_attraction.mouse_sensitivity, wall_attraction.rightstick_sensitivity, wall_attraction.jump_strength, const, player, player_arcade)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not wall_attraction.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------
