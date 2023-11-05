local this = {}

-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode(vars_ui, const)
    local modewin = {}
    vars_ui.modewin = modewin

    modewin.changes = Changes:new()




    modewin.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(modewin)
end

function ActivateWindow_Mode(vars_ui, const)
    if not vars_ui.modewin then
        DefineWindow_Mode(vars_ui, const)
    end

    local modewin = vars_ui.modewin

    modewin.changes:Clear()



end

-- This gets called each frame from DrawConfig()
function DrawWindow_Mode(isCloseRequested, vars, vars_ui, player, window, o, const)
    local modewin = vars_ui.modewin

    local mode = vars_ui.transition_info.mode

    ------------------------- Finalize models for this frame -------------------------

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(modewin.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(modewin.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------




    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(modewin.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, mode, vars_ui.transition_info.mode_index)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not modewin.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Save(player, mode, mode_index)
    -- Store mode in the database, maybe build a new instance of mode


    -- Change player's mode primary key list


    -- If mode_index == player.mode_index, make sure player has the updated mode


    -- Save player
end