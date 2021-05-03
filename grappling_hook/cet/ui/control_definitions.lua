-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- See
--  models\ui\SummaryButton
--  models\ui\Label
--  models\ui\OrderedList
function Define_Controls_MainWindow(vars_ui, const)
    local main = vars_ui.mainWindow

    main.energyTank = Define_EnergyTank(vars_ui.mainWindow)

    Define_GrappleSlots(vars_ui, main)

    main.experience = Define_Experience_Main(const)

    main.consoleWarning = Define_ConsoleWarning(const)
end

------------------------------------- Main Window -------------------------------------

--NOTE: Define functions get called during init.  Refresh functions get called each frame that the config is visible

function Define_EnergyTank(mainWindow)
    return
    {
        -- In the middle of the window
        center_x = mainWindow.width / 2,
        center_y = mainWindow.height / 2,

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

function Define_GrappleSlots(vars_ui, window)
    -- Figure out the positions (they are in a hex pattern around the center)
    local center_x = vars_ui.mainWindow.width / 2
    local center_y = vars_ui.mainWindow.height / 2
    local offset_x_small = 160
    local offset_x_large = 280
    local offset_y = 180

    window.grapple1 = Define_GrappleSlots_DoIt(center_x - offset_x_small, center_y - offset_y, "1")
    window.grapple2 = Define_GrappleSlots_DoIt(center_x + offset_x_small, center_y - offset_y, "2")
    window.grapple3 = Define_GrappleSlots_DoIt(center_x + offset_x_large, center_y, "3")
    window.grapple4 = Define_GrappleSlots_DoIt(center_x + offset_x_small, center_y + offset_y, "4")
    window.grapple5 = Define_GrappleSlots_DoIt(center_x - offset_x_small, center_y + offset_y, "5")
    window.grapple6 = Define_GrappleSlots_DoIt(center_x - offset_x_large, center_y, "6")
end
function Define_GrappleSlots_DoIt(x, y, suffix)
    return
    {
        center_x = x,
        center_y = y,

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