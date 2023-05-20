Orb_AudioVisual = {}

function Orb_AudioVisual:new(props)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.props = props

    return obj
end

function Orb_AudioVisual:Tick(deltaTime)
    debug_render_screen.Add_Dot(self.props.pos, nil, "8FFF", nil, true, 6)

    local dist_sqr = GetVectorLengthSqr(SubtractVectors(self.props.pos, self.props.o.pos))
    if dist_sqr > 18 * 18 then
        debug_render_screen.Add_Circle2D(self.props.pos, 24, nil, "D5CEDB0F", nil, true, 1.5)
    end
end