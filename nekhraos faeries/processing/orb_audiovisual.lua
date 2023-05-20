Orb_AudioVisual = {}

function Orb_AudioVisual:new(props)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.props = props

    return obj
end

function Orb_AudioVisual:Tick(eye_pos, look_dir, deltaTime)

    local color = nil
    if self.props.o:IsPointVisible(eye_pos, self.props.pos) then
        color = "8FFF"
    else
        color = "4E6BADDA"
    end

    debug_render_screen.Add_Dot(self.props.pos, nil, color, nil, true, 6)

    local dist_sqr = GetVectorLengthSqr(SubtractVectors(self.props.pos, self.props.o.pos))
    if dist_sqr > 18 * 18 then
        debug_render_screen.Add_Circle2D(self.props.pos, 24, nil, "D5CEDB0F", nil, true, 1.5)
    end
end