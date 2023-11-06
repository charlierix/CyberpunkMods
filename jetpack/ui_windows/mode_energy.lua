local this = {}

-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode_Energy(vars_ui, const)
    local mode_energy = {}
    vars_ui.mode_energy = mode_energy

    mode_energy.changes = Changes:new()


    mode_energy.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(mode_energy)
end

function ActivateWindow_Mode_Energy(vars_ui, const)
    if not vars_ui.modewin then
        DefineWindow_Mode_Energy(vars_ui, const)
    end

    local mode_energy = vars_ui.mode_energy

    mode_energy.changes:Clear()
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Mode_Energy(isCloseRequested, vars, vars_ui, player, window, o, const)
    local mode_energy = vars_ui.mode_energy

    local mode = vars_ui.transition_info.mode

    ------------------------- Finalize models for this frame -------------------------


    --this.Refresh_IsDirty(mode_energy.okcancel, mode)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(mode_energy.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(mode_energy.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------



    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(mode_energy.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        --this.Save(player, mode, vars_ui.transition_info.mode_index)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not mode_energy.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------





