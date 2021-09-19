-- This holds values that have changes to be applied
--
-- Each window will need to create one instance of this class
--
-- Each time TransitionWindows_xxx is called, it calls changes:Clear()
--
-- While a window is showing, the user can change various properties.  Instead of directly applying
-- those changes to the model, the changes are added/subtracted here.  Then the user has the chance
-- to click OK or Cancel (dirty flag driven by whether things are stored here)
--
-- OK applies the changes and saves to db, Cancel just switches windows

Changes = {}

function Changes:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Changes:Clear()
    for key, _ in pairs(self) do        -- this seems to be ignoring __index
        self[key] = nil
    end
end

--NOTE: It's assumed that all values stored here are numeric, so these functions pretend that nothing stored is a zero

function Changes:Get(key)
    local value = self[key]

    if value then
        return value
    else
        return 0
    end
end

function Changes:Add(key, amount)
    local value = self:Get(key)

    self[key] = value + amount
end
function Changes:Subtract(key, amount)
    self:Add(key, -amount)
end

function Changes:IsDirty()
    for _, value in pairs(self) do
        if not IsNearZero(value) then
            return true
        end
    end

    return false
end