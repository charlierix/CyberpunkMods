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

    return obj
end

function InputTracker_StartStop:Tick()
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

-- Returns
--  isHangDown, isJumpDown
function InputTracker_StartStop:GetButtonState()
    -- Hang doesn't care how long the button has been held down
    local isHangDown = false

    if self.vars.wallhangkey_usecustom then
        isHangDown = self.keys.custom_hang
    else
        isHangDown = self.keys.hang
    end

    -- Jump only reports true if it was very recently pressed
    local isJumpDown = false

    if self.jump_downTime and self.o.timer - self.jump_downTime <= self.max_jump then       -- jump_downTime is only populated when keys.jump is true
        isJumpDown = true
    end

    return isHangDown, isJumpDown
end