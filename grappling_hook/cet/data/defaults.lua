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

        accel_alongGrappleLine =
        {
            accel = 24,
            speed = 7,

            deadSpot_distance = 3,
            deadSpot_speed = 1,
        },

        accel_alongLook =
        {
            accel = 36,
            speed = 9,

            deadSpot_distance = 3,
            deadSpot_speed = 1,
        },

        springAccel_k = nil,        --TODO: Play with this

        velocity_away = nil,        -- the attractive force is strong enough that there will likely never be a velocity away.  And if there is, the force is pretty strong anyway

        energy_cost = 7,

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

        accel_alongGrappleLine = nil,
        accel_alongLook = nil,

        springAccel_k = nil,        --TODO: Play with this

        velocity_away =
        {
            accel_compression = 20,     -- using a small value
            accel_tension = 84,         -- using a big value so it feels like rope

            deadSpot = 0.5,
        },

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
    return
    {
        energyBurnRate = 1,
        mappin_name = "OffVariant",
        accel =
        {
            accel = 28,     -- anything below this, and it's like the horizontal component is ignored
            speed = 9,

            deadSpot_distance = 0,
            deadSpot_speed = 1,
        },
    }
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

    return
        CalculateExperienceCost_Value(grapple.aim_straight.max_distance, grapple.aim_straight.max_distance_update) +
        CalculateExperienceCost_Value(grapple.aim_straight.aim_duration, grapple.aim_straight.aim_duration_update) +
        antigrav
end