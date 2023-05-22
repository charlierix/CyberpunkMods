Orb = {}

local this = {}

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

    obj.limits = this.GetDefinition_Limits()

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

----------------------------------- Private Methods -----------------------------------

function this.GetDefinition_Limits()
    -- models\swarmbot_limits
    return
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

            speed_mult =
            {
                rate = 1.5,
                cap_min = 1,
                cap_max = 6,
            },

            dist_mult =
            {
                rate = 1.333,
                cap_min = 1,
                cap_max = 3,
            },
        },
        maxbydist =
        {
            speed_mult =
            {
                rate = 1.6667,
                cap_min = 1,
                cap_max = 12,
            },
        },

        outofbounds_speedingaway =
        {
            accel_mult_speed =      -- really letting it get big so the orb can turn around quickly
            {
                rate = 1,
                cap_min = 0,
                cap_max = 12,
            },
            accel_mult_bounds =     -- this isn't as important as reversing speed
            {
                rate = 1,
                cap_min = 0,
                cap_max = 1,
            }
        },
        outofbounds =
        {
            accel_mult =
            {
                rate = 4,
                cap_min = 0,
                cap_max = 2,
            },
        },
        overspeed =
        {
            accel_mult =
            {
                rate = 3,
                cap_min = 0,
                cap_max = 2,
            },
        },

        dragorthvelocity =
        {
            accel_mult =
            {
                rate = 0.15,
                cap_min = 0,
                cap_max = 0.6667,
            },
        },
    }
end