local this = {}

local up = nil      -- can't use vector4 before init
local MAX_UPADJUSTED_DOT = 0.8      -- the max allowed tilt from straight up

function Process_Jump_Rebound_Calculate(o, player, vars, const, debug)
    o:GetCamera()
    if not o.lookdir_forward then       -- shouldn't happen
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    local up_adjusted, normal_horz, look_horz, up_dot, horz_dot = this.GetLookDirections(vars.normal, o.lookdir_forward, vars.hangPos, o.pos)

    local impulse_x = 0
    local impulse_y = 0
    local impulse_z = 0

    -- Special logic for jumping straight up when facing the wall and looking up
    local percent_horz, play_fail_sound1, vert_x, vert_y, vert_z = this.GetImpulse_Vertical(o, player, up_dot, horz_dot, up_adjusted)
    impulse_x = impulse_x + vert_x
    impulse_y = impulse_y + vert_y
    impulse_z = impulse_z + vert_z

    local play_fail_sound2 = false
    if percent_horz > 0 then
        -- Standard jump logic (the term horizontal is just to differentiate from straight up)
        local horz_x, horz_y, horz_z, yaw_turn_percent, play_fail_sound3 = this.GetImpulse_Horizontal(o.lookdir_forward, look_horz, horz_dot, normal_horz, player.rebound, o.vel)

        impulse_x = impulse_x + (horz_x * percent_horz)
        impulse_y = impulse_y + (horz_y * percent_horz)
        impulse_z = impulse_z + (horz_z * percent_horz)

        play_fail_sound2 = play_fail_sound3
    end

    if play_fail_sound1 or play_fail_sound2 then
        PlaySound_FailJump(vars, o)
    end

    --TODO: implement this.  It would be a call to Transition_ToJump_TeleTurn instead of straight to Transition_ToJump_Impulse
    --would also need to figure out the direction
    --if yaw_turn_percent > 0

    if IsNearZero(impulse_x) and IsNearZero(impulse_y) and IsNearZero(impulse_z) then
        Transition_ToStandard(vars, const, debug, o)
    else
        local impulse = Vector4.new(impulse_x, impulse_y, impulse_z, 1)
        Transition_ToJump_Impulse(vars, const, debug, o, impulse, false)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetLookDirections(normal, lookdir, hangPos, player_pos)
    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    local adjusted_up = this.GetAdjustedUp(normal)
    local normal_horz = this.GetHorizontalNormal(normal, lookdir, hangPos, player_pos)
    local look_horz = GetProjectedVector_AlongPlane_Unit(lookdir, up)

    local up_dot = DotProduct3D(lookdir, adjusted_up)

    local horz_dot = DotProduct3D(look_horz, normal_horz)

    return adjusted_up, normal_horz, look_horz, up_dot, horz_dot
end

function this.GetImpulse_Vertical(o, player, up_dot, horz_dot, up_adjusted)
    --NOTE: there is the possibility of a blend between straight up and horizontal jumping
    local straightup_percent = Clamp(0, 1, player.rebound.straightup_vert_percent:Evaluate(up_dot))

    if IsNearZero(straightup_percent) then
        return 1, false, 0, 0, 0
    end

    local percent_vert = Clamp(0, 1, player.rebound.percent_vert_whenup:Evaluate(horz_dot))
    local percent_horz = Clamp(0, 1, player.rebound.percent_horz_whenup:Evaluate(horz_dot))

    straightup_percent = straightup_percent * percent_vert

    if IsNearZero(straightup_percent) then
        return percent_horz, false, 0, 0, 0
    end

    local percent_speed = this.GetSpeedAdjustedPercent(o.vel, up_adjusted, player.rebound.straightup_percent_at_speed)
    if IsNearZero(percent_speed) then
        return percent_horz, true, 0, 0, 0      -- playing the fail sound because of over speed
    end

    return
        percent_horz,
        false,
        up_adjusted.x * player.rebound.straightup_strength * straightup_percent * percent_speed,
        up_adjusted.y * player.rebound.straightup_strength * straightup_percent * percent_speed,
        up_adjusted.z * player.rebound.straightup_strength * straightup_percent * percent_speed
end

function this.GetImpulse_Horizontal(look, look_horz, horz_dot, wall_normal_horz, rebound, velocity)
    local percent_up = Clamp(0, 1, rebound.horz_percent_up:Evaluate(horz_dot))
    local percent_along = Clamp(0, 1, rebound.horz_percent_along:Evaluate(horz_dot))
    local percent_away = Clamp(0, 1, rebound.horz_percent_away:Evaluate(horz_dot))
    local strength = rebound.horz_strength:Evaluate(horz_dot)
    local yaw_turn_percent = Clamp(0, 1, rebound.yaw_turn_percent:Evaluate(horz_dot))
    local percent_look = Clamp(0, 1, rebound.horizontal_percent_look:Evaluate(horz_dot))

    -- along and away are in the horizontal plane, so must be treated like vectors (only need the x and y)
    local look_away_comp = GetProjectedVector_AlongVector(look, wall_normal_horz, false)
    local away_unit = ToUnit(AddVectors(wall_normal_horz, MultiplyVector(look_away_comp, percent_look)))

    local wall_along_horz = CrossProduct3D(up, wall_normal_horz)
    if DotProduct3D(wall_along_horz, look_horz) < 0 then
        wall_along_horz = Negate(wall_along_horz)
    end

    local look_along_comp = GetProjectedVector_AlongVector(look, wall_normal_horz, true)
    local along_unit = ToUnit(AddVectors(wall_along_horz, MultiplyVector(look_along_comp, percent_look)))

    --local horz_x, horz_y, horz_z = this.CombineHorizontal1(away_unit, along_unit, look, percent_away, percent_along, percent_up, percent_look)
    local horz_x, horz_y, horz_z = this.CombineHorizontal2(away_unit, along_unit, look, percent_away, percent_along, percent_up, percent_look)

    local percent_speed = this.GetSpeedAdjustedPercent(velocity, ToUnit(Vector4.new(horz_x, horz_y, horz_z, 1)), rebound.horizontal_percent_at_speed)

    return
        horz_x * strength * percent_speed,
        horz_y * strength * percent_speed,
        horz_z * strength * percent_speed,
        yaw_turn_percent,
        false
end

function this.CombineHorizontal1(away_unit, along_unit, look, percent_away, percent_along, percent_up, percent_look)
    return
        Clamp(-1, 1, (away_unit.x * percent_away) + (along_unit.x * percent_along)),
        Clamp(-1, 1, (away_unit.y * percent_away) + (along_unit.y * percent_along)),
        Clamp(-1, 1, (up.z * percent_up) + (look.z * percent_look))
end
function this.CombineHorizontal2(away_unit, along_unit, look_unit, percent_away, percent_along, percent_up, percent_look)
    -- Scale the unit vectors based on their percent influence
    local percent_wall = 1 - percent_look

    local away_x = away_unit.x * percent_wall
    local away_y = away_unit.y * percent_wall

    local along_x = along_unit.x * percent_wall
    local along_y = along_unit.y * percent_wall

    local up_z = up.z * percent_wall

    local look_x = look_unit.x * percent_look
    local look_y = look_unit.y * percent_look
    local look_z = look_unit.z * percent_look

    return
        (away_x * percent_away) + (along_x * percent_along) + look_x,
        (away_y * percent_away) + (along_y * percent_along) + look_y,
        (up_z * percent_up) + look_z
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

function this.GetSpeedAdjustedPercent(velocity, impulse_dir_unit, percent_at_speed)
    local vel_along = GetProjectedVector_AlongVector(velocity, impulse_dir_unit, false)
    local speed_along = math.sqrt(GetVectorLengthSqr(vel_along))

    return Clamp(0, 1, percent_at_speed:Evaluate(speed_along))
end