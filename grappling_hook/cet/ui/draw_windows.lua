function DrawWindow_Main(vars_ui, player, window, const)
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
        WindowTransition_Grapple_Straight(vars_ui, const, 1)
    end

    if Draw_SummaryButton(main.grapple2, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Grapple_Straight(vars_ui, const, 2)
    end

    if Draw_SummaryButton(main.grapple3, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Grapple_Straight(vars_ui, const, 3)
    end

    if Draw_SummaryButton(main.grapple4, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Grapple_Straight(vars_ui, const, 4)
    end

    if Draw_SummaryButton(main.grapple5, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Grapple_Straight(vars_ui, const, 5)
    end

    if Draw_SummaryButton(main.grapple6, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        WindowTransition_Grapple_Straight(vars_ui, const, 6)
    end

    Draw_OrderedList(main.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local _, isCloseClicked = Draw_OkCancelButtons(main.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)

    return not isCloseClicked       -- only stop showing when they click the close button
end

function DrawWindow_Energy_Tank(vars_ui, player, window, const)
    local energy_tank = vars_ui.energy_tank

    ------------------------- Finalize models for this frame -------------------------
    Refresh_EnergyTank_Experience(energy_tank.experience, player, energy_tank.changes)

    Refresh_EnergyTank_Total_Value(energy_tank.total_value, player.energy_tank, energy_tank.changes)
    Refresh_EnergyTank_Total_UpDown(energy_tank.total_updown, player.energy_tank, player, energy_tank.changes)

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



    -- While Grappling %



    -- OK/Cancel
    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(energy_tank.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        print("TODO: Save EnergyTank")
        WindowTransition_Main(vars_ui, const)

    elseif isCancelClicked then
        WindowTransition_Main(vars_ui, const)
    end
end

function DrawWindow_Grapple_Straight(vars_ui, player, window, const)

    --TODO: Get the current grapple from some structure in vars_ui that holds current window stats
    local grapple = player.grapple1



end
