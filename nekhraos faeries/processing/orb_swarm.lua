Orb_Swarm = {}

local this = {}

local MIN_SPEED = 2

function Orb_Swarm:new(props, limits)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.props = props
    obj.limits = limits

    --obj.neighbors = StickyList:new()

    -- These could be modified by ai, so that some weights take priority based on conditions
    obj.weight_neighbors = 1
    obj.weight_goals = 1
    obj.weight_obstacles = 1
    obj.weight_wander = 1

    obj.perlin_start_x = GetRandomVector_Spherical(0, 12)
    obj.perlin_start_y = GetRandomVector_Spherical(0, 12)
    obj.perlin_start_z = GetRandomVector_Spherical(0, 12)
    obj.perlin_dir_x = GetRandomVector_Spherical(0.1, 0.5)
    obj.perlin_dir_y = GetRandomVector_Spherical(0.1, 0.5)
    obj.perlin_dir_z = GetRandomVector_Spherical(0.1, 0.5)
    obj.start_time = props.o.timer

    return obj
end

function Orb_Swarm:Tick(deltaTime)
    local accelX = 0
    local accelY = 0
    local accelZ = 0

    local accelX_boundry, accelY_boundry, accelZ_boundry = this.GetAccelBoundary(self)
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

    local accelX_wander, accelY_wander, accelZ_wander = this.GetAccelWander(self)
    accelX = accelX + accelX_wander
    accelY = accelY + accelY_wander
    accelZ = accelZ + accelZ_wander

    -- min/max velocity (relative to player's velocity).  max accel
    accelX, accelY, accelZ = this.AccelConstraints(self, accelX, accelY, accelZ)

    self.props.vel = Vector4.new(self.props.vel.x + accelX * deltaTime, self.props.vel.y + accelY * deltaTime, self.props.vel.z + accelZ * deltaTime, 1)
    self.props.pos = Vector4.new(self.props.pos.x + self.props.vel.x * deltaTime, self.props.pos.y + self.props.vel.y * deltaTime, self.props.pos.z + self.props.vel.z * deltaTime, 1)
end

---------------------------------- Get Accelerations ----------------------------------

function this.GetAccelBoundary(self)
    local MIN_DIST = self.limits.max_dist_player * 0.75

    local to_player = SubtractVectors(self.props.o.pos, self.props.pos)
    local dist_sqr = GetVectorLengthSqr(to_player)

    if dist_sqr < MIN_DIST * MIN_DIST then
        return 0, 0, 0
    end

    local dist = math.sqrt(dist_sqr)

    -- 0 at 0.75, 1 at 1, 3 at 1.5
    local accel = 4 * dist - 3

    return
        to_player.x / dist * accel,
        to_player.y / dist * accel,
        to_player.z / dist * accel
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

function this.GetAccelWander(self)
    local time = self.props.o.timer - self.start_time

    local x = Perlin(self.perlin_start_x.x + self.perlin_dir_x.x * time, self.perlin_start_x.y + self.perlin_dir_x.y * time, self.perlin_start_x.z + self.perlin_dir_x.z * time)
    local y = Perlin(self.perlin_start_y.x + self.perlin_dir_y.x * time, self.perlin_start_y.y + self.perlin_dir_y.y * time, self.perlin_start_y.z + self.perlin_dir_y.z * time)
    local z = Perlin(self.perlin_start_z.x + self.perlin_dir_z.x * time, self.perlin_start_z.y + self.perlin_dir_z.y * time, self.perlin_start_z.z + self.perlin_dir_z.z * time)

    return
        GetScaledValue(-self.limits.max_accel, self.limits.max_accel, 0, 1, x),
        GetScaledValue(-self.limits.max_accel, self.limits.max_accel, 0, 1, y),
        GetScaledValue(-self.limits.max_accel, self.limits.max_accel, 0, 1, z)
end

function this.AccelConstraints(self, accelX, accelY, accelZ)
    local accel_sqr = (accelX * accelX) + (accelY * accelY) + (accelZ * accelZ)

    if accel_sqr <= self.limits.max_accel * self.limits.max_accel then
        return accelX, accelY, accelZ
    else
        local accel = math.sqrt(accel_sqr)

        return
            (accelX / accel) * self.limits.max_accel,
            (accelY / accel) * self.limits.max_accel,
            (accelZ / accel) * self.limits.max_accel
    end
end

----------------------------------- Private Methods -----------------------------------

function this.FindNeighbors(retVal)
    -- is part of pod: return all members of pod
    -- otherwise return the closest N neighbors in local cluster
end