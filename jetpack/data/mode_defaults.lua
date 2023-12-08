local this = {}
local ModeDefaults = {}

ModeDefaults.HOVER_MAX_HOLD_DURATION = 9999

-- Presets, the index will point to one of these (or wrap around to the beginning)
local presets = nil

-- Every time keys.cycleConfig is pressed, this function will get called with the next mode
function ModeDefaults.GetConfigValues(index, sounds_thrusting, const)
    this.EnsurePresetsAssigned()

    -- Default Values - overridden by presets
    local mode = this.Default(const)

    if index < 1 or index > #presets then
        index = 1
    end

    -- Call the preset, which changes some of the values in mode
    presets[index](mode, sounds_thrusting, const)

    mode.index = index

    -- The vertical accelerations need to defeat gravity
    mode.accel.vert_stand = ModeDefaults.ImpulseGravityAdjust_ToMode(mode.useImpulse, mode.accel.gravity, mode.accel.vert_stand)
    mode.accel.vert_dash = ModeDefaults.ImpulseGravityAdjust_ToMode(mode.useImpulse, mode.accel.gravity, mode.accel.vert_dash)

    return mode
end

function ModeDefaults.GetConfigValues_Count()
    this.EnsurePresetsAssigned()
    return #presets
end

function ModeDefaults.ToJSON(mode, const)
    local retVal = this.CloneTable_CurrentLayer(mode)

    retVal.mode_key = nil

    -- Need to replace extra_xxx with a definition, since it's currently a live object that would serialize as too much
    if mode.extra_rmb then
        retVal.extra_rmb = this.ToJSON_Extra(mode.extra_rmb, const)
    end

    if mode.extra_key1 then
        retVal.extra_key1 = this.ToJSON_Extra(mode.extra_key1, const)
    end

    if mode.extra_key2 then
        retVal.extra_key2 = this.ToJSON_Extra(mode.extra_key2, const)
    end

    return extern_json.encode(retVal)
end
function ModeDefaults.FromJSON(json, mode_key, sounds_thrusting, const)
    local retVal = extern_json.decode(json)

    retVal.mode_key = mode_key

    -- Replace extra_xxx with a live object
    if retVal.extra_rmb then
        retVal.extra_rmb = this.FromJSON_Extra(retVal.extra_rmb, retVal, sounds_thrusting, const)
    end

    if retVal.extra_key1 then
        retVal.extra_key1 = this.FromJSON_Extra(retVal.extra_key1, retVal, sounds_thrusting, const)
    end

    if retVal.extra_key2 then
        retVal.extra_key2 = this.FromJSON_Extra(retVal.extra_key2, retVal, sounds_thrusting, const)
    end

    return retVal
end

-- Impulse based flight needs to adjust the value to account for gravity.  This is done to the modes returned by
-- ModeDefaults.GetConfigValues.  So those adjustments are in the live modes as well as stored in the database.
-- But the UI needs to show the unmodified values, also convert the ui values into modified ones when saving changes
-- to the mode
function ModeDefaults.ImpulseGravityAdjust_ToMode(uses_impulse, gravity, accel)
    -- Increases/Decreases accel to cancel out gravity
    if uses_impulse then
        -- Gravity is negative.  If gravity is -16, then the adjustment is zero.  If gravity is more negative then the returned accel needs to overcome that
        --return accel + 16 - (16 + gravity)
        return accel - gravity
    else
        return accel
    end
end
function ModeDefaults.ImpulseGravityAdjust_ToUI(uses_impulse, gravity, accel)
    -- Reverses the transform done in ToMode so the value can be shown
    -- NOTE: make sure that the values passed in are ui values.  Don't mix an old baked accel with a new gravity (unpack the old accel with old gravity, then repack the pure accel with new gravity)
    if uses_impulse then
        return accel + gravity
    else
        return accel
    end
end

--------------------------------------- Presets ---------------------------------------

function this.Default(const)
    return
    {
        name = "",
        description = "",

        useImpulse = false,               -- True: impulse based flight (game engine handles physics/collisions) | False: teleport based flight (this mod handles physics/collisions)

        sound_type = const.thrust_sound_type.steam,

        -- can't use both time dilation settings, only one or none
        timeDilation = nil,                    -- 0.0001 is frozen time, 1 is standard
        timeDilation_gradient = nil,           -- this defines bullet time based on abs(vel.z)
        -- {
        --     timeDilation_lowZSpeed = 0.05,  -- the bullet time to use when z speed is lower than this
        --     lowZSpeed = 2,

        --     timeDilation_highZSpeed = 0.9,
        --     highZSpeed = 4.5,
        -- },

        extra_rmb = nil,                    -- this is an optional class that does custom actions when right mouse button is held in
        extra_key1 = nil,
        extra_key2 = nil,

        jump_land =
        {
            holdJumpDelay = 0.22,           -- how long to hold down the jump key to start flight

            explosiveJumping = false,       -- this will ragdoll nearby NPCs when jumping from ground (a small force compared to landing)
            explosiveLanding = false,       -- this will ragdoll nearby NPCs when landing

            shouldSafetyFire = true,        -- this detects when they are falling fast and close to the ground.  It will blip teleport to eliminate velocity and avoid death
        },

        accel =
        {
            gravity = -16,              -- this is what the game uses for player's gravity (thrown items are -9.8)

            horz_stand = 1.5,           -- standard is when you hold down a key (not dashing)
            horz_dash = 4,              -- dash is when you tap then hold a direction
            vert_stand = 2.5,
            vert_dash = 6,

            vert_initial = nil,         -- a one time burst up when jetpack is first activated (only works when starting from the ground)
        },

        energy =
        {
            maxBurnTime = 4,            -- seconds
            burnRate_dash = 2,          -- uses up "energy" at this higher rate when dashing (energy being time left to burn the thrusters)
            burnRate_horz = 0.3,        -- how much "energy" horizontal thruster firing uses
            recoveryRate = 0.35,        -- how quickly "energy" recharges when not using thrust
        },

        mouseSteer = nil,
        -- mouseSteer =
        -- {
        --     percent_horz = 0.8,         -- How strong the pull is.  This is percent per second (1 would be fully aligned after one second)
        --     percent_vert = 0,           -- Aligning vertically gets annoying, because the player is naturally looking down at an angle, causing it to always want to go down
        --     dotPow = 3,                 -- unsigned integer, percent will be multiplied by the dot product so when they are looking perpendicular to velocity (or more), percent will be zero.  That dot will be taken to this power.  0 won't do the dot product, 1 is standard, 2 is squared, etc.  Paste this into desmos for a visualization: "\cos\left(\frac{\pi}{2}\cdot\left(1-x\right)\right)^{n}"
        --     minSpeed = 30,              -- the speed to start rotating velocity to look dir
        --     maxSpeed = 55,              -- the speed is above this, percent will be at its max
        -- },

        rebound = nil,                      -- allows the player to bounce off the ground if they hit jump as they hit the ground
        -- rebound =
        -- {
        --     percent_at_zero = 1.5,       -- the percent of Z part of velocity to rebound with when speed along Z is zero
        --     percent_at_max = 0.8,        -- the percent to use at a high impact speed
        --     speed_of_max = 40,           -- the speed where percent_at_max should be applied.  Any speed higher than this will also use percent_at_max
        -- },
    }
end

function this.Realism(mode, sounds_thrusting, const)
    mode.name = "realism"

    mode.description =
[[Default implementation of a jetpack

Has low accelerations, a small fuel tank, and doesn't protect you from fall damage

It's designed to be less overpowered than other modes]]

    mode.useImpulse = true

    mode.energy.maxBurnTime = 3.5

    mode.accel.horz_stand = 1.2
    mode.accel.horz_dash = 3
    mode.accel.vert_stand = 1.5
    mode.accel.vert_dash = 6

    mode.accel.vert_initial = 3

    mode.accel.gravity = -12

    mode.jump_land.shouldSafetyFire = false      -- NOTE: the terminal velocity animation seems to interfere with jetpack activation, so use the jetpack before falling too much
end

function this.WellRounded(mode, sounds_thrusting, const)
    mode.name = "well rounded"

    mode.description =
[[A strong general purpose mode

A bit more acceleration, infinite fuel, and no fall damage]]

    mode.useImpulse = true

    mode.energy.maxBurnTime = 999
    mode.energy.recoveryRate = 99

    mode.accel.horz_stand = 2
    mode.accel.horz_dash = 6
    mode.accel.vert_stand = 2.4
    mode.accel.vert_dash = 8

    mode.accel.vert_initial = 5

    mode.rebound =       -- need to figure out why impulse mode has such unstable impulses
    {
        percent_at_zero = 0.8,        -- there seems to be a problem where value > 1 over amplifies the rebound velocity.  Maybe impulse accel isn't 1:1 with speed?
        percent_at_max = 0.6,
        speed_of_max = 40,
    }

    mode.accel.gravity = -7

    mode.extra_rmb = Extra_Hover:new("rmb", 10, 6, 2, 1, ModeDefaults.HOVER_MAX_HOLD_DURATION, mode.useImpulse, mode.accel.gravity, sounds_thrusting, const)

    mode.sound_type = const.thrust_sound_type.steam_quiet
end

function this.JetTrooper(mode, sounds_thrusting, const)
    mode.name = "jet trooper"

    mode.description =
[[Slows time, weakens gravity

Pairs well with smart weapons or heavy machine gun

Somewhat limited fuel tank to keep from being too overpowered]]

    -- Extra fuel, but still somewhat constrained
    mode.energy.maxBurnTime = 18
    mode.energy.recoveryRate = 0.8

    -- Slow things down for air superiority
    mode.accel.gravity = -3
    mode.timeDilation = 0.33

    mode.accel.vert_stand = 1.5
    mode.accel.vert_dash = 3

    mode.accel.vert_initial = 2

    mode.extra_rmb = Extra_Hover:new("rmb", 2, 2, 0.4, 0.3, 12, mode.useImpulse, mode.accel.gravity, sounds_thrusting, const)

    mode.sound_type = const.thrust_sound_type.steam_quiet
end

function this.Airplane(mode, sounds_thrusting, const)
    mode.name = "airplane"

    mode.description =
[[Very high acceleration, infinite fuel

Use this to get around the map quickly]]

    -- Give infinite fuel
    mode.energy.maxBurnTime = 999
    mode.energy.recoveryRate = 99

    -- Have much faster horizontal acceleration
    mode.accel.horz_stand = 18
    mode.accel.horz_dash = 54

    -- A little faster vertical accelerations
    mode.accel.vert_stand = 8
    mode.accel.vert_dash = 16

    mode.accel.vert_initial = 7

    mode.accel.gravity = -16

    mode.extra_rmb = Extra_Hover:new("rmb", 12, 6, 2, 1, ModeDefaults.HOVER_MAX_HOLD_DURATION, mode.useImpulse, mode.accel.gravity, sounds_thrusting, const)

    mode.mouseSteer =
    {
        percent_horz = 0.8,         -- How strong the pull is.  This is percent per second (1 would be fully aligned after one second)
        percent_vert = 0,           -- Aligning vertically gets annoying, because the player is naturally looking down at an angle, causing it to always want to go down
        dotPow = 3,                 -- unsigned integer, percent will be multiplied by the dot product so when they are looking perpendicular to velocity (or more), percent will be zero.  That dot will be taken to this power.  0 won't do the dot product, 1 is standard, 2 is squared, etc.  Paste this into desmos for a visualization: "\cos\left(\frac{\pi}{2}\cdot\left(1-x\right)\right)^{n}"
        minSpeed = 30,              -- the speed to start rotating velocity to look dir
        maxSpeed = 55,              -- the speed is above this, percent will be at its max
    }

    mode.sound_type = const.thrust_sound_type.steam_quiet
end

function this.NPCLauncher(mode, sounds_thrusting, const)
    mode.name = "npc launcher"       -- telekinetic eyeball

    mode.description =
[[Designed to launch NPCs in the air when you press the right mouse button

It has a slow and ominous feel to it, low gravity]]

    mode.useImpulse = true

    mode.energy.maxBurnTime = 12
    mode.energy.recoveryRate = 1.2

    mode.accel.gravity = -1
    mode.accel.vert_stand = 3.5

    mode.extra_rmb = Extra_PushUp:new("rmb", 22, 6, 8, 0.5, const)
    mode.extra_key1 = Extra_Hover:new("extra1", 2, 4, 0.4, 0.1, 36, mode.useImpulse, mode.accel.gravity, sounds_thrusting, const)

    mode.sound_type = const.thrust_sound_type.levitate
end

function this.HulkStomp(mode, sounds_thrusting, const)
    mode.name = "hulk stomp"

    mode.description =
[[High acceleration up and down

Knocks people back if you land near them]]

    mode.energy.maxBurnTime = 0.6
    mode.energy.burnRate_dash = 1
    mode.energy.burnRate_horz = 0.01
    mode.energy.recoveryRate = 0.4

    mode.accel.horz_stand = 0.5
    mode.accel.horz_dash = 0.5
    mode.accel.vert_stand = 14
    mode.accel.vert_dash = 14

    mode.accel.vert_initial = 12

    mode.accel.gravity = -28

    mode.jump_land.holdJumpDelay = 0.2
    mode.useImpulse = true

    mode.jump_land.explosiveJumping = true
    mode.jump_land.explosiveLanding = true

    mode.rebound =
    {
        percent_at_zero = 1,
        percent_at_max = 0.6,
        speed_of_max = 40,
    }

    mode.sound_type = const.thrust_sound_type.jump
end

function this.DreamJump(mode, sounds_thrusting, const)
    mode.name = "dream jump"

    mode.description =
[[Designed to mimic the feeling of jumping in a dream

It features low gravity, time nearly stops at the top of the arc, and can rebound as you land to go higher on the next jump

It's a laid back way to play (major tom to ground control usually loops in my head while using it)]]

    -- Give infinite fuel
    mode.energy.maxBurnTime = 0.8
    mode.energy.burnRate_dash = 1
    mode.energy.burnRate_horz = 0.2
    mode.energy.recoveryRate = 0.1

    -- Slow things down, like it's a dream
    mode.accel.gravity = -2

    mode.timeDilation_gradient =               -- this defines bullet time based on abs(vel.z)
    {
        timeDilation_lowZSpeed = 0.05,          -- the bullet time to use when z speed is lower than this
        lowZSpeed = 2,

        timeDilation_highZSpeed = 0.9,
        highZSpeed = 4.5,
    }

    -- Low accelerations, there is no dash
    mode.accel.horz_stand = 4
    mode.accel.horz_dash = 4

    mode.accel.vert_stand = 1.2
    mode.accel.vert_dash = 1.2

    -- Most of the height should come from the initial kick
    mode.accel.vert_initial = 1.1

    mode.rebound =
    {
        percent_at_zero = 1.065,       -- the percent of Z part of velocity to bebound with when speed along Z is zero
        percent_at_max = 0.8,        -- the percent to use at a high impact speed
        speed_of_max = 30,           -- the speed where percent_at_max should be applied.  Any speed higher than this will also use percent_at_max
    }

    mode.sound_type = const.thrust_sound_type.jump
end

function this.ExtremeSlowMotion()
    --TODO: this also needs hover on right click

    -- {
    --     "accel": {
    --         "gravity": -0.7,
    --         "horz_dash": 9,
    --         "horz_stand": 2,
    --         "vert_dash": 5.5,
    --         "vert_initial": 0.667,
    --         "vert_stand": 0.85
    --     },
    --     "description": "Just for fun, very over powered.  Buzz around, take people out with impunity",
    --     "energy": {
    --         "burnRate_dash": 0.1,
    --         "burnRate_horz": 0.1,
    --         "maxBurnTime": 999,
    --         "recoveryRate": 99
    --     },
    --     "index": 1,
    --     "jump_land": {
    --         "explosiveJumping": false,
    --         "explosiveLanding": false,
    --         "holdJumpDelay": 0.22,
    --         "shouldSafetyFire": false
    --     },
    --     "name": "Extreme Slow Motion",
    --     "sound_type": "levitate",
    --     "timeDilation": 0.07,
    --     "useImpulse": false
    -- }
end

----------------------------------- Private Methods -----------------------------------

function this.EnsurePresetsAssigned()
    if not presets then
        presets =
        {
            this.Realism,
            this.WellRounded,
            this.JetTrooper,
            this.Airplane,
            this.NPCLauncher,
            this.HulkStomp,
            this.DreamJump,
        }
    end
end

function this.CloneTable_CurrentLayer(table)
    local retVal = {}

    for key, value in pairs(table) do
        retVal[key] = value
    end

    return retVal
end

function this.ToJSON_Extra(extra, const)
    if extra.extra_type == const.extra_type.hover then
        return
        {
            extra_type = extra.extra_type,
            key = extra.key,
            mult = extra.mult,
            accel_up = extra.accel_up_ORIG,
            accel_down = extra.accel_down,
            burnRate = extra.burnRate,
            holdDuration = extra.holdDuration,
        }

    elseif extra.extra_type == const.extra_type.pushup then
        return
        {
            extra_type = extra.extra_type,
            key = extra.key,
            force = extra.force,
            randHorz = extra.randHorz,
            randVert = extra.randVert,
            burnRate = extra.burnRate,
        }

    elseif extra.extra_type == const.extra_type.dash then
        return
        {
            extra_type = extra.extra_type,
            key = extra.key,
            acceleration = extra.acceleration,
            burnRate = extra.burnRate,
        }

    else
        LogError("ModeDefaults.ToJSON_Extra: Unknown extra_type: " .. tostring(extra.extra_type))
        return nil
    end
end
function this.FromJSON_Extra(extra, deserialized, sounds_thrusting, const)
    if extra.extra_type == const.extra_type.hover then
        return Extra_Hover:new(extra.key, extra.mult, extra.accel_up, extra.accel_down, extra.burnRate, extra.holdDuration, deserialized.useImpulse, deserialized.accel.gravity, sounds_thrusting, const)

    elseif extra.extra_type == const.extra_type.pushup then
        return Extra_PushUp:new(extra.key, extra.force, extra.randHorz, extra.randVert, extra.burnRate, const)

    elseif extra.extra_type == const.extra_type.dash then
        return Extra_Dash:new(extra.key, extra.acceleration, extra.burnRate, const)

    else
        LogError("ModeDefaults.FromJSON_Extra: Unknown extra_type: " .. tostring(extra.extra_type))
        return nil
    end
end

return ModeDefaults