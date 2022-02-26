
---------------------------------------- NO - Scrap air dash, use virutal anchor instead ----------------------------------------
--TODO: Change air dash into a burst instead of continuous.  Continuous is too hard to make work at slow speed
--TODO: Add a version int to the airdash model, v1 can use the old code, even though it's kind of broken
--TODO: Add a note on the config when they have v1 "Old version of air dash\r\nScrap and rebuild to get latest version"
---------------------------------------------------------------------------------------------------------------------------------

-- Air Dash is like a small rocket thruster that propels the player in the direction
-- that they are looking
--
-- It's meant to be a bridge between aiming and grappling, to get them to a grapple
-- point at a high energy cost
--
-- Though, if airdash is highly upgraded, and the corresponding grapple is set super
-- weak, it could basically be its own thing.  For example, set the grapple to be
-- really short range, almost no forces, incredibly small dot product threshold
function Process_AirDash(o, player, vars, const, debug, deltaTime)
    local dash = vars.grapple.aim_straight.air_dash

    -- Reduce Energy
    local newEnergy, isEnergyEmpty = ConsumeEnergy(vars.energy, dash.energyBurnRate * (1 - dash.burnReducePercent), deltaTime)
    if isEnergyEmpty then
        vars.animation_lowEnergy:ActivateAnimation()
        Transition_ToStandard(vars, const, debug, o)
        do return end
    else
        vars.energy = newEnergy
    end

    if HasSwitchedFlightMode(o, player, vars, const, true) then
        do return end
    end

    -- If they are on the ground after being airborne, then exit flight
    local shouldStop, _ = ShouldStopFlyingBecauseGrounded(o, vars)
    if shouldStop then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    o:GetCamera()

    -- Fire a ray, according to initial conditions
    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)
    local to = GetPoint(from, o.lookdir_forward, vars.rayLength)

    local hitPoint = o:RayCast(from, to)

    -- See if the ray hit something
    if hitPoint then
        -- Ensure pin is drawn and placed properly (flight pin, not aim pin)
        EnsureMapPinVisible(hitPoint, vars.grapple.mappin_name, vars, o)

        Transition_ToFlight_Straight(vars, const, o, from, hitPoint, nil)
        do return end
    end

    -- Update map pin
    local aimPoint = Vector4.new(from.x + (o.lookdir_forward.x * vars.rayLength), from.y + (o.lookdir_forward.y * vars.rayLength), from.z + (o.lookdir_forward.z * vars.rayLength), 1)
    EnsureMapPinVisible(aimPoint, dash.mappin_name, vars, o)

    -- Get the component of the velocity along the request line
    local vel_along, isSameDir = GetProjectedVector_AlongVector(o.vel, o.lookdir_forward, true)

    -- Figure out the delta between actual and desired speed
    local speed = GetVectorLength(vel_along)

    -- Calculate forward accel
    local air_x, air_y, air_z, percent = GetPullAccel_Constant(dash.accel, o.lookdir_forward, 1000, speed, not isSameDir)

    -- Need to multiply by percent, otherwise they will just accelerate up once they reach the desired
    -- speed along the dash vector
    local antigrav_z = 16 * percent

    -- Apply the acceleration
    local accel_x = air_x * deltaTime
    local accel_y = air_y * deltaTime
    local accel_z = (air_z + antigrav_z) * deltaTime

    -- debug.accel_x = Round(accel_x / deltaTime, 1)
    -- debug.accel_y = Round(accel_y / deltaTime, 1)
    -- debug.accel_z = Round(accel_z / deltaTime, 1)

    o:AddImpulse(accel_x, accel_y, accel_z)
end




-- This was an attempt to limit vertical speed.  It sort of works, but horizontal accel is pretty much ignored below 26.
-- It's hard to control when moving that fast, plus having instant motion in the look direction is unnatural.  Also, the
-- map pin doesn't look right when looking up and down.  Also, ASDW causes the player to walk around midair, even more
-- unnaturalness
--
-- redscript based flight doesn't really work this way for slow speeds.  It would need to be cet based teleports
--
-- Instead, make a cannon mod that does more of a quick burst in an initial direction



-- local dash_accel_z = nil

-- function Process_AirDash(o, player, vars, const, debug, deltaTime)
--     local dash = vars.grapple.aim_straight.air_dash

--     -- Reduce Energy
--     local newEnergy, isEnergyEmpty = ConsumeEnergy(vars.energy, dash.energyBurnRate * (1 - dash.burnReducePercent), deltaTime)
--     if isEnergyEmpty then
--         vars.animation_lowEnergy:ActivateAnimation()
--         Transition_ToStandard(vars, const, debug, o)
--         do return end
--     else
--         vars.energy = newEnergy
--     end

--     if HasSwitchedFlightMode(o, player, vars, const, true) then
--         do return end
--     end

--     -- If they are on the ground after being airborne, then exit flight
--     local shouldStop, _ = ShouldStopFlyingBecauseGrounded(o, vars)
--     if shouldStop then
--         Transition_ToStandard(vars, const, debug, o)
--         do return end
--     end

--     o:GetCamera()

--     -- Fire a ray, according to initial conditions
--     local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)

--     local hitPoint, _ = RayCast_HitPoint(from, o.lookdir_forward, vars.rayLength, const.grappleMinResolution, o)

--     -- See if the ray hit something
--     if hitPoint then
--         -- Ensure pin is drawn and placed properly (flight pin, not aim pin)
--         EnsureMapPinVisible(hitPoint, vars.grapple.mappin_name, vars, o)

--         Transition_ToFlight_Straight(vars, const, o, from, hitPoint)
--         do return end
--     end

--     -- Update map pin
--     local aimPoint = Vector4.new(from.x + (o.lookdir_forward.x * vars.rayLength), from.y + (o.lookdir_forward.y * vars.rayLength), from.z + (o.lookdir_forward.z * vars.rayLength), 1)
--     EnsureMapPinVisible(aimPoint, dash.mappin_name, vars, o)

--     -- Get the component of the velocity along the request line
--     local vel_along, isSameDir = GetProjectedVector_AlongVector(o.vel, o.lookdir_forward, true)










--     -- -- Figure out the delta between actual and desired speed
--     -- local speed = GetVectorLength(vel_along)

--     -- -- Calculate forward accel
--     -- local air_x, air_y, air_z, percent = GetPullAccel_Constant(dash.accel, o.lookdir_forward, 1000, speed, not isSameDir)




--     if not dash_accel_z then
--         dash_accel_z =
--         {
--             accel = 6,
--             speed = 2.5,
--             deadSpot_distance = 0,
--             deadSpot_speed = 0.1,
--         }
--     end


--     local speed_xy = GetVectorLength2D(vel_along.x, vel_along.y)
--     local speed_z = math.abs(vel_along.z)

--     local air_x, air_y = GetPullAccel_Constant(dash.accel, o.lookdir_forward, 1000, speed_xy, not isSameDir)
--     local _, _, air_z = GetPullAccel_Constant(dash_accel_z, o.lookdir_forward, 1000, speed_z, not isSameDir)


--     --local antigrav_z = 16
--     local antigrav_z = 14


--     -- Apply the acceleration
--     local accel_x = air_x * deltaTime
--     local accel_y = air_y * deltaTime
--     local accel_z = (air_z + antigrav_z) * deltaTime







--     -- debug.accel_x = Round(accel_x / deltaTime, 1)
--     -- debug.accel_y = Round(accel_y / deltaTime, 1)
--     -- debug.accel_z = Round(accel_z / deltaTime, 1)

--     o:AddImpulse(accel_x, accel_y, accel_z)
-- end