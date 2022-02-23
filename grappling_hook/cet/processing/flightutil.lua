local this = {}

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

----------------------------------- Private Methods -----------------------------------

function this.TryStartFlight(o, vars, const, grapple)
    if not grapple then     -- they might have input bindings set up, but no grapple assigned
        return false
    end

    if CheckOtherModsFor_FlightStart(o, const.modNames) then
        -- No other mod is standing in the way
        if Transition_ToAim(grapple, vars, const, o, true) then
            return true
        else
            -- There wasn't enough energy
            vars.startStopTracker:ResetKeyDowns()
            return false
        end
    else
        -- Another mod is flying, don't interfere.  Also eat the keys
        vars.startStopTracker:ResetKeyDowns()
        return true
    end
end