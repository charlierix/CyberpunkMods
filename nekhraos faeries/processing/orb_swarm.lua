Orb_Swarm = {}

function Orb_Swarm:new(props)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.props = props

    return obj
end

function Orb_Swarm:Tick(deltaTime)
end