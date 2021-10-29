local this = {}

local up = nil      -- can't use vector4 before init
local log = nil

function Process_Standard(o, player, vars, const, debug, startStopTracker, deltaTime)
    -- Cheapest check is looking at keys
    local isHangDown, isJumpDown = startStopTracker:GetButtonState()
    if not isHangDown and not isJumpDown then
        if log and log:IsPopulated() then
            log:Save("LatchRayTrace")
        end

        do return end
    end

    -- Next cheapest is a single raycast down
    if not IsAirborne(o) then
        startStopTracker:ResetHangLatch()
        do return end
    end

    -- Next is a ray cast along look.  Was going to go with several, but one seems to be good enough
    o:GetCamera()
    if not o.lookdir_forward then
        startStopTracker:ResetHangLatch()
        do return end
    end

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    if not log then
        log = DebugRenderLogger:new(not const.shouldShowLogging3D_latchRayTrace)
    end

    -- Fire a few rays, see if there are wall around
    local fromPos = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.rayFrom_Z, 1)

    local hits = RayCast_NearbyWalls(fromPos, o, log, player.wallDistance_attract_max)
    if #hits == 0 then
        do return end
    end

    if hits[1].distSqr <= const.wallDistance_stick_max * const.wallDistance_stick_max then
        -- Close enough to interact directly with the wall
        this.DirectDistance(isHangDown, isJumpDown, hits, fromPos, o, vars, const, startStopTracker)
    else
        this.AttractDistance(isHangDown, hits, fromPos, o, player, const, debug, deltaTime)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.DirectDistance(isHangDown, isJumpDown, hits, fromPos, o, vars, const, startStopTracker)
    if isJumpDown and this.ValidateSlope_Jump(hits[1].normal) then
        local hangPos = Vector4.new(fromPos.x, fromPos.y, fromPos.z - const.rayFrom_Z, 1)
        Transition_ToJump_Calculate(vars, const, o, hangPos, hits[1].normal, startStopTracker)

        do return end
    end

    if isHangDown and this.ValidateSlope_Hang(hits[1].normal) then      --NOTE: slope check for hang is pretty much unnecessary.  The IsAirborne eliminates slopes already

        --TODO: Check velocity relative to wall plane, apply drag or stick if slow enough


        local hangPos = Vector4.new(fromPos.x, fromPos.y, fromPos.z - const.rayFrom_Z, 1)
        Transition_ToHang(vars, const, o, hangPos, hits[1].normal)

        do return end
    end
end

function this.AttractDistance(isHangDown, hits, fromPos, o, player, const, debug, deltaTime)
    if not isHangDown then
        debug.attract_x = nil
        debug.attract_y = nil
        debug.attract_z = nil
        do return end
    end
    
    --TODO: If more points are used, the total acceleration will need to be spread among them.  Also, how to decide
    --which points to use?  Probably the closest for each plane

    -- For now, just use the closest

    local hit = hits[1]

    local distance = math.sqrt(hit.distSqr)

    local accel = this.GetAttractAccel(distance, player, const)

    local x = ((hit.hit.x - fromPos.x) / distance) * accel * deltaTime
    local y = ((hit.hit.y - fromPos.y) / distance) * accel * deltaTime
    local z = ((hit.hit.z - fromPos.z) / distance) * accel * deltaTime

    debug.attract_x = x
    debug.attract_y = y
    debug.attract_z = z

    o.player:WallHang_AddImpulse(x, y, z)
end

function this.GetAttractAccel(distance, player, const)
    local percent = GetScaledValue(0, 1, const.wallDistance_stick_max, player.wallDistance_attract_max, distance)
    percent = Clamp(0, 1, percent)

    -- This strong ramp up stronger than linear (maybe not realistic, but should work well in practice)
    local accel = 1 - (percent ^ player.attract_pow)

    return accel * player.attract_accel
end

-- If the slope is horizontal enough to stand on, this returns false
function this.ValidateSlope_Hang(normal)
    return DotProduct3D(normal, up) < 0.4       -- also allowing them to grab the under side of objects
end
function this.ValidateSlope_Jump(normal)
    return math.abs(DotProduct3D(normal, up)) < 0.6      -- don't allow if they are under overhangs
end