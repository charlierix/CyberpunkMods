local this = {}
local ModeDefaults = {}

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

    this.AdjustAccelForGravity(mode)

    return mode
end

function ModeDefaults.GetConfigValues_Count()
    this.EnsurePresetsAssigned()
    return #presets
end

function ModeDefaults.ToJSON(mode, const)
    local retVal = mode

    retVal.mode_key = nil

    -- Need to replace rmb_extra with a definition, since it's currently a live object that would serialize as too much
    if mode.rmb_extra then
        retVal = this.CloneTable_CurrentLayer(mode)

        if mode.rmb_extra.rmb_type == const.rmb_type.hover then
            retVal.rmb_extra =
            {
                rmb_type = mode.rmb_extra.rmb_type,
                mult = mode.rmb_extra.mult,
                accel_up = mode.rmb_extra.accel_up_ORIG,
                accel_down = mode.rmb_extra.accel_down,
                burnRate = mode.rmb_extra.burnRate,
                holdDuration = mode.rmb_extra.holdDuration,
            }

        elseif mode.rmb_extra.rmb_type == const.rmb_type.pushup then
            retVal.rmb_extra =
            {
                rmb_type = mode.rmb_extra.rmb_type,
                force = mode.rmb_extra.force,
                randHorz = mode.rmb_extra.randHorz,
                randVert = mode.rmb_extra.randVert,
                burnRate = mode.rmb_extra.burnRate,
            }

        elseif mode.rmb_extra.rmb_type == const.rmb_type.dash then
            retVal.rmb_extra =
            {
                rmb_type = mode.rmb_extra.rmb_type,
                acceleration = mode.rmb_extra.acceleration,
                burnRate = mode.rmb_extra.burnRate,
            }

        else
            LogError("ModeDefaults.ToJSON: Unknown mode.rmb_extra.rmb_type: " .. tostring(mode.rmb_extra.rmb_type))
            retVal.rmb_extra = nil
        end
    end

    return extern_json.encode(retVal)
end
function ModeDefaults.FromJSON(json, mode_key, sounds_thrusting, const)
    local retVal = extern_json.decode(json)

    retVal.mode_key = mode_key

    -- Replace rmb_extra with a live object
    if retVal.rmb_extra then

        if retVal.rmb_extra.rmb_type == const.rmb_type.hover then
            retVal.rmb_extra = RMB_Hover:new(retVal.rmb_extra.mult, retVal.rmb_extra.accel_up, retVal.rmb_extra.accel_down, retVal.rmb_extra.burnRate, retVal.rmb_extra.holdDuration, retVal.useImpulse, retVal.accel.gravity, sounds_thrusting, const)

        elseif retVal.rmb_extra.rmb_type == const.rmb_type.pushup then
            retVal.rmb_extra = RMB_PushUp:new(retVal.rmb_extra.force, retVal.rmb_extra.randHorz, retVal.rmb_extra.randVert, retVal.rmb_extra.burnRate, const)

        elseif retVal.rmb_extra.rmb_type == const.rmb_type.dash then
            retVal.rmb_extra = RMB_Dash:new(retVal.rmb_extra.acceleration, retVal.rmb_extra.burnRate, const)

        else
            LogError("ModeDefaults.FromJSON: Unknown mode.rmb_extra.rmb_type: " .. tostring(retVal.rmb_extra.rmb_type))
            retVal.rmb_extra = nil
        end
    end

    return retVal
end

--------------------------------------- Presets ---------------------------------------

function this.Default(const)
    return
    {
        name = "",

        useImpulse = false,               -- True: impulse based flight (game engine handles physics/collisions) | False: teleport based flight (this mod handles physics/collisions)

        sound_type = const.thrust_sound_type.steam,

        -- can't use both timespeed settings, only one or none
        timeSpeed = nil,                    -- 0.0001 is frozen time, 1 is standard
        timeSpeed_gradient = nil,           -- this defines bullet time based on abs(vel.z)
        -- {
        --     timeSpeed_lowZSpeed = 0.05,  -- the bullet time to use when z speed is lower than this
        --     lowZSpeed = 2,

        --     timeSpeed_highZSpeed = 0.9,
        --     highZSpeed = 4.5,
        -- },

        rmb_extra = nil,                    -- this is an optional class that does custom actions when right mouse button is held in

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

        rotateVel =
        {
            is_used = false,            -- This should only be done in teleport based flight (non impulse).  This will pull the velocity to line up with the direction facing
            percent_horz = 0.8,         -- How strong the pull is.  This is percent per second (1 would be fully aligned after one second)
            percent_vert = 0,           -- Aligning vertically gets annoying, because the player is naturally looking down at an angle, causing it to always want to go down
            dotPow = 3,                 -- unsigned integer, percent will be multiplied by the dot product so when they are looking perpendicular to velocity (or more), percent will be zero.  That dot will be taken to this power.  0 won't do the dot product, 1 is standard, 2 is squared, etc.  Paste this into desmos for a visualization: "\cos\left(\frac{\pi}{2}\cdot\left(1-x\right)\right)^{n}"
            minSpeed = 30,              -- the speed to start rotating velocity to look dir
            maxSpeed = 55,              -- the speed is above this, percent will be at its max
        },

        rebound = nil,                      -- allows the player to bounce off the ground if they hit jump as they hit the ground
        -- rebound =
        -- {
        --     percent_at_zero = 1.5,       -- the percent of Z part of velocity to bebound with when speed along Z is zero
        --     percent_at_max = 0.8,        -- the percent to use at a high impact speed
        --     speed_of_max = 40,           -- the speed where percent_at_max should be applied.  Any speed higher than this will also use percent_at_max
        -- },
    }
end

function this.Realism(mode, sounds_thrusting, const)
    mode.name = "realism"

    mode.useImpulse = true

    mode.energy.maxBurnTime = 3.5

    mode.accel.horz_stand = 1.2
    mode.accel.horz_dash = 3
    mode.accel.vert_stand = 1.5
    mode.accel.vert_dash = 6

    mode.accel.vert_initial = 4

    mode.accel.gravity = -12

    mode.jump_land.shouldSafetyFire = false      -- NOTE: the terminal velocity animation seems to interfere with jetpack activation, so use the jetpack before falling too much
end

function this.WellRounded(mode, sounds_thrusting, const)
    mode.name = "well rounded"

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

    mode.rmb_extra = RMB_Hover:new(10, 6, 2, 1, 9999, mode.useImpulse, mode.accel.gravity, sounds_thrusting, const)

    mode.sound_type = const.thrust_sound_type.steam_quiet
end

function this.JetTrooper(mode, sounds_thrusting, const)
    mode.name = "jet trooper"

    -- Extra fuel, but still somewhat constrained
    mode.energy.maxBurnTime = 18
    mode.energy.recoveryRate = 0.8

    -- Slow things down for air superiority
    mode.accel.gravity = -3
    mode.timeSpeed = 0.33

    mode.accel.vert_stand = 1.5
    mode.accel.vert_dash = 3

    mode.accel.vert_initial = 2

    mode.rmb_extra = RMB_Hover:new(2, 2, 0.4, 0.3, 12, mode.useImpulse, mode.accel.gravity, sounds_thrusting, const)

    mode.sound_type = const.thrust_sound_type.steam_quiet
end

function this.Airplane(mode, sounds_thrusting, const)
    mode.name = "airplane"

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

    mode.rmb_extra = RMB_Hover:new(12, 6, 2, 1, 9999, mode.useImpulse, mode.accel.gravity, sounds_thrusting, const)

    mode.rotateVel.is_used = true

    mode.sound_type = const.thrust_sound_type.steam_quiet
end

function this.NPCLauncher(mode, sounds_thrusting, const)
    mode.name = "npc launcher"       -- telekinetic eyeball

    mode.useImpulse = true

    mode.energy.maxBurnTime = 12
    mode.energy.recoveryRate = 1.2

    mode.accel.gravity = -1
    mode.accel.vert_stand = 3.5

    mode.rmb_extra = RMB_PushUp:new(22, 6, 8, 60, const)      -- the burn rate is only applied for one frame, so need something large

    mode.sound_type = const.thrust_sound_type.levitate
end

function this.HulkStomp(mode, sounds_thrusting, const)
    mode.name = "hulk stomp"

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

    -- Give infinite fuel
    mode.energy.maxBurnTime = 0.8
    mode.energy.burnRate_dash = 1
    mode.energy.burnRate_horz = 0.2
    mode.energy.recoveryRate = 0.1

    -- Slow things down, like it's a dream
    mode.accel.gravity = -2

    mode.timeSpeed_gradient =               -- this defines bullet time based on abs(vel.z)
    {
        timeSpeed_lowZSpeed = 0.05,          -- the bullet time to use when z speed is lower than this
        lowZSpeed = 2,

        timeSpeed_highZSpeed = 0.9,
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

function this.AdjustAccelForGravity(mode)
    -- The vertical accelerations need to defeat gravity
    if mode.useImpulse then
        mode.accel.vert_stand = this.GetAccelAdjustedForGravity_Impulse(mode.accel.vert_stand, mode)
        mode.accel.vert_dash = this.GetAccelAdjustedForGravity_Impulse(mode.accel.vert_dash, mode)
    end
end

-- Increases/Decreases accel to cancel out gravity
function this.GetAccelAdjustedForGravity_Impulse(accel, mode)
    if mode.useImpulse then
        local extra = 16 + mode.accel.gravity      -- if gravity is 16, then this is zero.  If gravity is higher, then this is some negative amount
        return accel + 16 - extra
    else
        return accel
    end
end

function this.CloneTable_CurrentLayer(table)
    local retVal = {}

    for key, value in pairs(table) do
        retVal[key] = value
    end

    return retVal
end

return ModeDefaults