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
    obj.custom_hang = false      -- this is set from PressedCustom()

    obj.prev_forward = false
    obj.prev_backward = false
    obj.prev_left = false
    obj.prev_right = false
    obj.prev_jump = false
    obj.prev_hang = false
    obj.prev_custom_hang = false

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

    -- This is a list that holds action names that are currently in a pressed state.  It is only managed between
    -- calls to StartWatching and StopWatching (used by the input bindings window)
    obj.watching = {}
    obj.isWatching = false
    obj.isWatching_latch = false        -- while latching, this won't remove unpressed buttons.  Without this, the input binding will miss quickly pressed buttons

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

    if self.isWatching then
        self:MapAction_Watching(actionName, pressed, released)
    end
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

function Keys:PressedCustom_Hang(isDown)
    self.custom_hang = isDown
end

function Keys:Tick()
    for _, propName in pairs(self.hardcodedMapping) do
        self["prev_" .. propName] = self[propName]
    end

    self.prev_custom_hang = self.custom_hang

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

function Keys:StartWatching()
    self.isWatching = true
    self.isWatching_latch = false
    self:ClearWatching()
end
function Keys:StopWatching()
    self.isWatching = false
    self.isWatching_latch = false
    self:ClearWatching()
end

--NOTE: These only make sense while inside of StartWatching/StopWatching
function Keys:StartLatchingWatched()
    self.isWatching_latch = true
    self:ClearWatching()
end
function Keys:StopLatchingWatched()
    self.isWatching_latch = false
    self:ClearWatching()
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

function Keys:MapAction_Watching(actionName, pressed, released)
    if pressed then
        if not this.ShouldExclude(actionName) and not self.watching[actionName] then
            self.watching[actionName] = self.o.timer
        end

    elseif released and not self.isWatching_latch then      -- only release when latch is false
        if not this.ShouldExclude(actionName) then
            self.watching[actionName] = nil
        end
    end
end

function Keys:ClearWatching()
    for key, _ in pairs(self.watching) do
        self.watching[key] = nil
    end
end

local exclude_whole =
{
    -- Left Click
    "MeleeAttack",
    "RangedAttack",
    "click",
    "mouse_left",

    -- Right Click
    "MeleeBlock",
    "RangedADS",

    -- A
    "UI_FakeMovement",
    "option_switch_prev",
    "option_switch_prev_settings",

    -- D
    "UI_Drop",
    "option_switch_next",
    "option_switch_next_settings",

    -- S,W        -- A and D filters also eliminated these

    -- Q
    "ChoiceScrollUp",
    "UI_MoveUp",
    "popup_moveUp",

    -- E
    "ChoiceScrollDown",
    "UI_MoveDown",
    "popup_moveDown",
    "IconicCyberware",
    "PickUpBodyFromTakedown",

    -- F
    "ChoiceApply",
    "Choice1_Release",
    "UI_Apply",
    "one_click_confirm",
    "track_quest",

    -- Space
    "UI_Skip",

    -- Arrow Left
    "UI_MoveLeft",
    "navigate_left",
    "popup_moveLeft",

    -- Arrow Right
    "UI_MoveRight",
    "navigate_right",
    "popup_moveRight",

    -- Arrow Up
    "UI_DialogFocus",
    "navigate_up",

    -- Arrow Down
    "navigate_down",

}
local exclude_startswith =
{
    "world_map_",           -- left click, right click (maybe more)
}

function this.ShouldExclude(actionName)
    for i = 1, #exclude_whole do
        if actionName == exclude_whole[i] then
            return true
        end
    end

    for i = 1, #exclude_startswith do
        if this.StartsWith(actionName, exclude_startswith[i]) then
            return true
        end
    end

    -- for i = 1, #exclude_endswith do
    --     if this.EndsWith(actionName, exclude_endswith[i]) then
    --         return true
    --     end
    -- end

    return false
end

function this.StartsWith(text, prefix)
    --return text:find(prefix, 1, true) == 1        -- don't use find, it's a regex variant, and would require escaping
    return text:sub(1, #prefix) == prefix
end
function this.EndsWith(text, suffix)
    return text:sub(-#suffix) == suffix
end