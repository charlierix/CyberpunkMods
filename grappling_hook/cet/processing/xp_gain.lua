local pool_max = 144 * 3
local pool_refill_rate = pool_max / (18 * 60)   -- refill in 18 minutes
local minPoolRequestPercent = 1 / 12            -- even when the pool is empty, they can still get a tiny amount of xp from performing actions

local gain_straight_start = 12
--local gain_straight_continuous = 0.3
local gain_airdash_continuous = 1 / 24          -- gain per second

local gain_achievement_straight_180 = 48        -- when the dot product between the start of the grapple and current is nearly -1 (they use grapple to reverse their direction)
local gain_achievement_straight_quad = 6        -- 4 grapples in a row
local gain_achievement_straight_cheatdeath = 18 -- grapple when vel.z < -40
local gain_achievement_straight_triple180 = 288 -- 3 180s in a single grapple

local final_percent = 1 / 12                    -- the pool and gains are stored as integers to be easy to think about.  This converts from those units into what the xp will actually be incremented by

XPGain = {}

function XPGain:new(o, vars, debug, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.vars = vars
    obj.debug = debug
    obj.const = const

    -- These are set in PlayerCreated()
    --self.player
    --self.experience

    -- These are used to see how long a desired save has been pending.  It is nil until needed (then goes back to
    -- nil once the save occurs)
    --self.elapsed_any
    --self.elapsed_one

    --self.pool = 0

    -- Used to keep track of their current flight state
    --self.prev_flighMode

    return obj
end

function XPGain:Tick(deltaTime)
    if not self.player then
        self.debug.pending_xp = nil
        do return end
    end

    self:RefillPool(deltaTime)

    local baseGain = self:GetBaseGain(deltaTime)

    if not IsNearZero(baseGain) then
        local poolReducedGain = baseGain * self:GetPercentFromPool(baseGain)

        self:AddExperience(poolReducedGain * final_percent)
    end

    --TODO: if there is xp that needs to be saved, but < 1.  Save anyway after X minutes (probably about 4 minutes)
    --TODO: Remove old player rows (just keep the last 12 of each playerID)
    if self:ShouldSave(deltaTime) then
        self:SaveExperience()
    end

    if self.const.shouldShowDebugWindow then
        self:LogDebug()
    end
end

-- Call this when loading a new save
function XPGain:Clear()
    self.player = nil
    self.experience = 0
    self.elapsed_any = nil
    self.elapsed_one = nil
    self.pool = 0
    self.prev_flighMode = self.const.flightModes.standard       -- it may not be this (almost certainly is though), but there's no better constant to assume
end

-- This resets the class whe the player is loaded
function XPGain:PlayerCreated(player)
    self:Clear()
    self.player = player
end

------------------------------------ Private Instance Methods -----------------------------------

function XPGain:RefillPool(deltaTime)
    self.pool = self.pool + (pool_refill_rate * deltaTime)

    if self.pool > pool_max then
        self.pool = pool_max
    end
end

-- This looks at what they are currently doing and returns how much xp they should receive
function XPGain:GetBaseGain(deltaTime)
    local retVal = 0

    if self.vars.flightMode == self.const.flightModes.flight then

        --TODO: when grapple swing is implemented, this needs to determine swing vs straight (look at current index in vars)

        if self.prev_flighMode ~= self.const.flightModes.flight then
            -- Start straight grapple
            retVal = retVal + gain_straight_start

        -- Not doing a continuous xp gain.  It would be too easy to exploit by just hanging there
        -- else
        --     -- Continue straight grapple
        --     retVal = retVal + (gain_straight_continuous * deltaTime)
        end

    elseif self.vars.flightMode == self.const.flightModes.airdash then
        -- Continue airdash
        retVal = retVal + (gain_airdash_continuous * deltaTime)
    end

    --TODO: Detect achievements.  Would also need to limit them to once a day (or every couple hours)

    self.prev_flighMode = self.vars.flightMode

    return retVal
end

-- This returns a percent based on how full the pool is (calling this reduces the pool.  Only time increases
-- the pool)
function XPGain:GetPercentFromPool(gain)
    -- This is a way to reduce xp gain from repeated grapples.  That way they can't just sit there an grapple
    -- over and over to get xp.  They have to wait a while
    local currentPoolPercent = self.pool / pool_max

    self.pool = self.pool - gain

    if self.pool < 0 then
        self.pool = 0
    end

    return minPoolRequestPercent + (currentPoolPercent * (1 - minPoolRequestPercent))
end

-- This adds experience, returns true if the accumulated xp should be saved off
function XPGain:AddExperience(deltaTime)
    self.experience = self.experience + 0.03 * deltaTime

    if not self.elapsed_any then
        self.elapsed_any = self.o.timer
    end
end

function XPGain:ShouldSave(deltaTime)
    if self.elapsed_any and self.o.timer - self.elapsed_any >= 6 * 60 then
        -- There has been a small amount of xp pending for a few minutes.  Autosave before it's lost
        return true
    end

    if self.experience < 1 then
        return false
    end

    -- It needs to save, but not mid grapple
    if self.vars.flightMode ~= self.const.flightModes.standard then
        self.elapsed_one = nil      -- reset the timer.  They need to be walking around for a bit before getting hit with a potential db lag
        return false
    end

    -- Increment timer
    if self.elapsed_one then
        self.elapsed_one = self.elapsed_one + deltaTime
    else
        self.elapsed_one = 0
    end

    return self.elapsed_one > 1.5       -- hopefully at this point, they are just walking around
end

function XPGain:SaveExperience()
    self.player.experience = self.player.experience + self.experience

    self.experience = 0
    self.elapsed_any = nil
    self.elapsed_one = nil

    self.player:Save()
end

function XPGain:LogDebug()
    self.debug.xp_pending = Round(self.experience, 3)
    self.debug.xp_pool = Round(self.pool, 1)
    self.debug.xp_poolPercent = Round((self.pool / pool_max) * 100, 1)

    if self.elapsed_any then
        self.debug.xp_elapsed_any = Round(self.o.timer - self.elapsed_any)
    else
        self.debug.xp_elapsed_any = nil
    end

    if self.elapsed_one then
        self.debug.xp_elapsed_one = Round(self.o.timer - self.elapsed_one, 2)
    else
        self.debug.xp_elapsed_one = nil
    end
end