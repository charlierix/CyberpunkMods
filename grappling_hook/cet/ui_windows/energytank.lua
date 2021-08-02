local this = {}

function DefineWindow_EnergyTank(vars_ui, const)
    local energy_tank = {}
    vars_ui.energy_tank = energy_tank

    energy_tank.changes = Changes:new()

    energy_tank.title = Define_Title("Energy Tank", const)

    -- Total Energy (EnergyTank.max_energy)
    local prompt, value, updown, help = Define_PropertyPack_Vertical("Total Energy", 0, -144, const, false, "EnergyTank_TotalEnergy", this.Tooltip_Total())
    energy_tank.total_prompt = prompt
    energy_tank.total_value = value
    energy_tank.total_updown = updown
    energy_tank.total_help = help

    -- Refill Rate (EnergyTank.recovery_rate)
    prompt, value, updown, help = Define_PropertyPack_Vertical("Refill Rate", -144, 120, const, false, "EnergyTank_RefillRate", this.Tooltip_Refill())
    energy_tank.refill_prompt = prompt
    energy_tank.refill_value = value
    energy_tank.refill_updown = updown
    energy_tank.refill_help = help

    -- While Grappling (EnergyTank.flying_percent)
    prompt, value, updown, help = Define_PropertyPack_Vertical("While Grappling", 144, 120, const, false, "EnergyTank_WhileGrappling", this.Tooltip_Percent())
    energy_tank.percent_prompt = prompt
    energy_tank.percent_value = value
    energy_tank.percent_updown = updown
    energy_tank.percent_help = help

    energy_tank.experience = Define_Experience(const, "energy tank")

    energy_tank.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(energy_tank)
end

function ActivateWindow_EnergyTank(vars_ui, const)
    if not vars_ui.energy_tank then
        DefineWindow_EnergyTank(vars_ui, const)
    end

    vars_ui.energy_tank.changes:Clear()
end

function DrawWindow_EnergyTank(isCloseRequested, vars_ui, player, window, const)
    local energy_tank = vars_ui.energy_tank
    local changes = energy_tank.changes

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Total_Value(energy_tank.total_value, player.energy_tank, changes)
    this.Refresh_Total_UpDown(energy_tank.total_updown, player.energy_tank, player, changes)

    this.Refresh_Refill_Value(energy_tank.refill_value, player.energy_tank, changes)
    this.Refresh_Refill_UpDown(energy_tank.refill_updown, player.energy_tank, player, changes)

    this.Refresh_Percent_Value(energy_tank.percent_value, player.energy_tank, changes)
    this.Refresh_Percent_UpDown(energy_tank.percent_updown, player.energy_tank, player, changes)

    this.Refresh_Experience(energy_tank.experience, player, changes)

    this.Refresh_IsDirty(energy_tank.okcancel, changes)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(energy_tank.render_nodes, vars_ui.style, vars_ui.line_heights)
    CalculatePositions(energy_tank.render_nodes, window.width, window.height, const)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(energy_tank.title, vars_ui.style.colors)

    Draw_OrderedList(energy_tank.experience, vars_ui.style.colors)

    -- Total Energy
    Draw_Label(energy_tank.total_prompt, vars_ui.style.colors)
    Draw_Label(energy_tank.total_value, vars_ui.style.colors)

    local isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.total_updown, vars_ui.style.updownButtons)
    this.Update_Total(energy_tank.total_updown, changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.total_help, vars_ui.style.helpButton, window.left, window.top, vars_ui)

    -- Refill Rate
    Draw_Label(energy_tank.refill_prompt, vars_ui.style.colors)
    Draw_Label(energy_tank.refill_value, vars_ui.style.colors)

    isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.refill_updown, vars_ui.style.updownButtons)
    this.Update_Refill(energy_tank.refill_updown, changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.refill_help, vars_ui.style.helpButton, window.left, window.top, vars_ui)

    -- While Grappling %
    Draw_Label(energy_tank.percent_prompt, vars_ui.style.colors)
    Draw_Label(energy_tank.percent_value, vars_ui.style.colors)

    isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.percent_updown, vars_ui.style.updownButtons)
    this.Update_Percent(energy_tank.percent_updown, changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.percent_help, vars_ui.style.helpButton, window.left, window.top, vars_ui)

    -- OK/Cancel
    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(energy_tank.okcancel, vars_ui.style.okcancelButtons)
    if isOKClicked then
        this.Save(player, changes)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not energy_tank.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Refresh_Experience(def, player, changes)
    def.content.available.value = tostring(math.floor(player.experience + changes:Get("experience")))
    def.content.used.value = tostring(Round(player.energy_tank.experience - changes:Get("experience")))
end

function this.Tooltip_Total()
    return
[[How large the energy tank is.  Each time grapple is used, it costs energy

So a larger total allows multiple grapples to be used in quick succession]]
end
function this.Refresh_Total_Value(def, energy_tank, changes)
    def.text = tostring(Round(energy_tank.max_energy + changes:Get("max_energy")))
end
function this.Refresh_Total_UpDown(def, energy_tank, player, changes)
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(energy_tank.max_energy_update, energy_tank.max_energy + changes:Get("max_energy"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up)
end
function this.Update_Total(def, changes, isDownClicked, isUpClicked)
    Update_UpDownButton("max_energy", "experience", isDownClicked, isUpClicked, def, changes)
end

function this.Tooltip_Refill()
    return
[[How quickly the energy tank refills

A value of one means recover one per second]]
end
function this.Refresh_Refill_Value(def, energy_tank, changes)
    def.text = tostring(Round(energy_tank.recovery_rate + changes:Get("recovery_rate"), 1))
end
function this.Refresh_Refill_UpDown(def, energy_tank, player, changes)
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(energy_tank.recovery_rate_update, energy_tank.recovery_rate + changes:Get("recovery_rate"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up)
end
function this.Update_Refill(def, changes, isDownClicked, isUpClicked)
    Update_UpDownButton("recovery_rate", "experience", isDownClicked, isUpClicked, def, changes)
end

function this.Tooltip_Percent()
    return
[[When in the middle of grappling, energy fills more slowly at this percent

100% would be normal refill rate]]
end
function this.Refresh_Percent_Value(def, energy_tank, changes)
    def.text = tostring(Round((energy_tank.flying_percent + changes:Get("flying_percent")) * 100)) .. "%"
end
function this.Refresh_Percent_UpDown(def, energy_tank, player, changes)
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(energy_tank.flying_percent_update, energy_tank.flying_percent + changes:Get("flying_percent"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up, 0, 100)
end
function this.Update_Percent(def, changes, isDownClicked, isUpClicked)
    Update_UpDownButton("flying_percent", "experience", isDownClicked, isUpClicked, def, changes)
end

function this.Refresh_IsDirty(def, changes)
    def.isDirty = changes:IsDirty()
end

function this.Save(player, changes)
    if not player:TransferExperience_EnergyTank(player.energy_tank, -changes:Get("experience")) then
        do return end
    end

    player.energy_tank.max_energy = player.energy_tank.max_energy + changes:Get("max_energy")
    player.energy_tank.recovery_rate = player.energy_tank.recovery_rate + changes:Get("recovery_rate")
    player.energy_tank.flying_percent = player.energy_tank.flying_percent + changes:Get("flying_percent")

    player:Save()
end