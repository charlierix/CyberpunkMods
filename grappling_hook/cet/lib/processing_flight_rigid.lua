function Process_Flight_Rigid(o, state, const, debug, deltaTime)
    if state.startStopTracker:ShouldStop() then
        -- told to stop swinging, back to standard
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    --TODO: If standing on the ground, then cancel

    local args = const.rigid

    local playerAnchor, grappleDir, grappleLen, grappleDirUnit = GetGrappleLine(o, state, const)

    o:GetCamera()

    --debug.playerAnchor = vec_str(playerAnchor)
    --debug.rayHit = vec_str(state.rayHit)

    -- debug.grappleDir = vec_str(grappleDir)
    -- debug.grappleDirUnit = vec_str(grappleDirUnit)
    debug.grappleLen = Round(grappleLen, 1)

    --debug.grappleDirUnitLen = GetVectorLength(grappleDirUnit)
    --debug.lookDirLen = GetVectorLength(o.lookdir_forward)
    --debug.dot_look_grapple = Round(DotProduct3D(o.lookdir_forward, grappleDirUnit), 2)

    if DotProduct3D(o.lookdir_forward, grappleDirUnit) < args.minDot then
        -- They looked too far away
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    -- Apply force to bring to desired distance from grapple point
    local diffDist = grappleLen - state.distToHit

    --debug.distToHit = state.distToHit
    debug.diffDist = Round(diffDist, 2)

    local stand_x, stand_y, stand_z = Rigid_GetAccel_Standard(grappleDir, diffDist, args.accelToRadius, args.radiusDeadSpot)

    -- Get the component of the velocity that's along the grapple line
    local velAlong = GetProjectedVector_AlongVector(o.vel, grappleDirUnit, true)

    -- Add extra acceleration if flying away (extra drag)
    --local drag_x, drag_y, drag_z = Rigid_GetAccel_VelocityDrag(grappleDir, diffDist, velAlong, args.velAway_accel, args.velAway_deadSpot)
    local drag_x = 0
    local drag_y = 0
    local drag_z = 0

    -- Cancel out the portion of gravity that's along the grapple line
    --local antigrav_z = Rigid_GetAccel_AntiGravity(grappleDir)
    local antigrav_z = 0

    -- Apply the acceleration
    local accelX = (stand_x + drag_x) * deltaTime
    local accelY = (stand_y + drag_y) * deltaTime
    local accelZ = (stand_z + drag_z + antigrav_z) * deltaTime

    o.player:Jetpack_AddImpulse(accelX, accelY, accelZ)
end

function Rigid_GetAccel_Standard(direction, diffDist, maxAccel, deadSpot)
    local accel = GetAccel_Deadspot(diffDist, maxAccel, deadSpot)

    if diffDist < 0 then
        accel = -accel
    end

    return
        direction.x * accel,
        direction.y * accel,
        direction.z * accel
end

function Rigid_GetAccel_VelocityDrag(grappleDir, diffDist, velAlong, maxAccel, deadSpot)
    local dot = DotProduct3D(grappleDir, velAlong)

    -- diff = desired - actual
    -- A positive diff means the player is too close.  Negative is too far away
    -- A positive dot means the player is moving toward the point (decreasing distance)
    if ((diffDist > 0) and (dot < 0) or (diffDist < 0) and (dot > 0)) then
        -- The player is already moving in the correct direction.  No extra acceleration needed
        return 0, 0, 0
    end

    local accel = GetAccel_Deadspot(diffDist, maxAccel, deadSpot)
    accel = -accel      -- it's a drag against current velocity

    local velLen = GetVectorLength(velAlong)

    return
        velAlong.x / velLen * accel,
        velAlong.y / velLen * accel,
        velAlong.z / velLen * accel
end

function GetAccel_Deadspot(diffDist, maxAccel, deadSpot)
    local accel = maxAccel

    local absDiff = math.abs(diffDist)

    if absDiff < deadSpot then
        accel = GetScaledValue(0, maxAccel, 0, deadSpot, absDiff)
    end

    return accel
end

function Rigid_GetAccel_AntiGravity(grappleDir)
    -- Take gravity dot grappleDir (can ignore x an y, because gravity is only along z)
    local dotZ = grappleDir.z * -16      -- grappleDir is a unit vector.  gravity is 0,0,-16

    return math.abs(dotZ)       -- make sure it's positive, since it needs to cancel out gravity
end