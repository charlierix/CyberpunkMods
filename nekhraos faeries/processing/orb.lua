Orb = {}

function Orb:new(o, pos)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.props =
    {
        o = o,
        pos = pos,
        vel = Vector4.new(0, 0, 0, 1),
    }

    obj.limits =
    {
        min_speed = 0.5,
        max_speed = 4,
        max_dist_player = 12,
        max_accel = 1.5,

        boundary_percent_start = 0.75,
        speed_percent_start = 0.8,

        maxbyspeed =
        {
            percent_start = 7,

            speed_mult_rate = 1.5,
            speed_mult_cap = 6,

            dist_mult_rate = 1.333,
            dist_mult_cap = 3,
        },
        maxbydist =
        {
            speed_mult_rate = 1.6667,
            speed_mult_cap = 12,
        },
    }

    obj.ai = Orb_AI:new(obj.props)
    obj.audiovisual = Orb_AudioVisual:new(obj.props)
    obj.swarm = Orb_Swarm:new(obj.props, obj.limits)

    obj.create_time = o.timer

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