local this = {}
local antigrav_percents = { 0.15, 0.3, 0.4, 0.5, 0.6, 0.65, 0.7, 0.75, 0.8, 0.825, 0.85, 0.875, 0.9, 0.925, 0.95 }

function GetDefault_Player(playerID)
    return
    {
        playerID = playerID,
        name = "default",
        energy_tank = GetDefault_EnergyTank(),

        --TODO: Action Mappings

        grapple1 = GetDefault_Grapple_Pull(),
        grapple2 = GetDefault_Grapple_Rigid(),
        --grapple3 = GetDefault_WebSwing(),

        experience = 0,
    }
end

------------------------------------------------ Grapples ------------------------------------------------

function GetDefault_Grapple_Pull()
    local retVal =
    {
        name = "pull",
        description = "Pulls toward anchor point, also pulls in the look direction (modeled after titanfall2)",

        mappin_name = "AimVariant",
        minDot = 0,
        stop_on_wallHit = true,

        anti_gravity = nil,

        desired_length = 0,     -- pull all the way to the anchor

        accel_alongGrappleLine = GetDefault_ConstantAccel(24, 7),
        accel_alongLook = GetDefault_ConstantAccel(36, 9),

        springAccel_k = nil,        --TODO: Play with this

        velocity_away = nil,        -- the attractive force is strong enough that there will likely never be a velocity away.  And if there is, the force is pretty strong anyway

        energy_cost = 7,        --TODO: this should be a function of the experience cost

        aim_straight = GetDefault_AimStraight(),

        fallDamageReduction_percent = 0,
    }

    retVal.experience = this.CalculateExperience_GrappleStraight(retVal)

    return retVal
end

function GetDefault_Grapple_Rigid()
    local retVal =
    {
        name = "rigid",
        description = "Mainly used like a rope.  Also has a small compression resistance, like a weak pole vault",

        mappin_name = "TakeControlVariant",
        minDot = -0.71,     -- give this extra freedom so they can look around more while hanging/swinging
        stop_on_wallHit = false,

        anti_gravity = nil,

        desired_length = nil,       -- 6 to 12 would be a good range (start long).  The main use for this is to swing from an overhang, and if you start too far away, you'll just fall to the ground

        --accel_alongGrappleLine = nil,       --TODO: Some of the acceleration needs to be this.  Otherwise it gets jerky when only drag is applied
        accel_alongGrappleLine = GetDefault_ConstantAccel(nil, nil, 0.75),      -- still jerky
        accel_alongLook = nil,

        springAccel_k = nil,        --TODO: Play with this

        velocity_away = GetDefault_VelocityAway(nil, 60, nil),      -- using a big tension so it feels like rope

        energy_cost = 3,

        aim_straight = GetDefault_AimStraight(12),

        fallDamageReduction_percent = 0,
    }

    retVal.experience = this.CalculateExperience_GrappleStraight(retVal)

    return retVal
end

function GetDefault_Grapple_WallHanger()
    -- This should be rope used to hang from a wall

    -- mindot = nil
    -- desired length = .75
    -- moderate pull force
    -- strong anti gravity
end

function GetDefault_Grapple_AngryBird()
    -- "Launch yourself at the pigs - with guns blazing"

    -- Fairly high antigravity/fade and acceleration
    -- Short aim length

    -- This uses the grapple like a slingshot
end

function GetDefault_Grapple_HeliumFrog()
    -- "Hi Ho! Kermit the parade balloon here!"

    -- This turns the player into a blimp/balloon


    -- Very high antigravity/fade

    -- Long aim distance

    -- Very weak acceleration, low max speed
end

----------------------------------------------- Components -----------------------------------------------

function GetDefault_EnergyTank()
    local retVal =
    {
        max_energy = 12,
        max_energy_update =
        {
            min = 1,        -- there is no max
            amount = 2,
        },

        recovery_rate = 1,
        recovery_rate_update =
        {
            min = 0.1,
            --TODO: Make this non linear
            amount = 0.2,
        },

        flying_percent = 0.25,
        flying_percent_update =
        {
            min = 0,
            max = 1,
            amount = 0.05,
        },

        experience = 0,
    }

    retVal.experience =
        retVal.experience +
        CalculateExperienceCost_Value(retVal.max_energy, retVal.max_energy_update) +
        CalculateExperienceCost_Value(retVal.recovery_rate, retVal.recovery_rate_update) +
        CalculateExperienceCost_Value(retVal.flying_percent, retVal.flying_percent_update)

    return retVal
end

function GetDefault_AntiGravity(percent_override, fade_override)
    local percent = percent_override
    if not percent then
        percent = antigrav_percents[1]
    end

    local fade = fade_override
    if not fade then
        fade = 0
    end

    local retVal =
    {
        antigrav_percent = percent,
        antigrav_percent_update =
        {
            min = antigrav_percents[1],
            max = antigrav_percents[#antigrav_percents],
            getDecrementIncrement = "AntiGrav_Percent_IncDec",
        },

        fade_duration = fade,
        fade_duration_update =
        {
            min = 0,
            --max = 6,      -- no max.  If they want to dump xp into being a blimp, there's no reason to stop them
            amount = 0.333333,
        },
    }

    retVal.experience =
        1 +     -- there is a base cost of 1
        CalculateExperienceCost_Value(retVal.antigrav_percent, retVal.antigrav_percent_update) +
        CalculateExperienceCost_Value(retVal.fade_duration, retVal.fade_duration_update)

    return retVal
end

function GetDefault_AimStraight(max_override)
    local max = max_override
    if not max then
        max = 9
    end

    return
    {
        max_distance = max,
        max_distance_update =
        {
            min = 6,
            max = 120,
            amount = 1,
        },

        aim_duration = 0.333,     -- 1 seems ideal, but make them pay for it in third second intervals
        aim_duration_update =
        {
            min = 0.333,
            max = 3,
            amount = 0.333333,
        },

        mappin_name = "CustomPositionVariant",
        air_dash = nil,
    }
end

function GetDefault_AirDash()
    local retVal =
    {
        energyBurnRate = 1,

        burnReducePercent = 0,
        burnReducePercent_update =
        {
            min = 0,
            max = 0.85,
            amount = 0.05,
        },

        mappin_name = "OffVariant",
        accel =
        {
            accel = 28,     -- anything below this, and it's like the horizontal component is ignored (this is probably a flaw in the code.  projected vector maxing out and too much accel going to anti gravity.  probably need to stop applying any force when projected vector is full)
            accel_update =
            {
                min = 28,
                max = 28 + (2 * 8),
                amount = 2,
            },

            speed = 6,
            speed_update =
            {
                min = 6,
                max = 6 + (1 * 8),
                amount = 1,
            },

            deadSpot_distance = 0,
            deadSpot_speed = 1,
        },
    }

    retVal.experience =
        1 +     -- there is a base cost of 1
        CalculateExperienceCost_Value(retVal.burnReducePercent, retVal.burnReducePercent_update) +
        CalculateExperienceCost_Value(retVal.accel.accel, retVal.accel.accel_update) +
        CalculateExperienceCost_Value(retVal.accel.speed, retVal.accel.speed_update)

    return retVal
end

function GetDefault_ConstantAccel(accel_override, speed_override, deadSpot_distance_override)
    local accel_update, accel = this.GetUpdateAndValue(20, 20 + (2 * 16), 2, accel_override, false)

    local speed_update, speed = this.GetUpdateAndValue(6, 6 + (1 * 8), 1, speed_override, false)

    local deadspot_dist = deadSpot_distance_override
    if not deadspot_dist then
        deadspot_dist = 3
    end

    return
    {
        accel = accel,
        accel_update = accel_update,

        speed = speed,
        speed_update = speed_update,

        deadSpot_distance = deadspot_dist,
        deadSpot_speed = 1,

        experience =
            1 +     -- there is a base cost of 1
            CalculateExperienceCost_Value(accel, accel_update) +
            CalculateExperienceCost_Value(speed, speed_update),
    }
end

function GetDefault_VelocityAway(compress_override, tension_override, deadspot_override)
    local compress_update, compress = this.GetUpdateAndValue(12, 12 + (3 * 12), 3, compress_override, true)

    local tension_update, tension = this.GetUpdateAndValue(12, 96, 6, tension_override, true)

    local deadspot = deadspot_override
    if not deadspot then
        deadspot = 1
    end

    local retVal =
    {
        accel_compression = compress,
        accel_compression_update = compress_update,

        accel_tension = tension,
        accel_tension_update = tension_update,

        deadSpot = deadspot
    }

    retVal.experience = 1

    if compress then
        retVal.experience = retVal.experience + CalculateExperienceCost_Value(compress, compress_update)
    end

    if tension then
        retVal.experience = retVal.experience + CalculateExperienceCost_Value(tension, tension_update)
    end

    return retVal
end

--------------------------------------------- Other Functions --------------------------------------------

-- This is how much experience was used to get the current value of a property (from min)
-- WARNING: This assumes that it's always an increase.  If there's a property that upgrades
-- from high to low, this function needs to be more robust
-- Params:
-- 	valueUpdates: models\ValueUpdates
--	currentValue: this is the current value of the property that the up/down buttons will modify
function CalculateExperienceCost_Value(currentValue, valueUpdates)
    local min = 0
    if valueUpdates.min then
        min = valueUpdates.min
    end

    if currentValue < min then      -- this should never happen
        return 0
    end

    if valueUpdates.amount then
        -- Simple linear calculation
        return math.floor((currentValue - min) / valueUpdates.amount)
    end

    if not valueUpdates.getDecrementIncrement then      -- should never happen (one of them should be populated)
        return 0
    end

    -- Nonlinear.  Need to do one step at a time

    local newCurrent = currentValue
    local count = 0

    while newCurrent > min do
        --local dec, inc = valueUpdates.getDecrementIncrement(newCurrent)
        local dec, inc = CallReferenced_DecrementIncrement(valueUpdates.getDecrementIncrement, newCurrent)

        newCurrent = newCurrent - dec

        if newCurrent >= min then
            count = count + 1
        end
    end

    return count
end

-- This is a wrapper to the actual ValueUpdates.getDecrementIncrement functions.  Needed to use a string for
-- the function name so the grapple can be cleanly serialized/deserialized
function CallReferenced_DecrementIncrement(key, currentValue)
    return this[key](currentValue)
end

------------------------------------------- Private Methods -------------------------------------------

function this.AntiGrav_Percent_IncDec(current)
    local index = this.GetAntiGravPercentIndex(current)
    if not index then
        return nil, nil
    end

    --NOTE: These calculations subtract using current and not antigrav_percents[index].  This is to try to counteract math drift

    local dec = nil
    if index > 1 then
        dec = current - antigrav_percents[index - 1]        -- the value needs to be positive
    end

    local inc = nil
    if index < #antigrav_percents then
        inc = antigrav_percents[index + 1] - current
    end

    return dec, inc
end
function this.GetAntiGravPercentIndex(current)
    for i = 1, #antigrav_percents do
        if IsNearValue_custom(antigrav_percents[i], current, 0.015) then     -- no need to be too strict
            return i
        end
    end

    return nil
end

function this.CalculateExperience_GrappleStraight(grapple)
    local antigrav = 0
    if grapple.anti_gravity then
        antigrav = grapple.anti_gravity.experience
    end

    local accel_along = 0
    if grapple.accel_alongGrappleLine then
        accel_along = grapple.accel_alongGrappleLine.experience
    end

    local accel_look = 0
    if grapple.accel_alongLook then
        accel_look = grapple.accel_alongLook.experience
    end

    local velocity_away = 0
    if grapple.velocity_away then
        velocity_away = grapple.velocity_away.experience
    end

    return
        CalculateExperienceCost_Value(grapple.aim_straight.max_distance, grapple.aim_straight.max_distance_update) +
        CalculateExperienceCost_Value(grapple.aim_straight.aim_duration, grapple.aim_straight.aim_duration_update) +
        antigrav +
        accel_along +
        accel_look +
        velocity_away
end

function this.GetUpdateAndValue(min, max, amount, value_override, defaultToNil)
    local update =
    {
        min = min,
        max = max,
        amount = amount,
    }

    local value = value_override
    if not defaultToNil and not value then
        value = update.min
    end

    if value then
        if value < update.min then
            update.min = value
        elseif value > update.max then
            update.max = value
        end
    end

    return update, value
end