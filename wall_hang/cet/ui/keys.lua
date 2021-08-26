Keys = {}

local this = {}

function Keys:new(o, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.const = const

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
    }

    -- This holds the action name as the key, bool for value (true is pressed)
    -- Only one of the set needs to be true for the wall hang to be considered true
    obj.hangActions = {}

    --QuickMelee = HANG,       -- Q
    -- if hangAction then
    --     obj.hardcodedMapping[hangAction] = HANG
    -- end

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

    self:MapAction_Hang(actionName, pressed, released)
end

-- If any of these actions are seen, it will be considered an instruction to hang
function Keys:SetHangActions(hangActions)
    self:ClearHangActions()

    if hangActions then
        for i = 1, #hangActions do
            self.hangActions[hangActions[i]] = false
        end
    end
end
function Keys:ClearHangActions()
    for key, _ in pairs(self.hangActions) do
        print("before remove")
        ReportTable(self.hangActions)

        self.hangActions[key] = nil

        print("")
        print("after remove")
        ReportTable(self.hangActions)
    end

    print("")
    print("after clear")
    ReportTable(self.hangActions)
end

function Keys:PressedCustom(isDown)
    self.custom = isDown
end

function Keys:Tick()
    for _, propName in pairs(self.hardcodedMapping) do
        self["prev_" .. propName] = self[propName]
    end

    self.prev_custom = self.custom

    self.prev_hang = self.hang

    -- Hang just needs one of them to be true (pressing a key will cause multiple actions to fire.  It would be
    -- difficult to programatically know which action is the best one, so just look for any)
    self.hang = false
    for _, value in pairs(self.hangActions) do
        if value == true then
            self.hang = true
            break
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function Keys:MapAction_Fixed(action, actionName, pressed, released)
    if actionName == "CameraMouseX" then        -- actionType: "RELATIVE_CHANGE"
        self.mouse_x = action:GetValue(action)

    elseif actionName == "right_stick_x" then       -- actionType: "AXIS_CHANGE"
        self.mouse_x = action:GetValue(action) * self.const.rightstick_sensitivity
    end

    for key, value in pairs(self.hardcodedMapping) do
        if actionName == key then
            if pressed then
                self[value] = true
            elseif released then
                self[value] = false
            end

            do return end
        end
    end
end

function Keys:MapAction_Hang(actionName, pressed, released)
    for key, _ in pairs(self.hangActions) do
        if key == actionName then
            if pressed then
                self.hangActions[key] = true
            elseif released then
                self.hangActions[key] = false
            end

            break
        end
    end
end