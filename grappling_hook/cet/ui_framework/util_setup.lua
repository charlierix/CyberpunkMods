local this = {}

-- This adds enums that are used by ui framework
function Define_UI_Framework_Constants(const)
    const.alignment_horizontal = CreateEnum("left", "center", "right")
    const.alignment_vertical = CreateEnum("top", "center", "bottom")
end

function LoadStylesheet()
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

-- The last step when defining a window is to call this, which does some post processing
function FinishDefiningWindow(window)
    this.BuildRenderTree(window)
    this.SortContentLists(window.render_nodes)
end

----------------------------------- Private Methods -----------------------------------

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

------------------------ Private Methods (FinishDefiningWindow) -----------------------

-- This looks for controls that have a position property and stores them in render_nodes
-- NOTE: This is is recursive, because controls may be stored in structures
function this.BuildRenderTree(window)
    local controls = this.FindAllControlsWithPosition(window)
    local nodes = this.Convert_Control_To_RenderPosition(controls)

    this.GroupRelativeTo(nodes)

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

-- This converts into nodes, doesn't touch children property
function this.Convert_Control_To_RenderPosition(controls)
    local nodes = {}

    for i = 1, #controls do
        nodes[#nodes+1] =
        {
            control = controls[i],
            --children = nil,
        }
    end

    return nodes
end

-- This moves nodes under the node they are relative to
-- NOTE: nodes passed in needs to be a 1D list
function this.GroupRelativeTo(nodes)
    local index = 1

    while index < #nodes do
        if nodes[index].control.position.relative_to then
            -- This has a parent, so can't be at the root level.  Remove from the roots and add to the control it's pointing to
            local node = table.remove(nodes, index)

            local parent = this.FindParent(nodes, node)
            if not parent then      -- letting control flow so a nil exception will also be logged
                print("Couldn't find the control referenced by relative_to")
                ReportTable(node.control)
            end

            if not parent.children then
                parent.children = {}
            end

            parent.children[#parent.children+1] = node

        else
            -- This can stay at the root level, move to the next node
            index = index + 1
        end
    end
end
function this.FindParent(nodes, node)
    for i = 1, #nodes do
        if nodes[i].control == node.control.position.relative_to then
            return nodes[i]
        end

        if nodes[i].children then
            -- Recurse
            local retVal = this.FindParent(nodes[i].children, node)
            if retVal then
                return retVal
            end
        end
    end

    return nil
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