local this = {}

function DefineWindow_Jumping(vars_ui, const)
    local jumping = {}
    vars_ui.jumping = jumping

    jumping.changes = Changes:new()

    jumping.title = Define_Title("Jumping", const)




    jumping.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(jumping)
end

function ActivateWindow_Jumping(vars_ui, const)
    if not vars_ui.jumping then
        DefineWindow_Jumping(vars_ui, const)
    end

    vars_ui.jumping.changes:Clear()
end

function DrawWindow_Jumping(isCloseRequested, vars, vars_ui, window, const, player, player_arcade)
    local jumping = vars_ui.jumping

    ------------------------- Finalize models for this frame -------------------------


    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(jumping.render_nodes, vars_ui.style, vars_ui.line_heights)
    CalculatePositions(jumping.render_nodes, window.width, window.height, const)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(jumping.title, vars_ui.style.colors)




    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(jumping.okcancel, vars_ui.style.okcancelButtons)
    if isOKClicked then
        --this.Save(jumping.latch_wallhang, jumping.mouse_sensitivity, jumping.rightstick_sensitivity, jumping.jump_strength, const, player, player_arcade)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not jumping.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------
