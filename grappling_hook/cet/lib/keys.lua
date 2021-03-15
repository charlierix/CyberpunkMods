Keys = { }

function Keys:new()
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    obj.cycleModes = false      --NOTE: This is a hotkey, and is set to true in init.lua

    obj.mouse_x = 0

    obj.forward = false
    obj.backward = false
    obj.left = false
    obj.right = false
    obj.jump = false
    obj.rmb = false

    obj.prev_forward = false
    obj.prev_backward = false
    obj.prev_left = false
    obj.prev_right = false
    obj.prev_jump = false
    obj.prev_rmb = false

    return obj
end

function Keys:MapAction(action)
    local actionName = Game.NameToString(action:GetName(action))
    local actionType = action:GetType(action).value
    local pressed = actionType == "BUTTON_PRESSED"
    local released = actionType == "BUTTON_RELEASED"

    --print("pressed: " .. tostring(pressed) .. ", released: " .. tostring(released))

    if actionName == "CameraMouseX" then
        self.mouse_x = tonumber(action:GetValue(action))
    else
        self.mouse_x = 0
    end

    if actionName == "Forward" then
        if pressed then
            self.forward = true
        elseif released then
            self.forward = false
        -- else
        --     print("Forward else: " .. actionType)
        end

    elseif actionName == "Back" then
        if pressed then
            self.backward = true
        elseif released then
            self.backward = false
        -- else
        --     print("Back else: " .. actionType)
        end

    elseif actionName == "Left" then
        if pressed then
            self.left = true
        elseif released then
            self.left = false
        -- else
        --     print("Left else: " .. actionType)
        end

    elseif actionName == "Right" then
        if pressed then
            self.right = true
        elseif released then
            self.right = false
        -- else
        --     print("Right else: " .. actionType)
        end

    elseif actionName == "Jump" then
        if pressed then
            self.jump = true
        elseif released then
            self.jump = false
        -- else
        --     print("Jump else: " .. actionType)
        end

    --elseif (actionName == "CameraAim") or (actionName == "RangedADS") or (actionName == "MeleeBlock") then
    elseif actionName == "CameraAim" then
        if pressed then
            self.rmb = true
        elseif released then
            self.rmb = false
        -- else
        --     print("CameraAim else: " .. actionType)
        end
    end
end

function Keys:Tick()
    self.cycleModes = false     -- this is a hotkey, so needs to be manually turned off after one tick

    self.prev_forward = self.forward
    self.prev_backward = self.backward
    self.prev_left = self.left
    self.prev_right = self.right
    self.prev_jump = self.jump
    self.prev_rmb = self.rmb
end
