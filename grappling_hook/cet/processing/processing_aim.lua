local swing_grapples = require("processing/aimswing_grapples")
local swing_raycasts = require("processing/aimswing_raycasts")

local this = {}

local up = nil

local set_debug_categories = false
local debug_categories = CreateEnum("AIM_action", "AIM_speed", "AIM_dots", "AIM_implementationtext", "AIM_pos", "AIM_look", "AIM_velunit", "AIM_velcomponent", "AIM_up", "AIM_anchor", "AIM_stopplane", "AIM_anchordist", "AIM_arc", "AIM_notvisualtext", "AIM_testcase", "AIM_construction")

local slingshot_dist_by_dot = nil
local slingshot_accelmult_by_dot = nil
local slingshot_distmult_by_speed = nil
local underswing_dist_by_speed = nil
local tossdownup_radius_by_speed = nil
local tossdownup_releaseangle_by_dot = nil

--local tossup_radius_by_speed = nil
--local tossup_releaseangle_by_dot = nil

local tossup_dist_by_dot = nil
local tossup_distmult_by_speed = nil
local tossup_releaseangle_by_dot = nil


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
        this.Aim_Swing_Slingshot(position, look_dir, speed_look, false, o, vars, const)
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
        this.Aim_Swing_Slingshot(position, look_dir, speed_look, false, o, vars, const)
        do return end
    end

    this.Draw_Not180(look_horz_unit, position, vel_horz_unit, DOT_HORZ_MIN, 0, -2.2, 0)

    if dot_vertical < DOT_UNDERSWING_MIN then
        -- Going nearly straight down
        -- If there is enough velocity, do an underswing and toss them to the end point
        if this.Aim_Swing_Toss_DownUp(position, look_dir, o, vars, const) then
            debug_render_screen.Add_Text2D(nil, nil, "down - tossing up", debug_categories.AIM_action)
        else
            -- There's not enough velocity, revert to straight line
            debug_render_screen.Add_Text2D(nil, nil, "down - couldn't toss up", debug_categories.AIM_action)
            this.Aim_Swing_Slingshot(position, look_dir, speed_look, false, o, vars, const)
        end
        do return end
    end

    this.Draw_CantTossDownUp(look_horz_unit, position, vel_unit, DOT_UNDERSWING_MIN, 2.2, -2.2, 0)

    if dot_vertical > DOT_TOSS_MAX then
        -- Going above 45 degrees
        -- An overswing might be able to be used, but that would feel unnatural.  Just do a straight line
        debug_render_screen.Add_Text2D(nil, nil, "over 45 degrees", debug_categories.AIM_action)
        this.Aim_Swing_Slingshot(position, look_dir, speed_look, false, o, vars, const)
        do return end
    end

    this.Draw_CantOver45(look_horz_unit, position, vel_unit, DOT_TOSS_MAX, -2.2, -2.2, 0)

    if dot_vertical < DOT_UNDERSWING_MAX then
        -- Standard web swing, this should be most cases
        if this.Aim_Swing_UnderSwing(position, look_dir, speed_look, vel_unit, o, vars, const) then
            debug_render_screen.Add_Text2D(nil, nil, "underswing", debug_categories.AIM_action)
        else
            debug_render_screen.Add_Text2D(nil, nil, "couldn't underswing", debug_categories.AIM_action)
            this.Aim_Swing_Slingshot(position, look_dir, speed_look, false, o, vars, const)
        end
        do return end
    end

    this.Draw_CantUnderSwing(look_horz_unit, position, vel_unit, DOT_UNDERSWING_MAX, 0, -2.2, 2.2)

    -- If there's enough velocity, do a mini underswing and toss them to the end point
    if this.Aim_Swing_Toss_Up(position, look_dir, speed_look, o, vars, const) then
        debug_render_screen.Add_Text2D(nil, nil, "toss up", debug_categories.AIM_action)
        do return end
    end

    -- Nothing else worked, default to straight line
    debug_render_screen.Add_Text2D(nil, nil, "default", debug_categories.AIM_action)
    this.Aim_Swing_Slingshot(position, look_dir, speed_look, false, o, vars, const)
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
    debug_render_screen.DefineCategory(debug_categories.AIM_implementationtext, "BB596E3D", "FFF", nil, nil, nil, 0.25, 0.75)

    debug_render_screen.DefineCategory(debug_categories.AIM_pos, "CCC")
    debug_render_screen.DefineCategory(debug_categories.AIM_look, nil, "FFEBEDA8")
    debug_render_screen.DefineCategory(debug_categories.AIM_velunit, nil, "FF9643E9")
    debug_render_screen.DefineCategory(debug_categories.AIM_velcomponent, nil, "9E9160C2")
    debug_render_screen.DefineCategory(debug_categories.AIM_arc, nil, "80D69A19")

    debug_render_screen.DefineCategory(debug_categories.AIM_up, nil, "FF0AC70D")

    debug_render_screen.DefineCategory(debug_categories.AIM_anchor, "FFDED716", nil, nil, 1.5, true)
    debug_render_screen.DefineCategory(debug_categories.AIM_stopplane, "40DED716", "80DED716")
    debug_render_screen.DefineCategory(debug_categories.AIM_anchordist, "94838150", "FFF8F36C")

    debug_render_screen.DefineCategory(debug_categories.AIM_notvisualtext, "BCD4BEB6", "FF702305")
    debug_render_screen.DefineCategory(debug_categories.AIM_testcase, "F00", "F00")

    debug_render_screen.DefineCategory(debug_categories.AIM_construction, "80DB56A4", "FFDB56A4")       -- these are generic minor graphics that represent calculations used to get to final answers

    set_debug_categories = true
end

function this.ShowErrorText(func_name, message)
    if not debug_render_screen.IsEnabled() then
        do return end
    end

    local x = 0.05 + (math.random() * 0.15)     -- not perfect, but should be fine in most cases and there's no need for a list
    local y = 0.2 + (math.random() * 0.6)

    debug_render_screen.Add_Text2D(x, y, func_name .. "\r\n" .. message, debug_categories.AIM_notvisualtext)
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

function this.Aim_Swing_UnderSwing(position, look_dir, speed_look, vel_unit, o, vars, const)
    local VELOCITY_OFFPLANE_MULT = -0.1
    local MIN_OUTPUT_SPEED = 3

    if not underswing_dist_by_speed then
        underswing_dist_by_speed = AnimationCurve:new()
        underswing_dist_by_speed:AddKeyValue(0, 7)
        underswing_dist_by_speed:AddKeyValue(12, 9)
        underswing_dist_by_speed:AddKeyValue(18, 20)
        underswing_dist_by_speed:AddKeyValue(24, 30)
        underswing_dist_by_speed:AddKeyValue(36, 42)
    end

    --TODO: Reduce distance if the area is cluttered
    local dest_dist = underswing_dist_by_speed:Evaluate(speed_look)
    local dest_pos = AddVectors(position, MultiplyVector(look_dir, dest_dist))

    local new_grapple = swing_grapples.GetPureRope(vars.grapple)

    -- If destination position is higher than current position, make sure there's enough velocity to get there
    if dest_pos.z > position.z then
        -- v = sqrt(2gh)
        local gravity = 16
        if new_grapple.anti_gravity then
            gravity = gravity * (1 - new_grapple.anti_gravity.antigrav_percent)
        end

        local speed_loss = math.sqrt(2 * gravity * (dest_pos.z - position.z))

        if speed_look - speed_loss < MIN_OUTPUT_SPEED then
            this.ShowErrorText("Aim_Swing_UnderSwing", "too much speed loss\r\nheight: " .. tostring(Round(dest_pos.z - position.z, 1)) .. "\r\nspeed_look: " .. tostring(Round(speed_look, 1)) .. "\r\nfinal speed: " .. tostring(Round(speed_look - speed_loss, 1)))
            return false
        end
    end

    -- Get the vertical component of the velocity
    local vert_plane_normal = CrossProduct3D(look_dir, up)
    local vel_vert_unit = GetProjectedVector_AlongPlane_Unit(o.vel, vert_plane_normal)

    -- Any point along this anchor line should make a smooth curve
    local anchor_line = CrossProduct3D(vert_plane_normal, vel_vert_unit)

    -- Take a line from midpoint of look to intersect and find an anchor point
    local mid_point = AddVectors(position, MultiplyVector(look_dir, dest_dist / 2))
    local up_to_anchor = CrossProduct3D(vert_plane_normal, look_dir)

    debug_render_screen.Add_Line(position, AddVectors(position, vel_vert_unit), debug_categories.AIM_velcomponent)
    debug_render_screen.Add_Line(position, AddVectors(position, MultiplyVector(anchor_line, 12)), debug_categories.AIM_construction)
    debug_render_screen.Add_Line(mid_point, AddVectors(mid_point, MultiplyVector(up_to_anchor, 12)), debug_categories.AIM_construction)

    local found_intersection, intersect1, intersect2 = GetClosestPoints_Line_Line(position, AddVectors(position, anchor_line), mid_point, AddVectors(mid_point, up_to_anchor))
    if not found_intersection then
        this.ShowErrorText("Aim_Swing_UnderSwing", "couln't find intersect")
        return false
    end

    local anchor_point = Vector4.new((intersect1.x + intersect2.x) / 2, (intersect1.y + intersect2.y) / 2, (intersect1.z + intersect2.z) / 2, 1)

    -- Adjust the anchor point off vert plane based on horizontal velocity
    local vel_plane_normal = GetProjectedVector_AlongVector(o.vel, vert_plane_normal)

    debug_render_screen.Add_Dot(anchor_point, debug_categories.AIM_construction)
    debug_render_screen.Add_Line(position, AddVectors(position, vel_plane_normal), debug_categories.AIM_velcomponent)

    --TODO: also multiply by radius
    -- Technically, this should be a rotation about mid_point, but the offset should be small enough that linear should be fine
    anchor_point = AddVectors(anchor_point, MultiplyVector(vel_plane_normal, VELOCITY_OFFPLANE_MULT))

    local radius = math.sqrt(GetVectorDiffLengthSqr(position, anchor_point))

    this.ShowEndPoint(anchor_point, radius, nil, nil, new_grapple, vars, o)     -- reusing this function to show the anchor and distance
    debug_render_screen.Add_Arc(anchor_point, position, dest_pos, debug_categories.AIM_arc)

    local quat = GetRotation(vel_unit, look_dir, 2)
    local dest_dir = RotateVector3D(vel_unit, quat)

    local stopplane_point, stopplane_normal = this.GetStopPlane_Straight(dest_pos, dest_dir, new_grapple.stop_plane_distance)

    this.ShowEndPoint(dest_pos, dest_dist, stopplane_point, stopplane_normal, new_grapple, vars, o)
    Transition_ToFlight_Swing(new_grapple, vars, const, o, position, anchor_point, nil, stopplane_point, stopplane_normal)

    return true
end

function this.Aim_Swing_Toss_DownUp(position, look_dir, o, vars, const)
    local VELOCITY_OFFPLANE_MULT = -0.1

    if not tossdownup_radius_by_speed then
        tossdownup_radius_by_speed = AnimationCurve:new()
        tossdownup_radius_by_speed:AddKeyValue(0, 4)
        tossdownup_radius_by_speed:AddKeyValue(12, 4.5)
        tossdownup_radius_by_speed:AddKeyValue(18, 5)
        tossdownup_radius_by_speed:AddKeyValue(30, 7)
        tossdownup_radius_by_speed:AddKeyValue(40, 9)
        tossdownup_radius_by_speed:AddKeyValue(50, 10)

        tossdownup_releaseangle_by_dot = AnimationCurve:new()
        tossdownup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(0), 90)     -- dot is against (0,0,1), rotating vector (0,0,-1)
        tossdownup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(90), 45)
        tossdownup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(180), 20)
    end

    -- Get the vertical component of the velocity
    local vert_plane_normal = CrossProduct3D(look_dir, up)
    local vel_vert = GetProjectedVector_AlongPlane(o.vel, vert_plane_normal)
    local speed_vert = GetVectorLength(vel_vert)
    local vel_vert_unit = DivideVector(vel_vert, speed_vert)

    -- mult to calcuate radius based on vertical speed
    local radius = tossdownup_radius_by_speed:Evaluate(speed_vert)

    -- Any point along this anchor line should make a smooth curve
    local anchor_line_unit = CrossProduct3D(vert_plane_normal, vel_vert_unit)

    local anchor_point = AddVectors(position, MultiplyVector(anchor_line_unit, radius))

    debug_render_screen.Add_Line(position, AddVectors(position, vel_vert_unit), debug_categories.AIM_velcomponent)
    debug_render_screen.Add_Dot(anchor_point, debug_categories.AIM_construction)

    -- release at 45 degrees
    local look_dot_up = DotProduct3D(look_dir, up)
    local release_angle = tossdownup_releaseangle_by_dot:Evaluate(look_dot_up)

    local releasedir_unit = RotateVector3D_axis_angle(Vector4.new(0, 0, -1, 1), vert_plane_normal, release_angle)
    local release_point = AddVectors(anchor_point, MultiplyVector(releasedir_unit, radius))

    local release_vel_unit = RotateVector3D_axis_angle(releasedir_unit, vert_plane_normal, 90)

    local stopplane_point, stopplane_normal = this.GetStopPlane_Straight(release_point, release_vel_unit, 0.25)

    -- Adjust the anchor point off vert plane based on horizontal velocity
    local vel_plane_normal = GetProjectedVector_AlongVector(o.vel, vert_plane_normal)

    debug_render_screen.Add_Dot(anchor_point, debug_categories.AIM_construction)
    debug_render_screen.Add_Line(position, AddVectors(position, vel_plane_normal), debug_categories.AIM_velcomponent)

    --TODO: also multiply by radius
    -- Technically, this should be a rotation about mid_point, but the offset should be small enough that linear should be fine
    anchor_point = AddVectors(anchor_point, MultiplyVector(vel_plane_normal, VELOCITY_OFFPLANE_MULT))

    this.ShowEndPoint(anchor_point, radius, nil, nil, vars.grapple, vars, o)

    local new_grapple = swing_grapples.GetPureRope(vars.grapple)

    local dist_to_release = math.sqrt(GetVectorDiffLengthSqr(release_point, position))
    this.ShowEndPoint(release_point, dist_to_release, stopplane_point, stopplane_normal, new_grapple, vars, o)


    -- that will toss the player in a reasonable way
    --TODO: calculate parabola and draw



    debug_render_screen.Add_Text2D(nil, nil, "speed vert: " .. tostring(Round(speed_vert, 1)) .. "\r\nrelease angle: " .. tostring(Round(release_angle)), debug_categories.AIM_implementationtext)

    Transition_ToFlight_Swing(new_grapple, vars, const, o, position, anchor_point, nil, stopplane_point, stopplane_normal)

    return true
end

--TODO: instead of a plain rope, make an elastic rope, and pull the anchor forward, so it accelerates and redirects up at an angle
function this.Aim_Swing_Toss_Up_ATTEMPT1(position, look_dir, o, vars, const)
    local VELOCITY_OFFPLANE_MULT = -0.1

    if not tossup_radius_by_speed then
        tossup_radius_by_speed = AnimationCurve:new()
        tossup_radius_by_speed:AddKeyValue(0, 4)
        tossup_radius_by_speed:AddKeyValue(12, 15)
        tossup_radius_by_speed:AddKeyValue(25, 22)
        tossup_radius_by_speed:AddKeyValue(50, 30)

        tossup_releaseangle_by_dot = AnimationCurve:new()
        -- tossup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(0), 60)     -- dot is against (0,0,1), rotating vector (0,0,-1)
        -- tossup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(90), 16)
        -- tossup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(180), 12)
        tossup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(0), 60)     -- dot is against (0,0,1), rotating vector (0,0,-1)
        tossup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(90), 30)
        tossup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(180), 24)
    end

    -- Get the vertical component of the velocity
    local vert_plane_normal = CrossProduct3D(look_dir, up)
    local vel_vert = GetProjectedVector_AlongPlane(o.vel, vert_plane_normal)
    local speed_vert = GetVectorLength(vel_vert)
    local vel_vert_unit = DivideVector(vel_vert, speed_vert)

    -- mult to calcuate radius based on vertical speed
    local radius = tossup_radius_by_speed:Evaluate(speed_vert)

    -- Any point along this anchor line should make a smooth curve
    local anchor_line_unit = CrossProduct3D(vert_plane_normal, vel_vert_unit)

    local anchor_point = AddVectors(position, MultiplyVector(anchor_line_unit, radius))

    debug_render_screen.Add_Line(position, AddVectors(position, vel_vert_unit), debug_categories.AIM_velcomponent)
    debug_render_screen.Add_Dot(anchor_point, debug_categories.AIM_construction)

    -- release at 45 degrees
    local look_dot_up = DotProduct3D(look_dir, up)
    local release_angle = tossup_releaseangle_by_dot:Evaluate(look_dot_up)

    local releasedir_unit = RotateVector3D_axis_angle(Vector4.new(0, 0, -1, 1), vert_plane_normal, release_angle)
    local release_point = AddVectors(anchor_point, MultiplyVector(releasedir_unit, radius))

    local release_dir_unit = RotateVector3D_axis_angle(releasedir_unit, vert_plane_normal, 90)

    local stopplane_point, stopplane_normal = this.GetStopPlane_Straight(release_point, release_dir_unit, 0.25)

    -- Adjust the anchor point off vert plane based on horizontal velocity
    local vel_plane_normal = GetProjectedVector_AlongVector(o.vel, vert_plane_normal)

    debug_render_screen.Add_Dot(anchor_point, debug_categories.AIM_construction)
    debug_render_screen.Add_Line(position, AddVectors(position, vel_plane_normal), debug_categories.AIM_velcomponent)

    --TODO: also multiply by radius
    -- Technically, this should be a rotation about mid_point, but the offset should be small enough that linear should be fine
    anchor_point = AddVectors(anchor_point, MultiplyVector(vel_plane_normal, VELOCITY_OFFPLANE_MULT))

    this.ShowEndPoint(anchor_point, radius, nil, nil, vars.grapple, vars, o)

    local new_grapple = swing_grapples.GetPureRope(vars.grapple)

    local dist_to_release = math.sqrt(GetVectorDiffLengthSqr(release_point, position))
    this.ShowEndPoint(release_point, dist_to_release, stopplane_point, stopplane_normal, new_grapple, vars, o)


    -- that will toss the player in a reasonable way
    --TODO: calculate parabola and draw



    debug_render_screen.Add_Text2D(nil, nil, "speed vert: " .. tostring(Round(speed_vert, 1)) .. "\r\nrelease angle: " .. tostring(Round(release_angle)), debug_categories.AIM_implementationtext)

    Transition_ToFlight_Swing(new_grapple, vars, const, o, position, anchor_point, nil, stopplane_point, stopplane_normal)

    return true
end

function this.Aim_Swing_Toss_Up(position, look_dir, speed_look, o, vars, const)
    local VELOCITY_OFFPLANE_MULT = -0.1

    if not tossup_dist_by_dot then
        tossup_dist_by_dot = AnimationCurve:new()
        tossup_dist_by_dot:AddKeyValue(Angle_to_Dot(0), 4)      -- look dot up
        tossup_dist_by_dot:AddKeyValue(Angle_to_Dot(45), 6)
        tossup_dist_by_dot:AddKeyValue(Angle_to_Dot(90), 12)
        tossup_dist_by_dot:AddKeyValue(Angle_to_Dot(135), 4)
        tossup_dist_by_dot:AddKeyValue(Angle_to_Dot(180), 3)

        tossup_distmult_by_speed = AnimationCurve:new()
        tossup_distmult_by_speed:AddKeyValue(0, 0.95)
        tossup_distmult_by_speed:AddKeyValue(12, 1)
        tossup_distmult_by_speed:AddKeyValue(24, 1.5)
        tossup_distmult_by_speed:AddKeyValue(36, 2)
        tossup_distmult_by_speed:AddKeyValue(48, 1)

        tossup_releaseangle_by_dot = AnimationCurve:new()
        tossup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(0), 60)     -- look dot up, rotating vector (0,0,-1)
        tossup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(90), 30)
        tossup_releaseangle_by_dot:AddKeyValue(Angle_to_Dot(180), 24)
    end

    local look_dot_up = DotProduct3D(look_dir, up)

    --TODO: Reduce distance if the area is cluttered

    local release_dist = tossup_dist_by_dot:Evaluate(look_dot_up) * tossup_distmult_by_speed:Evaluate(speed_look)

    local radius = release_dist * 0.25

    local right = CrossProduct3D(look_dir, up)
    local perp_toward_anchor = CrossProduct3D(right, look_dir)

    local anchor_pos_base = AddVectors(position, MultiplyVector(look_dir, release_dist - radius))
    local anchor_pos = AddVectors(anchor_pos_base, MultiplyVector(perp_toward_anchor, radius))

    local swing_arm_unit = MultiplyVector(perp_toward_anchor, -1)

    local release_angle = tossup_releaseangle_by_dot:Evaluate(look_dot_up)
    local releasedir_unit = RotateVector3D_axis_angle(swing_arm_unit, right, release_angle)
    local release_point = AddVectors(anchor_pos, MultiplyVector(releasedir_unit, radius))

    local release_dir_unit = RotateVector3D_axis_angle(releasedir_unit, right, 90)

    local stopplane_point, stopplane_normal = this.GetStopPlane_Straight(release_point, release_dir_unit, 0.25)

    -- Adjust the anchor point off vert plane based on horizontal velocity
    local vel_plane_normal = GetProjectedVector_AlongVector(o.vel, right)

    debug_render_screen.Add_Dot(anchor_pos, debug_categories.AIM_construction)
    debug_render_screen.Add_Line(position, AddVectors(position, vel_plane_normal), debug_categories.AIM_velcomponent)

    --TODO: also multiply by radius
    -- Technically, this should be a rotation about mid_point, but the offset should be small enough that linear should be fine
    anchor_pos = AddVectors(anchor_pos, MultiplyVector(vel_plane_normal, VELOCITY_OFFPLANE_MULT))

    this.ShowEndPoint(anchor_pos, math.sqrt(GetVectorDiffLengthSqr(position, anchor_pos)), nil, nil, vars.grapple, vars, o)

    local new_grapple = swing_grapples.GetElasticRope(vars.grapple, radius, 1, 1)

    this.ShowEndPoint(release_point, math.sqrt(GetVectorDiffLengthSqr(position, release_point)), stopplane_point, stopplane_normal, new_grapple, vars, o)

    debug_render_screen.Add_Text2D(nil, nil, "look_dot_up: " .. tostring(Round(look_dot_up, 1)) .. "\r\nspeed_look: " .. tostring(Round(speed_look, 1)), debug_categories.AIM_implementationtext)

    Transition_ToFlight_Swing(new_grapple, vars, const, o, position, anchor_pos, nil, stopplane_point, stopplane_normal)
    return true
end

function this.Aim_Swing_Slingshot(position, look_dir, speed_look, is_airborne, o, vars, const)
    if not slingshot_dist_by_dot then
        slingshot_dist_by_dot = AnimationCurve:new()
        slingshot_dist_by_dot:AddKeyValue(Angle_to_Dot(0), 4)
        slingshot_dist_by_dot:AddKeyValue(Angle_to_Dot(45), 6)
        slingshot_dist_by_dot:AddKeyValue(Angle_to_Dot(90), 12)
        slingshot_dist_by_dot:AddKeyValue(Angle_to_Dot(135), 4)
        slingshot_dist_by_dot:AddKeyValue(Angle_to_Dot(180), 3)

        slingshot_accelmult_by_dot = AnimationCurve:new()
        slingshot_accelmult_by_dot:AddKeyValue(Angle_to_Dot(0), 0.95)
        slingshot_accelmult_by_dot:AddKeyValue(Angle_to_Dot(90), 1)
        slingshot_accelmult_by_dot:AddKeyValue(Angle_to_Dot(135), 1.5)
        slingshot_accelmult_by_dot:AddKeyValue(Angle_to_Dot(180), 2)

        slingshot_distmult_by_speed = AnimationCurve:new()
        slingshot_distmult_by_speed:AddKeyValue(0, 0.95)
        slingshot_distmult_by_speed:AddKeyValue(12, 1)
        slingshot_distmult_by_speed:AddKeyValue(24, 1.5)
        slingshot_distmult_by_speed:AddKeyValue(36, 2)
        slingshot_distmult_by_speed:AddKeyValue(48, 1)
    end

    local look_dot_up = DotProduct3D(look_dir, up)

    --TODO: Reduce distance if the area is cluttered

    local anchor_dist = slingshot_dist_by_dot:Evaluate(look_dot_up) * slingshot_distmult_by_speed:Evaluate(speed_look)

    local anchor_pos = AddVectors(position, MultiplyVector(look_dir, anchor_dist))

    local hit = o:RayCast(position, anchor_pos)
    if hit then
        -- Not clear, set anchor point at hit
        anchor_pos = hit
    end

    local accel_mult = slingshot_accelmult_by_dot:Evaluate(look_dot_up)

    local new_grapple = swing_grapples.GetElasticStraight(vars.grapple, position, anchor_pos, accel_mult)

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



    if vars == nil then
        print("vars is nil")
    elseif vars.grapple == nil then
        print("vars.grapple is nill")
    end


    --TODO: grapple is sometimes nil
    -- [2023-03-03 09:36:46 UTC-06:00] [20648] ...aks\mods\grappling_hook\processing\aimswing_grapples.lua:84: attempt to index local 'grapple' (a nil value)
    -- stack traceback:
    --     ...aks\mods\grappling_hook\processing\aimswing_grapples.lua:84: in function 'GetElasticStraight2'
    --     ...tweaks\mods\grappling_hook\processing\processing_aim.lua:577: in function 'Aim_Swing_FromGround_DoIt'
    --     ...tweaks\mods\grappling_hook\processing\processing_aim.lua:559: in function 'Aim_Swing_FromGround'
    --     ...tweaks\mods\grappling_hook\processing\processing_aim.lua:230: in function 'Aim_Swing'
    --     ...tweaks\mods\grappling_hook\processing\processing_aim.lua:39: in function 'Process_Aim'
    --     init.lua:387: in function <init.lua:338>
    local new_grapple = swing_grapples.GetElasticStraight(vars.grapple, position, anchor_pos)




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

-------------------------------- Draw Swing Conditions --------------------------------

function this.Draw_Not180(look_horz_unit, position, vel_horz_unit, DOT_HORZ_MIN, offset_x, offset_y, offset_z)
    if not debug_render_screen.IsEnabled() then
        do return end
    end

    local right_unit = CrossProduct3D(look_horz_unit, up)

    position = AddVectors(position, MultiplyVector(right_unit, offset_x))
    position = AddVectors(position, MultiplyVector(look_horz_unit, offset_y))
    position = AddVectors(position, MultiplyVector(up, offset_z))

    debug_render_screen.Add_Dot(position, debug_categories.AIM_pos)
    debug_render_screen.Add_Line(position, AddVectors(position, look_horz_unit), debug_categories.AIM_look)
    debug_render_screen.Add_Line(position, AddVectors(position, vel_horz_unit), debug_categories.AIM_velunit)

    local radians = Dot_to_Radians(DOT_HORZ_MIN)
    local dir_neg = RotateVector3D(vel_horz_unit, Quaternion_FromAxisRadians(up, -radians))
    debug_render_screen.Add_Line(position, AddVectors(position, dir_neg), debug_categories.AIM_testcase)

    local dir_pos = RotateVector3D(vel_horz_unit, Quaternion_FromAxisRadians(up, radians))
    debug_render_screen.Add_Line(position, AddVectors(position, dir_pos), debug_categories.AIM_testcase)

    debug_render_screen.Add_Text(Vector4.new(position.x, position.y, position.z - 0.25), "Not 180", debug_categories.AIM_notvisualtext)
end

function this.Draw_CantTossDownUp(look_horz_unit, position, vel_unit, DOT_UNDERSWING_MIN, offset_x, offset_y, offset_z)
    if not debug_render_screen.IsEnabled() then
        do return end
    end

    local right_unit = CrossProduct3D(look_horz_unit, up)

    position = AddVectors(position, MultiplyVector(right_unit, offset_x))
    position = AddVectors(position, MultiplyVector(look_horz_unit, offset_y))
    position = AddVectors(position, MultiplyVector(up, offset_z))

    debug_render_screen.Add_Dot(position, debug_categories.AIM_pos)
    debug_render_screen.Add_Line(position, AddVectors(position, vel_unit), debug_categories.AIM_velunit)

    local radians = Dot_to_Radians(DOT_UNDERSWING_MIN)
    local orth = CrossProduct3D(up, vel_unit)
    local direction = RotateVector3D(up, Quaternion_FromAxisRadians(orth, radians))
    debug_render_screen.Add_Line(position, AddVectors(position, direction), debug_categories.AIM_testcase)

    debug_render_screen.Add_Text(Vector4.new(position.x, position.y, position.z + 0.25), "Can't Toss DownUp", debug_categories.AIM_notvisualtext)
end

function this.Draw_CantOver45(look_horz_unit, position, vel_unit, DOT_TOSS_MAX, offset_x, offset_y, offset_z)
    if not debug_render_screen.IsEnabled() then
        do return end
    end

    local right_unit = CrossProduct3D(look_horz_unit, up)

    position = AddVectors(position, MultiplyVector(right_unit, offset_x))
    position = AddVectors(position, MultiplyVector(look_horz_unit, offset_y))
    position = AddVectors(position, MultiplyVector(up, offset_z))

    debug_render_screen.Add_Dot(position, debug_categories.AIM_pos)
    debug_render_screen.Add_Line(position, AddVectors(position, vel_unit), debug_categories.AIM_velunit)

    local radians = Dot_to_Radians(DOT_TOSS_MAX)
    local orth = CrossProduct3D(up, vel_unit)
    local direction = RotateVector3D(up, Quaternion_FromAxisRadians(orth, radians))
    debug_render_screen.Add_Line(position, AddVectors(position, direction), debug_categories.AIM_testcase)

    debug_render_screen.Add_Text(Vector4.new(position.x, position.y, position.z - 0.25), "Can't Over 45 Launch", debug_categories.AIM_notvisualtext)
end

function this.Draw_CantUnderSwing(look_horz_unit, position, vel_unit, DOT_UNDERSWING_MAX, offset_x, offset_y, offset_z)
    if not debug_render_screen.IsEnabled() then
        do return end
    end

    local right_unit = CrossProduct3D(look_horz_unit, up)

    position = AddVectors(position, MultiplyVector(right_unit, offset_x))
    position = AddVectors(position, MultiplyVector(look_horz_unit, offset_y))
    position = AddVectors(position, MultiplyVector(up, offset_z))

    debug_render_screen.Add_Dot(position, debug_categories.AIM_pos)
    debug_render_screen.Add_Line(position, AddVectors(position, vel_unit), debug_categories.AIM_velunit)

    local radians = Dot_to_Radians(DOT_UNDERSWING_MAX)
    local orth = CrossProduct3D(up, vel_unit)
    local direction = RotateVector3D(up, Quaternion_FromAxisRadians(orth, radians))
    debug_render_screen.Add_Line(position, AddVectors(position, direction), debug_categories.AIM_testcase)

    debug_render_screen.Add_Text(Vector4.new(position.x, position.y, position.z + 0.25), "Can't Under Swing", debug_categories.AIM_notvisualtext)
end