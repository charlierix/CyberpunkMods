-- This is used when the user wants to grapple, but there's not enough energy.  It plays a failure
-- sound, and also flashes self.isProgressBarRed that the energy bar drawing looks at
--
-- This will stay in an inactive state most of the time (CET will leak memory if objects keep getting
-- created/killed)

Animation_LowEnergy = { }

-- "ui_tv_turn_on",                         -- too weak
-- "ui_generic_set_14_negative",            -- very quiet no (too weak)
-- "ui_generic_set_14_positive",            -- another good error tone (still too quiet)
-- "ui_tv_turn_off",                        -- also too weak
-- "q101_sc_06_troy_hits_hood",             -- no
-- "dev_doors_single_cabin_dex_end_open",   -- no
-- "test_ad_emitter_2_4",                   -- good, but not negative enough
-- "ui_hacking_access_denied"               -- too obnoxious

local SOUNDNAME = "q114_sc_04_saul_hugs"
local NUMPULSES = 3         -- number of times to make the progress bar red
local DURATION_ON = 0.33    -- how long to stay red each pulse
local DURATION_OFF = 0.25   -- delay between being red pulses

function Animation_LowEnergy:new(o)
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.isActive = false            -- goes true for a little bit while the animation should run
    obj.isProgressBarRed = false    -- this will alternate true/false a few times when active (controlled in tick)

    return obj
end

function Animation_LowEnergy:Tick()
    if not self.isActive then
        do return end
    end

    -- There's probably a way to calculate the on/off state with algebra, but a for loop is simple
    local deltaTime = 0

    for i=0, NUMPULSES + (NUMPULSES - 1) - 1 do
        local curOn = IsNearZero(i % 2)

        if curOn then
            deltaTime = deltaTime + DURATION_ON
        else
            deltaTime = deltaTime + DURATION_OFF
        end

        if self.startTime + deltaTime > self.o.timer then
            -- Inside the animation time.  Store the on/off state of the progress bar
            self.isProgressBarRed = curOn
            do return end
        end
    end

    -- The animation is finished.  Go back to an inactive state
    self.isActive = false
    self.isProgressBarRed = false
    self.o:StopSound(SOUNDNAME)
end

-- Call this to kick off the active state (when they try to grapple, but don't have enough energy)
function Animation_LowEnergy:ActivateAnimation()
    if self.isActive then
        self.o:StopSound(SOUNDNAME)
    end

    self.isActive = true
    self.isProgressBarRed = true
    self.startTime = self.o.timer

    self.o:PlaySound(SOUNDNAME)
end