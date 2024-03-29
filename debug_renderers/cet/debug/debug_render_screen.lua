-- All colors are hex format.  ARGB, alpha is optional
--  "444" becomes "FF444444" (very dark gray)
--  "806A" becomes "880066AA" (dusty blue)
--  "FF8040" becomes "FFFF8040" (sort of a coral)
--  "80FFFFFF" (50% transparent white)

-- Figuring out the ink controller was made possible by reading discord conversations between anygoodname, keanuWheeze, psiberx, donk7413 (and likely others that I'm forgetting)
-- Also analyzing "let there be flight" by jackhumbert and "nano drone" by keanuWheeze
-- Another great resource is rtti dump (search for it on discord)
-- and this site:
-- https://nativedb.red4ext.com/

local frame = require "debug/debug_render_screen_frame"
local ui = require "debug/debug_render_screen_ui"

local DebugRenderScreen = {}

local this = {}

local next_id = 0
local timer = 0
local item_types = CreateEnum("dot", "line", "triangle", "text", "text2D")

local controller = nil

local categories = {}
local items = StickyList:new()
local visuals_circle = StickyList:new()
local visuals_line = StickyList:new()
local visuals_triangle = StickyList:new()
local visuals_text = StickyList:new()

local sound_name = nil
local sound_time = nil

local up = nil

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
    this.PossiblyStopSound(false)

    -- Go through items and populate visuals (only items that are in front of the camera).  Turns high level concepts
    -- like circle/square into line paths that match this frame's perspective
    frame.RebuildVisuals(controller, items, item_types, visuals_circle, visuals_line, visuals_triangle, visuals_text)
end

function DebugRenderScreen.CallFrom_onDraw()
    if not is_enabled or (visuals_circle:GetCount() == 0 and visuals_line:GetCount() == 0 and visuals_triangle:GetCount() == 0 and visuals_text:GetCount() == 0) then
        do return end
    end

    ui.DrawCanvas(visuals_circle, visuals_line, visuals_triangle, visuals_text)
end

----------------------------------- Public Methods ------------------------------------

-- This can make it easier to group similar items into the same category.  All items will be shown with
-- the color and size specified here
---@param name string
---@param color_back string? Hex of color.  Formats: RGB, ARGB, RRGGBB, AARRGGBB
---@param color_fore string?
---@param lifespan_seconds number? If populated, a visual will be removed this long after adding it.  If nil, the visual will stay until manually removed
---@param size_mult number?
---@param const_size boolean? False/nil: size decreases when far from the camera.  True: size is the same regardless of distance from camera.  Useful if debuging things that are really far away
---@param x_percent2D number? Only used by 2D graphics (0 is left side of screen, 1 is right, 0.5 is center)
---@param y_percent2D number? Only used by 2D graphics (0 is top of screen, 1 is bottom, 0.5 is center)
function DebugRenderScreen.DefineCategory(name, color_back, color_fore, lifespan_seconds, is_single_frame, size_mult, const_size, x_percent2D, y_percent2D)
    local category =
    {
        name = name,
        color_back = color_back,
        color_fore = color_fore,
        size_mult = size_mult,
        const_size = const_size,
        lifespan_seconds = lifespan_seconds,
        is_single_frame = is_single_frame,
        x_percent2D = x_percent2D,
        y_percent2D = y_percent2D,
    }

    table.insert(categories, category)
end

function DebugRenderScreen.IsEnabled()
    return is_enabled
end

-- Category and after are all optional.  If a category is passed in, then the item will use that
-- category's values, unless overridden in the add method call
---@param position Vector4
---@return integer id Pass this to the remove function
function DebugRenderScreen.Add_Dot(position, category, color, lifespan_seconds, is_single_frame, size_mult, const_size)
    if not is_enabled then
        return nil
    end

    local color_back_final, _, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final = this.GetFinalValues(category, color, nil, size_mult, const_size, lifespan_seconds, is_single_frame)

    local item = items:GetNewItem()
    this.SetItemBase(item, item_types.dot, color_back_final, nil, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final)
    item.position = position

    return item.id
end

function DebugRenderScreen.Add_Line(point1, point2, category, color, lifespan_seconds, is_single_frame, size_mult, const_size)
    if not is_enabled then
        return nil
    end

    local _, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final = this.GetFinalValues(category, nil, color, size_mult, const_size, lifespan_seconds, is_single_frame)

    local item = items:GetNewItem()
    this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final)
    item.point1 = point1
    item.point2 = point2

    return item.id
end

function DebugRenderScreen.Add_Circle(center, normal, radius, category, color, lifespan_seconds, is_single_frame, size_mult, const_size)
    if not is_enabled then
        return nil
    end

    local _, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final = this.GetFinalValues(category, nil, color, size_mult, const_size, lifespan_seconds, is_single_frame)

    -- The default line thickness is too thin for a circle.  Use a larger value if there is nothing specified
    if not size_mult_final then
        size_mult_final = 8
    end

    -- Turn the circle into lines
    -- NOTE: if the player starts far away, then walks close the circle, then the num sides will be too small.  But it's not worth
    -- the expense of converting to lines every frame for that edge case
    local num_sides = this.GetCircleNumSides(center, radius)

    local points = this.GetCirclePoints(center, radius, normal, num_sides)

    local id = this.GetNextID()

    for i = 1, #points - 1, 1 do
        local item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = points[i]
        item.point2 = points[i + 1]
    end

    local item = items:GetNewItem()
    this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final, id)
    item.point1 = points[#points]
    item.point2 = points[1]

    return id
end

function DebugRenderScreen.Add_Arc(center, start_point, end_point, category, color, lifespan_seconds, is_single_frame, size_mult, const_size)
    if not is_enabled then
        return nil
    end

    local _, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final = this.GetFinalValues(category, nil, color, size_mult, const_size, lifespan_seconds, is_single_frame)

    -- The default line thickness is too thin for a circle.  Use a larger value if there is nothing specified
    if not size_mult_final then
        size_mult_final = 8
    end

    local radius_start = math.sqrt(GetVectorDiffLengthSqr(start_point, center))
    local radius_end = math.sqrt(GetVectorDiffLengthSqr(end_point, center))

    if IsNearZero(radius_start) or IsNearZero(radius_end) then
        LogError("Add_Arc start point and/or end point are same as center.  start radius: " .. tostring(radius_start) .. ", end radius: " .. tostring(radius_end))
        do return end
    end

    local arm_start_unit = DivideVector(SubtractVectors(start_point, center), radius_start)
    local arm_end_unit = DivideVector(SubtractVectors(end_point, center), radius_end)

    local degrees = Radians_to_Degrees(RadiansBetween3D(arm_start_unit, arm_end_unit))

    local num_sides = this.GetCircleNumSides(center, (radius_start + radius_end) / 2, degrees)

    local quat = GetRotation(arm_start_unit, arm_end_unit, 1 / num_sides)

    local unit1 = arm_start_unit
    local point1 = start_point

    local id = this.GetNextID()

    for i = 1, num_sides - 1, 1 do
        local unit2 = RotateVector3D(unit1, quat)
        local point2 = MultiplyVector(unit2, GetScaledValue(radius_start, radius_end, 0, num_sides, i))
        point2 = AddVectors(center, point2)

        local item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = point1
        item.point2 = point2

        unit1 = unit2
        point1 = point2
    end

    local item = items:GetNewItem()
    this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final, id)
    item.point1 = point1
    item.point2 = end_point     -- there's a slight math drift when repeatedly applying rotations.  I've only seen it come under.  So just run the last line to the endpoint passed in

    return id
end

-- size_mult and const_size refer to line thickness, which is only used if color_fore is populated
function DebugRenderScreen.Add_Triangle(point1, point2, point3, category, color_back, color_fore, lifespan_seconds, is_single_frame, size_mult, const_size)
    if not is_enabled then
        return nil
    end

    local color_back_final, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final = this.GetFinalValues(category, color_back, color_fore, size_mult, const_size, lifespan_seconds, is_single_frame)

    local id = this.GetNextID()

    if color_back_final then
        local item = items:GetNewItem()
        this.SetItemBase(item, item_types.triangle, color_back_final, nil, nil, nil, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = point1
        item.point2 = point2
        item.point3 = point3
    end

    if color_fore_final then
        if color_back_final and not size_mult_final then
            size_mult_final = 8
        end

        local item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = point1
        item.point2 = point2

        item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = point2
        item.point2 = point3

        item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = point3
        item.point2 = point1
    end

    return id
end

function DebugRenderScreen.Add_Square(center, normal, size_x, size_y, category, color_back, color_fore, lifespan_seconds, is_single_frame, size_mult, const_size)
    if not is_enabled then
        return nil
    end

    local color_back_final, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final = this.GetFinalValues(category, color_back, color_fore, size_mult, const_size, lifespan_seconds, is_single_frame)

    local id = this.GetNextID()

    local p1, p2, p3, p4 = this.GetSquarePoints(center, normal, size_x, size_y)

    if color_back_final then
        local item = items:GetNewItem()
        this.SetItemBase(item, item_types.triangle, color_back_final, nil, nil, nil, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = p1
        item.point2 = p2
        item.point3 = p3

        item = items:GetNewItem()
        this.SetItemBase(item, item_types.triangle, color_back_final, nil, nil, nil, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = p3
        item.point2 = p4
        item.point3 = p1
    end

    if color_fore_final then
        if color_back_final and not size_mult_final then
            size_mult_final = 8
        end

        local item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = p1
        item.point2 = p2

        item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = p2
        item.point2 = p3

        item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = p3
        item.point2 = p4

        item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore_final, size_mult_final, const_size_final, lifespan_seconds_final, is_single_frame_final, id)
        item.point1 = p4
        item.point2 = p1
    end

    return id
end

function DebugRenderScreen.Add_Text(center, text, category, color_back, color_fore, lifespan_seconds, is_single_frame)
    if not is_enabled then
        return nil
    end

    local color_back_final, color_fore_final, _, _, lifespan_seconds_final, is_single_frame_final = this.GetFinalValues(category, color_back, color_fore, nil, nil, lifespan_seconds, is_single_frame)

    local item = items:GetNewItem()
    this.SetItemBase(item, item_types.text, color_back_final, color_fore_final, nil, nil, lifespan_seconds_final, is_single_frame_final)
    item.center = center
    item.text = text

    return item.id
end

-- Instead of writing text at a world 3D position, this shows it at a fixed 2D screen position
---@param x_percent number? 0 is left edge of screen, 1 is right edge of screen (0.5 is center) -- nil allowed if category is passed in and specifies location
---@param y_percent number? 0 is top edge of screen, 1 is bottom edge of screen (0.5 is center)
function DebugRenderScreen.Add_Text2D(x_percent, y_percent, text, category, color_back, color_fore, lifespan_seconds, is_single_frame)
    if not is_enabled then
        return nil
    end

    local color_back_final, color_fore_final, _, _, lifespan_seconds_final, is_single_frame_final, x_percent_final, y_percent_final = this.GetFinalValues(category, color_back, color_fore, nil, nil, lifespan_seconds, is_single_frame, x_percent, y_percent)

    local item = items:GetNewItem()
    this.SetItemBase(item, item_types.text2D, color_back_final, color_fore_final, nil, nil, lifespan_seconds_final, is_single_frame_final)
    item.x_percent = x_percent_final
    item.y_percent = y_percent_final
    item.text = text

    return item.id
end

---@param id integer This is the id from one of the add functions
function DebugRenderScreen.Remove(id)
    if not is_enabled then
        do return end
    end

    local index = 1

    while index <= items:GetCount() do        -- there can be multiple items tied to the same id, so need to scan the whole list
        local item = items:GetItem(index)

        if item.id == id then
            items:RemoveItem(index)
        else
            index = index + 1
        end
    end
end

-- Removes all visual items (doesn't remove categories)
function DebugRenderScreen.Clear()
    if not is_enabled then
        do return end
    end

    items:Clear()
    this.PossiblyStopSound(true)        -- stopping this in case the want to stop calling update after calling clear
end

-- Though not a visual, this is a convinent class to add alert sounds to.  These can be used to make it more obvious when
-- something happens
--
-- Be sure to call CallFrom_onUpdate regularly so the sound can be dequeued after a second
function DebugRenderScreen.PlayTone1()
    if is_enabled then
        this.PlaySound("dev_alarm_02")
    end
end
function DebugRenderScreen.PlayTone2()
    if is_enabled then
        this.PlaySound("dev_drone_griffin_default_sgn_idle_beep")
    end
end
function DebugRenderScreen.PlayTone3()
    if is_enabled then
        this.PlaySound("dev_alarm_03")
    end
end
function DebugRenderScreen.PlayTone4()
    if is_enabled then
        this.PlaySound("q014_sc_02a_alarm")
    end
end
function DebugRenderScreen.PlayTone5()
    if is_enabled then
        this.PlaySound("dev_alarm_04")
    end
end
function DebugRenderScreen.PlayTone_TwoTones()
    if is_enabled then
        this.PlaySound("q110_screen_advert_hack_alert")
    end
end

----------------------------------- Private Methods -----------------------------------

-- id is optional.  Pass it in if multiple entries need to be tied to the same id
function this.SetItemBase(item, item_type, color_back, color_fore, size_mult, const_size, lifespan_seconds, is_single_frame, id)
    if not id then
        id = this.GetNextID()
    end

    item.id = id
    item.create_time = timer

    item.item_type = item_type
    item.color_back = color_back
    item.color_fore = color_fore
    item.size_mult = size_mult
    item.const_size = const_size
    item.lifespan_seconds = lifespan_seconds

    if is_single_frame then
        item.remaining_frames = 1
    else
        item.remaining_frames = nil     -- this needs to be set because it's stored in a stickylist, which reuses entries
    end
end

-- Populate from category if there is one.  If explicit values are passed in, they override category's definition
function this.GetFinalValues(category, color_back, color_fore, size_mult, const_size, lifespan_seconds, is_single_frame, x_percent, y_percent)
    if category then
        for i = 1, #categories, 1 do
            if categories[i].name == category then
                if not color_back then
                    color_back = categories[i].color_back
                end

                if not color_fore then
                    color_fore = categories[i].color_fore
                end

                if not size_mult then
                    size_mult = categories[i].size_mult
                end

                if not const_size then
                    const_size = categories[i].const_size
                end

                if not lifespan_seconds then
                    lifespan_seconds = categories[i].lifespan_seconds
                end

                if is_single_frame == nil then
                    is_single_frame = categories[i].is_single_frame
                end

                if not x_percent then
                    x_percent = categories[i].x_percent2D
                end

                if not y_percent then
                    y_percent = categories[i].y_percent2D
                end

                break
            end
        end
    end

    return color_back, color_fore, size_mult, const_size, lifespan_seconds, is_single_frame, x_percent, y_percent
end

function this.GetNextID()
    next_id = next_id + 1
    return next_id - 1
end

function this.RemoveExpiredItems()
    local index = 1

    while index <= items:GetCount() do
        local item = items:GetItem(index)

        if item.lifespan_seconds and timer > item.create_time + item.lifespan_seconds then
            items:RemoveItem(index)
        elseif item.remaining_frames == 0 then
            items:RemoveItem(index)
        else
            index = index + 1
        end

        if item.remaining_frames and item.remaining_frames > 0 then
            item.remaining_frames = item.remaining_frames - 1
        end
    end
end

function this.GetCircleNumSides(center, radius, degrees)
    local distance = math.sqrt(GetVectorDiffLengthSqr(Game.GetPlayer():GetWorldPosition(), center))
    if IsNearZero(distance) then
        distance = 0.01
    end
    local size = radius / distance

    local min_sides = 11
    local max_sides = 40
    local num_sides = Round(GetScaledValue(min_sides, max_sides, 0.01, 0.1, size), 0)

    if degrees then
        num_sides = num_sides * (degrees / 360)
    end

    num_sides = Clamp(min_sides, max_sides, num_sides)

    -- print("radius: " .. tostring(radius))
    -- print("distance: " .. tostring(distance))
    -- print("size: " .. tostring(size))
    -- print("num sides: " .. tostring(num_sides))

    return num_sides
end

function this.GetCirclePoints(center, radius, normal, num_sides)
    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    local quat = GetRotation(up, ToUnit(normal))

    local points2D = GetCircle_Cached(num_sides)

    local retVal = {}

    for _, point2D in ipairs(points2D) do
        local offset = Vector4.new(point2D.X * radius, point2D.Y * radius, 0, 1)
        offset = RotateVector3D(offset, quat)

        table.insert(retVal, AddVectors(center, offset))
    end

    return retVal
end
function this.GetSquarePoints(center, normal, size_x, size_y)
    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    local half_x = size_x / 2
    local half_y = size_y / 2

    local p1 = Vector4.new(-half_x, -half_y, 0, 1)
    local p2 = Vector4.new(half_x, -half_y, 0, 1)
    local p3 = Vector4.new(half_x, half_y, 0, 1)
    local p4 = Vector4.new(-half_x, half_y, 0, 1)

    local quat = GetRotation(up, ToUnit(normal))

    p1 = RotateVector3D(p1, quat)
    p2 = RotateVector3D(p2, quat)
    p3 = RotateVector3D(p3, quat)
    p4 = RotateVector3D(p4, quat)

    return
        AddVectors(center, p1),
        AddVectors(center, p2),
        AddVectors(center, p3),
        AddVectors(center, p4)
end

function this.PlaySound(name)
    if sound_name == name then
        do return end       -- already playing, let it play out
    end

    this.PossiblyStopSound(true)

    sound_name = name
    sound_time = timer

    local audioEvent = SoundPlayEvent.new()
    audioEvent.soundName = sound_name
    Game.GetPlayer():QueueEvent(audioEvent)
end
function this.PossiblyStopSound(should_force)
    if sound_name and (should_force or (timer - sound_time) > 1.5) then     -- the sounds are all quick

        local audioEvent = SoundStopEvent.new()
        audioEvent.soundName = sound_name
        Game.GetPlayer():QueueEvent(audioEvent)

        sound_name = nil
        sound_time = nil
    end
end

return DebugRenderScreen