local this = {}

local up = nil      -- can't use vector4 before init
local MAX_UPADJUSTED_DOT = 0.8      -- the max allowed tilt from straight up

function Process_Jump_Rebound_Calculate(o, player, vars, const, debug)
    o:GetCamera()
    if not o.lookdir_forward then       -- shouldn't happen
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    local log = DebugRenderLogger:new(true)
    log:DefineCategory("player", "99A")
    log:DefineCategory("hit", "A99")
    log:DefineCategory("up", "6DB054")
    log:DefineCategory("adjust", "914C72")

    local up_adjusted, normal_horz, look_horz, up_dot, horz_dot = this.GetLookDirections(vars.normal, o.lookdir_forward, vars.hangPos, o.pos, log)

    log:WriteLine_Global("up_dot: " .. tostring(up_dot))
    log:WriteLine_Global("horz_dot: " .. tostring(horz_dot))

    local impulse_x = 0
    local impulse_y = 0
    local impulse_z = 0

    --NOTE: there is the possibility of a blend between straight up and horizontal jumping
    local straightup_percent = Clamp(0, 1, player.rebound.straightup_vert_percent:Evaluate(up_dot))

    log:WriteLine_Global("straightup_percent A: " .. tostring(straightup_percent))

    local percent_horz = 1
    if straightup_percent > 0 then
        local percent_vert = Clamp(0, 1, player.rebound.percent_vert_whenup:Evaluate(horz_dot))
        percent_horz = Clamp(0, 1, player.rebound.percent_horz_whenup:Evaluate(horz_dot))

        straightup_percent = straightup_percent * percent_vert

        log:WriteLine_Global("percent_vert: " .. tostring(percent_vert))
        log:WriteLine_Global("straightup_percent B: " .. tostring(straightup_percent))

        -- this is the desired.  compare with current speed to see how much to apply, possibility play a fail sound
        if straightup_percent > 0 then
            local is_fail, vert_x, vert_y, vert_z = this.GetImpulse_StraightUp(straightup_percent, up_adjusted, o.vel, player.rebound.straightup_strength, player.rebound.straightup_percent_at_speed, log)

            if is_fail then
                log:WriteLine_Global("playing fail sound")
                PlaySound_FailJump(vars, o)
            else
                log:WriteLine_Global("adding straight up impulse")
                impulse_x = impulse_x + vert_x
                impulse_y = impulse_y + vert_y
                impulse_z = impulse_z + vert_z
            end
        end
    end

    log:WriteLine_Global("percent_horz: " .. tostring(percent_horz))

    if percent_horz > 0 then
        local horz_x, horz_y, horz_z, yaw_turn_percent = this.GetImpulse_Horizontal(look_horz, horz_dot, normal_horz, player.rebound)

        -- impulse_x = impulse_x + horz_x
        -- impulse_y = impulse_y + horz_y
        -- impulse_z = impulse_z + horz_z
    end

    log:WriteLine_Global("impulse: " .. tostring(impulse_x) .. ", " .. tostring(impulse_y) .. ", " .. tostring(impulse_z))


    log:Save("rebound")

    if IsNearZero(impulse_x) and IsNearZero(impulse_y) and IsNearZero(impulse_z) then
        Transition_ToStandard(vars, const, debug, o)
    else
        --TODO: may need to teleturn
        local impulse = Vector4.new(impulse_x, impulse_y, impulse_z, 1)
        Transition_ToJump_Impulse(vars, const, debug, o, impulse, false)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetLookDirections(normal, lookdir, hangPos, player_pos, log)
    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    log:Add_Dot(player_pos, "player")
    log:Add_Line(player_pos, AddVectors(player_pos, lookdir), "player")
    log:Add_Line(player_pos, AddVectors(player_pos, up), "up")

    log:Add_Dot(hangPos, "hit")
    log:Add_Line(hangPos, AddVectors(hangPos, normal), "hit")

    local adjusted_up = this.GetAdjustedUp(normal)
    local normal_horz = this.GetHorizontalNormal(normal, lookdir, hangPos, player_pos)
    local look_horz = GetProjectedVector_AlongPlane_Unit(lookdir, up)

    log:Add_Line(player_pos, AddVectors(player_pos, adjusted_up), "adjust")
    log:Add_Line(player_pos, AddVectors(player_pos, look_horz), "adjust")
    log:Add_Line(hangPos, AddVectors(hangPos, normal_horz), "adjust")

    local up_dot = DotProduct3D(lookdir, adjusted_up)

    local horz_dot = DotProduct3D(look_horz, normal_horz)

    return adjusted_up, normal_horz, look_horz, up_dot, horz_dot
end

function this.GetAdjustedUp(normal)
    if IsNearZero(DotProduct3D(normal, up)) then
        -- The plane they are jumping off of is horizontal
        return up
    end

    --NOTE: This would allow jumping backward if they are facing away from the wall, but other logic only jumps straight up
    --when mostly looking toward the wall
    local retVal = GetProjectedVector_AlongPlane_Unit(up, normal)

    local dot_adjusted = DotProduct3D(up, retVal)
    if dot_adjusted < MAX_UPADJUSTED_DOT then
        retVal = RotateVector3D_axis_radian(up, CrossProduct3D(up, retVal), Dot_to_Radians(MAX_UPADJUSTED_DOT))
    end

    return retVal
end

function this.GetHorizontalNormal(normal, lookdir, hangPos, player_pos)
    if IsNearValue(math.abs(DotProduct3D(normal, up)), 1) then
        -- The normal is straight up or down (horizontal plate)
        local retVal = GetProjectedVector_AlongPlane_Unit(SubtractVectors(player_pos, hangPos), up)
        if IsNearZero_vec4(retVal) then
            -- They are also directly above/below the point
            retVal = GetProjectedVector_AlongPlane_Unit(Negate(lookdir), up)
        end

        return retVal
    end

    return GetProjectedVector_AlongPlane_Unit(normal, up)
end

function this.GetImpulse_StraightUp(percent, up_adjusted, velocity, jump_strength, percent_at_speed, log)
    local vel_along = GetProjectedVector_AlongVector(velocity, up_adjusted, false)

    local speed_along = math.sqrt(GetVectorLengthSqr(vel_along))
    log:WriteLine_Global("vertical speed along: " .. tostring(speed_along))

    local percent_speed = Clamp(0, 1, percent_at_speed:Evaluate(speed_along))
    if IsNearZero(percent_speed) then
        return true, 0, 0, 0
    end

    percent = percent * percent_speed

    return
        false,
        up_adjusted.x * jump_strength * percent,
        up_adjusted.y * jump_strength * percent,
        up_adjusted.z * jump_strength * percent
end

function this.GetImpulse_Horizontal(look, dot, wall_normal, rebound)
    local percent_up = Clamp(0, 1, rebound.horz_percent_up:Evaluate(dot))
    local percent_along = Clamp(0, 1, rebound.horz_percent_along:Evaluate(dot))
    local percent_away = Clamp(0, 1, rebound.horz_percent_away:Evaluate(dot))
    local strength = Clamp(0, 1, rebound.horz_strength:Evaluate(dot))
    local yaw_turn_percent = Clamp(0, 1, rebound.yaw_turn_percent:Evaluate(dot))

    --TODO: take in horizontal component of look direction

    
end