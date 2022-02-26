Keys = {}

function Keys:new(debug, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.debug = debug
    obj.const = const

    obj.cycleModes = false      --NOTE: This is a hotkey, and is set to true in init.lua

    obj.mouse_x = 0

    obj.analog_x = 0        -- this is a controller's analog stick
    obj.analog_y = 0

    obj.jump = false
    obj.rmb = false

    obj.prev_jump = false
    obj.prev_rmb = false

    return obj
end

function Keys:MapAction(action)
    local actionName = Game.NameToString(action:GetName())
    local actionType = action:GetType(action).value
    local pressed = actionType == "BUTTON_PRESSED"
    local released = actionType == "BUTTON_RELEASED"

    -- This fires from controller's left thumbsick as well as ASDW
    if actionName == "MoveX" then       -- actionType: "AXIS_CHANGE"
        self.analog_x = action:GetValue(action)

    elseif actionName == "MoveY" then
        self.analog_y = action:GetValue(action)
    end

    if actionName == "CameraMouseX" then        -- actionType: "RELATIVE_CHANGE"
        self.mouse_x = action:GetValue(action)

    elseif actionName == "right_stick_x" then       -- actionType: "AXIS_CHANGE"
        self.mouse_x = action:GetValue(action) * self.const.rightstick_sensitivity
    end

    --NOTE: This mostly duplicates the MoveX, MoveY above, but it ensures that keyboard movement is reliable
    if actionName == "Forward" then
        if pressed then
            self.analog_y = 1
        elseif released then
            self.analog_y = 0
        end

    elseif actionName == "Back" then
        if pressed then
            self.analog_y = -1
        elseif released then
            self.analog_y = 0
        end

    elseif actionName == "Left" then
        if pressed then
            self.analog_x = -1
        elseif released then
            self.analog_x = 0
        end

    elseif actionName == "Right" then
        if pressed then
            self.analog_x = 1
        elseif released then
            self.analog_x = 0
        end

    elseif actionName == "Jump" then
        if pressed then
            self.jump = true
        elseif released then
            self.jump = false
        end

    --elseif (actionName == "CameraAim") or (actionName == "RangedADS") or (actionName == "MeleeBlock") then
    elseif actionName == "cancel" or actionName == "CameraAim" then     -- looks like CameraAim no longer fires in 1.5
        if pressed then
            self.rmb = true
        elseif released then
            self.rmb = false
        end
    end
end

function Keys:Tick()
    self.cycleModes = false     -- this is a hotkey, so needs to be manually turned off after one tick

    self.prev_jump = self.jump
    self.prev_rmb = self.rmb
end