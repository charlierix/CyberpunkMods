Keys = {}

function Keys:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.proceed = false
    obj.prev_proceed = false

    return obj
end

-- This gets called whenever an input action occurs (mouse movement, key press/release)
function Keys:MapAction(action)
    local actionName = Game.NameToString(action:GetName())

    if actionName == "proceed" then
        local actionType = action:GetType()
        local pressed = actionType == gameinputActionType.BUTTON_PRESSED
        local released = actionType == gameinputActionType.BUTTON_RELEASED

        if pressed then
            self.proceed = true
        elseif released then
            self.proceed = false
        end
    end
end

function Keys:Tick()
    self.prev_proceed = self.proceed
end