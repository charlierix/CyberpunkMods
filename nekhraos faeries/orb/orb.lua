Orb = {}

local next_token = 0

-- velocity is optional
function Orb:new(o, pos, vel, map)
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

    -- These are items in the world that the ai is interested in
    -- list of models\interested_item.cs
    obj.interested_items = StickyList:new()

    obj.goals = settings_util.Goals()
    obj.limits = settings_util.Limits()
    obj.neighbors = settings_util.Neighbors()
    obj.obstacles = settings_util.Obstacles()

    obj.ai = Orb_AI:new(obj.props, map, obj.interested_items, obj.goals)
    obj.audiovisual = Orb_AudioVisual:new(obj.props)
    obj.swarm = Orb_Swarm:new(obj.props, obj.interested_items, obj.goals, obj.limits, obj.neighbors, obj.obstacles)

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