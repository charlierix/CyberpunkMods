Orb_Swarm = {}

local this = {}

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

    obj.last_log_time = 0

    return obj
end

function Orb_Swarm:Tick(deltaTime)
    local log = nil
    -- if self.props.o.timer - self.last_log_time > 4 then
    --     self.last_log_time = self.props.o.timer
    --     log = DebugRenderLogger:new(true)
    --     log:DefineCategory("player", "F00")
    --     log:DefineCategory("orb", "0F4")
    -- end

    local rel_vel = SubtractVectors(self.props.vel, self.props.o.vel)
    local rel_speed_sqr = GetVectorLengthSqr(rel_vel)

    -- Get component accelerations

    local accelX_boundary, accelY_boundary, accelZ_boundary, boundary_percent = this.GetAccelBoundary(self, log)

    local accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, rel_speed, maxspeed_percent = this.GetAccelMaxSpeed(self, rel_vel, rel_speed_sqr, log)

    local accelX_neighbors, accelY_neighbors, accelZ_neighbors, had_neighbors = this.GetAccelNeighbors(self.neighbors)

    local accelX_goals, accelY_goals, accelZ_goals, had_goals = this.GetAccelGoals()

    local accelX_obstacles, accelY_obstacles, accelZ_obstacles, had_obstacles = this.GetAccelObstacles()

    local accelX_wander, accelY_wander, accelZ_wander = this.GetAccelWander(self, log)

    -- Adjust multipliers based on certain conditions
    local mult_boundary, mult_maxspeed, mult_misc, mult_wander = this.GetCombineMults(boundary_percent, maxspeed_percent, rel_speed_sqr, rel_speed)

    local accelX =
        (accelX_boundary * mult_boundary) +
        (accelX_maxspeed * mult_maxspeed) +
        (accelX_neighbors * mult_misc) +
        (accelX_goals * mult_misc) +
        (accelX_obstacles * mult_misc) +
        (accelX_wander * mult_wander)

    local accelY =
        (accelY_boundary * mult_boundary) +
        (accelY_maxspeed * mult_maxspeed) +
        (accelY_neighbors * mult_misc) +
        (accelY_goals * mult_misc) +
        (accelY_obstacles * mult_misc) +
        (accelY_wander * mult_wander)

    local accelZ =
        (accelZ_boundary * mult_boundary) +
        (accelZ_maxspeed * mult_maxspeed) +
        (accelZ_neighbors * mult_misc) +
        (accelZ_goals * mult_misc) +
        (accelZ_obstacles * mult_misc) +
        (accelZ_wander * mult_wander)

    -- Possibly cap acceleration
    accelX, accelY, accelZ = this.AccelConstraints(self, accelX, accelY, accelZ, log)

    -- Apply Acceleration
    self.props.vel = Vector4.new(self.props.vel.x + accelX * deltaTime, self.props.vel.y + accelY * deltaTime, self.props.vel.z + accelZ * deltaTime, 1)
    self.props.pos = Vector4.new(self.props.pos.x + self.props.vel.x * deltaTime, self.props.pos.y + self.props.vel.y * deltaTime, self.props.pos.z + self.props.vel.z * deltaTime, 1)

    if log and (boundary_percent or maxspeed_percent) then
        log:Save("swarm snapshot")
    end
end

---------------------------------- Get Accelerations ----------------------------------

function this.GetAccelBoundary(self, log)
    local MIN_DIST = self.limits.max_dist_player * 0.75

    local to_player = SubtractVectors(self.props.o.pos, self.props.pos)
    local dist_sqr = GetVectorLengthSqr(to_player)

    if log then
        log:NewFrame("boundary")
        log:Add_Dot(self.props.o.pos, "player")
        log:Add_Dot(self.props.pos, "orb")
        log:Add_Line(self.props.o.pos, self.props.pos)

        log:WriteLine_Frame("distance: " .. tostring(math.sqrt(dist_sqr)))
    end

    if dist_sqr < MIN_DIST * MIN_DIST then
        if log then
            log:WriteLine_Frame("less than min distance")
        end

        return 0, 0, 0, nil
    end

    local dist = math.sqrt(dist_sqr)

    -- 0 at 0.75, 1 at 1, 3 at 1.5
    local accel = 4 * dist - 3
    accel = accel * self.limits.max_accel

    if log then
        log:Add_Line(self.props.pos, AddVectors(self.props.pos, Vector4.new((to_player.x / dist) * accel, (to_player.y / dist) * accel, (to_player.z / dist) * accel, 1)), "orb", nil, 2)
        log:WriteLine_Frame("accel: " .. tostring(accel))
    end

    return
        (to_player.x / dist) * accel,
        (to_player.y / dist) * accel,
        (to_player.z / dist) * accel,
        dist / self.limits.max_dist_player
end

function this.GetAccelMaxSpeed(self, rel_vel, rel_speed_sqr, log)
    local MIN_SPEED = self.limits.max_speed * 0.8

    if log then
        log:NewFrame("max speed")
        log:Add_Dot(self.props.pos, "orb")
        log:Add_Line(self.props.pos, AddVectors(self.props.pos, rel_vel))
        log:WriteLine_Frame("speed: " .. tostring(math.sqrt(rel_speed_sqr)))
    end

    if rel_speed_sqr < MIN_SPEED * MIN_SPEED then
        if log then
            log:WriteLine_Frame("less than min speed")
        end

        return 0, 0, 0, nil, nil
    end

    local rel_speed = math.sqrt(rel_speed_sqr)

    local accel = GetScaledValue(0, self.limits.max_accel, MIN_SPEED, self.limits.max_speed, rel_speed)

    if log then
        log:Add_Line(self.props.pos, AddVectors(self.props.pos, Vector4.new((rel_vel.x / rel_speed) * -accel, (rel_vel.y / rel_speed) * -accel, (rel_vel.z / rel_speed) * -accel, 1)), "orb", nil, 2)
        log:WriteLine_Frame("accel: " .. tostring(accel))
    end

    return
        (rel_vel.x / rel_speed) * -accel,
        (rel_vel.y / rel_speed) * -accel,
        (rel_vel.z / rel_speed) * -accel,
        rel_speed,
        rel_speed / self.limits.max_speed
end

function this.GetAccelNeighbors(neighbors)
    --neighbors:Clear()
    --this.FindNeighbors(neighbors)


    return 0, 0, 0, false
end

function this.GetAccelGoals()
    return 0, 0, 0, false
end

function this.GetAccelObstacles()
    return 0, 0, 0, false
end

function this.GetAccelWander(self, log)
    local time = self.props.o.timer - self.start_time

    local x = Perlin(self.perlin_start_x.x + self.perlin_dir_x.x * time, self.perlin_start_x.y + self.perlin_dir_x.y * time, self.perlin_start_x.z + self.perlin_dir_x.z * time)
    local y = Perlin(self.perlin_start_y.x + self.perlin_dir_y.x * time, self.perlin_start_y.y + self.perlin_dir_y.y * time, self.perlin_start_y.z + self.perlin_dir_y.z * time)
    local z = Perlin(self.perlin_start_z.x + self.perlin_dir_z.x * time, self.perlin_start_z.y + self.perlin_dir_z.y * time, self.perlin_start_z.z + self.perlin_dir_z.z * time)

    if log then
        log:NewFrame("wander")
        log:WriteLine_Frame("perlin x: " .. tostring(x))
        log:WriteLine_Frame("perlin y: " .. tostring(y))
        log:WriteLine_Frame("perlin z: " .. tostring(z))
    end

    return
        GetScaledValue(-self.limits.max_accel, self.limits.max_accel, 0, 1, x),
        GetScaledValue(-self.limits.max_accel, self.limits.max_accel, 0, 1, y),
        GetScaledValue(-self.limits.max_accel, self.limits.max_accel, 0, 1, z)
end

function this.GetCombineMults(boundary_percent, maxspeed_percent, rel_speed_sqr, rel_speed)

    --TODO: when out of bounds and traveling toward player, don't accelerate beyond relative max speed




    return 1, 1, 1, 1
end

function this.AccelConstraints(self, accelX, accelY, accelZ, log)
    local accel_sqr = (accelX * accelX) + (accelY * accelY) + (accelZ * accelZ)

    if log then
        log:NewFrame("constraints")
        log:WriteLine_Frame("accel: " .. tostring(math.sqrt(accel_sqr)))
    end

    if accel_sqr <= self.limits.max_accel * self.limits.max_accel then
        if log then
            log:WriteLine_Frame("less than max")
        end

        return accelX, accelY, accelZ
    else
        if log then
            log:WriteLine_Frame("more than max")
        end

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