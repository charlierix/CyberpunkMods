local this = {}

function GetDefault_Player(playerID)
    return
    {
        playerID = playerID,
        name = "default",

        -- There's no need for an energy tank until it's unlocked.  It would just complicate the function
        -- that determines if a player entry is unlocked

        -- Don't give them any grapples by default.  At the time of unlocking, they get experience and
        -- can equip the grapples that they want

        experience = 0,

        isUnlocked = false,
    }
end

function GetDefault_Experience()
    return 24
end

function GetEnergyCost_GrappleStraight(experience)
    -- https://mycurvefit.com/
    -- https://www.desmos.com/calculator
    -- zero=0 (0)
    -- low=12 (3)
    -- med=24 (6)
    -- high=48 (9)

    local retVal = 12 + -12/(1 + (experience/24)^1.584963)

    return math.max(retVal, 0)
end

------------------------------------------------ Grapples ------------------------------------------------

-- This returns an array that is used by the grapple choose window
-- Returns
--  { { name, experience, description }, {...}, {...}, }
function GetDefault_Grapple_Choices()
    local comparer = function (a, b)
        return Comparer(a.experience, b.experience)
    end

    local retVal = {}

    InsertSorted(
        retVal,
        this.GetDefault_Grapple_Choices_SubArray(GetDefault_Grapple_Blank()),
        comparer)

    InsertSorted(
        retVal,
        this.GetDefault_Grapple_Choices_SubArray(GetDefault_Grapple_Pull()),
        comparer)

    InsertSorted(
        retVal,
        this.GetDefault_Grapple_Choices_SubArray(GetDefault_Grapple_Rope()),
        comparer)

    InsertSorted(
        retVal,
        this.GetDefault_Grapple_Choices_SubArray(GetDefault_Grapple_PoleVault()),
        comparer)

    InsertSorted(
        retVal,
        this.GetDefault_Grapple_Choices_SubArray(GetDefault_Grapple_AngryBird()),
        comparer)

    InsertSorted(
        retVal,
        this.GetDefault_Grapple_Choices_SubArray(GetDefault_Grapple_Swing()),
        comparer)

    return retVal
end

function GetDefault_Grapple_ByName(name)
    if name == "blank" then
        return GetDefault_Grapple_Blank()

    elseif name == "pull" then
        return GetDefault_Grapple_Pull()

    elseif name == "rope" then
        return GetDefault_Grapple_Rope()

    elseif name == "pole vault" then
        return GetDefault_Grapple_PoleVault()

    elseif name == "swing" then
        return GetDefault_Grapple_Swing()

    else
        print("GetDefault_Grapple_ByName: Unknown name: " .. tostring(name))
        return nil
    end
end

function GetDefault_Grapple_Blank()
    local retVal =
    {
        name = "blank",
        description = "Just a scaffolding to build from.  Some assembly required",

        mappin_name = "DistractVariant",
        minDot = nil,
        stop_on_wallHit = false,

        anti_gravity = nil,

        desired_length = nil,

        accel_alongGrappleLine = nil,
        accel_alongLook = nil,

        springAccel_k = nil,        --TODO: Play with this

        velocity_away = nil,        -- the attractive force is strong enough that there will likely never be a velocity away.  And if there is, the force is pretty strong anyway

        energy_cost = 1,        --TODO: this should be a function of the experience cost

        aim_straight = GetDefault_AimStraight(6),

        fallDamageReduction_percent = 0,
    }

    retVal.experience = this.CalculateExperience_GrappleStraight(retVal)
    --retVal.energy_cost = this.CalculateEnergyCost_GrappleStraight(retVal)

    return retVal
end

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

        aim_straight = GetDefault_AimStraight(),

        fallDamageReduction_percent = 0,
    }

    retVal.experience = this.CalculateExperience_GrappleStraight(retVal)
    retVal.energy_cost = GetEnergyCost_GrappleStraight(retVal.experience)

    return retVal
end

function GetDefault_Grapple_Rope()
    local retVal =
    {
        name = "rope",
        description = "This allows you to swing from overhangs or hang from walls",

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

        aim_straight = GetDefault_AimStraight(12),

        fallDamageReduction_percent = 0,
    }

    retVal.experience = this.CalculateExperience_GrappleStraight(retVal)
    retVal.energy_cost = GetEnergyCost_GrappleStraight(retVal.experience)

    return retVal
end

function GetDefault_Grapple_PoleVault()
    local retVal =
    {
        name = "pole vault",
        description = "Meant to be pointed at the ground mid jump to help traverse gaps between buildings",

        mappin_name = "TakeControlVariant",
        minDot = -0.87,
        stop_distance = 2,
        stop_on_wallHit = true,

        anti_gravity = nil,

        desired_length = nil,

        accel_alongGrappleLine = GetDefault_ConstantAccel(20, 6, 0.75),
        accel_alongLook = nil,

        springAccel_k = nil,        --TODO: Play with this

        velocity_away = GetDefault_VelocityAway(42, nil, 1),

        aim_straight = GetDefault_AimStraight(14),

        fallDamageReduction_percent = 0,
    }

    retVal.experience = this.CalculateExperience_GrappleStraight(retVal)
    retVal.energy_cost = GetEnergyCost_GrappleStraight(retVal.experience)

    return retVal
end

function GetDefault_Grapple_AngryBird()
    local retVal =
    {
        name = "angry bird",
        description = "Launch yourself at the pigs - with guns blazing",

        mappin_name = "OffVariant",

        minDot = -0.13,
        stop_on_wallHit = true,
        stop_distance = 0.8,

        anti_gravity = GetDefault_AntiGravity(0.4, 4),

        desired_length = 0,     -- pull all the way to the anchor

        accel_alongGrappleLine = GetDefault_ConstantAccel(40, 14, 2.4),
        accel_alongLook = nil,

        aim_straight = GetDefault_AimStraight(14),

        fallDamageReduction_percent = 0,
    }

    retVal.aim_straight.air_anchor = GetDefault_AirAnchor()

    retVal.experience = this.CalculateExperience_GrappleStraight(retVal)
    retVal.energy_cost = GetEnergyCost_GrappleStraight(retVal.experience)

    return retVal
end

function GetDefault_Grapple_HeliumFrog()
    -- "Hi Ho! Kermit the parade balloon here!"

    -- This turns the player into a blimp/balloon


    -- Very high antigravity/fade

    -- Long aim distance

    -- Very weak acceleration, low max speed


    -- The current min speeds and accel are too high for this to work.  Fun idea, but jetpack
    -- is better suited for this type of flight

end

--TODO: Swing won't rely on such fixed defaults.  The aim will need to do a few ray casts to see if it's a big open
--space, too tight, speed, look, etc.  If in a long narrow gap and slow and looking along the gap, fire two lines
function GetDefault_Grapple_Swing()
    local retVal =
    {
        name = "swing",
        description = "Open air swinging",

        mappin_name = "AimVariant",
        minDot = nil,
        stop_on_wallHit = true,

        anti_gravity = nil,

        desired_length = nil,

        --accel_alongGrappleLine = nil,       --TODO: Some of the acceleration needs to be this.  Otherwise it gets jerky when only drag is applied
        accel_alongGrappleLine = GetDefault_ConstantAccel(12, 6, 0.75),      -- still jerky
        accel_alongLook = nil,

        springAccel_k = nil,        --TODO: Play with this

        velocity_away = GetDefault_VelocityAway(nil, 70, nil),      -- using a big tension so it feels like rope

        aim_swing = GetDefault_AimSwing(),

        fallDamageReduction_percent = 0,
    }

    retVal.experience = 12
    retVal.energy_cost = 1

    return retVal
end

----------------------------------------------- Components -----------------------------------------------

function GetDefault_EnergyTank()
    local retVal =
    {
        max_energy = 12,
        max_energy_update =
        {
            min = 1,        -- there is no max
            amount = 3,
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
            min_abs = 1,        -- values between 1 and 6 don't cost experience
            min = 6,
            max = 120,
            amount = 1,
        },

        aim_duration = 0.35,     -- 1 seems ideal, but make them pay for it in third second intervals
        aim_duration_update =
        {
            min_abs = 0.05,
            min = 0.35,
            max = 3,
            amount = 0.3,
        },

        mappin_name = "CustomPositionVariant",
        air_dash = nil,
        air_anchor = nil,
    }
end

function GetDefault_AimSwing()
    return
    {
        SwingLength = 24,
        MinAngle = -45,
    }
end

function GetDefault_AirAnchor()
    local retVal =
    {
        energyCost = 3,

        energyCost_reduction_percent = 0,
        energyCost_reduction_percent_update =
        {
            min = 0,
            max = 0.9,
            amount = 0.15,
        },

        energyBurnRate = 2,

        burnReducePercent = 0,
        burnReducePercent_update =
        {
            min = 0,
            max = 0.9,
            amount = 0.1,
        },
    }

    retVal.experience =
        1 +     -- there is a base cost of 1
        CalculateExperienceCost_Value(retVal.energyCost_reduction_percent, retVal.energyCost_reduction_percent_update) +
        CalculateExperienceCost_Value(retVal.burnReducePercent, retVal.burnReducePercent_update)

    return retVal
end

function GetDefault_AirDash()
    local retVal =
    {
        energyBurnRate = 4,

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
                min_abs = 2,
                min = 28,
                max = 28 + (2 * 8),
                amount = 2,
            },

            speed = 6,
            speed_update =
            {
                min_abs = 1,
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
    local accel_update, accel = this.GetUpdateAndValue(2, 20, 20 + (2 * 24), 2, accel_override, false)

    local speed_update, speed = this.GetUpdateAndValue(1, 6, 6 + (1 * 64), 1, speed_override, false)

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
    local compress_update, compress = this.GetUpdateAndValue(3, 12, 12 + (3 * 12), 3, compress_override, true)

    local tension_update, tension = this.GetUpdateAndValue(6, 12, 96, 6, tension_override, true)

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
    if not valueUpdates.min then
        -- should never be nil.  If it is, just give up and don't calculate xp
        return 0
    end

    if currentValue < valueUpdates.min then      -- ignoring min_abs
        return 0
    end

    if valueUpdates.amount then
        -- Simple linear calculation
        return math.floor((currentValue - valueUpdates.min) / valueUpdates.amount)
    end

    if not valueUpdates.getDecrementIncrement then      -- should never happen (one of them should be populated)
        return 0
    end

    -- Nonlinear.  Need to do one step at a time

    local newCurrent = currentValue
    local count = 0

    while newCurrent > valueUpdates.min do
        --local dec, inc = valueUpdates.getDecrementIncrement(newCurrent)
        local dec, inc = CallReferenced_DecrementIncrement(valueUpdates.getDecrementIncrement, newCurrent)

        newCurrent = newCurrent - dec

        if newCurrent >= valueUpdates.min then
            count = count + 1
        end
    end

    return count
end

------------------------------------------- Private Methods -------------------------------------------

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

function this.GetUpdateAndValue(min_abs, min, max, amount, value_override, defaultToNil)
    local update =
    {
        min_abs = min_abs,
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

function this.GetDefault_Grapple_Choices_SubArray(grapple)
    return
    {
        name = grapple.name,
        experience = grapple.experience,
        description = grapple.description,
    }
end