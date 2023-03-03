local swing_grapples = require("processing/aimswing_grapples")
local swing_raycasts = require("processing/aimswing_raycasts")

local this = {}

local up = nil

local set_debug_categories = false
local debug_categories = CreateEnum("AIM_action", "AIM_speed", "AIM_dots", "AIM_pos", "AIM_look", "AIM_velunit", "AIM_up", "AIM_anchor", "AIM_stopplane", "AIM_anchordist")

local slingshot_dist_by_dot = nil
local slingshot_accelmult_by_dot = nil
local slingshot_distmult_by_speed = nil

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
        local stopplane_point, stopplane_normal = this.GetStopPlane_Straight(hitPoint, o.lookdir_forward, vars.grapple.stop_plane_distance)
        Transition_ToFlight_Straight(vars, const, o, from, hitPoint, nil, stopplane_point, stopplane_normal)
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
                local stopplane_point, stopplane_normal = this.GetStopPlane_Straight(hitPoint, o.lookdir_forward, vars.grapple.stop_plane_distance)
                Transition_ToFlight_Straight(vars, const, o, from, hitPoint, aim.air_anchor, stopplane_point, stopplane_normal)

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

function this.Aim_Swing_ATTEMPT3(aim, o, player, vars, const, debug)
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

function this.Aim_Swing(aim, o, player, vars, const, debug)
    local SPEED_STRAIGHT = 3
    local DOT_UNDERSWING_MIN = -0.8
    local DOT_UNDERSWING_MAX = -0.2
    local DOT_TOSS_MAX = 0.4
    local DOT_HORZ_MIN = -0.6

    this.EnsureDebugCategoriesSet()
    debug_render_screen.Clear()

    if this.RecoverEnergy_Switch(o, player, vars, const) then
        debug_render_screen.Add_Text2D(nil, nil, "exit early", debug_categories.AIM_action)
        do return end
    end

    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    o:GetCamera()

    local position, look_dir = o:GetCrosshairInfo()

    if debug_render_screen.IsEnabled() then
        debug_render_screen.Add_Dot(position, debug_categories.AIM_pos)
        debug_render_screen.Add_Line(position, AddVectors(position, look_dir), debug_categories.AIM_look)
    end

    if not IsAirborne(o) then
        debug_render_screen.Add_Text2D(nil, nil, "from ground", debug_categories.AIM_action)
        this.Aim_Swing_FromGround(position, look_dir, o, vars, const)
        do return end
    end

    --TODO: option to limit anchor if there's not any ray hits nearby.  Either cost, or a reduced height

    local vel_look = GetProjectedVector_AlongVector(o.vel, look_dir, false)
    local speed_look = GetVectorLength(vel_look)

    local speed_sqr = GetVectorLengthSqr(o.vel)
    if debug_render_screen.IsEnabled() then
        debug_render_screen.Add_Text2D(nil, nil, "speed: " .. tostring(Round(math.sqrt(speed_sqr), 1)) .. "\r\nspeed look: " .. tostring(Round(speed_look, 1)), debug_categories.AIM_speed)
    end

    if speed_sqr <= SPEED_STRAIGHT * SPEED_STRAIGHT then
        -- Moving too slow, just do a straight line grapple
        debug_render_screen.Add_Text2D(nil, nil, "too slow", debug_categories.AIM_action)
        this.Aim_Swing_Slingshot3(position, look_dir, speed_look, false, o, vars, const)
        do return end
    end

    local speed = math.sqrt(speed_sqr)
    local vel_unit = MultiplyVector(o.vel, 1 / speed)       -- safe to divide, because check for zero was done above

    local dot_vertical = DotProduct3D(vel_unit, up)

    local vel_horz_unit = GetProjectedVector_AlongPlane_Unit(o.vel, up)
    local vel_horz = GetProjectedVector_AlongVector(o.vel, vel_horz_unit)       -- this is the same thing that GetProjectedVector_AlongPlane does

    local look_horz_unit = GetProjectedVector_AlongPlane_Unit(look_dir, up)

    local dot_horizontal = DotProduct3D(look_horz_unit, vel_horz_unit)

    if debug_render_screen.IsEnabled() then
        debug_render_screen.Add_Line(position, AddVectors(position, up), debug_categories.AIM_up)
        debug_render_screen.Add_Line(position, AddVectors(position, vel_unit), debug_categories.AIM_velunit)
        debug_render_screen.Add_Text2D(nil, nil, "dot vertical: " .. tostring(Round(dot_vertical, 2)) .. "\r\ndot horizontal: " .. tostring(Round(dot_horizontal, 2)), debug_categories.AIM_dots)
    end

    if dot_horizontal < DOT_HORZ_MIN then
        -- They are trying to pull a 180
        debug_render_screen.Add_Text2D(nil, nil, "pulling a 180", debug_categories.AIM_action)
        this.Aim_Swing_Slingshot3(position, look_dir, speed_look, false, o, vars, const)
        do return end

    elseif dot_vertical < DOT_UNDERSWING_MIN then
        -- Going nearly straight down
        -- If there is enough velocity, do an underswing and toss them to the end point
        if this.Aim_Swing_Toss_DownUp() then
            debug_render_screen.Add_Text2D(nil, nil, "down - tossing up", debug_categories.AIM_action)
        else
            -- There's not enough velocity, revert to straight line
            debug_render_screen.Add_Text2D(nil, nil, "down - couldn't toss up", debug_categories.AIM_action)
            this.Aim_Swing_Slingshot3(position, look_dir, speed_look, false, o, vars, const)
        end
        do return end

    elseif dot_vertical > DOT_TOSS_MAX then
        -- Going above 45 degrees
        -- An overswing might be able to be used, but that would feel unnatural.  Just do a straight line
        debug_render_screen.Add_Text2D(nil, nil, "over 45 degrees", debug_categories.AIM_action)
        this.Aim_Swing_Slingshot3(position, look_dir, speed_look, false, o, vars, const)
        do return end

    elseif dot_vertical < DOT_UNDERSWING_MAX then
        -- Standard web swing, this should be most cases
        if this.Aim_Swing_UnderSwing(position, look_dir, speed_look, vel_unit, o, vars, const) then
            debug_render_screen.Add_Text2D(nil, nil, "underswing", debug_categories.AIM_action)
        else
            debug_render_screen.Add_Text2D(nil, nil, "couldn't underswing", debug_categories.AIM_action)
            this.Aim_Swing_Slingshot3(position, look_dir, speed_look, false, o, vars, const)
        end
        do return end
    end

    -- If there's enough velocity, do a mini underswing and toss them to the end point
    if this.Aim_Swing_Toss_Up() then
        debug_render_screen.Add_Text2D(nil, nil, "toss up", debug_categories.AIM_action)
        do return end
    end

    -- Nothing else worked, default to straight line
    debug_render_screen.Add_Text2D(nil, nil, "default", debug_categories.AIM_action)
    this.Aim_Swing_Slingshot3(position, look_dir, speed_look, false, o, vars, const)
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

function this.GetStopPlane_Straight(anchor_pos, direction, stop_plane_distance)
    if not stop_plane_distance then
        return nil, nil
    end

    local point_on_plane = AddVectors(anchor_pos, MultiplyVector(direction, -stop_plane_distance))

    return point_on_plane, direction
end

function this.EnsureDebugCategoriesSet()
    if set_debug_categories then
        do return end
    end

    debug_render_screen.DefineCategory(debug_categories.AIM_action, "BC105C80", "FFF", nil, nil, nil, 0.25, 0.6)
    debug_render_screen.DefineCategory(debug_categories.AIM_speed, "BC2E6939", "FFF", nil, nil, nil, 0.25, 0.65)
    debug_render_screen.DefineCategory(debug_categories.AIM_dots, "BC3D6E6C", "FFF", nil, nil, nil, 0.25, 0.7)

    debug_render_screen.DefineCategory(debug_categories.AIM_pos, "CCC")
    debug_render_screen.DefineCategory(debug_categories.AIM_look, nil, "EBEDA8")
    debug_render_screen.DefineCategory(debug_categories.AIM_velunit, nil, "9370B5")

    debug_render_screen.DefineCategory(debug_categories.AIM_up, nil, "0AC70D")

    debug_render_screen.DefineCategory(debug_categories.AIM_anchor, "DED716", nil, nil, 1.5, true)
    debug_render_screen.DefineCategory(debug_categories.AIM_stopplane, "40DED716", "80DED716")
    debug_render_screen.DefineCategory(debug_categories.AIM_anchordist, "94838150", "F8F36C")

    set_debug_categories = true
end

function this.ShowEndPoint(anchor_pos, anchor_dist, stopplane_point, stopplane_normal, grapple, vars, o)
    if debug_render_screen.IsEnabled() then
        debug_render_screen.Add_Dot(anchor_pos, debug_categories.AIM_anchor)
        debug_render_screen.Add_Text(AddVectors(anchor_pos, MultiplyVector(up, -0.2)), tostring(Round(anchor_dist, 1)), debug_categories.AIM_anchordist)

        if stopplane_point then
            debug_render_screen.Add_Square(stopplane_point, stopplane_normal, 3, 3, debug_categories.AIM_stopplane)
        end
    else
        EnsureMapPinVisible(anchor_pos, grapple.mappin_name, vars, o)       -- Flight pin, not aim
    end
end

------------------------------------ Temp Hardcoded -----------------------------------

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


    --TODO: get a rope style grapple


    local quat = GetRotation(vel_unit, look_dir, 2)
    local dest_dir = RotateVector3D(vel_unit, quat)
    local stopplane_point, stopplane_normal = this.GetStopPlane_Straight(dest_pos, dest_dir, vars.grapple.stop_plane_distance)

    EnsureMapPinVisible(anchor_point, vars.grapple.mappin_name, vars, o)
    Transition_ToFlight_Swing(vars.grapple, vars, const, o, position, anchor_point, nil, stopplane_point, stopplane_normal)

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

    local new_grapple = swing_grapples.GetElasticStraight(vars.grapple, position, anchor_pos)

    this.MaybePopUp(is_airborne, o, new_grapple.anti_gravity, look_dir)

    local stopplane_point, stopplane_normal = this.GetStopPlane_Straight(anchor_pos, look_dir, new_grapple.stop_plane_distance)

    EnsureMapPinVisible(anchor_pos, new_grapple.mappin_name, vars, o)
    Transition_ToFlight_Swing(new_grapple, vars, const, o, position, anchor_pos, nil, stopplane_point, stopplane_normal)
end
function this.Aim_Swing_Slingshot2(position, look_dir, speed_look, is_airborne, o, vars, const)
    local MIN_DIST = 15
    local MAX_DIST = 60
    local SPEED_MAX = 24

    --TODO: Reduce distance if the area is cluttered
    local anchor_dist = Clamp(0, MAX_DIST, GetScaledValue(MIN_DIST, MAX_DIST, 0, SPEED_MAX, speed_look))

    --TODO: If looking down, and there is ground in the way, choose a point above the ground
    local anchor_pos = AddVectors(position, MultiplyVector(look_dir, anchor_dist))

    local new_grapple = swing_grapples.GetElasticStraight(vars.grapple, position, anchor_pos)

    this.MaybePopUp(is_airborne, o, new_grapple.anti_gravity, look_dir)

    local stopplane_point, stopplane_normal = this.GetStopPlane_Straight(anchor_pos, look_dir, new_grapple.stop_plane_distance)

    EnsureMapPinVisible(anchor_pos, new_grapple.mappin_name, vars, o)
    Transition_ToFlight_Swing(new_grapple, vars, const, o, position, anchor_pos, nil, stopplane_point, stopplane_normal)
end
function this.Aim_Swing_Slingshot3(position, look_dir, speed_look, is_airborne, o, vars, const)
    if not slingshot_dist_by_dot then
        slingshot_dist_by_dot = AnimationCurve:new()
        slingshot_dist_by_dot:AddKeyValue(Angle_to_Dot(0), 4)
        slingshot_dist_by_dot:AddKeyValue(Angle_to_Dot(45), 6)
        slingshot_dist_by_dot:AddKeyValue(Angle_to_Dot(90), 12)
        slingshot_dist_by_dot:AddKeyValue(Angle_to_Dot(135), 4)
        slingshot_dist_by_dot:AddKeyValue(Angle_to_Dot(180), 3)

        slingshot_accelmult_by_dot = AnimationCurve:new()
        slingshot_accelmult_by_dot:AddKeyValue(Angle_to_Dot(0), 1)
        slingshot_accelmult_by_dot:AddKeyValue(Angle_to_Dot(90), 1)
        slingshot_accelmult_by_dot:AddKeyValue(Angle_to_Dot(135), 1.5)
        slingshot_accelmult_by_dot:AddKeyValue(Angle_to_Dot(180), 2)

        slingshot_distmult_by_speed = AnimationCurve:new()
        slingshot_distmult_by_speed:AddKeyValue(0, 1)
        slingshot_distmult_by_speed:AddKeyValue(12, 1)
        slingshot_distmult_by_speed:AddKeyValue(24, 1.5)
        slingshot_distmult_by_speed:AddKeyValue(36, 2)
        slingshot_distmult_by_speed:AddKeyValue(48, 1)
    end

    local dot_vert = DotProduct3D(look_dir, up)

    --TODO: Reduce distance if the area is cluttered

    local anchor_dist = slingshot_dist_by_dot:Evaluate(dot_vert) * slingshot_distmult_by_speed:Evaluate(speed_look)

    local anchor_pos = AddVectors(position, MultiplyVector(look_dir, anchor_dist))

    local hit = o:RayCast(position, anchor_pos)
    if hit then
        -- Not clear, set anchor point at hit
        anchor_pos = hit
    end

    local accel_mult = slingshot_accelmult_by_dot:Evaluate(dot_vert)

    local new_grapple = swing_grapples.GetElasticStraight2(vars.grapple, position, anchor_pos, accel_mult)

    this.MaybePopUp(is_airborne, o, new_grapple.anti_gravity, look_dir)

    local stopplane_point, stopplane_normal = this.GetStopPlane_Straight(anchor_pos, look_dir, new_grapple.stop_plane_distance)

    this.ShowEndPoint(anchor_pos, anchor_dist, stopplane_point, stopplane_normal, new_grapple, vars, o)

    Transition_ToFlight_Swing(new_grapple, vars, const, o, position, anchor_pos, nil, stopplane_point, stopplane_normal)
end

function this.Aim_Swing_FromGround(position, look_dir, o, vars, const)
    local DIST_HORZ = 18
    local DIST_VERT = 6

    local DOT_MAX = 0.9
    local DOT_MIN = 0

    local dot_vert = DotProduct3D(look_dir, up)

    -- Figure out max distance based on angle
    local anchor_dist
    if dot_vert >= DOT_MAX then
        anchor_dist = DIST_VERT
    elseif dot_vert <= DOT_MIN then
        anchor_dist = DIST_HORZ
    else
        anchor_dist = GetScaledValue(DIST_HORZ, DIST_VERT, DOT_MIN, DOT_MAX, dot_vert)
    end

    local anchor_pos = AddVectors(position, MultiplyVector(look_dir, anchor_dist))

    -- Fire a ray to see if the path is clear
    local hit = o:RayCast(position, anchor_pos)
    if hit then
        -- Not clear, set anchor point at hit
        this.Aim_Swing_FromGround_DoIt(position, hit, look_dir, o, vars, const)
        do return end
    end

    ---------------------------
    -- After analyzing various launches and ray hits/misses, I don't think I would want to change behavior of the grapple.
    -- The player knows where they're pointing and reducing grapple ability in tight spots will just be annoying
    ---------------------------
    -- Not going to run into something, fire some rays to see how cluttered the area is
    --local hits = swing_raycasts.Cylinder(o, position, look_dir, anchor_dist)

    -- Reduce max if cluttered (hits along the path should apply a constricting pressure)
    -- May also want to push the anchor point if too close to a hit
    ---------------------------

    this.Aim_Swing_FromGround_DoIt(position, anchor_pos, look_dir, anchor_dist, o, vars, const)
end
function this.Aim_Swing_FromGround_DoIt(position, anchor_pos, jumpdir_unit, anchor_dist, o, vars, const)
    local new_grapple = swing_grapples.GetElasticStraight2(vars.grapple, position, anchor_pos)

    this.MaybePopUp(false, o, new_grapple.anti_gravity, jumpdir_unit)

    local stopplane_point, stopplane_normal = this.GetStopPlane_Straight(anchor_pos, jumpdir_unit, new_grapple.stop_plane_distance)

    this.ShowEndPoint(anchor_pos, anchor_dist, stopplane_point, stopplane_normal, new_grapple, vars, o)

    Transition_ToFlight_Swing(new_grapple, vars, const, o, position, anchor_pos, nil, stopplane_point, stopplane_normal)
end

-- If on the ground and angle is too low, apply an up impulse
function this.MaybePopUp(is_airborne, o, anti_gravity, jumpdir_unit)
    local STRENGTH_MAX = 4
    local DOT_HORZ = 0.4
    local DOT_VERT = 0.75

    if is_airborne then
        do return end
    end

    --TODO: May want to add some kick in the horizontal portion of direction facing
    --TODO: Adjust upward strength based on antigrav

    local dot = DotProduct3D(jumpdir_unit, up)

    local strength = 0
    if dot < DOT_HORZ then
        strength = STRENGTH_MAX
    elseif dot > DOT_VERT then
        do return end
    else
        strength = GetScaledValue(0, STRENGTH_MAX, DOT_VERT, DOT_HORZ, dot)
    end

    o:AddImpulse(0, 0, strength)
end