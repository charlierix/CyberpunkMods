local swing_grapples = require("processing/aimswing_grapples")
local swing_raycasts = require("processing/aimswing_raycasts")

local this = {}

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
function this.Aim_Swing(aim, o, player, vars, const, debug)
    if this.RecoverEnergy_Switch(o, player, vars, const) then
        do return end
    end

    local is_airborne = IsAirborne(o)

    local SPEED_STRAIGHT = 4

    local speed_sqr = GetVectorLengthSqr(o.vel)

    if not is_airborne or speed_sqr <= SPEED_STRAIGHT * SPEED_STRAIGHT then
        -- Moving too slow, just do a straight line grapple
        this.Aim_Swing_Slingshot(is_airborne, o, vars, const)
        do return end
    end

    -- Use velocity and direction looking to define a cone and fire some rays
    --aimswing_raycasts.Scan_LookAndVelocity1()

    -- If the path is clear, swing
    this.Aim_Swing_45Only(o, vars, const)

    -- else
    --this.Aim_Swing_Slingshot(is_airborne, o, vars, const)
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

--TODO: aim distance should be based on current velocity (length of component of velocity along look)
-- This first attempt just shoots the player like a slingshot, possibly applying an extra impulse to get them
-- off the ground
function this.Aim_Swing_Slingshot(is_airborne, o, vars, const)
    local MIN_DIST = 12
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

-- If on the ground and angle is too low, apply an up impulse
function this.MaybePopUp(is_airborne, o, anti_gravity)
    if is_airborne then
        do return end
    end

    --TODO: May want to add some kick in the horizontal portion of direction facing
    --TODO: Adjust upward strength based on antigrav

    o:AddImpulse(0, 0, 4)
end