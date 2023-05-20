Orb_AudioVisual = {}

function Orb_AudioVisual:new(props)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.props = props

    return obj
end

function Orb_AudioVisual:Tick(deltaTime)

    --TODO: draw a circle when distance > N

    debug_render_screen.Add_Dot(self.props.pos, nil, "8FFF", nil, true, 6)


end