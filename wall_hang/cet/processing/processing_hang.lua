local this = {}

local log2 = nil
local log3 = nil

-- Just keeps teleporting to the initial catch point
function Process_Hang(o, player, vars, const, debug, keys, startStopTracker, deltaTime)
    local isHangDown, isJumpDown = startStopTracker:GetButtonState()

    if log2 and log2:IsPopulated() and (not isHangDown or isJumpDown) then
        log2:Save("WallCrawl2")
        log3:Save("WallCrawl3")
    end

    if not isHangDown then
        Transition_ToStandard(vars, const, debug, o)
        do return end

    elseif isJumpDown then
        Transition_ToJump_Calculate(vars, const, o, vars.hangPos, vars.normal, startStopTracker)
        do return end
    end

    if not log2 then
        log2 = DebugRenderLogger:new(const.shouldShowLogging3D_wallCrawl)
        log3 = DebugRenderLogger:new(const.shouldShowLogging3D_wallCrawl)
    end

    -- Get the new yaw if they are trying to look left or right
    local yaw = this.GetYaw(o, keys, const)

    -- If they are trying to crawl around, then the position will change
    local isTryingToStand, pos, normal = WallCrawl_GetNewPosition(vars.hangPos, vars.normal, o, player, keys, const, deltaTime, log2, log3)

    if isTryingToStand then
        -- Need to give them a small upward kick (and a little toward the wall), then transition back to standard
        startStopTracker:ResetHangLatch()
        this.HopUpOntoLedge(o, vars.hangPos, pos, const)
        Transition_ToStandard(vars, const, debug, o)
    else
        vars.hangPos = pos
        vars.normal = normal

        o:Teleport(pos, yaw)        --NOTE: Even if they aren't crawling or changing look direction, teleport is needed to counteract gravity
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetYaw(o, keys, const)
    local deltaYaw = keys.mouse_x * const.mouse_sensitivity

    return AddYaw(o.yaw, deltaYaw)
end

-- This hits the player with an impulse that will knock them up onto a ledge
function this.HopUpOntoLedge(o, currentPos, newPos, const)
    local x, y, z = this.GetHopImpulse(currentPos, newPos, const)

    o.player:WallHang_AddImpulse(x, y, z)
end
function this.GetHopImpulse(currentPos, newPos, const)
    if const.ledgeHop_angle <= 1 or const.ledgeHop_angle >= 89 then
        -- The code below only works for acute angles.  Just jump straight up
        return 0, 0, const.ledgeHop_impulse
    end

    local direction_x = newPos.x - currentPos.x
    local direction_y = newPos.y - currentPos.y

    local horz_len = GetVectorLength2D(direction_x, direction_y)
    local vert_len = horz_len * math.tan(Degrees_to_Radians(const.ledgeHop_angle))

    local diagonal_len = math.sqrt(horz_len + vert_len)

    return
        direction_x / diagonal_len * const.ledgeHop_impulse,
        direction_y / diagonal_len * const.ledgeHop_impulse,
        vert_len / diagonal_len * const.ledgeHop_impulse
end