local NoNoSquares = {}

local this = {}

--local RADIUS = 1.5 / 2
local RADIUS = 3 / 2
local DOT = 0.98

-- list of long term squares
-- list of newly added squares (they need to be merged into the long term squares.  Also, by storing these here, the merge can be done in a separate frame from the ray casts)

-- lists where material is the key, stickylist of { hit, normal } as the value
local initial_list = {}

-- instead of just hit and normal, store more of an entry that has centerpoint, size (final should have last update time)
local intermediate_list = {}
local final_list = {}

function NoNoSquares.Tick(o)
    -- Merge intermediate squares into final.  Spreading the work over a couple frames to avoid processor spikes.  Doing
    -- intermediate first in case initial has a couple frames in a row of adding (shouldn't happen since scanner is set
    -- to run a few times a second)
    local intermediate = this.Move_Intermediate_to_Final()

    if not intermediate then
        this.Move_Initial_to_Intermediate()
    end

    -- clean up old squares
end

function NoNoSquares.AddRayHit(point, normal, material)
    if not initial_list[material] then
        initial_list[material] = StickyList:new()
    end

    local entry = initial_list[material]:GetNewItem()
    entry.hit = point
    entry.normal = normal


    -- assume this hit is the center of a square

    -- look for nearby hits with the same normal
    --  if found, enlarge the assumed square


    -- define a cube based on the square's area (may want more depth than just a cube)




end

-- Returns a list of squares that are inside the search sphere
function NoNoSquares.GetNearby(point, radius)
    
end

function NoNoSquares.TEST_AddHits(hits)
    local material_colors = {}

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
        --debug_render_screen.Add_Square(entry.hit, entry.normal, RADIUS * 2, RADIUS * 2, nil, material_colors[material], "4000")
        debug_render_screen.Add_Circle(entry.hit, entry.normal, RADIUS, nil, "000", nil, nil, 6)

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
        this.TEST_MergeSquares_Add(retVal, entry.hit, entry.normal, RADIUS)
    end

    return retVal
end


--TODO: radius should be larger for hits with straight up normals (use an animation curve)


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

function this.Move_Initial_to_Intermediate()
    for material, list in pairs(initial_list) do

    end
end

function this.Move_Intermediate_to_Final()
    for material, list in pairs(initial_list) do

    end

    return false
end

function this.FindMatches(list_from, list_to)
    
end

return NoNoSquares