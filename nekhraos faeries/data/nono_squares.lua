local NoNoSquares = {}

local this = {}

local DOT = 0.98

--TODO: The handling of hit_max_radius is too basic.  There ends up being multiple squares that mostly overlap
--I think this is the main reason for the runtime slowdown

-- lists where material is the key, stickylist of { center, normal, radius } as the value
local initial_list = {}
local intermediate_list = {}
local final_list = {}                       -- this should add last updated time

local settings = nil                        --settings_util.Obstacles()

local up = nil                              --Vector4.new(0, 0, 1, 1)
local dot_hitradius_animcurve = nil         --AnimationCurve:new()

local SHOW_DEBUG = true
local material_colors = {}

function NoNoSquares.Tick(o)
    if not settings then
        settings = settings_util.Obstacles()
    end

    -- Merge intermediate squares into final.  Spreading the work over a couple frames to avoid processor spikes.  Doing
    -- intermediate first in case initial has a couple frames in a row of adding (shouldn't happen since scanner is set
    -- to run a few times a second)
    local intermediate = this.Move_Intermediate_to_Final(o.timer, settings.hit_max_radius)

    if not intermediate then
        this.Move_Initial_to_Intermediate(o.timer, settings.hit_max_radius)
    end

    -- Clean up old squares
    this.RemoveOldSquares(o.timer, o.pos, settings.hit_remember_min_seconds, settings.hit_remember_max_distance)

    -------- TEMP DRAWING --------
    if SHOW_DEBUG then
        -- Give count summary of final, intermediate
        local report_intermediate = this.GetCountReport(intermediate_list)
        local report_final = this.GetCountReport(final_list)

        if report_intermediate then
            debug_render_screen.Add_Text2D(0.2, 0.4, report_intermediate, nil, "B84B194B", "FFF", nil, true)
        end

        if report_final then
            debug_render_screen.Add_Text2D(0.1, 0.4, report_final, nil, "BB66532C", "FFF", nil, true)
        end

        -- Draw squares
        for material, list in pairs(final_list) do
            if not material_colors[material] then
                material_colors[material] = GetRandomColor_HSV_ToHex(0, 360, 0.5, 0.8, 0.66, 0.85, 0.33, 0.33)
                --material_colors[material] = GetRandomColor_HSV_ToHex(0, 360, 0.5, 0.8, 0.66, 0.85, 0.9, 0.9)
            end

            for i = 1, list:GetCount(), 1 do
                local entry = list:GetItem(i)
                --debug_render_screen.Add_Circle(entry.center, entry.normal, entry.radius, nil, "FFF", nil, true, 12)       -- expensive to use single frame
                debug_render_screen.Add_Square(entry.center, entry.normal, entry.radius * 2, entry.radius * 2, nil, material_colors[material], "4000", nil, true)
            end
        end
    end
end

function NoNoSquares.AddRayHit(point, normal, material_cname)
    if not settings then
        settings = settings_util.Obstacles()
    end

    --this.TEMP_ClearIntermediate()

    local radius = this.GetHitRadius(normal)
    if radius < 0.25 then
        do return end
    end

    local material = Game.NameToString(material_cname)

    if not initial_list[material] then
        initial_list[material] = StickyList:new()
    end

    local entry = initial_list[material]:GetNewItem()
    entry.center = point
    entry.normal = normal
    entry.radius = radius
end

-- Returns a list of squares that are touching the point
-- results_list is a StickyList (to help cut down on garbage collections).  Each entry is:
--  { center, normal, radius, dist_sqr }
function NoNoSquares.GetNearby(results_list, point, item_radius_mult)
    results_list:Clear()

    for _, list in pairs(final_list) do
        for i = 1, list:GetCount(), 1 do
            local entry = list:GetItem(i)

            -- Distance from item
            local dist_sqr = GetVectorDiffLengthSqr(point, entry.center)

            local test_radius = entry.radius * item_radius_mult

            -- Add the item's radius to the total
            if dist_sqr <= test_radius * test_radius then
                local result_entry = results_list:GetNewItem()
                result_entry.center = entry.center
                result_entry.normal = entry.normal
                result_entry.radius = entry.radius
                result_entry.dist_sqr = dist_sqr
            end
        end
    end
end

function NoNoSquares.TEST_AddHits(hits)
    if not settings then
        settings = settings_util.Obstacles()
    end

    local by_material = {}

    -- store in hits by material
    for _, entry in ipairs(hits) do
        local material = Game.NameToString(entry.material)

        if not material_colors[material] then
            material_colors[material] = GetRandomColor_HSV_ToHex(0, 360, 0.5, 0.8, 0.66, 0.85, 0.33, 0.33)
            --material_colors[material] = GetRandomColor_HSV_ToHex(0, 360, 0.5, 0.8, 0.66, 0.85, 0.9, 0.9)
        end

        if not by_material[material] then
            by_material[material] = {}
        end

        --TODO: draw radius based on animation curve
        local radius = this.GetHitRadius(entry.normal)
        --debug_render_screen.Add_Square(entry.hit, entry.normal, radius * 2, radius * 2, nil, material_colors[material], "4000")
        debug_render_screen.Add_Circle(entry.hit, entry.normal, radius, nil, "000", nil, nil, 6)

        table.insert(by_material[material], { hit = entry.hit, normal = entry.normal })
    end

    -- merge nearby hits
    for material, material_set in pairs(by_material) do
        local merged = this.TEST_MergeSquares(material_set)

        -- draw them
        for _, entry in ipairs(merged) do
            debug_render_screen.Add_Circle(entry.center, entry.normal, entry.radius, nil, "FFF", nil, nil, 12)
            debug_render_screen.Add_Square(entry.center, entry.normal, entry.radius * 2, entry.radius * 2, nil, material_colors[material], "4000")
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function this.TEST_MergeSquares(material_set)
    -- center
    -- normal
    -- radius
    local retVal = {}

    for _, entry in ipairs(material_set) do
        local radius = this.GetHitRadius(entry.normal)
        this.TEST_MergeSquares_Add(retVal, entry.hit, entry.normal, radius)
    end

    return retVal
end

-- Adds the circle into the list, merging with whatever it is close to that has the same normal
function this.TEST_MergeSquares_Add(list, center, normal, radius)
    local index = 1

    while index <= #list do
        local entry = list[index]

        local removed = false

        if DotProduct3D(entry.normal, normal) >= DOT then
            local dist_sqr = GetVectorDiffLengthSqr(entry.center, center)

            local touch_dist = entry.radius + radius

            if dist_sqr <= touch_dist * touch_dist then
                -- Circles are touching.  Need to merge into a new one
                --local new_center, new_radius, is_eaten_by_1, is_eaten_by_2 = this.TEST_GetMergedCircle(entry.center, entry.radius, center, radius, math.sqrt(dist_sqr))
                local new_center, new_radius, is_eaten_by_1, is_eaten_by_2 = this.TEST_GetMergedCircle(entry.center, entry.normal, entry.radius, center, normal, radius, math.sqrt(dist_sqr))

                if is_eaten_by_1 then
                    -- The circle being added is completely inside the existing.  Since the list only contains non
                    -- touching circles, there is nothing else to do
                    do return end

                elseif is_eaten_by_2 then
                    -- The proposed merged circle is inside the circle passed in.  Wipe the current circle and keep
                    -- looking
                    table.remove(list, index)
                    removed = true

                else
                    -- Define a new circle that is the merge of these two
                    local new_normal = this.GetAverageNormal(entry.normal, entry.radius, normal, radius)

                    -- Remove existing and recurse with the new merged circle
                    table.remove(list, index)
                    this.TEST_MergeSquares_Add(list, new_center, new_normal, new_radius)
                    do return end       -- no further iterating needed, since the recurse call took care of adding (also, the for loop would be messed up from the remove)
                end
            end
        end

        if not removed then
            index = index + 1
        end
    end

    -- If execution gets there, then the circle passed in isn't touching existing
    table.insert(list,
    {
        center = center,
        normal = normal,
        radius = radius,
    })
end

function this.TEST_GetMergedCircle(center1, normal1, radius1, center2, normal2, radius2, dist)
    -- Check for one of the circles inside the other
    if dist < radius1 - radius2 then
        return center1, radius1, true, false        -- two is inside of one

    elseif dist < radius2 - radius1 then
        return center2, radius2, false, true        -- one is inside of two
    end

    -- Radius of the new circle
    local new_radius = (radius1 + dist + radius2) / 2

    -- Draw a line from the edge of circle1 to the edge of circle2
    local dir_1_to_2 = DivideVector(SubtractVectors(center2, center1), dist)

    local endpoint_1 = AddVectors(center1, MultiplyVector(dir_1_to_2, -radius1))
    local endpoint_2 = AddVectors(center2, MultiplyVector(dir_1_to_2, radius2))

    -- The center of the new circle is the middle of that line
    local midpoint = GetMidPoint(endpoint_1, endpoint_2)

    debug_render_screen.Add_Dot(center1, nil, "888")
    debug_render_screen.Add_Circle(center1, normal1, radius1, nil, "8888", nil, nil, 3)

    debug_render_screen.Add_Dot(center2, nil, "888")
    debug_render_screen.Add_Circle(center2, normal2, radius2, nil, "8888", nil, nil, 3)

    debug_render_screen.Add_Line(endpoint_1, endpoint_2, nil, "000")
    debug_render_screen.Add_Dot(midpoint, nil, "000")

    return midpoint, new_radius, false, false
end

function this.TEMP_ClearIntermediate()
    for _, list in pairs(intermediate_list) do
        list:Clear()
    end
end

-- Returns the weighted average of the normals (as unit vector)
function this.GetAverageNormal(normal1, radius1, normal2, radius2)
    local sum_radius = radius1 + radius2

    local average = Vector4.new(
        ((normal1.x * radius1) + (normal2.x * radius2)) / sum_radius,
        ((normal1.y * radius1) + (normal2.y * radius2)) / sum_radius,
        ((normal1.z * radius1) + (normal2.z * radius2)) / sum_radius,
        1)

    return ToUnit(average)
end

function this.GetHitRadius(normal)
    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    if not dot_hitradius_animcurve then
        dot_hitradius_animcurve = AnimationCurve:new()

        for _, entry in ipairs(settings.angle_hitradius) do
            dot_hitradius_animcurve:AddKeyValue(Angle_to_Dot(entry.input), entry.output)
        end
    end

    local dot = DotProduct3D(normal, up)

    return dot_hitradius_animcurve:Evaluate(dot)
end

function this.Move_Initial_to_Intermediate(time, max_radius)
    for material, list in pairs(initial_list) do
        if not intermediate_list[material] then
            intermediate_list[material] = StickyList:new()
        end

        this.MergeInto(list, intermediate_list[material], time, max_radius)
        list:Clear()
    end
end

function this.Move_Intermediate_to_Final(time, max_radius)
    local had_intermediate = false

    for material, list in pairs(initial_list) do
        if list:GetCount() > 0 then
            if not final_list[material] then
                final_list[material] = StickyList:new()
            end

            this.MergeInto(list, final_list[material], time, max_radius)
            list:Clear()

            had_intermediate = true
        end
    end

    return had_intermediate
end

-- Each list is a StickyList with elements { center, normal, radius, last_update_time }
function this.MergeInto(list_source, list_dest, time, max_radius)
    for i = 1, list_source:GetCount(), 1 do
        local entry = list_source:GetItem(i)
        this.MergeInto_Add(list_dest, entry.center, entry.normal, entry.radius, time, max_radius)
    end
end



-- Adds the circle into the list, merging with whatever it is close to that has the same normal
function this.MergeInto_Add_ORIG(list, center, normal, radius, time, max_radius)
    local index = 1

    while index <= list:GetCount() do
        local entry = list:GetItem(index)

        local removed = false

        if entry.radius < max_radius and DotProduct3D(entry.normal, normal) >= DOT then
            local dist_sqr = GetVectorDiffLengthSqr(entry.center, center)

            local touch_dist = entry.radius + radius

            if dist_sqr <= touch_dist * touch_dist then
                -- Circles are touching.  Need to merge into a new one
                local new_center, new_radius, is_eaten_by_1, is_eaten_by_2 = this.GetMergedCircle(entry.center, entry.radius, center, radius, math.sqrt(dist_sqr))

                if is_eaten_by_1 then
                    -- The circle being added is completely inside the existing.  Since the list only contains non
                    -- touching circles, there is nothing else to do
                    do return end

                elseif is_eaten_by_2 then
                    -- The proposed merged circle is inside the circle passed in.  Wipe the current circle and keep
                    -- looking
                    list:RemoveItem(index)
                    removed = true

                else
                    -- Define a new circle that is the merge of these two
                    local new_normal = this.GetAverageNormal(entry.normal, entry.radius, normal, radius)

                    -- Remove existing and recurse with the new merged circle
                    list:RemoveItem(index)
                    this.MergeInto_Add(list, new_center, new_normal, new_radius, time, max_radius)
                    do return end       -- no further iterating needed, since the recurse call took care of adding (also, the for loop would be messed up from the remove)
                end
            end
        end

        if not removed then
            index = index + 1
        end
    end

    -- If execution gets there, then the circle passed in isn't touching existing
    local new_entry = list:GetNewItem()
    new_entry.center = center
    new_entry.normal = normal
    new_entry.radius = radius
    new_entry.last_update_time = time
end



local remove_indices = nil

-- Don't just stop on the first intersecting item.  Compare with all, look to see if it's eaten by one.  Otherwise add to the one that is closest
function this.MergeInto_Add(list, center, normal, radius, time, max_radius)
    if not remove_indices then
        remove_indices = StickyList:new()
    end

    remove_indices:Clear()

    local best_center = nil
    local best_new_radius = nil
    local best_existing_radius = nil
    local best_normal = nil
    local best_index = nil

    -- Scan the list, get the closest mergable or if eating occurred
    for i = 1, list:GetCount(), 1 do
        local entry = list:GetItem(i)

        if entry.radius < max_radius and DotProduct3D(entry.normal, normal) >= DOT then
            local dist_sqr = GetVectorDiffLengthSqr(entry.center, center)

            local touch_dist = entry.radius + radius

            if dist_sqr <= touch_dist * touch_dist then
                -- Circles are touching.  Calculate what the new circle would look like
                local new_center, new_radius, is_eaten_by_1, is_eaten_by_2 = this.GetMergedCircle(entry.center, entry.radius, center, radius, math.sqrt(dist_sqr))

                if is_eaten_by_1 then
                    -- The circle being added is completely inside the existing.  Since the list only contains non
                    -- touching circles, there is nothing else to do
                    do return end

                elseif is_eaten_by_2 then
                    local remove_entry = remove_indices:GetNewItem()
                    remove_entry.index = i

                elseif not best_new_radius or new_radius < best_new_radius then
                    best_center = new_center
                    best_new_radius = new_radius
                    best_existing_radius = entry.radius
                    best_normal = entry.normal
                    best_index = i
                end
            end
        end
    end

    if best_index then
        -- Mark the existing for removal, because it will be replaced with the merged
        this.InsertRemoveIndex(remove_indices, best_index)
    end

    for i = remove_indices:GetCount(), 1, -1 do
        local remove_entry = remove_indices:GetItem(i)
        list:RemoveItem(remove_entry.index)
    end

    if best_center then
        -- Define a new circle that is the merge of these two
        local new_normal = this.GetAverageNormal(best_normal, best_existing_radius, normal, radius)

        -- Recurse with the new merged circle
        this.MergeInto_Add(list, best_center, new_normal, best_new_radius, time, max_radius)

    else
        -- The circle passed in isn't touching existing
        local new_entry = list:GetNewItem()
        new_entry.center = center
        new_entry.normal = normal
        new_entry.radius = radius
        new_entry.last_update_time = time
    end
end

-- The remove list needs to stay sorted, so insert index into the appropriate spot
function this.InsertRemoveIndex(list, index)
    for i = 1, remove_indices:GetCount(), 1 do
        local remove_entry = remove_indices:GetItem(i)

        if index < remove_entry.index then
            local remove_entry2 = list:InsertNewItem(i)
            remove_entry2.index = index
            do return end
        end
    end

    local remove_entry = remove_indices:GetNewItem()
    remove_entry.index = index
end


function this.GetMergedCircle(center1, radius1, center2, radius2, dist)
    -- Check for one of the circles inside the other
    if dist < radius1 - radius2 then
        return center1, radius1, true, false        -- two is inside of one

    elseif dist < radius2 - radius1 then
        return center2, radius2, false, true        -- one is inside of two
    end

    -- Radius of the new circle
    local new_radius = (radius1 + dist + radius2) / 2

    -- Draw a line from the edge of circle1 to the edge of circle2
    local dir_1_to_2 = DivideVector(SubtractVectors(center2, center1), dist)

    local endpoint_1 = AddVectors(center1, MultiplyVector(dir_1_to_2, -radius1))
    local endpoint_2 = AddVectors(center2, MultiplyVector(dir_1_to_2, radius2))

    -- The center of the new circle is the middle of that line
    local midpoint = GetMidPoint(endpoint_1, endpoint_2)

    return midpoint, new_radius, false, false
end

function this.RemoveOldSquares(time, pos, min_seconds, max_distance)
    local max_distance_sqr = max_distance * max_distance

    for _, list in pairs(final_list) do
        local index = 1

        while index <= list:GetCount() do
            local entry = list:GetItem(index)

            --NOTE: not accounting for radius of hit.  That needs to be part of max_distance
            if time - entry.last_update_time > min_seconds and GetVectorDiffLengthSqr(pos, entry.center) > max_distance_sqr then
                list:RemoveItem(index)
            else
                index = index + 1
            end
        end
    end
end

function this.GetCountReport(by_material)
    local retVal = nil

    for material, squares in pairs_sorted(by_material) do
        local count = squares:GetCount()

        if count > 0 then
            if not retVal then
                retVal = ""
            end

            if retVal then
                retVal = retVal .. "\r\n"
            end

            retVal = retVal .. material .. ": " .. tostring(count)
        end
    end

    return retVal
end

return NoNoSquares