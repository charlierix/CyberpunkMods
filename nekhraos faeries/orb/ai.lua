Orb_AI = {}

--TODO: Move these constants to a class/json
local NEARBY_REFRESH_RATE = 0.5     -- how often to refresh the list of local items from map (seconds)


function Orb_AI:new(props, map)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.props = props
    obj.map = map

    obj.target_item = nil
    obj.pulled_target_time = 0

    --obj.

    return obj
end

function Orb_AI:Tick(deltaTime)

    -- Have a boredom meter

    -- If boredom is low, don't look for anything to do, just do standard swarmbot stuff

    -- As boredom rises, look for stuff on the map


    -- get nearby
    -- sort by combination of dot product and distance
    --self.map:GetNearby_ObjectiveItems()









end