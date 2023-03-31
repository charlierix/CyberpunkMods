Keys = {}

local this = {}

function Keys:new(o)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o

    -- hardcoded keys (explicit propertes to make it easy to code against)
    obj.mouse_x = 0

    obj.analog_x = 0        -- this is a controller's analog stick
    obj.analog_y = 0

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

    -- This is a list that holds action names that are currently in a pressed state.  It is only managed between
    -- calls to StartWatching and StopWatching (used by the input bindings window)
    obj.watching = {}
    obj.isWatching = false
    obj.isWatching_latch = false        -- while latching, this won't remove unpressed buttons.  Without this, the input binding will miss quickly pressed buttons

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
    local actionName = Game.NameToString(action:GetName())
    local actionType = action:GetType()
    local pressed = actionType == gameinputActionType.BUTTON_PRESSED
    local released = actionType == gameinputActionType.BUTTON_RELEASED

    --print(actionName .. ", pressed: " .. tostring(pressed) .. ", released: " .. tostring(released))

    self:MapAction_Movement(action, actionName, pressed, released)
    self:MapAction_Fixed(action, actionName, pressed, released)
    self:MapAction_List(actionName, pressed, released)

    if self.isWatching then
        self:MapAction_Watching(actionName, pressed, released)
    end
end

-- This is called from registerInput event.  It allows custom bindings to be treated like actions
-- Params
--  name    a unique name for the custom key (make sure it's not the same as one of the in game action names)
--  isDown  a bool
function Keys:MapCustomKey(name, isDown)
    local pressed = isDown
    local released = not isDown

    self:MapAction_List(name, pressed, released)

    if self.isWatching then
        self:MapAction_Watching(name, pressed, released)
    end
end

function Keys:Tick()
    for _, propName in pairs(self.hardcodedMapping) do
        self["prev_" .. propName] = self[propName]
    end

    for key, value in pairs(self.actions) do
        self.prev_actions[key] = value
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

function Keys:MapAction_Movement(action, actionName, pressed, released)
    -- This fires from controller's left thumbsick as well as ASDW
    if actionName == "MoveX" then       -- actionType: "AXIS_CHANGE"
        self.analog_x = tonumber(action:GetValue())

    elseif actionName == "MoveY" then
        self.analog_y = tonumber(action:GetValue())
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
    end
end

function Keys:MapAction_Fixed(action, actionName, pressed, released)
    if actionName == "CameraMouseX" then
        self.mouse_x = tonumber(action:GetValue())
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