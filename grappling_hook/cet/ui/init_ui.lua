local this = {}

function InitializeUI(vars_ui, const)
    vars_ui.screen = this.GetScreenInfo()    --NOTE: This won't see changes if they mess with their video settings, but that should be super rare.  They just need to reload mods

    vars_ui.style = this.LoadStylesheet()

    --TODO: Come up with a better name for this.  It's too easily confused with vars_ui.main (the first window)
    vars_ui.mainWindow = this.Define_MainWindow(vars_ui.screen)      -- going with a SPA, so it's probably going to be the only window (maybe also a dialog box at some point?)

    DefineWindow_Main(vars_ui, const)      -- this must come after vars_ui.mainWindow is defined
    DefineWindow_EnergyTank(vars_ui, const)
    DefineWindow_Grapple_Choose(vars_ui, const)
    DefineWindow_Grapple_Straight(vars_ui, const)
    DefineWindow_GrappleStraight_AimDuration(vars_ui, const)
    DefineWindow_GrappleStraight_Distances(vars_ui, const)

    -- Post Processing
    this.SortContentLists(vars_ui.main)
    this.SortContentLists(vars_ui.energy_tank)
    this.SortContentLists(vars_ui.grapple_choose)
    this.SortContentLists(vars_ui.grapple_straight)
    this.SortContentLists(vars_ui.gst8_aimdur)
    this.SortContentLists(vars_ui.gst8_dist)
end

------------------------------------------- Private Methods -------------------------------------------

-- This looks for controls that have a content property and creates a sorted content_keys index
function this.SortContentLists(window)
    for _, item in pairs(window) do
        -- All controls should be tables
        if type(item) == "table" then
            -- The list that will be sorted is called content, so see if that exists
            local content = item.content
            if content and type(content) == "table" then
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

function this.GetScreenInfo()
    local width, height = GetDisplayResolution()

    return
    {
        width = width,
        height = height,
        center_x = width / 2,
        center_y = height / 2,
    }
end

function this.LoadStylesheet()
    local file = io.open("ui/stylesheet.json", "r")
    if not file then
        print("GRAPPLING HOOK ERROR: Can't find file: ui/stylesheet.json")
        return nil
    end

    local json = file:read("*all")

    local style = extern_json.decode(json)

    -- Convert color strings
    this.FinishStylesheetColors(style)

    return style
end

function this.FinishStylesheetColors(style)
    local stored = {}

    for key, value in pairs(style) do
        local type = type(value)

        if type == "string" then
            if string.find(key, "_color") then
                local argb, abgr, a, r, g, b = ConvertHexStringToNumbers(value)

                style[key] = nil        -- the hex value isn't needed anymore.  Getting rid of it so there's no confusion

                -- Store these off so there's no chance of interfering with the for loop
                stored[key .. "_argb"] = argb
                stored[key .. "_abgr"] = abgr

                -- stored[key .. "_a"] = a      -- the individual ints aren't needed
                -- stored[key .. "_r"] = r
                -- stored[key .. "_g"] = g
                -- stored[key .. "_b"] = b
            end

        elseif type == "table" then
            -- Recurse
            this.FinishStylesheetColors(value)
        end
    end

    for key, value in pairs(stored) do
        style[key] = value
    end
end

function this.Define_MainWindow(screen)
    local width = 1000
    local height = 800

    return
    {
        width = width,
        height = height,
        left = screen.center_x - width / 2,
        top = screen.center_y - height / 2,
    }
end