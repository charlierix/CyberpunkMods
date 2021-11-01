local this = {}

local log = nil
local up = nil      -- can't use vector4 before init

-- Just keeps teleporting to the initial catch point
function Process_Hang(o, player, vars, const, debug, keys, startStopTracker, deltaTime)
    local isHangDown, isJumpDown = startStopTracker:GetButtonState()

    if log and log:IsPopulated() and (not isHangDown or isJumpDown) then
        log:Save("WallCrawl")
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
        this.EnsureLogSetup()
    end

    local yaw = this.GetYaw(o, keys, const)

    local pos, normal = this.GetNewPosition(vars.hangPos, vars.normal, o, player, keys, const, deltaTime)
    vars.hangPos = pos
    vars.normal = normal

    o:Teleport(pos, yaw)
end

----------------------------------- Private Methods -----------------------------------

function this.EnsureLogSetup()
    if #log.categories == 0 then
        log:DefineCategory("player", "FF5", 2)
        log:DefineCategory("wall", "4000", 1)
        log:DefineCategory("normal")
        log:DefineCategory("look", "FF5", 0.75)
        log:DefineCategory("along", "55F")
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

function this.GetNewPosition(position, normal, o, player, keys, const, deltaTime)
    if IsNearZero(keys.analog_x) and IsNearZero(keys.analog_y) then
        return position, normal
    end

    o:GetCamera()
    if not o.lookdir_forward then
        return position, normal     -- should never happen
    end

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    -- Figure out the direction to move along the plane
    local direction, right = this.GetDirectionsAlongPlane(o, normal)
    if not direction then
        return position, normal
    end

    this.Log_OuterFunc(position, normal, direction, right, o)

    -- See what direction to crawl along the wall's plane
    local new_pos = this.GetProposedWallCrawlPos(position, direction, right, player, keys, const, deltaTime)

    -- Make sure it's ok to go in that direction:
    --  Fire a ray from the new position straight at the plane
    --  Fire a ray along the travel direction
    --  Maybe 5 total, one for each perpendicular direction

    -- TODO: handle transitioning to new planes





    return new_pos, normal



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

    x = x * const.wallcrawl_speed_horz
    y = y * const.wallcrawl_speed_horz
    if z >= 0 then
        z = z * const.wallcrawl_speed_up
    else
        z = z * const.wallcrawl_speed_down
    end

    x = x * deltaTime
    y = y * deltaTime
    z = z * deltaTime

    return Vector4.new(position.x + x, position.y + y, position.z + z, 1)
end


