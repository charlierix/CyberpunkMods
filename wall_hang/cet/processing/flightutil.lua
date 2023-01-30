local up = nil      -- can't use vector4 before init

-- This will return true as long as there is some air below the player
function IsAirborne(o)
    return o:IsPointVisible(o.pos, Vector4.new(o.pos.x, o.pos.y, o.pos.z - 0.3, 1))
end