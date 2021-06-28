Keys2 = {}

local this = {}

function Keys2:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.current = {}
    obj.prev = {}

    return obj
end

-- This gets called whenever an input action occurs (mouse movement, key press/release)
function Keys2:MapAction(action)
    local actionName = Game.NameToString(action:GetName())

    if this.ShouldExclude(actionName) then
        do return end
    end

    local actionType = action:GetType(action).value
    local pressed = actionType == "BUTTON_PRESSED"      -- there are quite a few more action types, but these two are the only ones that matter for keypress input
    local released = actionType == "BUTTON_RELEASED"

    if pressed then
        self.current[actionName] = true
    elseif released then
        self.current[actionName] = false
    end
end

function Keys2:Tick()
    for key, value in pairs(self.current) do
        self.prev[key] = value
    end
end

----------------------------------- Private Methods -----------------------------------

local exclude_whole =
{
    "CameraMouseX",
    --"mouse_left",     -- allow this
    "click",
    "one_click_confirm",
    "proceed",
    "UseCombatGadget",
    "Choice1",
    "Choice1_Release",
    "Choice2",
    "ChoiceApply",
    "vendor_checkout",
    "SwitchItem",
    "WeaponWheel",
    "SelectWheelItem",
    "back",
    "cancel",
    "close_tutorial",
    "Exit",
    --"track_quest",
}

local exclude_startswith =
{
    "Melee",
    "Ranged",
    "ChoiceScroll",
    "Notification",
    "UI_",
    "option_switch_",
    "popup_",
    "world_map_",
}

local exclude_endswith =
{
    "Menu",
    "PhotoMode",
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

    for i = 1, #exclude_endswith do
        if this.EndsWith(actionName, exclude_endswith[i]) then
            return true
        end
    end

    return false
end

function this.StartsWith(text, prefix)
    --return text:find(prefix, 1, true) == 1        -- don't use find, it's a regex variant, and would require escaping
    --return string.sub(text, 1, string.len(prefix)) == prefix
    return text:sub(1, #prefix) == prefix
end
function this.EndsWith(text, suffix)
    return text:sub(-#suffix) == suffix
end