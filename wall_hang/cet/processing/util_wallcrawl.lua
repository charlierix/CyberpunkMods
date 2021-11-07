local this = {}

local up = nil      -- can't use vector4 before init

-- If the player is trying to crawl along the wall, then this will calculate the new position
-- Returns
--  isTryingToStand     true when they are at the top of a wall and trying to climb up onto the ledge above
--  position            the new position to teleport
--  normal              the normal of the wall they are clinging to (normal could change frame to frame as they crawl around)
function WallCrawl_GetNewPosition(position, normal, o, player, keys, const, deltaTime, log2, log3)
    if IsNearZero(keys.analog_x) and IsNearZero(keys.analog_y) then
        return false, position, normal
    end

    o:GetCamera()
    if not o.lookdir_forward then
        return false, position, normal     -- should never happen
    end

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    -- Figure out the direction to move along the plane
    local direction, right = this.GetDirectionsAlongPlane(o, normal)
    if not direction then
        return false, position, normal
    end

    local position_offset = Vector4.new(position.x, position.y, position.z + const.rayFrom_Z)

    -- See what direction to crawl along the wall's plane
    local new_pos_offset, move_direction = this.GetProposedWallCrawlPos(position_offset, direction, right, player, keys, const, deltaTime)
    if IsNearZero_vec4(move_direction) then
        return false, position, normal      -- the check at the top of this function should have caught this case, but doing a second check here to be safe
    end

    -- Do some raycasts along the move direction
    -- NOTE: This won't see anything when they are at the edge of an outside corner
    local hits = RayCast_NearbyWalls_CrawlBasic(position_offset, new_pos_offset, move_direction, normal, o, log2, const.wallDistance_stick_max * 2)
    local hit = this.GetBestHit(hits, const.wallDistance_stick_min, const.wallDistance_stick_max)

    if hit then
        return this.Move_StandardHit(position_offset, new_pos_offset, hit, const)
    else
        return this.Move_OutsideCorner(position, normal, move_direction, position_offset, new_pos_offset, o, const, log3)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Move_StandardHit(position_offset, new_pos_offset, hit, const)
    -- Push them a bit toward the ideal distance from the plane
    local distance_moved = math.sqrt(GetVectorDiffLengthSqr(position_offset, new_pos_offset))
    new_pos_offset = MoveToIdealDistance(new_pos_offset, hit.normal, const.wallDistance_stick_ideal, math.sqrt(hit.distSqr), distance_moved)

    return false, Vector4.new(new_pos_offset.x, new_pos_offset.y, new_pos_offset.z - const.rayFrom_Z, 1), hit.normal
end
function this.Move_OutsideCorner(position, normal, move_direction, position_offset, new_pos_offset, o, const, log3)
    if log3.enable_logging then
        this.LogOutsideCorner_Prep(normal, move_direction, position_offset, o, log3)
    end

    local hits = RayCast_NearbyWalls_CrawlBasic_OutsideCorner(position_offset, new_pos_offset, move_direction, normal, const.wallDistance_stick_max, const.wallDistance_stick_max * 2, o, log3)
    local hit = this.GetBestHit(hits, const.wallDistance_stick_min, const.wallDistance_stick_max)

    if hit then
        if DotProduct3D(hit.normal, up) >= 0.9 then
            -- Outside corner climbing onto a horizontal ledge.  Tell the calling function to boost the
            -- player onto the ledge
            return true, Vector4.new(hit.rayStart.x, hit.rayStart.y, hit.rayStart.z - const.rayFrom_Z, 1), hit.normal
        else
            -- TODO: Can't jump to hit.rayStart.  Need to interpolate from current position to the new position
            return false, Vector4.new(hit.rayStart.x, hit.rayStart.y, hit.rayStart.z - const.rayFrom_Z, 1), hit.normal
        end
    else
        return false, position, normal
    end

end

-- This figures out what will be up/forward and right based on the player's look direction
-- relative to the plane (and special condition for perfectly horizontal planes)
function this.GetDirectionsAlongPlane(o, normal)
    --local direction = GetProjectedVector_AlongPlane_Unit(o.lookdir_forward, normal)        -- it didn't feel natural to move along look when pressing forward, and felt really odd when pressing left and right
    local direction = GetProjectedVector_AlongPlane_Unit(up, normal)

    local right = nil

    if IsNearZero_vec4(direction) then
        direction = GetProjectedVector_AlongPlane_Unit(o.lookdir_forward, normal)       -- the plane is a horizontal ceiling.  Just use the look direction

        if IsNearZero_vec4(direction) then
            return nil, nil     -- hanging from a ceiling and looking straight up or down (nearly impossible)
        end

        right = CrossProduct3D(normal, direction)       -- when hanging from the ceiling, this is the only correct way to cross product
    else
        -- Hanging on the side of a wall.  Right depends on whether the player is looking toward or away from the wall
        local dot = DotProduct3D(o.lookdir_forward, normal)

        if dot <= 0 then
            right = CrossProduct3D(direction, normal)       -- looking toward the wall
        else
            right = CrossProduct3D(normal, direction)       -- looking away from the wall, right becomes left
        end
    end

    return direction, right
end

-- Don't want hits that are too close.  Otherwise, the player will auger into inside corners.  Try to clip into walls
function this.GetBestHit(hits, min_dist, max_dist)
    if #hits == 0 then
        return nil
    end

    for i = 1, #hits, 1 do      -- it's sorted by distance
        if hits[i].distSqr > max_dist * max_dist then
            return nil
        elseif hits[i].distSqr >= min_dist * min_dist then
            return hits[i]
        end
    end

    return nil
end

-- This multiplies the move direction by the direction they are trying to move
-- W or controller's forward is along direction
-- S or controller's back is opposite direction
-- similar with left/right
-- Returns
--  Position to move to
--  Direction (unit vector)
function this.GetProposedWallCrawlPos(position, direction, right, player, keys, const, deltaTime)
    --NOTE: analog_x and y form a unit 2D vector, so no extra scaling is needed

    local x = (direction.x * keys.analog_y) + (right.x * keys.analog_x)
    local y = (direction.y * keys.analog_y) + (right.y * keys.analog_x)
    local z = (direction.z * keys.analog_y) + (right.z * keys.analog_x)

    x = x * player.wallcrawl_speed_horz
    y = y * player.wallcrawl_speed_horz
    if z >= 0 then
        z = z * player.wallcrawl_speed_up
    else
        z = z * player.wallcrawl_speed_down
    end

    local dir_len = math.sqrt((x * x) + (y * y) + (z * z))
    if IsNearZero(x) and IsNearZero(y) and IsNearZero(z) then
        dir_len = 10000     -- avoiding a divide by zero error.  Making the denominator large so that an isnearzero check against the vector is guaranteed to work
    end

    return
        Vector4.new(position.x + (x * deltaTime), position.y + (y * deltaTime), position.z + (z * deltaTime), 1),
        Vector4.new(x / dir_len, y / dir_len, z / dir_len, 1)
end

function this.LogOutsideCorner_Prep(normal, move_direction, position_offset, o, log3)
    if not log3.enable_logging then
        do return end
    end

    log3:NewFrame()

    log3:Add_Dot(o.pos, nil, "FFF")
    log3:Add_Dot(position_offset, nil, "FFF")
    log3:Add_Line(o.pos, position_offset, nil, "FFF")

    log3:Add_Line(o.pos, AddVectors(o.pos, o.lookdir_forward))
    log3:Add_Line(o.pos, AddVectors(o.pos, o.lookdir_right))

    local normal_neg = MultiplyVector(normal, -1)
    log3:Add_Line(o.pos, AddVectors(o.pos, normal_neg), nil, "44D")
    log3:Add_Line(o.pos, AddVectors(o.pos, move_direction), nil, "4D4")
    log3:Add_Line(o.pos, AddVectors(o.pos, CrossProduct3D(normal_neg, move_direction)), nil, "D44")
end