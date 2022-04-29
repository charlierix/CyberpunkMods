local this = {}

-- Every time keys.cycleConfig is pressed, this function will get called with the next mode
function GetConfigValues(index, sounds_thrusting, const)
    -- Presets, the index will point to one of these (or wrap around to the beginning)
    local presets =
    {
        this.Realism,
        this.WellRounded,
        this.JetTrooper,
        this.Airplane,
        this.NPCLauncher,
        this.HulkStomp,
        this.DreamJump,
    }

    print("preset count: " .. tostring(#presets))

    -- Default Values - overridden by presets
    local mode = this.Default(const)

    if index < 1 or index > #presets then
        index = 1
    end

    -- Call the preset, which changes some of the values in mode
    presets[index](mode, sounds_thrusting, const)

    mode.index = index

    this.AdjustAccelForGravity(mode)

    return mode
end

--------------------------------------- Presets ---------------------------------------

function this.Default(const)
    return
    {
        name = "",

        useRedscript = false,           -- TODO: Rename this to Acceleration vs Teleport based flight (redscript function is now done in cet, but it's still acceleration)

        accel_gravity = -16,            -- this is what the game uses for player's gravity (thrown items are -9.8)

        accel_horz_stand = 1.5,         -- standard is when you hold down a key (not dashing)
        accel_horz_dash = 4,            -- dash is when you tap then hold a direction
        accel_vert_stand = 2.5,
        accel_vert_dash = 6,

        accel_vert_initial = nil,       -- a one time burst up when jetpack is first activated (only works when starting from the ground)

        maxBurnTime = 4,                -- seconds
        burnRate_dash = 2,              -- uses up "energy" at this higher rate when dashing (energy being time left to burn the thrusters)
        burnRate_horz = 0.3,            -- how much "energy" horizontal thruster firing uses
        energyRecoveryRate = 0.35,      -- how quickly "energy" recharges when not using thrust

        holdJumpDelay = 0.37,           -- how long to hold down the jump key to start flight

        timeSpeed = 1,                  -- 0.0001 is frozen time, 1 is standard

        shouldSafetyFire = true,        -- this detects when they are falling fast and close to the ground.  It will blip teleport to eliminate velocity and avoid death

        rmb_extra = nil,                -- this is an optional class that does custom actions when right mouse button is held in

        explosiveJumping = false,       -- this will ragdoll nearby NPCs when jumping from ground (a small force compared to landing)
        explosiveLanding = false,       -- this will ragdoll nearby NPCs when landing

        rotateVelToLookDir = false,     -- This only be done in CET based flight (non redscript).  This will pull the velocity to line up with the direction facing
        rotateVel_percent_horz = 0.8,   -- How strong the pull is.  This is percent per second (1 would be fully aligned after one second)
        rotateVel_percent_vert = 0,     -- Aligning vertically gets annoying, because the player is naturally looking down at an angle, causing it to always want to go down
        rotateVel_dotPow = 3,           -- unsigned integer, percent will be multiplied by the dot product so when they are looking perpendicular to velocity (or more), percent will be zero.  That dot will be taken to this power.  0 won't do the dot product, 1 is standard, 2 is squared, etc.  Paste this into desmos for a visualization: "\cos\left(\frac{\pi}{2}\cdot\left(1-x\right)\right)^{n}"
        rotateVel_minSpeed = 30,        -- the speed to start rotating velocity to look dir
        rotateVel_maxSpeed = 55,        -- the speed is above this, percent will be at its max

        sound_type = const.thrust_sound_type.steam,
    }
end

function this.Realism(mode, sounds_thrusting, const)
    mode.name = "realism"

    mode.useRedscript = true

    mode.maxBurnTime = 3.5

    mode.accel_horz_stand = 1.2
    mode.accel_horz_dash = 3
    mode.accel_vert_stand = 1.5
    mode.accel_vert_dash = 6

    mode.holdJumpDelay = 0.28

    mode.accel_gravity = -12

    mode.shouldSafetyFire = false      -- NOTE: the terminal velocity animation seems to interfere with jetpack activation, so use the jetpack before falling too much
end

function this.WellRounded(mode, sounds_thrusting, const)
    mode.name = "well rounded"

    mode.useRedscript = true

    mode.maxBurnTime = 999
    mode.energyRecoveryRate = 99

    mode.accel_horz_stand = 2
    mode.accel_horz_dash = 6
    mode.accel_vert_stand = 2.4
    mode.accel_vert_dash = 8

    mode.holdJumpDelay = 0.24

    mode.accel_gravity = -7

    mode.rmb_extra = RMB_Hover:new(10, 6, 2, 1, 9999, useRedscript, accel_gravity, sounds_thrusting)
end

function this.JetTrooper(mode, sounds_thrusting, const)
    mode.name = "jet trooper"

    -- Extra fuel, but still somewhat constrained
    mode.maxBurnTime = 18
    mode.energyRecoveryRate = 0.8

    -- Slow things down for air superiority
    mode.accel_gravity = -3
    mode.timeSpeed = 0.5

    mode.accel_vert_stand = 1.5
    mode.accel_vert_dash = 3

    mode.rmb_extra = RMB_Hover:new(2, 2, 0.4, 0.3, 12, useRedscript, accel_gravity, sounds_thrusting)

    mode.sound_type = const.thrust_sound_type.steam_quiet
end

function this.Airplane(mode, sounds_thrusting, const)
    mode.name = "airplane"

    -- Give infinite fuel
    mode.maxBurnTime = 999
    mode.energyRecoveryRate = 99

    -- Have much faster horizontal acceleration
    mode.accel_horz_stand = 18
    mode.accel_horz_dash = 54

    -- A little faster vertical accelerations
    mode.accel_vert_stand = 8
    mode.accel_vert_dash = 16

    mode.accel_gravity = -16

    mode.rmb_extra = RMB_Hover:new(12, 6, 2, 1, 9999, useRedscript, accel_gravity, sounds_thrusting)

    mode.rotateVelToLookDir = true

    mode.sound_type = const.thrust_sound_type.steam_quiet
end

function this.NPCLauncher(mode, sounds_thrusting, const)
    mode.name = "npc launcher"       -- telekinetic eyeball

    mode.useRedscript = true

    mode.maxBurnTime = 12
    mode.energyRecoveryRate = 1.2

    mode.accel_gravity = -1
    mode.accel_vert_stand = 3.5

    mode.holdJumpDelay = 0.24

    mode.rmb_extra = RMB_PushUp:new(22, 6, 8, 60)      -- the burn rate is only applied for one frame, so need something large

    mode.sound_type = const.thrust_sound_type.levitate
end

function this.HulkStomp(mode, sounds_thrusting, const)
    mode.name = "hulk stomp"

    mode.maxBurnTime = 0.6
    mode.burnRate_dash = 1
    mode.burnRate_horz = 0.01
    mode.energyRecoveryRate = 0.4

    mode.accel_horz_stand = 0.5
    mode.accel_horz_dash = 0.5
    mode.accel_vert_stand = 14
    mode.accel_vert_dash = 14

    mode.accel_vert_initial = 12

    mode.accel_gravity = -28

    mode.holdJumpDelay = 0.2
    mode.useRedscript = true

    mode.explosiveJumping = true
    mode.explosiveLanding = true

    mode.sound_type = const.thrust_sound_type.jump
end

function this.DreamJump(mode, sounds_thrusting, const)
    mode.name = "dream jump"

    -- Give infinite fuel
    mode.maxBurnTime = 0.8
    mode.burnRate_dash = 1
    mode.burnRate_horz = 0.2
    mode.energyRecoveryRate = 0.1

    -- Slow things down, like it's a dream
    mode.accel_gravity = -2
    mode.timeSpeed = 0.1

    -- Low accelerations, there is no dash
    mode.accel_horz_stand = 4
    mode.accel_horz_dash = 4

    mode.accel_vert_stand = 1.2
    mode.accel_vert_dash = 1.2

    -- Most of the height should come from the initial kick
    mode.accel_vert_initial = 3

    mode.holdJumpDelay = 0.2

    mode.sound_type = const.thrust_sound_type.jump
end

----------------------------------- Private Methods -----------------------------------

function this.AdjustAccelForGravity(mode)
    -- The vertical accelerations need to defeat gravity
    if mode.useRedscript then
        local extra = 16 + mode.accel_gravity      -- if gravity is 16, then this is zero.  If gravity is higher, then this is some negative amount
        mode.accel_vert_stand = mode.accel_vert_stand + 16 - extra
        mode.accel_vert_dash = mode.accel_vert_dash + 16 - extra
    end
end