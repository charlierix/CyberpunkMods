Keys = { }

function Keys:new()
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    obj.cycleModes = false      --NOTE: This is a hotkey, and is set to true in init.lua

    -- hardcoded keys (explicit propertes to make it easy to code against)
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

    -- key=ActionName value=isKeyDown
    obj.actions = {}
    obj.prev_actions = {}

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

-- These tell the class to track arbitrary action names
function Keys:AddAction(actionName)
    self.actions[actionName] = false
    self.prev_actions[actionName] = false
end
function Keys:RemoveAction(actionName)
    self.actions[actionName] = nil
    self.prev_actions[actionName] = nil
end
function Keys:ClearActions()
    self.actions = {}
    self.prev_actions = {}
end

-- This gets called whenever an input action occurs (mouse movement, key press/release)
function Keys:MapAction(action)
    local actionName = Game.NameToString(action:GetName(action))
    local actionType = action:GetType(action).value
    local pressed = actionType == "BUTTON_PRESSED"
    local released = actionType == "BUTTON_RELEASED"

    --print("pressed: " .. tostring(pressed) .. ", released: " .. tostring(released))

    self:MapAction_Fixed(action, actionName, pressed, released)
    self:MapAction_List(actionName, pressed, released)
end

function Keys:Tick()
    self.cycleModes = false     -- this is a hotkey, so needs to be manually turned off after one tick

    self.prev_forward = self.forward
    self.prev_backward = self.backward
    self.prev_left = self.left
    self.prev_right = self.right
    self.prev_jump = self.jump
    self.prev_rmb = self.rmb

    for key, value in pairs(self.actions) do
        self.prev_actions[key] = value
    end
end

----------------------------- Private Methods -----------------------------
function Keys:MapAction_Fixed(action, actionName, pressed, released)
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

function Keys:MapAction_List(actionName, pressed, released)
    for key, _ in pairs(self.actions) do
        if key == actionName then
            if pressed then
                self.actions[key] = true
            elseif released then
                self.actions[key] = false
            -- else
            --     print(actionName .. " else: " .. actionType)
            end

            do return end       -- no need to loop through the rest of the list
        end
    end
end