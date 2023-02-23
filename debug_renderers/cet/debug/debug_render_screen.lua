-- All colors are hex format.  ARGB, alpha is optional
--  "444" becomes "FF444444" (very dark gray)
--  "806A" becomes "880066AA" (dusty blue)
--  "FF8040" becomes "FFFF8040" (sort of a coral)
--  "80FFFFFF" (50% transparent white)

local frame = require "debug/debug_render_screen_frame"
local ui = require "debug/debug_render_screen_ui"

local DebugRenderScreen = {}

local this = {}

local next_id = 0
local timer = 0
local item_types = CreateEnum("dot", "line", "circle", "rectangle", "text")

local controller = nil

local categories = {}
local items = {}
local visuals_circle = {}
local visuals_line = {}

local is_enabled = false

--------------------------------- Called From Events ----------------------------------

---@param enable_drawing boolean If enable_logging is false, then calling the rest of the functions do nothing.  This allows logging code to be left in with almost zero performance issues
function DebugRenderScreen.CallFrom_onInit(enable_drawing)
    --NOTE: There may be a better controller to use.  Chose this because it seems to run every time
    --If you reload all mods from cet console, you will need to load a save for this event to fire again
	Observe("CrosshairGameController_NoWeapon", "OnInitialize", function(obj)
        controller = obj        -- this is an instance of CrosshairGameController_NoWeapon which extends worlduiIWidgetGameController, which has ProjectWorldToScreen()
	end)

    is_enabled = enable_drawing
end

-- It's up to the caller to only call update/draw in valid conditions (not in menus or workspots, not shutdown)

function DebugRenderScreen.CallFrom_onUpdate(deltaTime)
    if not is_enabled then
        do return end
    end

    timer = timer + deltaTime

    -- Remove items that have exceeded lifespan_seconds
    this.RemoveExpiredItems()

    -- Go through items and populate visuals (only items that are in front of the camera).  Turns high level concepts
    -- like circle/square into line paths that match this frame's perspective
    frame.RebuildVisuals(controller, items, item_types, visuals_circle, visuals_line)
end

function DebugRenderScreen.CallFrom_onDraw()
    if not is_enabled or (#visuals_circle == 0 and #visuals_line == 0) then
        do return end
    end

    ui.DrawCanvas(visuals_circle, visuals_line)
end

----------------------------------- Public Methods ------------------------------------

-- This can make it easier to group similar items into the same category.  All items will be shown with
-- the color and size specified here
---@param name string
---@param color string Hex of color.  Formats: RGB, ARGB, RRGGBB, AARRGGBB
---@param size_mult number
---@param const_size boolean False: size decreases when far from the camera.  True: size is the same regardless of distance from camera.  Useful if debuging things that are really far away
---@param lifespan_seconds number [Optional] If populated, a visual will be removed this long after adding it.  If nil, the visual will stay until manually removed
function DebugRenderScreen.DefineCategory(name, color, size_mult, const_size, lifespan_seconds)
    local category =
    {
        name = name,
        color = color,
        size_mult = size_mult,
        const_size = const_size,
        lifespan_seconds = lifespan_seconds,
    }

    table.insert(categories, category)
end

function DebugRenderScreen.IsEnabled()
    return is_enabled
end

-- Category and after are all optional.  If a category is passed in, then the item will use that
-- category's values, unless overridden in the add method call
---@param position Vector4
---@return table? Item Use this if you want to modify a value after creation (like position)
function DebugRenderScreen.Add_Dot(position, category, color, size_mult, const_size, lifespan_seconds)
    if not is_enabled then
        return nil
    end

    local item = this.GetItemBase(item_types.dot, category, color, size_mult, const_size, lifespan_seconds)

    item.position = position

    table.insert(items, item)

    return item
end

function DebugRenderScreen.Add_Line(point1, point2, category, color, size_mult, const_size, lifespan_seconds)
    if not is_enabled then
        return nil
    end

    local item = this.GetItemBase(item_types.line, category, color, size_mult, const_size, lifespan_seconds)

    item.point1 = point1
    item.point2 = point2

    table.insert(items, item)

    return item
end

---@param item table This is an item that was returned by one of the add functions
function DebugRenderScreen.Remove(item)
    if not is_enabled then
        do return end
    end

    for i = 1, #items, 1 do
        if items[i].id == item.id then
            table.remove(items, i)
            do return end       -- no need to keep scanning, there should never be duplicate IDs
        end
    end
end

-- Removes all visual items (doesn't remove categories)
function DebugRenderScreen.Clear()
    if not is_enabled then
        do return end
    end

    while #items > 0 do
        table.remove(items, 1)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetItemBase(item_type, category, color, size_mult, const_size, lifespan_seconds)
    -- Populate from category if there is one.  If explicit values are passed in, they override category's definition
    if category then
        for i = 1, #categories, 1 do
            if categories[i].name == category then
                if not color then
                    color = categories[i].color
                end

                if not size_mult then
                    size_mult = categories[i].size_mult
                end

                if not lifespan_seconds then
                    lifespan_seconds = categories[i].lifespan_seconds
                end
            end
        end
    end

    return
    {
        id = this.GetNextID(),
        create_time = timer,

        item_type = item_type,
        category = category,
        color = color,
        size_mult = size_mult,
        const_size = const_size,
        lifespan_seconds = lifespan_seconds,
    }
end

function this.GetNextID()
    next_id = next_id + 1
    return next_id - 1
end

function this.RemoveExpiredItems()
    local index = 1

    while index <= #items do
        if items[index].lifespan_seconds and timer > items[index].create_time + items[index].lifespan_seconds then
            table.remove(items, index)
        else
            index = index + 1
        end
    end
end

return DebugRenderScreen