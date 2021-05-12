function DrawWindow_Main(isConfigRepress, vars_ui, player, window, const)
    local main = vars_ui.main

    -- Finalize models for this frame
    Refresh_Main_EnergyTank(main.energyTank, player.energy_tank)

    Refresh_Main_GrappleSlot(main.grapple1, player.grapple1)
    Refresh_Main_GrappleSlot(main.grapple2, player.grapple2)
    Refresh_Main_GrappleSlot(main.grapple3, player.grapple3)
    Refresh_Main_GrappleSlot(main.grapple4, player.grapple4)
    Refresh_Main_GrappleSlot(main.grapple5, player.grapple5)
    Refresh_Main_GrappleSlot(main.grapple6, player.grapple6)

    Refresh_Main_Experience(main.experience, player)

    -- Show ui elements
    Draw_Label(main.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(main.consoleWarning, vars_ui.style.colors, window.width, window.height, const)

    if Draw_SummaryButton(main.energyTank, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Energy_Tank(vars_ui, const)
    end

    if Draw_SummaryButton(main.grapple1, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Grapple(vars_ui, const, player, 1)
    end

    if Draw_SummaryButton(main.grapple2, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Grapple(vars_ui, const, player, 2)
    end

    if Draw_SummaryButton(main.grapple3, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Grapple(vars_ui, const, player, 3)
    end

    if Draw_SummaryButton(main.grapple4, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Grapple(vars_ui, const, player, 4)
    end

    if Draw_SummaryButton(main.grapple5, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Grapple(vars_ui, const, player, 5)
    end

    if Draw_SummaryButton(main.grapple6, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Grapple(vars_ui, const, player, 6)
    end

    Draw_OrderedList(main.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local _, isCloseClicked = Draw_OkCancelButtons(main.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)

    return not (isConfigRepress or isCloseClicked)       -- stop showing when they click the close button (or press config key a second time.  This main page doesn't have anything to save, so it's ok to exit at any time)
end

function DrawWindow_Energy_Tank(vars_ui, player, window, const)
    local energy_tank = vars_ui.energy_tank

    ------------------------- Finalize models for this frame -------------------------
    Refresh_EnergyTank_Experience(energy_tank.experience, player, energy_tank.changes)

    Refresh_EnergyTank_Total_Value(energy_tank.total_value, player.energy_tank, energy_tank.changes)
    Refresh_EnergyTank_Total_UpDown(energy_tank.total_updown, player.energy_tank, player, energy_tank.changes)

    Refresh_EnergyTank_Refill_Value(energy_tank.refill_value, player.energy_tank, energy_tank.changes)
    Refresh_EnergyTank_Refill_UpDown(energy_tank.refill_updown, player.energy_tank, player, energy_tank.changes)

    Refresh_EnergyTank_Percent_Value(energy_tank.percent_value, player.energy_tank, energy_tank.changes)
    Refresh_EnergyTank_Percent_UpDown(energy_tank.percent_updown, player.energy_tank, player, energy_tank.changes)

    Refresh_EnergyTank_IsDirty(energy_tank.okcancel, energy_tank.changes)

    -------------------------------- Show ui elements --------------------------------
    Draw_Label(energy_tank.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_OrderedList(energy_tank.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    -- Total Energy
    Draw_Label(energy_tank.total_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(energy_tank.total_value, vars_ui.style.colors, window.width, window.height, const)

    local isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.total_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    Update_EnergyTank_Total(energy_tank.total_updown, energy_tank.changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.total_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)

    -- Refill Rate
    Draw_Label(energy_tank.refill_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(energy_tank.refill_value, vars_ui.style.colors, window.width, window.height, const)

    isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.refill_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    Update_EnergyTank_Refill(energy_tank.refill_updown, energy_tank.changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.refill_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)

    -- While Grappling %
    Draw_Label(energy_tank.percent_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(energy_tank.percent_value, vars_ui.style.colors, window.width, window.height, const)

    isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.percent_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    Update_EnergyTank_Percent(energy_tank.percent_updown, energy_tank.changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.percent_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)



    -- OK/Cancel
    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(energy_tank.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        print("TODO: Save EnergyTank")
        WindowTransition_Main(vars_ui, const)

    elseif isCancelClicked then
        WindowTransition_Main(vars_ui, const)
    end
end

function DrawWindow_Grapple_Choose(vars_ui, player, window, const)
    local grapple_choose = vars_ui.grapple_choose

    Draw_Label(grapple_choose.title, vars_ui.style.colors, window.width, window.height, const)



    local _, isCancelClicked = Draw_OkCancelButtons(grapple_choose.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isCancelClicked then
        WindowTransition_Main(vars_ui, const)
    end
end

--local testText = "testing"

function DrawWindow_Grapple_Straight(vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_Grapple_Straight: grapple is nil")
        WindowTransition_Main(vars_ui, const)
        do return end
    end

    local grapple_straight = vars_ui.grapple_straight

    ------------------------- Finalize models for this frame -------------------------
    Refresh_GrappleStraight_Name(grapple_straight.name, grapple)
    Refresh_GrappleStraight_Description(grapple_straight.description, grapple)

    Refresh_GrappleStraight_IsDirty(grapple_straight.okcancel, grapple_straight.name, grapple_straight.description, grapple)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(grapple_straight.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_TextBox(grapple_straight.name, vars_ui.style.textbox, vars_ui.line_heights, window.width, window.height, const)
    Draw_TextBox(grapple_straight.description, vars_ui.style.textbox, vars_ui.line_heights, window.width, window.height, const)







    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(grapple_straight.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        print("TODO: Save Grapple Straight")
        WindowTransition_Main(vars_ui, const)

    elseif isCancelClicked then
        WindowTransition_Main(vars_ui, const)
    end
end
