local this = {}

local log = nil
local log2 = nil
local up = nil      -- can't use vector4 before init

-- Just keeps teleporting to the initial catch point
function Process_Hang(o, player, vars, const, debug, keys, startStopTracker, deltaTime)
    local isHangDown, isJumpDown = startStopTracker:GetButtonState()

    if log and log:IsPopulated() and (not isHangDown or isJumpDown) then
        log:Save("WallCrawl")
        log2:Save("WallCrawl2")
    end

    if not isHangDown then
        Transition_ToStandard(vars, const, debug, o)
        do return end

    elseif isJumpDown then
        Transition_ToJump_Calculate(vars, const, o, vars.hangPos, vars.normal, startStopTracker)
        do return end
    end

    if not log then
        log = DebugRenderLogger:new(const.shouldShowLogging3D_wallCrawl)
        log2 = DebugRenderLogger:new(const.shouldShowLogging3D_wallCrawl)
        this.EnsureLogSetup()
    end

    -- Get the new yaw if they are trying to look left or right
    local yaw = this.GetYaw(o, keys, const)

    -- If they are trying to crawl around, then the position will change
    local isTryingToStand, pos, normal = this.GetNewPosition(vars.hangPos, vars.normal, o, player, keys, const, deltaTime)

    if isTryingToStand then
        -- Need to give them a small upward kick (and maybe a little toward the wall), then transition back to standard

    else
        vars.hangPos = pos
        vars.normal = normal

        o:Teleport(pos, yaw)        --NOTE: Even if they aren't crawling or changing look direction, teleport is needed to counteract gravity
    end
end

----------------------------------- Private Methods -----------------------------------

function this.EnsureLogSetup()
    if #log.categories == 0 then
        log:DefineCategory("player", "FF5", 0.05)
        log:DefineCategory("wall", "4000", 1)
        log:DefineCategory("normal")
        log:DefineCategory("look", "FF5", 0.75)
        log:DefineCategory("along", "55F")
        log:DefineCategory("crawl1", "000", 0.33)
        log:DefineCategory("crawl2", "FFF", 0.33)
    end
end

function this.Log_OuterFunc(position, normal, direction, right, o)
    if not log.enable_logging then
        do return end
    end

    log:NewFrame()

    log:Add_Dot(position, "player")
    log:Add_Line(position, AddVectors(position, o.lookdir_forward), "look")

    log:Add_Square(position, normal, 1, 1, "wall")
    log:Add_Line(position, AddVectors(position, normal), "normal")

    log:Add_Line(position, AddVectors(position, direction), "along")
    log:Add_Line(position, AddVectors(position, right), "along")
end

function this.GetYaw(o, keys, const)
    local deltaYaw = keys.mouse_x * const.mouse_sensitivity

    return AddYaw(o.yaw, deltaYaw)
end

-- If the player is trying to crawl along the wall, then this will calculate the new position
-- Returns
--  isTryingToStand     true when they are at the top of a wall and trying to climb up onto the ledge above
--  position            the new position to teleport
--  normal              the normal of the wall they are clinging to (normal could change frame to frame as they crawl around)
function this.GetNewPosition(position, normal, o, player, keys, const, deltaTime)
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

    this.Log_OuterFunc(position, normal, direction, right, o)

    -- See what direction to crawl along the wall's plane
    local new_pos, move_direction = this.GetProposedWallCrawlPos(position, direction, right, player, keys, const, deltaTime)
    if IsNearZero_vec4(move_direction) then
        return false, position, normal      -- the check at the top of this function should have caught this case, but doing a second check here to be safe
    end

    local hits = RayCast_NearbyWalls_CrawlBasic(position, new_pos, move_direction, normal, o, log2, const.wallDistance_stick_max)
    if #hits > 0 then
        log:WriteLine_Frame(vec_str(position))

        log:Add_Dot(new_pos, "crawl1")
        log:WriteLine_Frame(vec_str(new_pos))

        -- Push them a bit toward the ideal distance from the plane
        local distance_moved = math.sqrt(GetVectorDiffLengthSqr(position, new_pos))
        new_pos = MoveToIdealDistance(new_pos, hits[1].normal, const.wallDistance_stick_ideal, math.sqrt(hits[1].distSqr), distance_moved)

        log:Add_Dot(new_pos, "crawl2")
        log:WriteLine_Frame(vec_str(new_pos))

        return false, new_pos, hits[1].normal
    else

        --TODO: Detect a corner, possibly trying to crawl onto a ledge
        --  If an outside corner is encountered:
        --      choose a from point beyond new_pos:
        --          position+(new_pos-position)*C
        --      fire a couple more rays from that point

        return false, position, normal
    end
end

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