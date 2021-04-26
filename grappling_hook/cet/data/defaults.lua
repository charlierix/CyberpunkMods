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

function GetDefault_EnergyTank()
    return
    {
        max_energy = 12,
        recovery_rate = 1,
        flying_percent = 0.25,

        experience = 0,
    }
end

function GetDefault_Grapple_Pull()
    return
    {
        name = "pull",
        description = "Pulls toward anchor point, also pulls in the look direction (modeled after titanfall2)",

        mappin_name = "AimVariant",
        minDot = 0,
        stop_on_wallHit = true,

        anti_gravity =
        {
            antigrav_percent = 0.6,       -- pull has to have some anti gravity.  Otherwise, the forces would need to be too large
            fade_duration = 2,
        },
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

        experience = 0,
    }
end

function GetDefault_Grapple_Rigid()
    return
    {
        name = "rigid",
        description = "Mainly used like a rope.  Also has a small compression resistance, like a weak pole vault",

        mappin_name = "TakeControlVariant",
        minDot = -0.71,     -- give this extra freedom so they can look around more while hanging/swinging
        stop_on_wallHit = false,

        anti_gravity = nil,

        desired_length = nil,       -- 6 to 12 would be a good range (start long).  The main use for this is to swing from an overhang, and if you start too far away, you'll just fall to the ground

        accel_alongGrappleLine =
        {
            accel = 8,      -- keep this weak, and rely on velocity away to do most of the work
            speed = 12,

            deadSpot_distance = 1,
            deadSpot_speed = 1,
        },

        accel_alongLook = nil,

        springAccel_k = nil,        --TODO: Play with this

        velocity_away =
        {
            accel_compression = 12,     -- using a small value
            accel_tension = 84,         -- using a big value so it feels like rope

            deadSpot = 0.5,
        },

        energy_cost = 3,

        aim_straight = GetDefault_AimStraight(),

        fallDamageReduction_percent = 0,

        experience = 0,
    }
end

function GetDefault_Grapple_WallHanger()
    -- This should be rope used to hang from a wall

    -- mindot = nil
    -- desired length = .75
    -- moderate pull force
    -- strong anti gravity
end

function GetDefault_AimStraight()
    return
    {
        max_distance = 9,
        aim_duration = 0.333,     -- 1 seems ideal, but make them pay for it in third second intervals
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