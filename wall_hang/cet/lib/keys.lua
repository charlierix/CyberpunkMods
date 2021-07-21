Keys = {}

local this = {}

function Keys:new(o, hangAction)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o

    -- hardcoded keys (explicit propertes to make it easy to code against)
    obj.mouse_x = 0

    obj.forward = false
    obj.backward = false
    obj.left = false
    obj.right = false
    obj.jump = false
    obj.hang = false
    obj.custom = false      -- this is set from PressedCustom()

    obj.prev_forward = false
    obj.prev_backward = false
    obj.prev_left = false
    obj.prev_right = false
    obj.prev_jump = false
    obj.prev_hang = false
    obj.prev_custom = false

    -- This is a mapping between action name and the hardcoded properties above (the strings must match exactly)
    -- Key is the actionName, value is self.xxx
    obj.hardcodedMapping =
    {
        Forward = "forward",
        Back = "backward",
        Left = "left",
        Right = "right",
        Jump = "jump",
        --QuickMelee = "hang",       -- Q
    }

    if hangAction then
        obj.hardcodedMapping[hangAction] = "hang"
    end

    return obj
end

-- This gets called whenever an input action occurs (mouse movement, key press/release)
function Keys:MapAction(action)
    local actionName = Game.NameToString(action:GetName())
    local actionType = action:GetType(action).value
    local pressed = actionType == "BUTTON_PRESSED"
    local released = actionType == "BUTTON_RELEASED"

    --print(actionName .. ", pressed: " .. tostring(pressed) .. ", released: " .. tostring(released))

    self:MapAction_Fixed(action, actionName, pressed, released)
end

function Keys:PressedCustom(isDown)
    self.custom = isDown
end

function Keys:Tick()
    for _, propName in pairs(self.hardcodedMapping) do
        self["prev_" .. propName] = self[propName]
    end

    self.prev_custom = self.custom
end

----------------------------------- Private Methods -----------------------------------

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