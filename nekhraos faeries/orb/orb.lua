Orb = {}

local this = {}

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

    obj.limits = this.GetDefinition_Limits()
    obj.neighbors = this.GetDefinition_Neighbors()

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

function this.GetDefinition_Neighbors()
    -- models\swarmbot_neighbors
    return
    {
        count = 3,
        search_radius = 8,

        nearbyscan_interval_seconds = 0.1,
        next_nearbyscan_time = -1,

        accel_percents =
        {
            center_project_seconds = 0.05,

            toward_flock_center =
            {
                animcurve_values =
                {
                    { input = 0, output = 0.1 },
                    { input = 1, output = 0.75 },
                    { input = 8, output = 0.2 },
                }
            },

            align_flock_velocity_speed =
            {
                animcurve_values =
                {
                    { input = 0, output = 0 },
                    { input = 1, output = 0.75 },
                    { input = 2, output = 1 },
                    { input = 4, output = 1.1 },
                }
            },

            align_flock_velocity_distance =
            {
                animcurve_values =
                {
                    { input = 0, output = 1 },
                    { input = 8, output = 0.1 },
                    { input = 16, output = 0 },
                }
            },

            drag_orth_flock_velocity_speed =
            {
                animcurve_values =
                {
                    { input = 0, output = 0 },
                    { input = 0.25, output = 0.15 },
                    { input = 0.5, output = 0.2 },
                    { input = 1, output = 0.22 },
                }
            },

            drag_orth_flock_velocity_distance =
            {
                animcurve_values =
                {
                    { input = 0, output = 1 },
                    { input = 8, output = 0.1 },
                    { input = 16, output = 0 },
                }
            },

            repel_other_orb =
            {
                animcurve_values =
                {
                    { input = 0, output = 0.8 },
                    { input = 1, output = 0.3 },
                    { input = 2, output = 0.15 },
                    { input = 4, output = 0 },
                }
            },

            repel_other_orb_velocitytoward =
            {
                animcurve_values =
                {
                    { input = 0, output = 2.5 },
                    { input = 1, output = 1.75 },
                    { input = 2, output = 0 },
                }
            },
        }
    }
end