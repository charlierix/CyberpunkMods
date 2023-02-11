local swing_grapples = require("processing/aimswing_grapples")
local swing_raycasts = require("processing/aimswing_raycasts")

local this = {}

local up = nil

-- This is called when they've initiated a new grapple.  It looks at the environment and kicks
-- off actual flight with final values (like anchor point)
--
-- StaightLine does a ray cast.  If the ray hits, then it starts grapple.  If too much time has
-- passed, it either does an air dash, or goes back to standard mode
--
-- Webswing will look at current velocity, direction looking and find a good anchor point that
-- carries flight through a desired arc
function Process_Aim(o, player, vars, const, debug, deltaTime)
    -- There's potentially a case to stop right away if standing on the ground if:
    --  there is no air dash
    --  there is no pull force, either by one of:
    --      desired_length ~= nil and (accel_alongGrappleLine ~= nil or springAccel_k ~= nil)
    --      accel_alongLook ~= nil
    --
    -- That's a lot of logic that will just get replicated in the corresponding flight functions

    -- Recover energy at the reduced flight rate
    vars.energy = RecoverEnergy(vars.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate * player.energy_tank.flying_percent, deltaTime)

    if vars.grapple.aim_straight then
        this.Aim_Straight(vars.grapple.aim_straight, o, player, vars, const, debug)

    elseif vars.grapple.aim_swing then
        this.Aim_Swing(vars.grapple.aim_swing, o, player, vars, const, debug)

    else
        LogError("Unknown aim")
        Transition_ToStandard(vars, const, debug, o)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Aim_Straight(aim, o, player, vars, const, debug)
    if this.RecoverEnergy_Switch(o, player, vars, const) then
        do return end
    end

    -- Fire a ray
    o:GetCamera()

    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)
    local to = GetPoint(o.pos, o.lookdir_forward, aim.max_distance)

    local hitPoint = o:RayCast(from, to)

    -- See if the ray hit something
    if hitPoint then
        -- Ensure pin is drawn and placed properly (flight pin, not aim pin)
        EnsureMapPinVisible(hitPoint, vars.grapple.mappin_name, vars, o)

        Transition_ToFlight_Straight(vars, const, o, from, hitPoint, nil)
        do return end
    end

    -- They're looking at open air, or something that is too far away
    if o.timer - vars.startTime > aim.aim_duration then
        -- Took too long to aim

        local switched = false

        -- if aim.air_dash then
        --     -- Switching to air dash
        --     Transition_ToAirDash(aim.air_dash, vars, const, o, from, aim.max_distance)
        --     switched = true
        -- elseif ....

        if aim.air_anchor then
            -- They have an air anchor equipped.  See if there's enough energy to use it
            -- (this energy compare is a copy of Transition_ToAim)

            local cost = aim.air_anchor.energyCost * (1 - aim.air_anchor.energyCost_reduction_percent)

            if vars.energy < cost then
                -- Notify the player that energy is too low
                vars.animation_lowEnergy:ActivateAnimation()
            else
                vars.energy = vars.energy - cost

                hitPoint = Vector4.new(from.x + (o.lookdir_forward.x * aim.max_distance), from.y + (o.lookdir_forward.y * aim.max_distance), from.z + (o.lookdir_forward.z * aim.max_distance), 1)
                EnsureMapPinVisible(hitPoint, vars.grapple.mappin_name, vars, o)
                Transition_ToFlight_Straight(vars, const, o, from, hitPoint, aim.air_anchor)

                switched = true
            end
        end

        if not switched then
            -- Took too long to aim, can't air dash, giving up

            -- Since the grapple didn't happen, give back the energy that was taken at the start of the aim
            vars.energy = math.min(vars.energy + vars.grapple.energy_cost, player.energy_tank.max_energy)

            Transition_ToStandard(vars, const, debug, o)
        end

    else
        -- Still aiming, make sure the map pin is visible
        local aimPoint = Vector4.new(from.x + (o.lookdir_forward.x * aim.max_distance), from.y + (o.lookdir_forward.y * aim.max_distance), from.z + (o.lookdir_forward.z * aim.max_distance), 1)
        EnsureMapPinVisible(aimPoint, aim.mappin_name, vars, o)
    end
end

function this.Aim_Swing_ATTEMPT1(aim, o, player, vars, const, debug)
    if this.RecoverEnergy_Switch(o, player, vars, const) then
        do return end
    end


    -- Maybe as a first step it would be best to look at current velocity, current direction facing
    -- Use those to figure out an ideal path and where to focus some ray casts



    -- Fire some rays in a forward cone
    --local cone_hits = swing_raycasts.InitialCone1(o, const)
    swing_raycasts.Scan_LookAndVelocity1(o, const)

    -- Detect if enclosed space:
    --  Launch the player into the middle of that space in the rough direction that the player is facing

    -- Detect if should launch the player in the air
    --  Launch the player up at an angle to get off the ground and moving quickly



    -- else (much more work to do here, but get the above working first)
    --this.Aim_Swing_45Only(o, vars, const)
    this.Aim_Swing_Slingshot(o, vars, const)
end
function this.Aim_Swing_ATTEMPT2(aim, o, player, vars, const, debug)
    if this.RecoverEnergy_Switch(o, player, vars, const) then
        do return end
    end

    local is_airborne = IsAirborne(o)

    local SPEED_STRAIGHT = 8

    local speed_sqr = GetVectorLengthSqr(o.vel)

    if not is_airborne or speed_sqr <= SPEED_STRAIGHT * SPEED_STRAIGHT then
        -- Moving too slow, just do a straight line grapple
        this.Aim_Swing_Slingshot(is_airborne, o, vars, const)
        do return end
    end

    --TODO: if looking too much up, then do a straight line, or an elastic rope

    -- Use velocity and direction looking to define a cone and fire some rays
    --aimswing_raycasts.Scan_LookAndVelocity1()

    -- If the path is clear, swing
    --this.Aim_Swing_45Only(o, vars, const)

    local speed = math.sqrt(speed_sqr)
    local vel_unit = MultiplyVector(o.vel, 1 / speed)       -- safe to divide, because check for zero was done above

    local MIN_DOT = 0.2

    local look_dot_vel = DotProduct3D(o.lookdir_forward, vel_unit)
    if look_dot_vel > MIN_DOT then
        --this.Aim_Swing_45_AppropriateVelocity(speed, o, vars, const)

        if this.Aim_Swing_LookBasedEndpoint(o, vars, const) then
            do return end
        end
    end

    this.Aim_Swing_Slingshot(is_airborne, o, vars, const)
end

--TODO: have a log, pass onto transition so process can continue to log points
function this.Aim_Swing(aim, o, player, vars, const, debug)
    local SPEED_STRAIGHT = 8
    local DOT_UNDERSWING_MIN = -0.8
    local DOT_UNDERSWING_MAX = -0.2
    local DOT_TOSS_MAX = 0.4
    local DOT_HORZ_MIN = -0.6

    if this.RecoverEnergy_Switch(o, player, vars, const) then
        do return end
    end

    o:GetCamera()

    local position, look_dir = o:GetCrosshairInfo()

    local vel_look = GetProjectedVector_AlongVector(o.vel, look_dir, false)
    local speed_look = GetVectorLength(vel_look)

    local is_airborne = IsAirborne(o)

    local speed_sqr = GetVectorLengthSqr(o.vel)

    if not is_airborne or speed_sqr <= SPEED_STRAIGHT * SPEED_STRAIGHT then
        -- On the ground or moving too slow, just do a straight line grapple
        this.Aim_Swing_Slingshot2(position, look_dir, speed_look, is_airborne, o, vars, const)
        do return end
    end

    local speed = math.sqrt(speed_sqr)
    local vel_unit = MultiplyVector(o.vel, 1 / speed)       -- safe to divide, because check for zero was done above

    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    local dot_vertical = DotProduct3D(vel_unit, up)

    local vel_horz_unit = GetProjectedVector_AlongPlane_Unit(o.vel, up)
    local vel_horz = GetProjectedVector_AlongVector(o.vel, vel_horz_unit)       -- this is the same thing that GetProjectedVector_AlongPlane does

    local look_horz_unit = GetProjectedVector_AlongPlane_Unit(look_dir, up)

    local dot_horizontal = DotProduct3D(look_horz_unit, vel_horz_unit)
    if dot_horizontal < DOT_HORZ_MIN then
        -- They are trying to pull a 180
        this.Aim_Swing_Slingshot2(position, look_dir, speed_look, is_airborne, o, vars, const)
        do return end

    elseif dot_vertical < DOT_UNDERSWING_MIN then
        -- Going nearly straight down
        -- If there is enough velocity, do an underswing and toss them to the end point
        if not this.Aim_Swing_Toss_DownUp() then
            -- There's not enough velocity, revert to straight line
            this.Aim_Swing_Slingshot2(position, look_dir, speed_look, is_airborne, o, vars, const)
        end
        do return end

    elseif dot_vertical > DOT_TOSS_MAX then
        -- Going above 45 degrees
        -- An overswing might be able to be used, but that would feel unnatural.  Just do a straight line
        this.Aim_Swing_Slingshot2(position, look_dir, speed_look, is_airborne, o, vars, const)
        do return end

    elseif dot_vertical < DOT_UNDERSWING_MAX then
        -- Standard web swing, this should be most cases
        if not this.Aim_Swing_UnderSwing(position, look_dir, speed_look, vel_unit, o, vars, const) then
            this.Aim_Swing_Slingshot2(position, look_dir, speed_look, is_airborne, o, vars, const)
        end
        do return end
    end

    -- If there's enough velocity, do a mini underswing and toss them to the end point
    if this.Aim_Swing_Toss_Up() then
        do return end
    end

    -- Nothing else worked, default to straight line
    this.Aim_Swing_Slingshot2(position, look_dir, speed_look, is_airborne, o, vars, const)
end

function this.RecoverEnergy_Switch(o, player, vars, const)
    if vars.startStopTracker:GetRequestedAction() then
        -- Something different was requested, recover the energy that was used for this current grapple
        local existingEnergy = vars.energy
        vars.energy = math.min(vars.energy + vars.grapple.energy_cost, player.energy_tank.max_energy)

        if HasSwitchedFlightMode(o, player, vars, const, true) then        -- this function looks at the same bindings as above
            return true
        else
            -- There was some reason why the switch didn't work.  Take the energy back
            vars.energy = existingEnergy
        end
    end

    return false
end

------------------------------------ Temp Hardcoded -----------------------------------

-- This blindly sets the anchor point at 24 meters, 45 degrees above look direction
function this.Aim_Swing_45Only(o, vars, const)
    o:GetCamera()

    -- For now, just do 45 degrees forward and up
    local lookdir_up = CrossProduct3D(o.lookdir_right, o.lookdir_forward)

    local look_direction = AddVectors(o.lookdir_forward, lookdir_up)
    Normalize(look_direction)

    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)
    local to = AddVectors(from, MultiplyVector(look_direction, 24))

    EnsureMapPinVisible(to, vars.grapple.mappin_name, vars, o)

    Transition_ToFlight_Swing(vars.grapple, vars, const, o, from, to, nil)
end

-- This is similar to Aim_Swing_45Only, but changes the anchor length based on velocity along look direction
function this.Aim_Swing_45_AppropriateVelocity(speed, o, vars, const)
    local MIN_DIST = 18
    local MAX_DIST = 36
    local MIN_SPEED = 8
    local MAX_SPEED = 24

    o:GetCamera()

    -- For now, just do 45 degrees forward and up
    local lookdir_up = CrossProduct3D(o.lookdir_right, o.lookdir_forward)

    local look_direction = AddVectors(o.lookdir_forward, lookdir_up)
    Normalize(look_direction)

    -- There's probably a better way, but for now, take the speed.  This function doesn't get called if velocity direction
    -- is too far away from look direction
    local anchor_dist = Clamp(MIN_DIST, MAX_DIST, GetScaledValue(MIN_DIST, MAX_DIST, MIN_SPEED, MAX_SPEED, speed))

    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)
    local to = AddVectors(from, MultiplyVector(look_direction, anchor_dist))

    EnsureMapPinVisible(to, vars.grapple.mappin_name, vars, o)

    Transition_ToFlight_Swing(vars.grapple, vars, const, o, from, to, nil)
end

-- This uses the speed along look direction to figure out how far along look the end point of the swing should be
-- There should be a new exit condition added to the grapple so that it stops the grapple when near that point
-- NOTE: this function probably only makes sense for low angles between velocity and look (in the horizontal plane)
function this.Aim_Swing_LookBasedEndpoint(o, vars, const)
    local MIN_DIST = 15
    local MAX_DIST = 60
    local SPEED_MAX = 24

    o:GetCamera()

    local position, look_dir = o:GetCrosshairInfo()

    local vel_look = GetProjectedVector_AlongVector(o.vel, look_dir, false)
    local speed_look = GetVectorLength(vel_look)

    local end_dist = Clamp(0, MAX_DIST, GetScaledValue(MIN_DIST, MAX_DIST, 0, SPEED_MAX, speed_look))

    local end_pos = AddVectors(position, MultiplyVector(look_dir, end_dist))

    -- There may be a more perfect solution, but for now, generate some random candidates near the expected
    -- ideal, calculate the arc, velocity at release point
    -- Then pick the winner (or do another round, up to MAX_ATTEMPTS)
    --  The winner's arc will be tangent to initial velocity at the starting point
    --  The arc also needs to pass near the end point
    --  The velocity at release should desirable

    -- Also use current velocity to figure out rougly where the anchor should be
    --  Any horizontal velocity would pull the anchor off the vertical plane in the oposite direction
    --  Vertical velocity will pull the anchor forward or back










    return false
end


--NOTE: if there is a horizontal component of initial velocity, the path will fall short of endpoint.  Probably need to compensate by rotating the anchor a bit higher
function this.Aim_Swing_UnderSwing(position, look_dir, speed_look, vel_unit, o, vars, const)
    local MIN_DIST = 12
    local MAX_DIST = 48
    local SPEED_MAX = 36

    --TODO: Reduce distance if the area is cluttered
    local dest_dist = Clamp(0, MAX_DIST, GetScaledValue(MIN_DIST, MAX_DIST, 0, SPEED_MAX, speed_look))

    local dest_pos = AddVectors(position, MultiplyVector(look_dir, dest_dist))

    local orth = CrossProduct3D(vel_unit, look_dir)
    local anchor_line = CrossProduct3D(orth, vel_unit)


    local mid_point = AddVectors(position, MultiplyVector(look_dir, dest_dist / 2))
    local up_to_anchor = CrossProduct3D(orth, look_dir)

    local found_intersection, intersect1, intersect2 = GetClosestPoints_Line_Line(position, AddVectors(position, anchor_line), mid_point, AddVectors(mid_point, up_to_anchor))
    if not found_intersection then
        return false
    end

    local anchor_point = Vector4.new((intersect1.x + intersect2.x) / 2, (intersect1.y + intersect2.y) / 2, (intersect1.z + intersect2.z) / 2, 1)

    EnsureMapPinVisible(anchor_point, vars.grapple.mappin_name, vars, o)

    --TODO: extra args for stop settings
    --  define a plane that will cancel the swing once they pass to the other side
    Transition_ToFlight_Swing(vars.grapple, vars, const, o, position, anchor_point, nil)

    return true
end

function this.Aim_Swing_Toss_DownUp()
    return false
end

function this.Aim_Swing_Toss_Up()
    return false
end

function this.Aim_Swing_Slingshot(is_airborne, o, vars, const)
    local MIN_DIST = 15
    local MAX_DIST = 60
    local SPEED_MAX = 24

    o:GetCamera()

    local position, look_dir = o:GetCrosshairInfo()

    local vel_look = GetProjectedVector_AlongVector(o.vel, look_dir, false)
    local speed_look = GetVectorLength(vel_look)

    local anchor_dist = Clamp(0, MAX_DIST, GetScaledValue(MIN_DIST, MAX_DIST, 0, SPEED_MAX, speed_look))

    --TODO: If looking down, and there is ground in the way, choose a point above the ground
    --TODO: Distance should be based on current speed (also how cluttered the area is)
    local anchor_pos = AddVectors(position, MultiplyVector(look_dir, anchor_dist))

    -- Ensure pin is drawn and placed properly (flight pin, not aim pin)
    EnsureMapPinVisible(anchor_pos, vars.grapple.mappin_name, vars, o)

    local new_grapple = swing_grapples.GetElasticStraight(vars.grapple, position, anchor_pos)

    this.MaybePopUp(is_airborne, o, new_grapple.anti_gravity)

    Transition_ToFlight_Swing(new_grapple, vars, const, o, position, anchor_pos, nil)
end
function this.Aim_Swing_Slingshot2(position, look_dir, speed_look, is_airborne, o, vars, const)
    local MIN_DIST = 15
    local MAX_DIST = 60
    local SPEED_MAX = 24

    --TODO: Reduce distance if the area is cluttered
    local anchor_dist = Clamp(0, MAX_DIST, GetScaledValue(MIN_DIST, MAX_DIST, 0, SPEED_MAX, speed_look))

    --TODO: If looking down, and there is ground in the way, choose a point above the ground
    local anchor_pos = AddVectors(position, MultiplyVector(look_dir, anchor_dist))

    -- Ensure pin is drawn and placed properly (flight pin, not aim pin)
    EnsureMapPinVisible(anchor_pos, vars.grapple.mappin_name, vars, o)

    local new_grapple = swing_grapples.GetElasticStraight(vars.grapple, position, anchor_pos)

    this.MaybePopUp(is_airborne, o, new_grapple.anti_gravity)

    Transition_ToFlight_Swing(new_grapple, vars, const, o, position, anchor_pos, nil)
end

-- If on the ground and angle is too low, apply an up impulse
function this.MaybePopUp(is_airborne, o, anti_gravity)
    if is_airborne then
        do return end
    end

    --TODO: May want to add some kick in the horizontal portion of direction facing
    --TODO: Adjust upward strength based on antigrav

    o:AddImpulse(0, 0, 4)
end