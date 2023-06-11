Orb_Swarm = {}

local this = {}

local goal_util = require "orb/swarm_goals"
local limit_util = require "orb/swarm_limits"
local neighbor_util = require "orb/swarm_neighbors"

local SHOW_DEBUG = false
local set_debug_categories = false
local debug_categories = CreateEnum("SWARM_CappedAccel")

function Orb_Swarm:new(props, interested_items, goals, limits, neighbors)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    this.EnsureDebugCategoriesSet()

    obj.props = props
    obj.interested_items = interested_items
    obj.goals = goals
    obj.limits = limits
    obj.neighbors = neighbors

    obj.nearby_scan =
    {
        interval_seconds = 0.1,
        next_scan_time = -1,
    }

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

    local vel = self.props.o:Custom_CurrentlyFlying_GetVelocity(self.props.o.vel)

    local rel_vel = SubtractVectors(self.props.vel, vel)
    local rel_speed_sqr = GetVectorLengthSqr(rel_vel)

    -- Get component accelerations
    local accelX_limits, accelY_limits, accelZ_limits, limits_percent, should_cap_accel = limit_util.GetAccelLimits(self.props, self.limits, rel_vel, rel_speed_sqr)

    local accelX_obstacles, accelY_obstacles, accelZ_obstacles, had_obstacles = this.GetAccelObstacles()

    local accelX_neighbors, accelY_neighbors, accelZ_neighbors, had_neighbors = neighbor_util.GetAccelNeighbors(self.props, self.nearby_scan, self.neighbors, self.limits)

    local accelX_goals, accelY_goals, accelZ_goals, goal_percent = goal_util.GetAccelGoals(self.props, self.interested_items, self.goals, self.limits)

    local accelX_wander, accelY_wander, accelZ_wander = this.GetAccelWander(self, log)


    --TODO: rework this section a little.  Don't let neighbors+goals+wander exceed max accel (limits and obstacles can exceed)



    -- Adjust multipliers based on certain conditions
    local mult_limits, mult_misc, mult_wander = this.GetCombineMults(limits_percent)

    local accelX =
        (accelX_limits * mult_limits) +
        (accelX_obstacles * mult_misc) +
        (accelX_neighbors * mult_misc) +
        (accelX_goals * mult_misc) +
        (accelX_wander * mult_wander)

    local accelY =
        (accelY_limits * mult_limits) +
        (accelY_obstacles * mult_misc) +
        (accelY_neighbors * mult_misc) +
        (accelY_goals * mult_misc) +
        (accelY_wander * mult_wander)

    local accelZ =
        (accelZ_limits * mult_limits) +
        (accelZ_obstacles * mult_misc) +
        (accelZ_neighbors * mult_misc) +
        (accelZ_goals * mult_misc) +
        (accelZ_wander * mult_wander)

    accelX, accelY, accelZ = this.DetectNaN(accelX, accelY, accelZ)

    -- NOTE: I think capping acceleration was a flawed idea.  The individual components should respect max accel, and if they need to exceed that, there's a good reason
    -- It's not a flawed idea, it just needs to ignore limits and obstacles

    -- Possibly cap acceleration
    -- if should_cap_accel then
    --     accelX, accelY, accelZ = this.AccelConstraints(self, accelX, accelY, accelZ, log)
    -- end

    --this.DrawFreeBody(self.props.o, self.props.vel, accelX, accelY, accelZ)





    -- Apply Acceleration
    self.props.vel = Vector4.new(self.props.vel.x + accelX * deltaTime, self.props.vel.y + accelY * deltaTime, self.props.vel.z + accelZ * deltaTime, 1)
    self.props.pos = Vector4.new(self.props.pos.x + self.props.vel.x * deltaTime, self.props.pos.y + self.props.vel.y * deltaTime, self.props.pos.z + self.props.vel.z * deltaTime, 1)

    if log and limits_percent then
        log:Save("swarm snapshot")
    end
end

---------------------------------- Get Accelerations ----------------------------------

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

        if SHOW_DEBUG then
            debug_render_screen.Add_Text2D(nil, nil, "capping accel\r\nfrom: " .. tostring(Round(accel, 1)) .. "\r\nto: " .. tostring(Round(self.limits.max_accel, 1)), debug_categories.SWARM_CappedAccel)
        end

        return
            (accelX / accel) * self.limits.max_accel,
            (accelY / accel) * self.limits.max_accel,
            (accelZ / accel) * self.limits.max_accel
    end
end

----------------------------------- Private Methods -----------------------------------

function this.EnsureDebugCategoriesSet()
    if set_debug_categories then
        do return end
    end

    debug_render_screen.DefineCategory(debug_categories.SWARM_CappedAccel, "BA1F585F", "FFF", nil, true, nil, nil, 0.3, 0.3)

    set_debug_categories = true
end

function this.DetectNaN(accelX, accelY, accelZ)
    -- This stopped happening, not sure what was causing it

    -- if IsNaN(accelX) then
    --     -- This seems to happen after a json reload.  There's something about a shared instance that is causing failure
    --     -- Orb_Swarm:Tick NaN.  accelX_limits: 0 | accelX_neighbors: nan | accelX_goals: 0 | accelX_obstacles: 0 | accelX_wander: 0.57474585775138
    --     -- mult_limits: 1 | mult_misc: 1 | mult_wander: 1
    --     print("Orb_Swarm:Tick NaN.  accelX_limits: " .. tostring(accelX_limits) .. " | accelX_neighbors: " .. tostring(accelX_neighbors) .. " | accelX_goals: " .. tostring(accelX_goals) .. " | accelX_obstacles: " .. tostring(accelX_obstacles) .. " | accelX_wander: " .. tostring(accelX_wander))
    --     print("mult_limits: " .. tostring(mult_limits) .. " | mult_misc: " .. tostring(mult_misc) .. " | mult_wander: " .. tostring(mult_wander))

    --     -- It's always related to neighbors.  This time it wasn't a reload, just random chance
    --     print("self.props.pos: " .. vec_str(self.props.pos))
    --     for index, item in ipairs(self.nearby_scan.nearby) do
    --         print("[" .. tostring(index) .. "]: " .. tostring(item.dist_sqr) .. " | " .. vec_str(item.orb.props.pos))
    --     end
    -- end

    if IsNaN(accelX) then
        LogError("accelX is NaN")
        accelX = 0
    end
    if IsNaN(accelY) then
        LogError("accelY is NaN")
        accelY = 0
    end
    if IsNaN(accelZ) then
        LogError("accelZ is NaN")
        accelZ = 0
    end

    return accelX, accelY, accelZ
end

function this.DrawFreeBody(o, vel, accelX, accelY, accelZ)
    o:GetCamera()

    -- Get a rotation from player's look to Y up
    local look_horz = GetProjectedVector_AlongPlane_Unit(o.lookdir_forward, Vector4.new(0, 0, 1, 1))
    local quat_world_to_local = GetRotation(look_horz, Vector4.new(0, 1, 0, 1))

    local accel_local = RotateVector3D(Vector4.new(accelX, accelY, accelZ, 1), quat_world_to_local)




end