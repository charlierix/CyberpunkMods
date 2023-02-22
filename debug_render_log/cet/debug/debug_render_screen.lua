-- All colors are hex format.  ARGB, alpha is optional
--  "444" becomes "FF444444" (very dark gray)
--  "806A" becomes "880066AA" (dusty blue)
--  "FF8040" becomes "FFFF8040" (sort of a coral)
--  "80FFFFFF" (50% transparent white)

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

-- It's up to the caller to only call this function in valid conditions (not in menus or workspots, not shutdown)
function DebugRenderScreen.CallFrom_onUpdate(deltaTime)
    if not is_enabled then
        do return end
    end

    timer = timer + deltaTime

    -- Remove items that have exceeded lifespan_seconds
    this.RemoveExpiredItems()

    -- Go through items and populate visuals (only items that are in front of the camera).  Turns high level concepts
    -- like circle/square into line paths that match this frame's perspective
    this.RebuildVisuals()
end

-- It's up to the caller to only call this function in valid conditions (not in menus or workspots, not shutdown)
function DebugRenderScreen.CallFrom_onDraw()
    if not is_enabled or (#visuals_circle == 0 and #visuals_line == 0) then
        do return end
    end

    local width, height, scale = this.GetScreenInfo()
    local center_x = width / 2
    local center_y = height / 2

    ImGui.SetNextWindowPos(0, 0, ImGuiCond.Always)
    ImGui.SetNextWindowSize(width, height, ImGuiCond.Always)

    if (ImGui.Begin("debug_canvas", true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoBackground)) then
        for _, circle in ipairs(visuals_circle) do
            local screen_x, screen_y = this.TransformToScreen(circle.center_x, circle.center_y, center_x, center_y)
            this.Draw_Circle(screen_x, screen_y, circle.radius, circle.color_background, circle.color_border, circle.thickness)
        end

        -- for _, line in ipairs(visuals_line) do
        --     this.Draw_Line()
        -- end
    end
    ImGui.End()
end

----------------------------------- Public Methods ------------------------------------

-- This can make it easier to group similar items into the same category.  All items will be shown with
-- the color and size specified here
---@param name string
---@param color string Hex of color.  Formats: RGB, ARGB, RRGGBB, AARRGGBB
---@param size_mult number
---@param lifespan_seconds number [Optional] If populated, a visual will be removed this long after adding it.  If nil, the visual will stay until manually removed
function DebugRenderScreen.DefineCategory(name, color, size_mult, lifespan_seconds)
    local category =
    {
        name = name,
        color = color,
        size_mult = size_mult,
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
function DebugRenderScreen.Add_Dot(position, category, color, size_mult, lifespan_seconds)
    if not is_enabled then
        return nil
    end

    local item = this.GetItemBase(item_types.dot, category, color, size_mult, lifespan_seconds)

    item.position = position

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

function this.GetItemBase(item_type, category, color, size_mult, lifespan_seconds)
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

function this.IsValidScreenPoint(point)
    return not ((point.X == -1 or point.X == 1) and (point.Y == -1 or point.Y == 1))
end

function this.TransformToScreen(x, y, screen_half_x, screen_half_y)
    return
        screen_half_x + (x * screen_half_x),        -- just assuming that it's normalized -1 to 1.  Need to test if it depends on aspect ratio
        screen_half_y + (-y * screen_half_y)
end

--------------------------- Private Methods (Build Visuals) ---------------------------

function this.ClearVisuals()
    while #visuals_circle > 0 do
        table.remove(visuals_circle, 1)
    end

    while #visuals_line > 0 do
        table.remove(visuals_line, 1)
    end
end

function this.RebuildVisuals()
    this.ClearVisuals()

    if not controller then      -- should never happen
        do return end
    end

    for _, item in ipairs(items) do
        if item.item_type == item_types.dot then
            this.RebuildVisuals_Dot(item)
        end
    end
end
function this.RebuildVisuals_Dot(item)
    local point = controller:ProjectWorldToScreen(item.position)

    if not this.IsValidScreenPoint(point) then
        do return end
    end

    local size_mult = 1
    if item.size_mult then
        size_mult = item.size_mult
    end

    local visual =
    {
        color_background = this.GetColor_ABGR(item.color),
        color_border = nil,
        thickness = nil,
        center_x = point.X,
        center_y = point.Y,
        radius = 6 * size_mult,
    }

    table.insert(visuals_circle, visual)
end

function this.GetColor_ABGR(color)
    if not color then
        local magenta = ConvertHexStringToNumbers_Magenta()
        return magenta
    end

    local _, color_abgr = ConvertHexStringToNumbers()
    return color_abgr
end

------------------------------- Private Methods (ImGui) -------------------------------

function this.Draw_Circle(center_x, center_y, radius, color_background, color_border, thickness)
    --local numSegments = 13
    local numSegments = -1      -- < 0 is an auto calculate

    if color_background then
        ImGui.ImDrawListAddCircleFilled(ImGui.GetWindowDrawList(), center_x, center_y, radius, color_background, numSegments)
    end

    if color_border then
        ImGui.ImDrawListAddCircle(ImGui.GetWindowDrawList(), center_x, center_y, radius, color_border, numSegments, thickness)
    end
end

function this.Draw_Line(x1, y1, x2, y2, color, thickness)
    ImGui.ImDrawListAddLine(ImGui.GetWindowDrawList(), x1, y1, x2, y2, color, thickness)
end

function this.Draw_Triangle(x1, y1, x2, y2, x3, y3, color_background, color_border, thickness)
    if color_background then
        ImGui.ImDrawListAddTriangleFilled(ImGui.GetWindowDrawList(), x1, y1, x2, y2, x3, y3, color_background)
    end

    if color_border then
        ImGui.ImDrawListAddTriangle(ImGui.GetWindowDrawList(), x1, y1, x2, y2, x3, y3, color_border, thickness)
    end
end

function this.Draw_Text(center_x, center_y, text, color)
    local width, height = ImGui.CalcTextSize(text, false, -1)

    ImGui.PushStyleColor(ImGuiCol.Text, color)





    ImGui.PopStyleColor(1)
end

---@return integer screen_width, integer screen_height, number scale
function this.GetScreenInfo()
    local width, height = GetDisplayResolution()
    local line_height = ImGui.GetTextLineHeight()

    return
        width,
        height,
        line_height / 18        -- it's 18 at a 1:1 scale, 36 on 4k (scale of 2)
end

return DebugRenderScreen