local this = {}

-- This is the primary worker method for grappling.  Conditions were set up while
-- aiming
--
-- There is an anchor point, possibly separate desired distance.  Then it's a matter
-- of applying acceleration toward desired distance with extra options for when they
-- overshoot
--
-- There's also an option to apply a separate acceleration in the direction that the
-- player is looking.  This makes it possible to control the swing, so it's not just
-- a boring straight line pull
--
-- There are a lot of different ways that a grapple could be set up.  Any actual
-- grapple config probably won't use all the acceleration types, but it's easier
-- to have a single worker method that can handle lots of possible config scenarios
function Process_Flight(o, player, vars, const, debug, deltaTime)
    -- Recover at a reduced rate
    vars.energy = RecoverEnergy(vars.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate * player.energy_tank.flying_percent, deltaTime)

    ---------------------------------- VALIDATIONS ----------------------------------

    if HasSwitchedFlightMode(o, player, vars, const, true) then
        do return end
    end

    -- If they are on the ground after being airborne, then exit flight
    local shouldStop, isAirborne = ShouldStopFlyingBecauseGrounded(o, vars)
    if shouldStop then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    local grapple = vars.grapple       -- this will be used a lot, save a dot reference

    -- If about to hit a wall, then cancel, but only if the settings say to
    if vars.hasBeenAirborne and grapple.stop_on_wallHit and IsWallCollisionImminent(o, deltaTime) then
        this.Transition_AntiGravOrStandard(vars, const, debug, o, grapple)
        do return end
    end

    local _, _, grappleLen, grappleDirUnit = GetGrappleLine(o, vars, const)

    if grapple.stop_distance and grappleLen <= grapple.stop_distance then
        this.Transition_AntiGravOrStandard(vars, const, debug, o, grapple)
        do return end
    end

    o:GetCamera()

    if grapple.minDot and (DotProduct3D(o.lookdir_forward, grappleDirUnit) < grapple.minDot) then
        -- They looked too far away
        this.Transition_AntiGravOrStandard(vars, const, debug, o, grapple)
        do return end
    end

    ----------------------------------- PREP WORK -----------------------------------

    -- How from desired distance they are (can be negative)
    local diffDist
    if grapple.desired_length then
        diffDist = grappleLen - grapple.desired_length
    else
        diffDist = grappleLen - vars.distToHit     -- no defined desired length, use the length at the time of initiating the grapple
    end

    -- Get the component of the velocity along the request line
    local vel_along, isSameDir = GetProjectedVector_AlongVector(o.vel, grappleDirUnit, true)

    -- Figure out the delta between actual and desired speed
    local speed = math.sqrt(GetVectorLengthSqr(vel_along))

    ---------------------------- CALCULATE ACCELERATIONS ----------------------------

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
    local look_x, look_y, look_z = this.GetLook(o, vars, grapple, grappleLen)

    -- Cancel gravity
    local antigrav_z = GetAntiGravity(grapple.anti_gravity, isAirborne)

    ------------------------------- APPLY ACCELERATION -------------------------------

    local accel_x = (const_x + spring_x + drag_x + look_x) * deltaTime
    local accel_y = (const_y + spring_y + drag_y + look_y) * deltaTime
    local accel_z = (const_z + spring_z + drag_z + look_z + antigrav_z) * deltaTime

    -- debug.accel_x = Round(accel_x / deltaTime, 1)
    -- debug.accel_y = Round(accel_y / deltaTime, 1)
    -- debug.accel_z = Round(accel_z / deltaTime, 1)

    o.player:GrapplingHook_AddImpulse(accel_x, accel_y, accel_z)
end

--------------------------------------- Private Methods ---------------------------------------

function this.GetVelocityDrag(dirUnit, diffDist, isSameDir, args)
    if not args then
        return 0, 0, 0
    end

    -- diff = actual - desired
    if ((diffDist < 0) and (not isSameDir)) or    -- Compressed and moving away from point
       ((diffDist > 0) and isSameDir) then     -- Stretched and moving toward the point
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

function this.GetLook(o, vars, grapple, grappleLen)
    if not grapple.accel_alongLook then
        return 0, 0, 0
    end

    -- Project velocity along look
    local vel_along, isSameDir = GetProjectedVector_AlongVector(o.vel, o.lookdir_forward, true)

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

function this.Transition_AntiGravOrStandard(vars, const, debug, o, grapple)
    if grapple.anti_gravity then
        Transition_ToAntiGrav(vars, const, o)
    else
        Transition_ToStandard(vars, const, debug, o)
    end
end