local this = {}

XPGain = {}

function XPGain:new(o, vars, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.vars = vars
    obj.const = const

    -- These are set in PlayerCreated()
    --self.player
    --self.experience

    -- This is use to see how long a desired save has been pending.  It is nil until needed (then goes back to
    -- nil once the save occurs)
    --self.elapsed

    return obj
end

function XPGain:Tick(deltaTime)
    if not self.player then
        do return end
    end

    if self:ShouldSave(deltaTime) then
        self:SaveExperience()
    end

    if self.vars.flightMode == self.const.flightModes.airdash or self.vars.flightMode == self.const.flightModes.flight then
        self:AddExperience(deltaTime)
    else
        --self:CoolDown()
    end

    -- First Draft:
    --  purely length of time

    -- Second Draft:
    --  add a decay, so they can just hang there
    --  the decay needs time to fully reset, so they can't keep spamming grapple

    -- Third Draft:
    --  have a long term cooldown, so they don't just grapple every 30 seconds


    --TODO: Remove old player rows


end

-- Call this when loading a new save
function XPGain:Clear()
    self.player = nil
    self.experience = nil
    self.elapsed = nil
end

-- This resets the class the player
function XPGain:PlayerCreated(player)
    self.player = player
    self.experience = 0
    self.elapsed = nil
end

------------------------------------ Private Instance Methods -----------------------------------

-- This adds experience, returns true if the accumulated xp should be saved off
function XPGain:AddExperience(deltaTime)
    self.experience = self.experience + 0.03 * deltaTime
end

function XPGain:ShouldSave(deltaTime)
    if self.experience < 1 then
        return false
    end

    -- It needs to save, but not mid grapple
    if self.vars.flightMode ~= self.const.flightModes.standard then
        self.elapsed = nil      -- reset the timer.  They need to be walking around for a bit before getting hit with a potential db lag
        return false
    end

    -- Increment timer
    if self.elapsed then
        self.elapsed = self.elapsed + deltaTime
    else
        self.elapsed = 0
    end

    return self.elapsed > 1.5       -- hopefully at this point, they are just walking around
end

function XPGain:SaveExperience()
    self.player.experience = self.player.experience + self.experience
    self.experience = 0

    self.player:Save()
end

------------------------------------- Private Static Methods ------------------------------------
