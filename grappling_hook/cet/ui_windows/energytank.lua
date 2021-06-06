local this = {}

function DefineWindow_EnergyTank(vars_ui, const)
    local energy_tank = {}
    vars_ui.energy_tank = energy_tank

    energy_tank.changes = Changes:new()

    energy_tank.title = Define_Title("Energy Tank", const)

    -- Total Energy (EnergyTank.max_energy)
    local prompt, value, updown, help = Define_PropertyPack_Vertical("Total Energy", 0, -144, const, false, "EnergyTank_TotalEnergy")
    energy_tank.total_prompt = prompt
    energy_tank.total_value = value
    energy_tank.total_updown = updown
    energy_tank.total_help = help

    -- Refill Rate (EnergyTank.recovery_rate)
    prompt, value, updown, help = Define_PropertyPack_Vertical("Refill Rate", -144, 120, const, false, "EnergyTank_RefillRate")
    energy_tank.refill_prompt = prompt
    energy_tank.refill_value = value
    energy_tank.refill_updown = updown
    energy_tank.refill_help = help

    -- While Grappling (EnergyTank.flying_percent)
    prompt, value, updown, help = Define_PropertyPack_Vertical("While Grappling", 144, 120, const, false, "EnergyTank_WhileGrappling")
    energy_tank.percent_prompt = prompt
    energy_tank.percent_value = value
    energy_tank.percent_updown = updown
    energy_tank.percent_help = help

    energy_tank.experience = Define_Experience(const, "energy tank")

    energy_tank.okcancel = Define_OkCancelButtons(false, vars_ui, const)
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

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(energy_tank.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_OrderedList(energy_tank.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    -- Total Energy
    Draw_Label(energy_tank.total_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(energy_tank.total_value, vars_ui.style.colors, window.width, window.height, const)

    local isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.total_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    this.Update_Total(energy_tank.total_updown, changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.total_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)

    -- Refill Rate
    Draw_Label(energy_tank.refill_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(energy_tank.refill_value, vars_ui.style.colors, window.width, window.height, const)

    isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.refill_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    this.Update_Refill(energy_tank.refill_updown, changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.refill_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)

    -- While Grappling %
    Draw_Label(energy_tank.percent_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(energy_tank.percent_value, vars_ui.style.colors, window.width, window.height, const)

    isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.percent_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    this.Update_Percent(energy_tank.percent_updown, changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.percent_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)

    -- OK/Cancel
    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(energy_tank.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
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

function this.Refresh_Total_Value(def, energy_tank, changes)
    def.text = tostring(Round(energy_tank.max_energy + changes:Get("max_energy")))
end
function this.Refresh_Total_UpDown(def, energy_tank, player, changes)
    local down, up = GetDecrementIncrement(energy_tank.max_energy_update, energy_tank.max_energy + changes:Get("max_energy"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up)
end
function this.Update_Total(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("max_energy", def.value_down)
        changes:Add("experience", 1)
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("max_energy", def.value_up)
        changes:Subtract("experience", 1)
    end
end

function this.Refresh_Refill_Value(def, energy_tank, changes)
    def.text = tostring(Round(energy_tank.recovery_rate + changes:Get("recovery_rate"), 1))
end
function this.Refresh_Refill_UpDown(def, energy_tank, player, changes)
    local down, up = GetDecrementIncrement(energy_tank.recovery_rate_update, energy_tank.recovery_rate + changes:Get("recovery_rate"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up)
end
function this.Update_Refill(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("recovery_rate", def.value_down)
        changes:Add("experience", 1)
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("recovery_rate", def.value_up)
        changes:Subtract("experience", 1)
    end
end

function this.Refresh_Percent_Value(def, energy_tank, changes)
    def.text = tostring(Round((energy_tank.flying_percent + changes:Get("flying_percent")) * 100)) .. "%"
end
function this.Refresh_Percent_UpDown(def, energy_tank, player, changes)
    local down, up = GetDecrementIncrement(energy_tank.flying_percent_update, energy_tank.flying_percent + changes:Get("flying_percent"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up)

    -- Refresh_UpDownButton set several properties, but the text needs to be multiplied by 100
    if down then
        def.text_down = tostring(Round(down * 100))
    end

    if up then
        def.text_up = tostring(Round(up * 100))
    end
end
function this.Update_Percent(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("flying_percent", def.value_down)
        changes:Add("experience", 1)
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("flying_percent", def.value_up)
        changes:Subtract("experience", 1)
    end
end

function this.Refresh_IsDirty(def, changes)
    def.isDirty = changes:IsDirty()
end

function this.Save(player, changes)
    player.energy_tank.max_energy = player.energy_tank.max_energy + changes:Get("max_energy")
    player.energy_tank.recovery_rate = player.energy_tank.recovery_rate + changes:Get("recovery_rate")
    player.energy_tank.flying_percent = player.energy_tank.flying_percent + changes:Get("flying_percent")

    player.energy_tank.experience = player.energy_tank.experience - changes:Get("experience")
    player.experience = player.experience + changes:Get("experience")

    player:Save()
end