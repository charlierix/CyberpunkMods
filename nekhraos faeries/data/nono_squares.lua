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
        --this.TEST_MergeSquares_Add_ATTEMPT1(retVal, entry.hit, entry.normal, RADIUS)
        this.TEST_MergeSquares_Add(retVal, entry.hit, entry.normal, RADIUS)
    end

    return retVal
end


--TODO: radius should be larger for hits with straight up normals (use an animation curve)
--TODO: instead of a bunch of print statements, draw



-- Adds the circle into the list, merging with whatever it is close to that has the same normal
function this.TEST_MergeSquares_Add_ATTEMPT1(list, center, normal, radius)
    local index = 1

    while index <= #list do
        print("this.TEST_MergeSquares_Add_A1 b: " .. tostring(index))

        local entry = list[index]

        local removed = false

        if DotProduct3D(entry.normal, normal) >= DOT then
            local dist_sqr = GetVectorDiffLengthSqr(entry.center, center)

            local touch_dist = radius + entry.radius

            print("this.TEST_MergeSquares_Add_A1 c.  dist: " .. tostring(Round(math.sqrt(dist_sqr), 2)) .. " | touch_dist: " .. tostring(touch_dist))

            if dist_sqr <= touch_dist * touch_dist then
                -- These circles are close enough to merge
                local dist = math.sqrt(dist_sqr)

                local new_radius = dist / 2 + math.min(entry.radius, radius)

                print("this.TEST_MergeSquares_Add_A1 d.  entry.radius: " .. tostring(Round(entry.radius, 2)) .. " | radius: " .. tostring(Round(radius, 2)) .. " | new_radius: " .. tostring(Round(new_radius, 2)))

                if new_radius < entry.radius then
                    print("this.TEST_MergeSquares_Add_A1 e")

                    -- The circle being added is completely inside the existing.  Since the list only contains non
                    -- touching circles, there is nothing else to do
                    do return end

                elseif new_radius < radius then
                    print("this.TEST_MergeSquares_Add_A1 f")

                    -- The proposed merged circle is inside the circle passed in.  Wipe the current circle and keep
                    -- looking
                    table.remove(list, index)
                    removed = true

                else
                    print("this.TEST_MergeSquares_Add_A1 g")

                    -- Need to define a new circle that is the merge of these two
                    local avg_normal = this.GetAverageNormal(entry.normal, entry.radius, normal, radius)
                    local avg_center = GetMidPoint(entry.center, center)

                    -- Remove existing and recurse with the new merged circle
                    table.remove(list, index)
                    this.TEST_MergeSquares_Add_ATTEMPT1(list, avg_center, avg_normal, new_radius)

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

function this.TEST_GetMergedCircle_ATTEMPT1(center1, radius1, center2, radius2, dist)

-- /// <summary>
-- /// Returns a new circle that is around both circles if they are touching, or the larger circle if one is inside the other.
-- /// </summary>
-- /// <param name="c1">The first circle.</param>
-- /// <param name="c2">The second circle.</param>
-- /// <returns>A new circle that is around both circles if they are touching, or the larger circle if one is inside the other.</returns>
-- public static Circle GetCircle(Circle c1, Circle c2)
-- {
--     // Calculate the distance between the centers of the two circles.
--     double d = Math.Sqrt(Math.Pow(c2.X - c1.X, 2) + Math.Pow(c2.Y - c1.Y, 2));

--     // If one circle is completely inside the other, return the larger one.
--     if (d < Math.Abs(c1.Radius - c2.Radius))
--     {
--         return c1.Radius > c2.Radius ? c1 : c2;
--     }
--     // If the two circles are touching, return a new circle that is around both.
--     else if (d < c1.Radius + c2.Radius)
--     {
--         // distance from the center of the first circle to the point where the line between the centers of the two circles intersects
--         // the line connecting the centers of the two circles
--         double a = (Math.Pow(c1.Radius, 2) - Math.Pow(c2.Radius, 2) + Math.Pow(d, 2)) / (2 * d);
--
--         // distance from that point to the center of the new circle
--         double h = Math.Sqrt(Math.Pow(c1.Radius, 2) - Math.Pow(a, 2));
--
--         double x = c1.X + a * (c2.X - c1.X) / d;
--         double y = c1.Y + a * (c2.Y - c1.Y) / d;
--
--         return new Circle(x, y, h);
--     }
--     // If the two circles are not touching or intersecting at all, return null.
--     else
--     {
--         return null;
--     }
-- }


    if dist < radius1 - radius2 then
        return center1, radius1, true, false        -- two is inside of one

    elseif dist < radius2 - radius1 then
        return center2, radius2, false, true        -- one is inside of two
    end

    local a = ((radius1 * radius1) - (radius2 * radius2) + (dist * dist)) / (dist * 2)
    local h = math.sqrt((radius1 * radius1) - (a * a))

    local x = center1.x + a * (center2.x - center1.x) / dist
    local y = center1.y + a * (center2.y - center1.y) / dist
    local z = center1.z + a * (center2.z - center1.z) / dist

    return Vector4.new(x, y, z, 1), h, false, false
end
function this.TEST_GetMergedCircle_ATTEMPT2(center1, radius1, center2, radius2, dist)
    if dist < radius1 - radius2 then
        return center1, radius1, true, false        -- two is inside of one

    elseif dist < radius2 - radius1 then
        return center2, radius2, false, true        -- one is inside of two
    end


    -- pick a random color for the two circles
    -- draw the two circles


    -- Diameter of the new circle
    local new_diameter = radius1 + dist + radius2

    -- Center of the new circle (would be directly between the two if both have the same radius, but otherwise
    -- is proportional to the two radii)
    local sum_radius = radius1 + radius2

    -- local x = (radius2 * center1.x + radius1 * center2.x) / sum_radius
    -- local y = (radius2 * center1.y + radius1 * center2.y) / sum_radius
    -- local z = (radius2 * center1.z + radius1 * center2.z) / sum_radius

    local x = (radius1 * center1.x + radius2 * center2.x) / sum_radius
    local y = (radius1 * center1.y + radius2 * center2.y) / sum_radius
    local z = (radius1 * center1.z + radius2 * center2.z) / sum_radius



    -- draw the result circle as black (and thicker)



    return Vector4.new(x, y, z, 1), new_diameter / 2, false, false
end
function this.TEST_GetMergedCircle_ATTEMPT3(center1, normal1, radius1, center2, normal2, radius2, dist)
    -- Check for one of the circles inside the other
    if dist < radius1 - radius2 then
        return center1, radius1, true, false        -- two is inside of one

    elseif dist < radius2 - radius1 then
        return center2, radius2, false, true        -- one is inside of two
    end

    local color = GetRandomColor_HSV_ToHex(0, 360, 0.5, 0.8, 0.66, 0.85)

    debug_render_screen.Add_Circle(center1, normal1, radius1, nil, color)
    debug_render_screen.Add_Circle(center2, normal2, radius2, nil, color)

    -- Radius of the new circle
    local new_radius = (radius1 + dist + radius2) / 2

    -- Draw a line from the edge of circle1 to the edge of circle2
    local dir_1_to_2 = DivideVector(SubtractVectors(center2, center1), dist)

    local endpoint_1 = AddVectors(center1, MultiplyVector(dir_1_to_2, -radius1))
    local endpoint_2 = AddVectors(center2, MultiplyVector(dir_1_to_2, radius2))

    -- The center of the new circle is the middle of that line
    local midpoint = GetMidPoint(endpoint_1, endpoint_2)

    debug_render_screen.Add_Line(endpoint_1, endpoint_2, nil, color)
    debug_render_screen.Add_Dot(midpoint, nil, "000")



    local sum_radius = radius1 + radius2

    local xa = (radius2 * center1.x + radius1 * center2.x) / sum_radius
    local ya = (radius2 * center1.y + radius1 * center2.y) / sum_radius
    local za = (radius2 * center1.z + radius1 * center2.z) / sum_radius

    local xb = (radius1 * center1.x + radius2 * center2.x) / sum_radius
    local yb = (radius1 * center1.y + radius2 * center2.y) / sum_radius
    local zb = (radius1 * center1.z + radius2 * center2.z) / sum_radius

    debug_render_screen.Add_Dot(Vector4.new(xa, ya, za, 1), nil, "F00")
    debug_render_screen.Add_Dot(Vector4.new(xb, yb, zb, 1), nil, "0F0")

    debug_render_screen.Add_Circle(midpoint, normal1, new_radius, nil, "000", nil, nil, 16)

    return midpoint, new_radius, false, false
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