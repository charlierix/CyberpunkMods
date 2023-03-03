local aimswing_grapples = {}

local this = {}

local up = nil

function aimswing_grapples.GetElasticStraight(grapple, from_pos, to_pos)
    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    local direction = SubtractVectors(to_pos, from_pos)
    local length = GetVectorLength(direction)
    local direction_unit = MultiplyVector(direction, 1 / length)

    local antigrav_percent = this.GetStaightAntigravPercent(direction_unit)

    --TODO: adjust accel, max speed, deadpot based on distance to travel

    return
    {
        name = grapple.name,
        description = grapple.description,

        mappin_name = grapple.mappin_name,


        --TODO: Add a stop condition:
        --  when inside anchor deadspot:
        --      if dot(dir_to_anchor, vel) > N then stop

        minDot = 0.3,
        stop_on_wallHit = true,

        anti_gravity =
        {
            antigrav_percent = antigrav_percent,     --TODO: antigrav % needs to depend on how much they are looking up (100% at horz, N% at vertical)
            fade_duration = 1,
        },

        desired_length = 0,     -- pull all the way to the anchor

        accel_alongGrappleLine =
        {
            accel = 50,
            speed = 36,
            deadSpot_distance = 12,
            deadSpot_speed = 1,
        },
        accel_alongLook = nil,

        springAccel_k = nil,

        velocity_away = nil,

        aim_swing = grapple.aim_swing,

        fallDamageReduction_percent = 0,
    }
end
function aimswing_grapples.GetElasticStraight2(grapple, from_pos, to_pos, accel_mult, speed_mult)
    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    local direction = SubtractVectors(to_pos, from_pos)
    local length = GetVectorLength(direction)
    local direction_unit = MultiplyVector(direction, 1 / length)

    local antigrav_percent = this.GetStaightAntigravPercent(direction_unit)

    if not accel_mult then
        accel_mult = 1
    end

    if not speed_mult then
        speed_mult = 1
    end

    --TODO: adjust accel, max speed, deadpot based on distance to travel

    return
    {
        name = grapple.name,
        description = grapple.description,

        mappin_name = grapple.mappin_name,

        stop_on_wallHit = true,
        stop_plane_distance = 0.25,

        anti_gravity =
        {
            antigrav_percent = antigrav_percent,     --TODO: antigrav % needs to depend on how much they are looking up (100% at horz, N% at vertical)
            fade_duration = 1,
        },

        desired_length = 0,     -- pull all the way to the anchor

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




    
end

function aimswing_grapples.GetElasticRope(grapple)
end

function this.GetStaightAntigravPercent(direction_unit)
    local dot = DotProduct3D(direction_unit, up)

    if dot < 0 then
        return 1
    elseif dot > 0.45 then
        return 0
    else
        return GetScaledValue(1, 0, 0, 0.45, dot)
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