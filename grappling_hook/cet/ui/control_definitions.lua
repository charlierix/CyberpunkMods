-- This gets called during init and sets up as much static inforation as it can for all the
-- summary buttons (the rest of the info gets filled out each frame)
--
-- See models\SummaryButton
function Define_SummaryButtons(vars_ui)
    --------------- Main Window ---------------
    vars_ui.energyTank = Define_EnergyTank(vars_ui.mainWindow)

    Define_GrappleSlots(vars_ui)


    -- Post Processing
    SortSummaryButtonContent(vars_ui)
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

function Define_GrappleSlots(vars_ui)

    -- Figure out the positions (they are in a hex pattern around the center)
    local center_x = vars_ui.mainWindow.width / 2
    local center_y = vars_ui.mainWindow.height / 2
    local offset_x_small = vars_ui.mainWindow.width * 0.25
    local offset_x_large = vars_ui.mainWindow.width * 0.4
    local offset_y = vars_ui.mainWindow.height * 0.2

    vars_ui.grapple1 = Define_GrappleSlots_DoIt(center_x - offset_x_small, center_y - offset_y, "1")
    vars_ui.grapple2 = Define_GrappleSlots_DoIt(center_x + offset_x_small, center_y - offset_y, "2")
    vars_ui.grapple3 = Define_GrappleSlots_DoIt(center_x + offset_x_large, center_y, "3")
    vars_ui.grapple4 = Define_GrappleSlots_DoIt(center_x + offset_x_small, center_y + offset_y, "4")
    vars_ui.grapple5 = Define_GrappleSlots_DoIt(center_x - offset_x_small, center_y + offset_y, "5")
    vars_ui.grapple6 = Define_GrappleSlots_DoIt(center_x - offset_x_large, center_y, "6")
end
function Define_GrappleSlots_DoIt(x, y, suffix)
    return
    {
        center_x = x,
        center_y = y,

        min_width = 200,
        min_height = 90,

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

------------------------------------ Helper Methods -----------------------------------

function SortSummaryButtonContent(vars_ui)
    for _, item in pairs(vars_ui) do
        -- Can't tell exactly what is a summary button, but it's at least a table
        if type(item) == "table" then
            -- The list that will be sorted is called content, so see if that exists
            local content = item.content
            if content and type(content) == "table" then
                -- This is likely a summary button content.  Could do an extra validation that keys are
                -- strings and items arrays that contain a prompt or value key.  But there shouldn't be
                -- any harm in sorting now

                -- Can't sort the content table directly, need an index table so that ipairs can be used
                local keys = {}

                -- populate the table that holds the keys
                for key in pairs(content) do
                    table.insert(keys, key)
                end

                -- sort the keys
                table.sort(keys)

                item.content_keys = keys
            end
        end
    end
end