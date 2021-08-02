local this = {}

function InitializeUI(vars_ui, const)
    vars_ui.autoshow_withconsole = GetSetting_Bool(const.settings.AutoShowConfig_WithConsole)
    if vars_ui.autoshow_withconsole == nil then     -- this will only happen if there's a db error
        vars_ui.autoshow_withconsole = true
    end

    vars_ui.screen = this.GetScreenInfo()    --NOTE: This won't see changes if they mess with their video settings, but that should be super rare.  They just need to reload mods

    vars_ui.style = this.LoadStylesheet()

    --TODO: Come up with a better name for this.  It's too easily confused with vars_ui.main (the first window)
    --TODO: Call it configWindow
    vars_ui.mainWindow = this.Define_MainWindow(vars_ui.screen)      -- going with a SPA, so it's probably going to be the only window (maybe also a dialog box at some point?)

    -- This can't be called yet.  It has to be done by the caller
    --TransitionWindows_Main(vars_ui, const)
end

-- The last step when defining a window is to call this, which does some post processing
function FinishDefiningWindow(window)
    this.BuildRenderTree(window)
    this.SortContentLists(window.render_nodes)
end

----------------------------------- Private Methods -----------------------------------

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

-- This looks for controls that have a position property and stores them in render_nodes
-- NOTE: This is is recursive, because controls may be stored in structures
function this.BuildRenderTree(window)
    local controls = this.FindAllControlsWithPosition(window)

    local nodes = {}

    for i = 1, #controls do
        --TODO: When controls can point to each other, this will need to be expanded to be a tree.  will
        -- need to have a list of temp subtrees in case the controls are iterated out of order (A points
        -- to B, but A is seen first)
        nodes[#nodes+1] =
        {
            control = controls[i],
            --children = nil,
        }
    end

    window.render_nodes = nodes
end

function this.FindAllControlsWithPosition(container)
    local retVal = {}

    for _, item in pairs(container) do
        if this.IsControlWithPosition(item) then
            retVal[#retVal+1] = item

        elseif type(item) == "table" then

            --TODO: Once panels are implemented, look for the children property and don't recurse (the panel will
            --manage its own children)

            -- Recurse
            local sub_list = this.FindAllControlsWithPosition(item)
            for i = 1, #sub_list do
                retVal[#retVal+1] = sub_list[i]
            end
        end
    end

    return retVal
end

function this.IsControlWithPosition(item)
    -- All controls should be tables
    if type(item) ~= "table" then
        return false
    end

    local pos = item.position
    if not pos or type(pos) ~= "table" then
        return false
    end

    -- This should be enough, but go ahead and look for horizontal and vertical
    local horz = pos.horizontal
    if not horz or type(horz) ~= "string" then
        return false
    end

    local vert = pos.horizontal
    if not vert or type(vert) ~= "string" then
        return false
    end

    return true
end

-- This looks for controls that have a content property and creates a sorted content_keys index
-- nodes is an array of models\misc\RenderNode
function this.SortContentLists(nodes)
    for i = 1, #nodes do
        -- The list that to be sorted is called content, so see if that exists
        local content = nodes[i].control.content
        if content and type(content) == "table" then
            -- Can't sort the content table directly, need an index table so that ipairs can be used
            local keys = {}

            -- populate the table that holds the keys
            for key in pairs(content) do
                table.insert(keys, key)
            end

            -- sort the keys
            table.sort(keys)

            nodes[i].control.content_keys = keys
        end

        -- Recurse
        if nodes[i].children then
            this.SortContentLists(nodes[i].children)
        end
    end
end