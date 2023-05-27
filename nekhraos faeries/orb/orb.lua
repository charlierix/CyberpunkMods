Orb = {}

local next_token = 0

-- velocity is optional
function Orb:new(o, pos, vel)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    next_token = next_token + 1

    if not vel then
        vel = Vector4.new(0, 0, 0, 1)
    end

    obj.props =
    {
        id = next_token,
        o = o,
        pos = pos,
        vel = vel,
    }

    obj.limits = settings_util.Limits()
    obj.neighbors = settings_util.Neighbors()

    obj.ai = Orb_AI:new(obj.props)
    obj.audiovisual = Orb_AudioVisual:new(obj.props)
    obj.swarm = Orb_Swarm:new(obj.props, obj.limits, obj.neighbors)

    obj.create_time = o.timer
    obj.is_alive = true

    return obj
end

function Orb:Tick(eye_pos, look_dir, deltaTime)
    self.ai:Tick(deltaTime)
    self.swarm:Tick(deltaTime)
    self.audiovisual:Tick(eye_pos, look_dir, deltaTime)
end

function Orb:ShouldRemove()
    --return self.props.o.timer - self.create_time > 6 * 60
    return false
end