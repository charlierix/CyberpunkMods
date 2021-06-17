Keys = {}

function Keys:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

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

    obj.forceFlight = false     -- this is set to true from a hotkey, but this class will still set it back to false each tick

    -- This is a mapping between action name and the hardcoded properties above (the strings must match exactly)
    obj.hardcodedMapping =
    {
        Forward = "forward",
        Back = "backward",
        Left = "left",
        Right = "right",
        Jump = "jump",
        CameraAim = "rmb",      -- "CameraAim" "RangedADS" "MeleeBlock"
    }

    return obj
end

-- This gets called whenever an input action occurs (mouse movement, key press/release)
function Keys:MapAction(action)
    local actionName = Game.NameToString(action:GetName())
    local actionType = action:GetType(action).value
    local pressed = actionType == "BUTTON_PRESSED"
    local released = actionType == "BUTTON_RELEASED"

    --print("pressed: " .. tostring(pressed) .. ", released: " .. tostring(released))

    self:MapAction_HardCoded(action, actionName, pressed, released)
end

function Keys:Tick()
    self.prev_forward = self.forward
    self.prev_backward = self.backward
    self.prev_left = self.left
    self.prev_right = self.right
    self.prev_jump = self.jump
    self.prev_rmb = self.rmb

    self.forceFlight = false        -- this is a hotkey, so needs to be manually turned off after one tick
end

----------------------------------- Private Methods -----------------------------------

function Keys:MapAction_HardCoded(action, actionName, pressed, released)
    if actionName == "CameraMouseX" then
        self.mouse_x = tonumber(action:GetValue(action))
    else
        self.mouse_x = 0
    end

    for key, value in pairs(self.hardcodedMapping) do
        if actionName == key then
            if pressed then
                self[value] = true
            elseif released then
                self[value] = false
            -- else
            --     print(actionName .. " else: " .. actionType)
            end

            do return end
        end
    end
end