function Define_Window_Grapple_Choose(vars_ui, const)
    local grapple_choose = {}
    vars_ui.grapple_choose = grapple_choose

    grapple_choose.changes = {}        -- this will hold values that have changes to be applied

    grapple_choose.title = Define_Title("New/Load Grapple", const)





    grapple_choose.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function DrawWindow_Grapple_Choose(vars_ui, player, window, const)
    local grapple_choose = vars_ui.grapple_choose

    Draw_Label(grapple_choose.title, vars_ui.style.colors, window.width, window.height, const)



    local _, isCancelClicked = Draw_OkCancelButtons(grapple_choose.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end
end