local this = {}

local up = nil      -- can't use vector4 before init
local MAX_UPADJUSTED_DOT = 0.8      -- the max allowed tilt from straight up

function Process_Jump_Rebound_Calculate(o, player, vars, const, debug)
    o:GetCamera()
    if not o.lookdir_forward then       -- shouldn't happen
        Transition_ToStandard(vars, const, debug, o, false)
        do return end
    end

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    local up_adjusted, normal_horz, look_horz, up_dot, horz_dot = this.GetLookDirections(vars.normal, o.lookdir_forward, vars.hangPos, o.pos)

    local impulse_x = 0
    local impulse_y = 0
    local impulse_z = 0
    local yaw_turn_radians = 0

    -- Special logic for jumping straight up when facing the wall and looking up
    local percent_horz, play_fail_sound1, vert_x, vert_y, vert_z = this.GetImpulse_Vertical(o, player.rebound.has_straightup, player.rebound.straight_up, up_dot, horz_dot, up_adjusted)
    impulse_x = impulse_x + vert_x
    impulse_y = impulse_y + vert_y
    impulse_z = impulse_z + vert_z

    local play_fail_sound2 = false
    local should_relatch = false
    if percent_horz > 0 then
        -- Standard jump logic (the term horizontal is just to differentiate from straight up)
        local horz_x, horz_y, horz_z, yaw_turn_radians1, should_relatch1, play_fail_sound3 = this.GetImpulse_Horizontal(o.lookdir_forward, look_horz, horz_dot, normal_horz, player.rebound.horizontal, o.vel)

        impulse_x = impulse_x + (horz_x * percent_horz)
        impulse_y = impulse_y + (horz_y * percent_horz)
        impulse_z = impulse_z + (horz_z * percent_horz)

        yaw_turn_radians = yaw_turn_radians1 * percent_horz

        should_relatch = should_relatch1

        play_fail_sound2 = play_fail_sound3
    end

    if play_fail_sound1 or play_fail_sound2 then
        PlaySound_FailJump(vars, o)
    end

    if IsNearZero(impulse_x) and IsNearZero(impulse_y) and IsNearZero(impulse_z) then
        Transition_ToStandard(vars, const, debug, o, false)
    else
        local impulse = Jump_AvoidOverhangs(Vector4.new(impulse_x, impulse_y, impulse_z, 1), vars.hangPos, normal_horz, o)

        if IsNearZero(yaw_turn_radians) then
            Transition_ToJump_Impulse(vars, const, debug, o, impulse, false, should_relatch)
        else
            local yaw_turn_direction = this.GetYawTurnDirection(normal_horz, look_horz, yaw_turn_radians)
            Transition_ToJump_TeleTurn(vars, const, debug, o, impulse, yaw_turn_direction, should_relatch)
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetLookDirections(normal, lookdir, hangPos, player_pos)
    local adjusted_up = this.GetAdjustedUp(normal)
    local normal_horz = this.GetHorizontalNormal(normal, lookdir, hangPos, player_pos)
    local look_horz = GetProjectedVector_AlongPlane_Unit(lookdir, up)

    local up_dot = DotProduct3D(lookdir, adjusted_up)

    local horz_dot = DotProduct3D(look_horz, normal_horz)

    return adjusted_up, normal_horz, look_horz, up_dot, horz_dot
end

function this.GetImpulse_Vertical(o, has_straightup, straight_up, up_dot, horz_dot, up_adjusted)
    if not has_straightup then
        return 1, false, 0, 0, 0
    end

    --NOTE: there is the possibility of a blend between straight up and horizontal jumping
    local straightup_percent = Clamp(0, 1, straight_up.percent:Evaluate(up_dot))

    if IsNearZero(straightup_percent) then
        return 1, false, 0, 0, 0
    end

    local percent_vert = Clamp(0, 1, straight_up.percent_vert_whenup:Evaluate(horz_dot))
    local percent_horz = Clamp(0, 1, straight_up.percent_horz_whenup:Evaluate(horz_dot))

    straightup_percent = straightup_percent * percent_vert

    if IsNearZero(straightup_percent) then
        return percent_horz, false, 0, 0, 0
    end

    local percent_speed = this.GetSpeedAdjustedPercent(o.vel, up_adjusted, straight_up.percent_at_speed)
    if IsNearZero(percent_speed) then
        return percent_horz, true, 0, 0, 0      -- playing the fail sound because of over speed
    end

    return
        percent_horz,
        false,
        up_adjusted.x * straight_up.strength * straightup_percent * percent_speed,
        up_adjusted.y * straight_up.strength * straightup_percent * percent_speed,
        up_adjusted.z * straight_up.strength * straightup_percent * percent_speed
end

function this.GetImpulse_Horizontal(look, look_horz, horz_dot, wall_normal_horz, horizontal, velocity)
    local yaw_turn = horizontal.yaw_turn:Evaluate(horz_dot)
    local strength = horizontal.strength

    local preset_x, preset_y, preset_z = this.GetImpulse_Horizontal_Preset(horz_dot, look_horz, wall_normal_horz, horizontal)

    local combined_x, combined_y, combined_z = this.CombineHorizontal_Preset_Look(preset_x, preset_y, preset_z, look, horizontal, horz_dot)

    local rotated = this.GetHorizontal_Rotated(Vector4.new(combined_x, combined_y, combined_z, 1))

    local percent_speed = this.GetSpeedAdjustedPercent(velocity, ToUnit(rotated), horizontal.percent_at_speed)
    if IsNearZero(percent_speed) then
        return 0, 0, 0, 0, false, true     -- over speed, play the fail sound
    end

    return
        rotated.x * percent_speed * strength,
        rotated.y * percent_speed * strength,
        rotated.z * percent_speed * strength,
        yaw_turn,
        horizontal.percent_latch_after_jump:Evaluate(horz_dot) >= 0.5,
        false
end

-- This takes the unit vectors of wall normal, up, along wall.  It then runs the dot product between look and normal
-- through the config curve map to see how much percent of each to use
function this.GetImpulse_Horizontal_Preset(horz_dot, look_horz, wall_normal_horz, horizontal)
    local x = 0
    local y = 0

    -- Away
    local percent_away = Clamp(0, 1, horizontal.percent_away:Evaluate(horz_dot))

    x = x + wall_normal_horz.x * percent_away
    y = y + wall_normal_horz.y * percent_away

    -- Along
    local percent_along = Clamp(0, 1, horizontal.percent_along:Evaluate(horz_dot))

    local wall_along_horz = CrossProduct3D(up, wall_normal_horz)
    if DotProduct3D(wall_along_horz, look_horz) < 0 then
        wall_along_horz = Negate(wall_along_horz)
    end

    x = x + wall_along_horz.x * percent_along
    y = y + wall_along_horz.y * percent_along

    -- Up
    local z = Clamp(0, 1, horizontal.percent_up:Evaluate(horz_dot))

    return x, y, z
end

function this.CombineHorizontal_Preset_Look(preset_x, preset_y, preset_z, look, horizontal, horz_dot)
    local percent_look = Clamp(0, 1, horizontal.percent_look:Evaluate(horz_dot))
    local percent_look_strength = Clamp(0, 1, horizontal.percent_look_strength:Evaluate(horz_dot))
    local percent_preset = 1 - percent_look

    return
        (preset_x * percent_preset) + (look.x * percent_look * percent_look_strength),
        (preset_y * percent_preset) + (look.y * percent_look * percent_look_strength),
        (preset_z * percent_preset) + (look.z * percent_look * percent_look_strength)
end

-- This rotates the vector upward.  Think of the vector passed in as desired direction.  This function rotates up
-- to help counter gravity
-- NOTE: the vector passed in isn't expected to be a unit vector
function this.GetHorizontal_Rotated(vector)
    local vec_len = math.sqrt(GetVectorLengthSqr(vector))
    local direction_unit = DivideVector(vector, vec_len)

    local dot = DotProduct3D(direction_unit, up)

    -- pi       straight down
    -- pi/2     horizontal
    -- 0        straight up
    local radian = Dot_to_Radians(dot)

    --https://mycurvefit.com/
    --https://www.desmos.com/calculator

    -- Rotate up, by this angle
    --  phi is the angle they are looking
    --  result is the angle they should jump

    -- -90  -90
    --  0   45      -- when they are looking straight out, angle should be 45 for best arc
    --  90  90

    -- jumpAngle = 45 + phi - 0.005555556 * phi^2

    -- Same idea, but with radians
    --  pi      -pi/2
    --  pi/2    pi/4
    --  0       pi/2

    local adjustRadians = 1.570796 - 0.3183099 * radian ^ 2

    local axis = CrossProduct3D(direction_unit, up)

    local horizontal = ToUnit(GetProjectedVector_AlongPlane(direction_unit, up))

    local rotated = RotateVector3D(horizontal, Quaternion_FromAxisRadians(axis, adjustRadians))

    return MultiplyVector(rotated, vec_len)
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

function this.GetYawTurnDirection(normal_horz, look_horz, radians)
    local axis = CrossProduct3D(look_horz, normal_horz)
    return RotateVector3D_axis_radian(look_horz, axis, radians)
end