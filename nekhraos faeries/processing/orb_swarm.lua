Orb_Swarm = {}

local this = {}

local MIN_SPEED = 2

function Orb_Swarm:new(props)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.props = props

    --obj.neighbors = StickyList:new()

    return obj
end

function Orb_Swarm:Tick(deltaTime)
    local accelX = 0
    local accelY = 0
    local accelZ = 0

    local accelX_boundry, accelY_boundry, accelZ_boundry = this.GetAccelBoundry()
    accelX = accelX + accelX_boundry
    accelY = accelY + accelY_boundry
    accelZ = accelZ + accelZ_boundry

    local had_neighbors, accelX_neighbors, accelY_neighbors, accelZ_neighbors = this.GetAccelNeighbors(self.neighbors)
    accelX = accelX + accelX_neighbors
    accelY = accelY + accelY_neighbors
    accelZ = accelZ + accelZ_neighbors

    local had_goals, accelX_goals, accelY_goals, accelZ_goals = this.GetAccelGoals()
    accelX = accelX + accelX_goals
    accelY = accelY + accelY_goals
    accelZ = accelZ + accelZ_goals

    local had_obstacles, accelX_obstacles, accelY_obstacles, accelZ_obstacles = this.GetAccelObstacles()
    accelX = accelX + accelX_obstacles
    accelY = accelY + accelY_obstacles
    accelZ = accelZ + accelZ_obstacles

    if not had_neighbors and not had_goals and not had_obstacles then
        local accelX_wander, accelY_wander, accelZ_wander = this.GetAccelWander()
        accelX = accelX + accelX_wander
        accelY = accelY + accelY_wander
        accelZ = accelZ + accelZ_wander
    end

    -- min/max velocity (relative to player's velocity).  max accel
    accelX, accelY, accelZ = this.AccelConstraints(accelX, accelY, accelZ)

    self.props.vel = Vector4.new(self.props.vel.x + accelX * deltaTime, self.props.vel.y + accelY * deltaTime, self.props.vel.z + accelZ * deltaTime, 1)
    self.props.pos = Vector4.new(self.props.pos.x + self.props.vel.x * deltaTime, self.props.pos.y + self.props.vel.y * deltaTime, self.props.pos.z + self.props.vel.z * deltaTime, 1)
end

---------------------------------- Get Accelerations ----------------------------------

function this.GetAccelBoundry()
    return 0, 0, 0
end

function this.GetAccelNeighbors(neighbors)
    --neighbors:Clear()
    --this.FindNeighbors(neighbors)


    return false, 0, 0, 0
end

function this.GetAccelGoals()
    return false, 0, 0, 0
end

function this.GetAccelObstacles()
    return false, 0, 0, 0
end

function this.GetAccelWander()

    -- use perlin noise based on self.props.o.timer

    -- -3 to 3 is arbitrary, use max accel

    return
        GetScaledValue(-3, 3, 0, 1, math.random()),
        GetScaledValue(-3, 3, 0, 1, math.random()),
        GetScaledValue(-3, 3, 0, 1, math.random())
end

function this.AccelConstraints(accelX, accelY, accelZ)
    return 0, 0, 0
end

----------------------------------- Private Methods -----------------------------------

function this.FindNeighbors(retVal)
    -- is part of pod: return all members of pod
    -- otherwise return the closest N neighbors in local cluster
end