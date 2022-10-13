local this = {}

local up = nil      -- can't use vector4 before init
local log = nil

-- This detects whether a hang/jump are needed
-- It also accelerates the player in certain cases:
--  attract to wall if hang desired, but too far away
--  slow down if hang desired, but going too fast
function Process_Standard(o, player, vars, const, debug, startStopTracker, deltaTime)
    -- Cheapest check is looking at keys
    local isHangDown, isJumpDown, isShiftDown = startStopTracker:GetButtonState()
    if not isHangDown and not isJumpDown then
        if log and log:IsPopulated() then
            log:Save("LatchRayTrace")
        end

        this.ResetVars(o, vars)
        do return end
    end

    -- Next cheapest is a single raycast down
    if not IsAirborne(o) then
        startStopTracker:ResetHangLatch()
        this.ResetVars(o, vars)
        do return end
    end

    -- Next is a ray cast along look.  Was going to go with several, but one seems to be good enough
    o:GetCamera()
    if not o.lookdir_forward then
        startStopTracker:ResetHangLatch()
        this.ResetVars(o, vars)
        do return end
    end

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    if not log then
        log = DebugRenderLogger:new(const.shouldShowLogging3D_latchRayTrace)
    end

    -- Fire a few rays, see if there's are wall around
    local fromPos = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.rayFrom_Z, 1)

    local hits = RayCast_NearbyWalls_Initial(fromPos, o, log, player.wallDistance_attract_max)
    if #hits == 0 then
        this.ResetVars(o, vars)
        do return end
    end

    if hits[1].distSqr <= const.wallDistance_stick_max * const.wallDistance_stick_max then
        -- Close enough to interact directly with the wall
        this.ResetVars(o, vars, true, false)
        this.DirectDistance(isHangDown, isJumpDown, isShiftDown, hits, fromPos, o, player, vars, const, debug, startStopTracker, deltaTime)

    else
        -- Somewhat close to the wall, maybe apply an attraction acceleration
        this.ResetVars(o, vars, false, true)
        this.AttractDistance(isHangDown, hits, fromPos, o, player, vars, const, debug, deltaTime)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.DirectDistance(isHangDown, isJumpDown, isShiftDown, hits, fromPos, o, player, vars, const, debug, startStopTracker, deltaTime)
    -- Jump
    if isJumpDown and this.ValidateSlope_Jump(hits[1].normal) and ShouldJump(o, const, hits[1].normal, isShiftDown) then
        this.ResetVars(o, vars)

        local hangPos = Vector4.new(fromPos.x, fromPos.y, fromPos.z - const.rayFrom_Z, 1)

        --TODO: This jump should use the planted jump style (same behavior is current)
        Transition_ToJump_Calculate(vars, const, debug, o, hangPos, hits[1].normal, startStopTracker)

    -- Grab
    elseif isHangDown and this.ValidateSlope_Hang(hits[1].normal) then      --NOTE: slope check for hang is pretty much unnecessary.  The IsAirborne eliminates slopes already
        if not this.SlideDrag(hits[1], fromPos, o, player, vars, const, debug, deltaTime) then
            local is_sliding = vars.is_sliding
            this.ResetVars(o, vars)

            local hangPos = Vector4.new(fromPos.x, fromPos.y, fromPos.z - const.rayFrom_Z, 1)
            Transition_ToHang(vars, const, debug, o, hangPos, hits[1].normal, is_sliding)
        end
    end
end

function this.AttractDistance(isHangDown, hits, fromPos, o, player, vars, const, debug, deltaTime)
    if not isHangDown then
        do return end
    end

    --TODO: If more points are used, the total acceleration will need to be spread among them.  Also, how to decide
    --which points to use?  Probably the closest for each plane

    -- For now, just use the closest

    local hit = hits[1]

    local distance = math.sqrt(hit.distSqr)

    local accel = this.GetAttractAccel(distance, player, const)

    local antigrav = 16 * player.attract_antigrav

    local x = ((hit.hit.x - fromPos.x) / distance) * accel * deltaTime
    local y = ((hit.hit.y - fromPos.y) / distance) * accel * deltaTime
    local z = (antigrav + (((hit.hit.z - fromPos.z) / distance) * accel)) * deltaTime

    o:AddImpulse(x, y, z)

    if not vars.is_attracting then
        PlaySound_Attract(vars, o)
        vars.is_attracting = true
    end
end

---------------------------------------------------------------------------------------

-- This is called when they are close to the wall and trying to stick
--  If they are moving too fast along the wall, it will apply drag and return true
--  If they are moving slow enough, this will return false, telling the caller that it's ok to stick in place
function this.SlideDrag(hit, fromPos, o, player, vars, const, debug, deltaTime)
    -- Check velocity relative to wall plane, apply drag or stick if slow enough
    local vel_plane = GetProjectedVector_AlongPlane(o.vel, hit.normal)

    local vel_plane_speedSqr = GetVectorLengthSqr(vel_plane)

    if vel_plane_speedSqr <= player.wallSlide_minSpeed * player.wallSlide_minSpeed then
        -- Moving slow enough to grab and stop.  No sliding drag needed
        return false
    end

    local vel_plane_speed = math.sqrt(vel_plane_speedSqr)

    -- Apply a drag accel along the plane
    local drag_x = -vel_plane.x / vel_plane_speed * player.wallSlide_dragAccel * deltaTime
    local drag_y = -vel_plane.y / vel_plane_speed * player.wallSlide_dragAccel * deltaTime
    local drag_z = (16 + (-vel_plane.z / vel_plane_speed * player.wallSlide_dragAccel)) * deltaTime      -- gravity is -16 in this game

    o:AddImpulse(drag_x, drag_y, drag_z)


    --TODO: Apply a pull accel toward ideal distance from plane
    --Put that in a file: Util_IdealDist
    --  It would be called from here, when crawling, when wall running
    --  Takes in wall's normal, from point, distance moved parallel to plane this frame.  Returns impulse to apply (will always be along normal or nil)


    if not vars.is_sliding then
        PlaySound_Slide(vars, o)
        vars.is_sliding = true
    end

    return true
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

function this.ResetVars(o, vars, skip_slide, skip_attract)
    if not skip_slide and vars.is_sliding then
        PossiblyStopSound(o, vars, true)
        vars.is_sliding = false
    end

    if not skip_attract and vars.is_attracting then
        PossiblyStopSound(o, vars, true)
        vars.is_attracting = false
    end
end