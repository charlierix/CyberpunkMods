-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- See
--  models\ui\SummaryButton
--  models\ui\Label
--  models\ui\OrderedList
function Define_Controls_MainWindow(vars_ui, const)
    local main = {}
    vars_ui.main = main

    main.title = Define_Title("Grappling Hook", const)

    main.consoleWarning = Define_ConsoleWarning(const)

    main.energyTank = Define_EnergyTank(const)

    Define_GrappleSlots(main, const)

    main.experience = Define_Experience_Main(const)
end

function Define_Controls_EnergyTank(vars_ui, const)
    local energy_tank = {}
    vars_ui.energy_tank = energy_tank

    energy_tank.title = Define_Title("Energy Tank", const)


    -- 3 sets in a triangle around the center

    energy_tank.updown =
    {
        position =
        {
            pos_x = 0,
            pos_y = 0,

            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        isHorizontal = false,
    }




    energy_tank.experience = Define_Experience_EnergyTank(const)

end

----------------------------------- Common Controls -----------------------------------

function Define_Title(title, const)
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

------------------------------------- Main Window -------------------------------------

--NOTE: Define functions get called during init.  Refresh functions get called each frame that the config is visible

function Define_EnergyTank(const)
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
function Refresh_EnergyTank(def, energy_tank)
    def.header_value = tostring(Round(energy_tank.max_energy))
    def.content.a_recovery_rate.value = tostring(Round(energy_tank.recovery_rate, 1))
    def.content.b_flying_percent.value = tostring(Round(energy_tank.flying_percent * 100)) .. "%%"
end

function Define_GrappleSlots(window, const)
    -- Figure out the positions (they are in a hex pattern around the center)
    local offset_x_small = 160
    local offset_x_large = 280
    local offset_y = 180

    window.grapple1 = Define_GrappleSlots_DoIt(-offset_x_small, -offset_y, "1", const)
    window.grapple2 = Define_GrappleSlots_DoIt(offset_x_small, -offset_y, "2", const)
    window.grapple3 = Define_GrappleSlots_DoIt(offset_x_large, 0, "3", const)
    window.grapple4 = Define_GrappleSlots_DoIt(offset_x_small, offset_y, "4", const)
    window.grapple5 = Define_GrappleSlots_DoIt(-offset_x_small, offset_y, "5", const)
    window.grapple6 = Define_GrappleSlots_DoIt(-offset_x_large, 0, "6", const)

end
function Define_GrappleSlots_DoIt(x, y, suffix, const)
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
function Refresh_GrappleSlot(def, grapple)
    if grapple then
        def.header_prompt = grapple.name
        def.unused_text = nil
    else
        def.unused_text = "empty"
        def.header_prompt = nil
    end
end

function Define_Experience_Main(const)
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
function Refresh_Experience_Main(def, player)
    def.content.available.value = tostring(math.floor(player.experience))
end

function Define_ConsoleWarning(const)
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

function Define_Experience_EnergyTank(const)
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

function Refresh_Updown(def)
    def.isEnabled_down = true
    def.text_down = "1"

    def.isEnabled_up = true
    def.text_up = "1"
end