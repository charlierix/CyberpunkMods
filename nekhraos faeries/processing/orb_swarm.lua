Orb_Swarm = {}

local this = {}

--TODO: rework this class, putting all the constants in a json, so it can be configured and stored in the db

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

    local max_speed, max_dist = this.GetMaxes_BySpeed(self)

    -- Get component accelerations
    local accelX_limits, accelY_limits, accelZ_limits, limits_percent, should_cap_accel = this.GetAccelLimits(self, rel_vel, rel_speed_sqr, max_speed, max_dist, log)

    local accelX_neighbors, accelY_neighbors, accelZ_neighbors, had_neighbors = this.GetAccelNeighbors(self.neighbors)

    local accelX_goals, accelY_goals, accelZ_goals, had_goals = this.GetAccelGoals()

    local accelX_obstacles, accelY_obstacles, accelZ_obstacles, had_obstacles = this.GetAccelObstacles()

    local accelX_wander, accelY_wander, accelZ_wander = this.GetAccelWander(self, log)

    -- Adjust multipliers based on certain conditions
    local mult_limits, mult_misc, mult_wander = this.GetCombineMults(limits_percent)

    local accelX =
        (accelX_limits * mult_limits) +
        (accelX_neighbors * mult_misc) +
        (accelX_goals * mult_misc) +
        (accelX_obstacles * mult_misc) +
        (accelX_wander * mult_wander)

    local accelY =
        (accelY_limits * mult_limits) +
        (accelY_neighbors * mult_misc) +
        (accelY_goals * mult_misc) +
        (accelY_obstacles * mult_misc) +
        (accelY_wander * mult_wander)

    local accelZ =
        (accelZ_limits * mult_limits) +
        (accelZ_neighbors * mult_misc) +
        (accelZ_goals * mult_misc) +
        (accelZ_obstacles * mult_misc) +
        (accelZ_wander * mult_wander)

    -- Possibly cap acceleration
    if should_cap_accel then
        accelX, accelY, accelZ = this.AccelConstraints(self, accelX, accelY, accelZ, log)
    end

    -- Apply Acceleration
    self.props.vel = Vector4.new(self.props.vel.x + accelX * deltaTime, self.props.vel.y + accelY * deltaTime, self.props.vel.z + accelZ * deltaTime, 1)
    self.props.pos = Vector4.new(self.props.pos.x + self.props.vel.x * deltaTime, self.props.pos.y + self.props.vel.y * deltaTime, self.props.pos.z + self.props.vel.z * deltaTime, 1)

    if log and limits_percent then
        log:Save("swarm snapshot")
    end
end

---------------------------------- Get Accelerations ----------------------------------

function this.GetMaxes_BySpeed(self)
    local SPEED_THRESHOLD = 7

    local speed_sqr = GetVectorLengthSqr(self.props.o.vel)

    if speed_sqr < SPEED_THRESHOLD * SPEED_THRESHOLD then
        return self.limits.max_speed, self.limits.max_dist_player
    end

    local speed = math.sqrt(speed_sqr)

    local speed_mult = GetScaledValue(1, 3, SPEED_THRESHOLD, SPEED_THRESHOLD * 6, speed)
    speed_mult = Clamp(1, 6, speed_mult)

    local dist_mult = GetScaledValue(1, 2, SPEED_THRESHOLD, SPEED_THRESHOLD * 6, speed)
    dist_mult = Clamp(1, 3, dist_mult)

    return
        self.limits.max_speed * speed_mult,
        self.limits.max_dist_player * dist_mult
end
function this.GetMaxSpeed_ByDistance(max_speed, dist_sqr, max_dist)
    if dist_sqr < max_dist * max_dist then
        return max_speed, nil
    end

    local dist = math.sqrt(dist_sqr)

    local speed_mult = GetScaledValue(1, 3, max_dist, max_dist * 2, dist)
    speed_mult = Clamp(1, 12, speed_mult)

    return
        max_speed * speed_mult,
        dist
end

function this.GetAccelLimits(self, rel_vel, rel_speed_sqr, max_speed, max_dist, log)
    local to_player = SubtractVectors(self.props.o.pos, self.props.pos)
    local dist_sqr = GetVectorLengthSqr(to_player)

    -- Allow a larger max speed based on how far away the orb is from the player.  I used low flying v to quickly escape an
    -- area.  Once I stopped, the orbs were 200 away and coming to me at their regular max speed
    local max_speed, dist = this.GetMaxSpeed_ByDistance(max_speed, dist_sqr, max_dist)

    local min_dist = max_dist * 0.75
    local min_speed = max_speed * 0.8

    if dist_sqr > min_dist * min_dist then
        if not dist then
            dist = math.sqrt(dist_sqr)
        end

        if rel_speed_sqr > min_speed * min_speed then
            local rel_speed = math.sqrt(rel_speed_sqr)

            if DotProduct3D(rel_vel, to_player) < 0 then
                -- Velocity is away from player while out of bounds.  Need to apply extra drag.  Without this, the orb accelerates toward
                -- the player to get back in bounds, but then overshoots, ending up in an oscillation
                local accelX_limit, accelY_limit, accelZ_limit, limit_percent = this.GetAccelLimits_BoundsSpeedingAway(self, rel_vel, min_speed, max_speed, rel_speed, to_player, min_dist, max_dist, dist)
                return accelX_limit, accelY_limit, accelZ_limit, limit_percent, false       -- the accel is capped inside the above function, don't cap it later

            else
                local accelX_boundary, accelY_boundary, accelZ_boundary, boundary_percent = this.GetAccelLimits_Bounds(self, to_player, dist, max_dist)
                local accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, maxspeed_percent = this.GetAccelLimits_Speed(self, rel_vel, min_speed, max_speed, rel_speed)

                return
                    accelX_boundary + accelX_maxspeed,
                    accelY_boundary + accelY_maxspeed,
                    accelZ_boundary + accelZ_maxspeed,
                    math.max(boundary_percent, maxspeed_percent),
                    true
            end

        else
            local accelX_boundary, accelY_boundary, accelZ_boundary, boundary_percent = this.GetAccelLimits_Bounds(self, to_player, dist, max_dist)
            return accelX_boundary, accelY_boundary, accelZ_boundary, boundary_percent, true
        end

    elseif rel_speed_sqr > min_speed * min_speed then
        local rel_speed = math.sqrt(rel_speed_sqr)
        local accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, maxspeed_percent = this.GetAccelLimits_Speed(self, rel_vel, min_speed, max_speed, rel_speed)
        return accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, maxspeed_percent, true

    else
        return 0, 0, 0, nil, true
    end
end
function this.GetAccelLimits_BoundsSpeedingAway(self, rel_vel, min_speed, max_speed, rel_speed, to_player, min_dist, max_dist, dist)
    local accel_speed = GetScaledValue(0, 1, min_speed, max_speed, rel_speed)
    accel_speed = Clamp(0, 12, accel_speed)     -- really letting it get big so the orb can turn around quickly
    accel_speed = accel_speed * self.limits.max_accel

    local accel_bounds = GetScaledValue(0, 1, min_dist, max_dist, dist)
    accel_bounds = Clamp(0, 1, accel_bounds)        -- this isn't as important as reversing speed
    accel_bounds = accel_bounds * self.limits.max_accel

    return
        ((rel_vel.x / rel_speed) * -accel_speed) + ((to_player.x / dist) * accel_bounds),
        ((rel_vel.y / rel_speed) * -accel_speed) + ((to_player.y / dist) * accel_bounds),
        ((rel_vel.z / rel_speed) * -accel_speed) + ((to_player.z / dist) * accel_bounds),
        math.max(rel_speed / max_speed, dist / max_dist)
end
function this.GetAccelLimits_Bounds(self, to_player, dist, max_dist)
    -- 0 at 0.75, 1 at 1, 3 at 1.5
    local accel = 4 * dist - 3
    accel = Clamp(0, 2, accel)
    accel = accel * self.limits.max_accel


    return
        (to_player.x / dist) * accel,
        (to_player.y / dist) * accel,
        (to_player.z / dist) * accel,
        dist / max_dist
end
function this.GetAccelLimits_Speed(self, rel_vel, min_speed, max_speed, rel_speed)
    local accel = GetScaledValue(0, 1, min_speed, max_speed, rel_speed)
    accel = Clamp(0, 2, accel)
    accel = accel * self.limits.max_accel

    return
        (rel_vel.x / rel_speed) * -accel,
        (rel_vel.y / rel_speed) * -accel,
        (rel_vel.z / rel_speed) * -accel,
        rel_speed / max_speed
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

function this.GetCombineMults(limits_percent)
    if limits_percent then
        local suppress_percent = GetScaledValue(0.9, 0.075, 1, 2.5, limits_percent)
        suppress_percent = Clamp(0.075, 1, suppress_percent)

        return 1, suppress_percent, suppress_percent
    else
        return 1, 1, 1
    end
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