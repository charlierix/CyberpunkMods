local this = {}
local up = nil

function RecoverEnergy(current, max, recoverRate, deltaTime)
    current = current + (recoverRate * deltaTime)

    if current > max then
        current = max
    end

    return current
end
function ConsumeEnergy(current, burnRate, deltaTime)
    local newValue = current - (burnRate * deltaTime)

    if newValue < 0 then
        return current, true
    else
        return newValue, false
    end
end

-- This is called while in flight.  It looks for the user wanting to switch flight modes
function HasSwitchedFlightMode(o, player, vars, const, watchForStop)
    local action = vars.startStopTracker:GetRequestedAction()
    if not action then
        return false
    end

    if action == const.bindings.grapple1 then
        return this.TryStartFlight(o, vars, const, player.grapple1)

    elseif action == const.bindings.grapple2 then
        return this.TryStartFlight(o, vars, const, player.grapple2)

    elseif action == const.bindings.grapple3 then
        return this.TryStartFlight(o, vars, const, player.grapple3)

    elseif action == const.bindings.grapple4 then
        return this.TryStartFlight(o, vars, const, player.grapple4)

    elseif action == const.bindings.grapple5 then
        return this.TryStartFlight(o, vars, const, player.grapple5)

    elseif action == const.bindings.grapple6 then
        return this.TryStartFlight(o, vars, const, player.grapple6)

    elseif watchForStop and action == const.bindings.stop then
        -- Told to stop swinging, back to standard
        if (vars.flightMode == const.flightModes.airdash or vars.flightMode == const.flightModes.flight_straight or vars.flightMode == const.flightModes.flight_swing) and vars.grapple and vars.grapple.anti_gravity then
            Transition_ToAntiGrav(vars, const, o)
        else
            Transition_ToStandard(vars, const, debug, o)
        end

        return true
    end

    -- Execution should never get here
    return false
end

-- This will return true as long as there is some air below the player
function IsAirborne(o)
    return o:IsPointVisible(Vector4.new(o.pos.x, o.pos.y, o.pos.z + 0.05), Vector4.new(o.pos.x, o.pos.y, o.pos.z - 0.55, 1))
end

function ShouldStopFlyingBecauseGrounded(o, vars, isImpulseBasedFlight)
    local isAirborne = IsAirborne(o)

    if vars.hasBeenAirborne then
        -- Has been continuously airborne in this flight mode for at least a small bit of time
        if not isAirborne then
            return true, isAirborne
        end
    else
        -- Hasn't had enough time to be continuously airborne yet
        if isAirborne then
            if vars.initialAirborneTime then
                -- Is airborne and has been airborne before.  See if they have been continuously long enough to transition out of this break in period
                if o.timer - vars.initialAirborneTime > 0.25 then
                    if isImpulseBasedFlight then
                        vars.isSafetyFireCandidate = true
                    end

                    vars.hasBeenAirborne = true
                end
            else
                vars.initialAirborneTime = o.timer
            end
        else
            -- Not airborne during this warmin period, remove the timer (they are starting on the ground, or sliding along the ground at a shallow angle)
            vars.initialAirborneTime = nil
        end
    end

    return false, isAirborne
end

function IsWallCollisionImminent(o, vel, deltaTime)
    return not o:IsPointVisible(o.pos, Vector4.new(o.pos.x + (vel.x * deltaTime * 4), o.pos.y + (vel.y * deltaTime * 4), o.pos.z + (vel.z * deltaTime * 4), 1))
end

function IsAboveAnyPlane(planes, pos)
    local count = planes:GetCount()

    for i = 1, count, 1 do
        local plane = planes:GetItem(i)

        if IsAbovePlane(plane.point, plane.normal, pos, false) then
            return true
        end
    end

    return false
end

function GetGrappleLine(o, vars, const)
    local playerAnchor = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)

    local grappleDir = SubtractVectors(vars.rayHit, playerAnchor)
    local grappleLen = GetVectorLength(grappleDir)
    local grappleDirUnit = DivideVector(grappleDir, grappleLen)

    return playerAnchor, grappleDir, grappleLen, grappleDirUnit
end

function GetAntiGravity(anti_gravity, isAirborne)
    if not isAirborne then
        return 16       -- when on the ground, the player seems to have extra friction.  This weightless assistance is only needed when pulling

    elseif not anti_gravity then
        return 0

    elseif anti_gravity.antigrav_percent <= 0 then
        return 0

    elseif anti_gravity.antigrav_percent >= 1 then
        return 16

    else
        return 16 * anti_gravity.antigrav_percent

    end
end

function GetPullAccel_Constant(constAccel, dirUnit, diffDist, speed, isVelAwayFromTarget)
    if not constAccel then
        return 0, 0, 0, 0
    end

    local percent_speed = GetDeadPercent_Speed(speed, constAccel.speed, constAccel.deadSpot_speed, isVelAwayFromTarget)
    local percent_dist = GetDeadPercent_Distance(diffDist, constAccel.deadSpot_distance)

    local percent = math.min(percent_speed, percent_dist, 1)

    return
        dirUnit.x * constAccel.accel * percent,
        dirUnit.y * constAccel.accel * percent,
        dirUnit.z * constAccel.accel * percent,
        percent
end

function GetAccel_GrappleStraight(o, vars, grapple, grappleLen, grappleDirUnit, vel)
    -- How far from desired distance they are (can be negative)
    local diffDist
    if grapple.desired_length then
        diffDist = grappleLen - grapple.desired_length
    else
        diffDist = grappleLen - vars.distToHit     -- no defined desired length, use the length at the time of initiating the grapple
    end

    -- Get the component of the velocity along the request line
    local vel_along, isSameDir = GetProjectedVector_AlongVector(vel, grappleDirUnit, true)

    -- Figure out the delta between actual and desired speed
    local speed = math.sqrt(GetVectorLengthSqr(vel_along))

    -- Constant accel toward desired distance
    local const_x, const_y, const_z = GetPullAccel_Constant(grapple.accel_alongGrappleLine, grappleDirUnit, diffDist, speed, not isSameDir)

    -- spring accel toward desired distance
    --TODO: Finish this
    local spring_x = 0
    local spring_y = 0
    local spring_z = 0

    -- Add extra acceleration if flying away from desired distance (extra drag)
    local drag_x, drag_y, drag_z = this.GetVelocityDrag(grappleDirUnit, diffDist, isSameDir, grapple.velocity_away)

    -- Accelerate along look direction
    local look_x, look_y, look_z = this.GetLook(o, vars, grapple, grappleLen, vel)

    return
        const_x + spring_x + drag_x + look_x,
        const_y + spring_y + drag_y + look_y,
        const_z + spring_z + drag_z + look_z
end

function GetAccel_Boosting(o, vars)
    if not vars.startStopTracker:IsPrevActionHeldDown() then
        return 0, 0, 0
    end

    --TODO: get accel from swing props
    local ACCEL = 12

    debug_render_screen.Add_Text2D(0.667, 0.67, "BOOSTING", nil, "C44", "FFF", nil, true)

    --TODO: play a sound

    -- Apply boost along look
    --local eye_pos, look_dir = o:GetCrosshairInfo()
    o:GetCamera()

    return
        o.lookdir_forward.x * ACCEL,
        o.lookdir_forward.y * ACCEL,
        o.lookdir_forward.z * ACCEL
end

function GetAccel_AirFriction(vel, airbrake_percent)
    -- https://www.engineeringtoolbox.com/drag-coefficient-d_627.html
    local AIR_DENSITY = 1.25
    local DRAG_COEFFICIENT = 1.1
    local AREA = 1
    local AIRBRAKE_AREA = 6
    local MASS = 100

    local area = AREA
    if airbrake_percent then
        area = GetScaledValue(AREA, AIRBRAKE_AREA, 0, 1, airbrake_percent)
    end

    -- F = -0.5 * fluid_density * drag_coefficient * area * velocity^2
    local mult = 0.5 * AIR_DENSITY * DRAG_COEFFICIENT * area / MASS

    local accel_x = vel.x * vel.x * mult
    local accel_y = vel.y * vel.y * mult
    local accel_z = vel.z * vel.z * mult

    -- All values above are kept positive.  Now negate if necessary
    -- Otherwise, the calculations do this:
    --  -3 * -3 * -1 = -9
    --   3 *  3 * -1 = -9
    if vel.x > 0 then
        accel_x = -accel_x
    end

    if vel.y > 0 then
        accel_y = -accel_y
    end

    if vel.z > 0 then
        accel_z = -accel_z
    end

    return accel_x, accel_y, accel_z
end

function ApplyAccel_Teleporting(o, vars, const, keys, debug, accel_x, accel_y, accel_z, deltaTime)
    -- debug.accel_x = accel_x
    -- debug.accel_y = accel_y
    -- debug.accel_z = accel_z

    if debug_render_screen.IsEnabled() then
        debug_render_screen.Add_Text2D(0.75, 0.5, "vel: " .. vec_str(vars.vel) .. "\r\naccel: " .. tostring(Round(accel_x, 2)) .. ", " .. tostring(Round(accel_y, 2)) .. ", " .. tostring(Round(accel_z, 2)), nil, "444", "CCC", nil, true)
    end

    accel_x = accel_x * deltaTime
    accel_y = accel_y * deltaTime
    accel_z = (accel_z - 16) * deltaTime        -- apply standard gravity (anti gravity calculations would be a positive z to counter this)

    -- Apply accelerations to the current velocity
    vars.vel.x = vars.vel.x + accel_x
    vars.vel.y = vars.vel.y + accel_y
    vars.vel.z = vars.vel.z + accel_z

    vars.vel = ClampVelocity(vars.vel, const.maxSpeed)      -- the game gets unstable and crashes at high speed.  Probably trying to load scenes too fast, probably machine dependent

    if debug_render_screen.IsEnabled() then
        debug_render_screen.Add_Text2D(0.667, 0.5, "speed: " .. tostring(Round(GetVectorLength(vars.vel), 1)), nil, "666", "CCC", nil, true)
    end

    local deltaYaw = keys.mouse_x * -0.08

    -- Try to move in the desired velocity (raycast first)
    local newPos = Vector4.new(o.pos.x + (vars.vel.x * deltaTime), o.pos.y + (vars.vel.y * deltaTime), o.pos.z + (vars.vel.z * deltaTime), 1)

    local isSafe, hit_normal = IsTeleportPointSafe(o.pos, newPos, vars.vel, deltaTime, o)

    if isSafe then
        local yaw = AddYaw(o.yaw, deltaYaw)
        o:Teleport(newPos, yaw)

    else
        vars.vel = GetCollisionSafeVelocity(vars.vel, hit_normal)
        Transition_ToStandard(vars, const, debug, o)
    end
end

-- This is called when about to collide with something under teleport based flight.  Transition to standard will convert
-- vars.vel into an impuse.  If that collision is the ground and they're going fast enough, the impulse will cause damage
--
-- This detects that and removes the Z portion so the player doesn't get hurt
function GetCollisionSafeVelocity(vel, hit_normal)
    if hit_normal.z < 0.75 then       -- since hit_normal is a unit vector, this is similar to a dot product with up
        return vel
    end

    return Vector4.new(vel.x, vel.y, Clamp(-6, nil, vel.z))
end

-- These linearly drop percent to zero if close to desired (so acceleration doesn't cause wild oscillations)
function GetDeadPercent_Speed(speed, maxSpeed, deadSpot, isVelAwayFromTarget)
    if isVelAwayFromTarget or not deadSpot then
        return 1
    end

    local speedDiff = speed - maxSpeed

    if speedDiff > 0 then
        -- Overspeed, don't add any acceleration
        return 0

    elseif speedDiff > -deadSpot then
        -- Close to desired speed.  Reduce the acceleration
        return -speedDiff / deadSpot      -- speedDiff is always negative here, so just flip it to positive to compare with the positive dead speed

    else
        -- Under the deadspot speed, use full acceleration
        return 1
    end
end
function GetDeadPercent_Distance(diffDist, deadSpot)
    if not deadSpot then
        return 1
    end

    local absDiff = math.abs(diffDist)

    if absDiff < deadSpot then
        return absDiff / deadSpot
    else
        return 1
    end
end

function ClampVelocity_Drag(vel, maxSpeed)
    local speedSqr = GetVectorLengthSqr(vel)

    local maxSpeed_min = maxSpeed * 0.75

    if speedSqr < (maxSpeed_min * maxSpeed_min) then
        return 0, 0, 0
    end

    local speed = math.sqrt(speedSqr)

    local percent = 1
    if speed < maxSpeed then
        percent = GetScaledValue(0, 1, maxSpeed_min, maxSpeed, speed)
    end

    -- max accel will be maxSpeed/6
    -- square the percent so it ramps up instead of linear climb
    local accel = GetScaledValue(0, maxSpeed / 2, 0, 1, percent * percent)

    return vel.x / speed * -accel, vel.y / speed * -accel, vel.z / speed * -accel
end

function ClampVelocity(vel, maxSpeed)
    local speedSqr = GetVectorLengthSqr(vel)

    if speedSqr <= (maxSpeed * maxSpeed) then
        return vel
    else
        local speed = math.sqrt(speedSqr)
        local ratio = maxSpeed / speed

        return Vector4.new(vel.x * ratio, vel.y * ratio, vel.z * ratio, 1)
    end
end

-- This does a couple ray casts to make sure the path is clear to jump to
-- Returns:
--  bool isSafe
--  vect4 hit's normal
function IsTeleportPointSafe(fromPos, toPos, velocity, deltaTime, o)
    -- test a bit above the teleport point
    --NOTE: pos is at the character's feet
    local hit_pos, hit_norm = o:RayCast(fromPos, Vector4.new(toPos.x, toPos.y, toPos.z + 2.3, toPos.w))

    if hit_pos and not this.IsHitUpFromTheGrave(velocity, hit_norm) then
        return false, hit_norm
    end

    -- project forward a bit
    hit_pos, hit_norm = o:RayCast(fromPos, Vector4.new(toPos.x + (velocity.x * deltaTime * 6), toPos.y + (velocity.y * deltaTime * 6), toPos.z, toPos.w))
    if hit_pos then
        return false, hit_norm
    end

    -- do an extra ground check
    if velocity.z < 6 then
        hit_pos, hit_norm = o:RayCast(fromPos, Vector4.new(toPos.x, toPos.y, toPos.z - 0.15, toPos.w))
        if hit_pos then
            return false, hit_norm
        end
    end

    return true, nil
end

----------------------------------- Private Methods -----------------------------------

function this.TryStartFlight(o, vars, const, grapple)
    if not grapple then     -- they might have input bindings set up, but no grapple assigned
        return false
    end

    if Transition_ToAim(grapple, vars, const, o, true) then
        return true
    else
        -- There wasn't enough energy or another mod was flying (unlikely that another mod was flying, because
        -- this function should only be called while in flight)
        vars.startStopTracker:ResetKeyDowns()
        return false
    end
end

-- If they clipped below ground and are trying to fly back up, then the up looking ray hit needs to be ignored
-- This function tries to detect that
--NOTE: pos.z < 0 check isn't good, since there are areas lower than zero, lots of areas higher than zero
function this.IsHitUpFromTheGrave(velocity, hit_norm)
    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    -- Ignore if they are going down
    if DotProduct3D(velocity, up) < 0 then      --NOTE: velocity isn't a unit vector, so can't get more accurate than positive/negative without normalizing
        return false
    end

    -- Only consider tiles that are pointing up
    if DotProduct3D(hit_norm, up) < 0.7 then
        return false
    end

    -- They are moving up onto the backside of an up facing tile
    return true
end

function this.GetVelocityDrag(dirUnit, diffDist, isSameDir, args)
    if not args then
        return 0, 0, 0
    end

    -- diff = actual - desired
    if (diffDist < 0 and not isSameDir) or    -- Compressed and moving away from point
       (diffDist > 0 and isSameDir) then     -- Stretched and moving toward the point
        return 0, 0, 0
    end

    local accel = 0
    if diffDist < 0 and args.accel_compression then     -- the acceleration could be nil
        -- It's being compressed
        local percent = GetDeadPercent_Distance(diffDist, args.deadSpot)

        accel = args.accel_compression * -percent       -- negating so that acceleration is away from the grapple direction

    elseif diffDist > 0 and args.accel_tension then
        -- It's being stretched
        local percent = GetDeadPercent_Distance(diffDist, args.deadSpot)

        accel = args.accel_tension * percent
    end

    return
        dirUnit.x * accel,
        dirUnit.y * accel,
        dirUnit.z * accel
end

function this.GetLook(o, vars, grapple, grappleLen, vel)
    if not grapple.accel_alongLook then
        return 0, 0, 0
    end

    -- Project velocity along look
    local vel_along, isSameDir = GetProjectedVector_AlongVector(vel, o.lookdir_forward, true)

    -- Figure out the delta between actual and desired speed
    local speed = math.sqrt(GetVectorLengthSqr(vel_along))

    -- Distance difference is used to see if dead spot applies.  So if there is no desired length, just
    -- use a large value so there is never a dead spot
    local diffDist = 1000
    if grapple.desired_length then
        -- How from desired distance they are (can be negative)
        diffDist = grappleLen - vars.distToHit
    end

    -- Get the acceleration
    return GetPullAccel_Constant(grapple.accel_alongLook, o.lookdir_forward, diffDist, speed, not isSameDir)
end