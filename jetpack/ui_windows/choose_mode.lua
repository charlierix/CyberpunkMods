local this = {}

-- This gets called during activate and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_ChooseMode(vars_ui, const)
    local choose_mode = {}
    vars_ui.choose_mode = choose_mode

    choose_mode.title = Define_Title("Choose Mode", const)





    choose_mode.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(choose_mode)
end

function ActivateWindow_ChooseMode(vars_ui, const)
    if not vars_ui.mode_energy then
        DefineWindow_ChooseMode(vars_ui, const)
    end

    local choose_mode = vars_ui.choose_mode






end

-- This gets called each frame from DrawConfig()
function DrawWindow_ChooseMode(isCloseRequested, vars, vars_ui, player, window, o, const)
    local choose_mode = vars_ui.choose_mode

    ------------------------- Finalize models for this frame -------------------------


    --this.Refresh_IsDirty(choose_mode.okcancel, choose_mode.available.selected_index)
    this.Refresh_IsDirty(choose_mode.okcancel, nil)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(choose_mode.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(choose_mode.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------


    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(choose_mode.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save()
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)

    elseif isCancelClicked then
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)
    end

    return not (isCloseRequested and not choose_mode.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------


function this.Refresh_IsDirty(def, selected_index)
    local isDirty = false


    def.isDirty = isDirty
end

function this.Save()

end