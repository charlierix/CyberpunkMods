InputTracker_StartStop = {}

function InputTracker_StartStop:new(o, vars, keys, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.max_jump = 0.1

    obj.o = o
    obj.vars = vars
    obj.keys = keys
    obj.const = const

    obj.jump_downTime = nil
    obj.saw_jump = false        -- this is a latch so jump is only reported the first time (when they hold in the jump key)

    obj.hang_latched = false

    obj.relatch_time = nil
    obj.relatch = nil

    return obj
end

function InputTracker_StartStop:Tick()
    -- Hang
    if self.const.latch_wallhang then
        -- This matches logic in GetButtonState, but only flips the bit on keydown
        if self.keys.custom_hang and not self.keys.prev_custom_hang then
            self.hang_latched = not self.hang_latched
        elseif not self.vars.wallhangkey_usecustom and self.keys.hang and not self.keys.prev_hang then
            self.hang_latched = not self.hang_latched
        end
    end

    -- Jump
    if not self.saw_jump and self.keys.jump and not self.jump_downTime then
        self.jump_downTime = self.o.timer
        self.saw_jump = true
    else
        self.jump_downTime = nil
    end

    if not self.keys.jump then
        self.saw_jump = false
    end
end

function InputTracker_StartStop:EnteringHang()
    self.hang_latched = true        -- when coming from a relatch (from a jump), this needs to be explicitly set
    self.relatch_time = nil
    self.relatch = nil
end

function InputTracker_StartStop:ResetHangLatch()
    self.hang_latched = false
    self.relatch_time = nil
    self.relatch = nil
end

function InputTracker_StartStop:SetRelatchTime(relatch)
    self.relatch_time = self.o.timer + relatch.time_seconds
    self.relatch = relatch
end
function InputTracker_StartStop:ClearRelatchTime()
    self.relatch_time = nil
    self.relatch = nil
end

-- Returns
--  isHangDown, isJumpDown, isShiftDown, wallattract
function InputTracker_StartStop:GetButtonState()
    -- Hang doesn't care how long the button has been held down
    local isHangDown = false
    local wallattract = nil

    if self.const.latch_wallhang then
        isHangDown = self.hang_latched
    else
        if self.keys.custom_hang then       -- don't want to force the checkbox to be checked.  From the user's perspective, they assigned a custom key, they're pressing that key.  How do they know to look two screens deep to also check some checkbox?
            isHangDown = true
        elseif not self.vars.wallhangkey_usecustom and self.keys.hang then      -- this looks at the checkbox==false, because the only way for it to be checked is if they checked it
            isHangDown = true
        end
    end

    if self.relatch_time and self.o.timer >= self.relatch_time then
        isHangDown = true       -- relatch will pretend that they've pressed the latch key
        wallattract = self.relatch      -- this is used to override the default wall attraction (wallattract will probably be stronger than default)
    end

    -- Jump only reports true if it was very recently pressed
    local isJumpDown = false

    if self.jump_downTime and self.o.timer - self.jump_downTime <= self.max_jump then       -- jump_downTime is only populated when keys.jump is true
        isJumpDown = true
    end

    local isShiftDown = false
    if self.keys.shift then
        isShiftDown = true
    end

    return isHangDown, isJumpDown, isShiftDown, wallattract
end