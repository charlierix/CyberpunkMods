local this = {}

-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- See
--  models\viewmodels\SummaryButton
--  models\viewmodels\Label
--  models\viewmodels\OrderedList
function Define_Window_Main(vars_ui, const)
    local main = {}
    vars_ui.main = main

    main.title = this.Define_Title("Grappling Hook", const)

    main.consoleWarning = this.Define_Main_ConsoleWarning(const)

    main.energyTank = this.Define_Main_EnergyTank(const)

    this.Define_Main_GrappleSlots(main, const)

    main.experience = this.Define_Main_Experience(const)

    main.okcancel = this.Define_OkCancelButtons(true, vars_ui, const)
end

function Define_Window_EnergyTank(vars_ui, const)
    local energy_tank = {}
    vars_ui.energy_tank = energy_tank

    energy_tank.changes = {}        -- this will hold values that have changes to be applied

    energy_tank.title = this.Define_Title("Energy Tank", const)


    -- 3 sets in a triangle around the center

    local prompt, value, updown, help = this.Define_EnergyTank_PropertyPack("Total Energy", 0, 0, const)
    energy_tank.total_prompt = prompt
    energy_tank.total_value = value
    energy_tank.total_updown = updown
    energy_tank.total_help = help





    energy_tank.experience = this.Define_EnergyTank_Experience(const)

    energy_tank.okcancel = this.Define_OkCancelButtons(false, vars_ui, const)
end

----------------------------------- Common Controls -----------------------------------

function this.Define_Title(title, const)
    -- Label
    return
    {
        text = title,

        position =
        {
            pos_x = 24,
            pos_y = 24,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.top,
        },

        color = "title",
    }
end

function this.Define_OkCancelButtons(isMainPage, vars_ui, const)
    return
    {
        isMainPage = isMainPage,
        isDirty = false,

        position =
        {
            pos_x = vars_ui.style.okcancelButtons.pos_x,
            pos_y = vars_ui.style.okcancelButtons.pos_y,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.bottom,
        },
    }
end

function this.Refresh_UpDownButton(def, down, up)
    --TODO: May want a significant digits function, only show one or two significant digits

    -- Down
    def.value_down = down

    if down then
        def.text_down = tostring(down)
        def.isEnabled_down = true
    else
        def.text_down = ""
        def.isEnabled_down = false
    end

    -- Up
    def.value_up = up

    if up then
        def.text_up = tostring(up)
        def.isEnabled_up = true
    else
        def.text_up = ""
        def.isEnabled_up = false
    end
end

------------------------------------- Main Window -------------------------------------

--NOTE: Define functions get called during init.  Refresh functions get called each frame that the config is visible

function this.Define_Main_EnergyTank(const)
    return
    {
        -- In the middle of the window
        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Energy",

        content =
        {
            -- the content is presented as sorted by name
            a_recovery_rate = { prompt = "refill rate" },
            b_flying_percent = { prompt = "while grappling" },
        },
    }
end
function Refresh_Main_EnergyTank(def, energy_tank)
    def.header_value = tostring(Round(energy_tank.max_energy))
    def.content.a_recovery_rate.value = tostring(Round(energy_tank.recovery_rate, 1))
    def.content.b_flying_percent.value = tostring(Round(energy_tank.flying_percent * 100)) .. "%"
end

function this.Define_Main_GrappleSlots(parent, const)
    -- Figure out the positions (they are in a hex pattern around the center)
    local offset_x_small = 160
    local offset_x_large = 280
    local offset_y = 180

    parent.grapple1 = this.Define_Main_GrappleSlots_DoIt(-offset_x_small, -offset_y, "1", const)
    parent.grapple2 = this.Define_Main_GrappleSlots_DoIt(offset_x_small, -offset_y, "2", const)
    parent.grapple3 = this.Define_Main_GrappleSlots_DoIt(offset_x_large, 0, "3", const)
    parent.grapple4 = this.Define_Main_GrappleSlots_DoIt(offset_x_small, offset_y, "4", const)
    parent.grapple5 = this.Define_Main_GrappleSlots_DoIt(-offset_x_small, offset_y, "5", const)
    parent.grapple6 = this.Define_Main_GrappleSlots_DoIt(-offset_x_large, 0, "6", const)

end
function this.Define_Main_GrappleSlots_DoIt(x, y, suffix, const)
    return
    {
        position =
        {
            pos_x = x,
            pos_y = y,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        min_width = 160,
        min_height = 70,

        suffix = suffix,
    }
end
function Refresh_Main_GrappleSlot(def, grapple)
    if grapple then
        def.header_prompt = grapple.name
        def.unused_text = nil
    else
        def.unused_text = "empty"
        def.header_prompt = nil
    end
end

function this.Define_Main_Experience(const)
    -- OrderedList
    return
    {
        content =
        {
            available = { prompt = "Experience" },
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
function Refresh_Main_Experience(def, player)
    def.content.available.value = tostring(math.floor(player.experience))
end

function this.Define_Main_ConsoleWarning(const)
    -- Label
    return
    {
        text = "NOTE: buttons won't respond unless the console window is also open",

        position =
        {
            pos_x = 0,
            pos_y = 30,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.top,
        },

        color = "info",
    }
end

------------------------------------- Energy Tank -------------------------------------

function this.Define_EnergyTank_Experience(const)
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
function Refresh_EnergyTank_Experience(def, player, changes)
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
function this.Define_EnergyTank_PropertyPack(text, x, y, const)
    -- Probably can't use this outside of a draw function.  Just hardcode the offsets
    --local size_text_x, size_text_y = ImGui.CalcTextSize(text)

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

    local help =
    {
        position =
        {
            pos_x = x + 60,
            pos_y = y - 23,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }

    return label_prompt, label_value, updown, help
end

function Refresh_EnergyTank_Total_Value(def, energy_tank, changes)
    def.text = tostring(Round(energy_tank.max_energy + changes.max_energy))
end
function Refresh_EnergyTank_Total_UpDown(def, energy_tank, player, changes)
    local down, up = GetDecrementIncrement(energy_tank.max_energy_update, energy_tank.max_energy + changes.max_energy, player.experience + changes.experience)
    this.Refresh_UpDownButton(def, down, up)
end
function Update_EnergyTank_Total(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes.max_energy = changes.max_energy - def.value_down
        changes.experience = changes.experience + 1
    end

    if isUpClicked and def.isEnabled_up then
        changes.max_energy = changes.max_energy + def.value_up
        changes.experience = changes.experience - 1
    end
end

function Refresh_EnergyTank_IsDirty(def, changes)
    local isClean =
        IsNearZero(changes.max_energy) and
        IsNearZero(changes.recovery_rate) and
        IsNearZero(changes.flying_percent) --and
        --IsNearZero(changes.experience)      -- experience is dependent on the other three.  So the only reason it would be non zero on its own is really bad math drift

    def.isDirty = not isClean
end