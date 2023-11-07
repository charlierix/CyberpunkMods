local this = {}

-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode_Accel(vars_ui, const)
    local mode_accel = {}
    vars_ui.mode_accel = mode_accel

    mode_accel.changes = Changes:new()

    mode_accel.title = Define_Title("Accelerations", const)
    mode_accel.name = Define_Name(const)

    mode_accel.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(mode_accel)
end

function ActivateWindow_Mode_Accel(vars_ui, const)
    if not vars_ui.mode_accel then
        DefineWindow_Mode_Accel(vars_ui, const)
    end

    local mode_accel = vars_ui.mode_accel

    mode_accel.changes:Clear()

end

-- This gets called each frame from DrawConfig()
function DrawWindow_Mode_Accel(isCloseRequested, vars, vars_ui, player, window, o, const)
    local mode_accel = vars_ui.mode_accel

    local mode = vars_ui.transition_info.mode

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(mode_accel.name, mode.name)


    this.Refresh_IsDirty(mode_accel.okcancel, mode)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(mode_accel.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(mode_accel.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(mode_accel.title, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(mode_accel.name, vars_ui.style.colors, vars_ui.scale)


    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(mode_accel.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, mode, vars_ui.transition_info.mode_index)
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)

    elseif isCancelClicked then
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)
    end

    return not (isCloseRequested and not mode_accel.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Refresh_IsDirty(def, mode)
    local isDirty = false


    def.isDirty = isDirty
end

function this.Save(player, mode, mode_index)

    player:SaveUpdatedMode(mode, mode_index)
end

---------------------------------------------------------------------------------------



