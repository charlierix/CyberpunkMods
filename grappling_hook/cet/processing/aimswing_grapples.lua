local aimswing_grapples = {}

local this = {}

local up = nil

function aimswing_grapples.GetElasticStraight(grapple, from_pos, to_pos, accel_mult, speed_mult, should_latch)
    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    if not accel_mult then
        accel_mult = 1
    end

    if not speed_mult then
        speed_mult = 1
    end

    local direction = SubtractVectors(to_pos, from_pos)
    local length = GetVectorLength(direction)
    local direction_unit = MultiplyVector(direction, 1 / length)

    local antigrav_percent = this.GetStaightAntigravPercent(direction_unit, accel_mult)

    local stop_on_wallHit = nil
    local stop_plane_distance = nil
    if should_latch then
        stop_on_wallHit = false
    else
        stop_on_wallHit = true
        stop_plane_distance = 0.25
    end

    return
    {
        name = grapple.name,
        description = grapple.description,

        mappin_name = grapple.mappin_name,

        stop_on_wallHit = stop_on_wallHit,
        stop_plane_distance = stop_plane_distance,

        anti_gravity =
        {
            antigrav_percent = antigrav_percent,
            fade_duration = 1,
        },

        desired_length = 0,

        accel_alongGrappleLine =
        {
            accel = 50 * accel_mult,
            speed = 72 * speed_mult,
        },
        accel_alongLook = nil,

        springAccel_k = nil,

        velocity_away = nil,

        aim_swing = grapple.aim_swing,

        fallDamageReduction_percent = 0,
    }
end

function aimswing_grapples.GetPureRope(grapple)
    return
    {
        name = grapple.name,
        description = grapple.description,

        mappin_name = grapple.mappin_name,

        stop_on_wallHit = true,
        stop_plane_distance = 0.25,

        anti_gravity = nil,

        desired_length = nil,

        accel_alongGrappleLine =        -- Some of the acceleration needs to be this.  Otherwise it gets jerky when only drag is applied
        {
            accel = 24,
            speed = 8,
        },
        accel_alongLook = nil,

        springAccel_k = nil,

        velocity_away =
        {
            accel_tension = 144,        -- using a big tension so it feels like rope
            deadSpot = 0.75
        },

        aim_swing = grapple.aim_swing,

        fallDamageReduction_percent = 0,
    }
end

function aimswing_grapples.GetElasticRope(grapple, desired_length, accel_mult, speed_mult)
    -- local point_on_line = GetClosestPoint_Line_Point(from_pos, SubtractVectors(to_pos, from_pos), anchor_pos)
    -- local desired_length = math.sqrt(GetVectorDiffLengthSqr(anchor_pos, point_on_line))

    return
    {
        name = grapple.name,
        description = grapple.description,

        mappin_name = grapple.mappin_name,

        stop_on_wallHit = true,
        stop_plane_distance = 0.25,

        anti_gravity =
        {
            antigrav_percent = 0.33,
            fade_duration = 1,
        },

        desired_length = desired_length,        -- pull until it hits this length, then be a rope

        accel_alongGrappleLine =
        {
            accel = 30 * accel_mult,
            speed = 60 * speed_mult,
        },
        accel_alongLook = nil,

        springAccel_k = nil,

        velocity_away =
        {
            accel_tension = 84,        -- using a fairly large tension so the rope part will act like a sling and not be too weak
            deadSpot = 0.75
        },

        aim_swing = grapple.aim_swing,

        fallDamageReduction_percent = 0,
    }
end

-- This replaces the grapple with a small rope when they hit a wall
function aimswing_grapples.GetLatchRope(grapple)
    return
    {
        name = grapple.name,
        description = grapple.description,

        mappin_name = grapple.mappin_name,

        stop_on_wallHit = false,

        anti_gravity =
        {
            antigrav_percent = 0.9,
        },

        desired_length = 0.8,

        accel_alongGrappleLine =        -- Some of the acceleration needs to be this.  Otherwise it gets jerky when only drag is applied
        {
            accel = 3,
            speed = 0.5,
            deadSpot_distance = 1,
        },
        accel_alongLook = nil,

        springAccel_k = nil,

        velocity_away =
        {
            accel_compression = 36,
            accel_tension = 72,
            deadSpot = 0.5,
        },

        aim_swing = grapple.aim_swing,

        fallDamageReduction_percent = 0,
    }
end

---@param direction_unit Vector4 direction that the straight line grapple is travelling
---@return number percent from 0 to 1 (1 would be 100% antigrav)
function this.GetStaightAntigravPercent(direction_unit, accel_mult)
    local dot = DotProduct3D(direction_unit, up)

    local min_antigrav = 0
    if accel_mult < 1 then
        min_antigrav = GetScaledValue(1, 0, 0, 1, accel_mult)
    end

    if dot < 0 then
        return 1
    elseif dot > 0.45 then
        return min_antigrav
    else
        return GetScaledValue(1, min_antigrav, 0, 0.45, dot)
    end
end

function this.NOTES()
    -- The current design has the grapple class defined and modified by the config

    -- Process_Standard calls flight util which tries all the non null grapples.  If one is activated,
    -- it calls Transition_ToAim, passing in that grapple (stored in vars.grapple)

    -- Aim then processes and if successful, transitions to processing the grapple

    -- This works fine for grapple straight, since all the settings are static.  But swing needs to have
    -- situation dependent grapple settings (slingshot, rope, elastic swing, etc)

    -- So this class has helper methods to generate an instance of Grapple that is passed on to
    -- Process_Flight_Swing

    -- In the future, it might be better to have a Grapple_Straight and Grapple_Swing class and another
    -- Grapple class

    -- Grapple_Straight
    --  Name, XP, etc
    --  Grapple (only settings necessary for Process_Flight_Straight)
    --  Aim_Straight

    -- Grapple_Swing
    --  Name, XP, etc
    --  Grapple[] (only settings necessary for Process_Flight_Swing)
    --  Aim_Swing
end

return aimswing_grapples