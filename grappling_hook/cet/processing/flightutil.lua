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
function SwitchedFlightMode(o, player, vars, const)
    -- See if they want to start a new grapple
    if StartFlightIfRequested(o, player, vars, const) then
        return true
    end

    if vars.startStopTracker:ShouldStop() then     -- doing this after the grapple check, because it likely uses a subset of those keys (A+D instead of A+D+W)
        -- Told to stop swinging, back to standard
        if (vars.flightMode == const.flightModes.airdash or vars.flightMode == const.flightModes.flight) and vars.grapple and vars.grapple.anti_gravity then
            Transition_ToAntiGrav(vars, const, o)
        else
            Transition_ToStandard(vars, const, debug, o)
        end

        return true
    end

    return false
end

-- This will return true as long as there is some air below the player
function IsAirborne(o)
    return o:IsPointVisible(o.pos, Vector4.new(o.pos.x, o.pos.y, o.pos.z - 0.5, 1))
end

function ShouldStopFlyingBecauseGrounded(o, vars)
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
                    vars.isSafetyFireCandidate = true
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

function IsWallCollisionImminent(o, deltaTime)
    return not o:IsPointVisible(o.pos, Vector4.new(o.pos.x + (o.vel.x * deltaTime * 4), o.pos.y + (o.vel.y * deltaTime * 4), o.pos.z + (o.vel.z * deltaTime * 4), 1))
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

-- These linearly drop percent to zero if close to desired (so acceleration doesn't cause wild oscillations)
function GetDeadPercent_Speed(speed, maxSpeed, deadSpot, isVelAwayFromTarget)
    if isVelAwayFromTarget then
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
    local absDiff = math.abs(diffDist)

    if absDiff < deadSpot then
        return absDiff / deadSpot
    else
        return 1
    end
end
