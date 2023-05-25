Orb_AI = {}

function Orb_AI:new(props)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.props = props

    return obj
end

function Orb_AI:Tick(deltaTime)
end