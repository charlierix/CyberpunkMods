local this = {}

function Define_Window_EnergyTank(vars_ui, const)
    local energy_tank = {}
    vars_ui.energy_tank = energy_tank

    energy_tank.changes = {}        -- this will hold values that have changes to be applied

    energy_tank.title = Define_Title("Energy Tank", const)

    -- Total Energy (EnergyTank.max_energy)
    local prompt, value, updown, help = this.Define_PropertyPack("Total Energy", 0, -144, const)
    energy_tank.total_prompt = prompt
    energy_tank.total_value = value
    energy_tank.total_updown = updown
    energy_tank.total_help = help

    -- Refill Rate (EnergyTank.recovery_rate)
    prompt, value, updown, help = this.Define_PropertyPack("Refill Rate", -144, 120, const)
    energy_tank.refill_prompt = prompt
    energy_tank.refill_value = value
    energy_tank.refill_updown = updown
    energy_tank.refill_help = help

    -- While Grappling (EnergyTank.flying_percent)
    prompt, value, updown, help = this.Define_PropertyPack("While Grappling", 144, 120, const)
    energy_tank.percent_prompt = prompt
    energy_tank.percent_value = value
    energy_tank.percent_updown = updown
    energy_tank.percent_help = help

    energy_tank.experience = this.Define_Experience(const)

    energy_tank.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function DrawWindow_EnergyTank(vars_ui, player, window, const)
    local energy_tank = vars_ui.energy_tank

    ------------------------- Finalize models for this frame -------------------------
    this.Refresh_Experience(energy_tank.experience, player, energy_tank.changes)

    this.Refresh_Total_Value(energy_tank.total_value, player.energy_tank, energy_tank.changes)
    this.Refresh_Total_UpDown(energy_tank.total_updown, player.energy_tank, player, energy_tank.changes)

    this.Refresh_Refill_Value(energy_tank.refill_value, player.energy_tank, energy_tank.changes)
    this.Refresh_Refill_UpDown(energy_tank.refill_updown, player.energy_tank, player, energy_tank.changes)

    this.Refresh_Percent_Value(energy_tank.percent_value, player.energy_tank, energy_tank.changes)
    this.Refresh_Percent_UpDown(energy_tank.percent_updown, player.energy_tank, player, energy_tank.changes)

    this.Refresh_IsDirty(energy_tank.okcancel, energy_tank.changes)

    -------------------------------- Show ui elements --------------------------------
    Draw_Label(energy_tank.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_OrderedList(energy_tank.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    -- Total Energy
    Draw_Label(energy_tank.total_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(energy_tank.total_value, vars_ui.style.colors, window.width, window.height, const)

    local isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.total_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    this.Update_Total(energy_tank.total_updown, energy_tank.changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.total_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)

    -- Refill Rate
    Draw_Label(energy_tank.refill_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(energy_tank.refill_value, vars_ui.style.colors, window.width, window.height, const)

    isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.refill_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    this.Update_Refill(energy_tank.refill_updown, energy_tank.changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.refill_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)

    -- While Grappling %
    Draw_Label(energy_tank.percent_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(energy_tank.percent_value, vars_ui.style.colors, window.width, window.height, const)

    isDownClicked, isUpClicked = Draw_UpDownButtons(energy_tank.percent_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    this.Update_Percent(energy_tank.percent_updown, energy_tank.changes, isDownClicked, isUpClicked)

    Draw_HelpButton(energy_tank.percent_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)



    -- OK/Cancel
    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(energy_tank.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        print("TODO: Save EnergyTank")
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Experience(const)
    -- OrderedList
    return
    {
        content =
        {
            available = { prompt = "Experience Available" },
            used = { prompt = "Spent on energy tank" },
        },

        position =
        {
            pos_x = 36,
            pos_y = 36,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
        },

        gap = 12,

        color_prompt = "experience_prompt",
        color_value = "experience_value",
    }
end
function this.Refresh_Experience(def, player, changes)
    def.content.available.value = tostring(math.floor(player.experience + changes.experience))
    def.content.used.value = tostring(Round(player.energy_tank.experience - changes.experience))
end

-- This creates a set of controls used to change a single property
-- x and y are an offset from center
-- Returns:
--  label property name
--  label property value
--  updown buttons
--  help button
function this.Define_PropertyPack(text, x, y, const)
    -- Probably can't use this outside of a draw function.  Just hardcode the offsets
    --local size_text_x, size_text_y = ImGui.CalcTextSize(text)

    -- Label
    local label_prompt =
    {
        text = text,

        position =
        {
            pos_x = x,
            pos_y = y - 24,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",
    }

    -- Label
    local label_value =
    {
        --text = ,      -- will be populated during refresh

        position =
        {
            pos_x = x,
            pos_y = y,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_value",
    }

    -- UpDownButtons
    local updown =
    {
        isEnabled_down = true,
        isEnabled_up = true,

        position =
        {
            pos_x = x,
            pos_y = y + 32,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        isHorizontal = true,
    }

    -- HelpButton
    local help =
    {
        position =
        {
            pos_x = x + 66,
            pos_y = y - 23,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "Help" .. text
    }

    return label_prompt, label_value, updown, help
end

function this.Refresh_Total_Value(def, energy_tank, changes)
    def.text = tostring(Round(energy_tank.max_energy + changes.max_energy))
end
function this.Refresh_Total_UpDown(def, energy_tank, player, changes)
    local down, up = GetDecrementIncrement(energy_tank.max_energy_update, energy_tank.max_energy + changes.max_energy, player.experience + changes.experience)
    Refresh_UpDownButton(def, down, up)
end
function this.Update_Total(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes.max_energy = changes.max_energy - def.value_down
        changes.experience = changes.experience + 1
    end

    if isUpClicked and def.isEnabled_up then
        changes.max_energy = changes.max_energy + def.value_up
        changes.experience = changes.experience - 1
    end
end

function this.Refresh_Refill_Value(def, energy_tank, changes)
    def.text = tostring(Round(energy_tank.recovery_rate + changes.recovery_rate, 1))
end
function this.Refresh_Refill_UpDown(def, energy_tank, player, changes)
    local down, up = GetDecrementIncrement(energy_tank.recovery_rate_update, energy_tank.recovery_rate + changes.recovery_rate, player.experience + changes.experience)
    Refresh_UpDownButton(def, down, up)
end
function this.Update_Refill(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes.recovery_rate = changes.recovery_rate - def.value_down
        changes.experience = changes.experience + 1
    end

    if isUpClicked and def.isEnabled_up then
        changes.recovery_rate = changes.recovery_rate + def.value_up
        changes.experience = changes.experience - 1
    end
end

function this.Refresh_Percent_Value(def, energy_tank, changes)
    def.text = tostring(Round((energy_tank.flying_percent + changes.flying_percent) * 100)) .. "%"
end
function this.Refresh_Percent_UpDown(def, energy_tank, player, changes)
    local down, up = GetDecrementIncrement(energy_tank.flying_percent_update, energy_tank.flying_percent + changes.flying_percent, player.experience + changes.experience)
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
        changes.flying_percent = changes.flying_percent - def.value_down
        changes.experience = changes.experience + 1
    end

    if isUpClicked and def.isEnabled_up then
        changes.flying_percent = changes.flying_percent + def.value_up
        changes.experience = changes.experience - 1
    end
end

function this.Refresh_IsDirty(def, changes)
    local isClean =
        IsNearZero(changes.max_energy) and
        IsNearZero(changes.recovery_rate) and
        IsNearZero(changes.flying_percent) --and
        --IsNearZero(changes.experience)      -- experience is dependent on the other three.  So the only reason it would be non zero on its own is really bad math drift

    def.isDirty = not isClean
end