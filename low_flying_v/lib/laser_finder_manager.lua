

    --TODO: There needs to be another laser worker class that takes an offset quaternion
    --Each frame, it will be passed a position and current velocity
    --
    --It won't optimize to the nearest integer, it will fire as is
    --It will still have keys to pass to storage "from**dir"
    --
    --Because it's not optimized to the nearest integer, there won't be many of them
    --
    --This is to try to fix getting confused on skinny objects, like poles, trees



local laser_settings =
{
    -- Down
    down_rayLength = 6,
    down_accuracyThreshold = 0.5,
    down_stepDistance = 2,
    down_numSteps = 3,

    -- Up
    up_rayLength = 6,
    up_accuracyThreshold = 0.5,
    up_stepDistance = 1,
    up_numSteps = 1,

    -- Side
    side_rayLength = 6,
    side_accuracyThreshold = 0.5,
    side_stepDistance = 2,
    side_numSteps = 1,
}

LaserFinderManager = {}

-- This sets up the 6 workers (one for each direction facing)
--
-- It is also responsible for figuring out the center point of firing (based on player's
-- position and velocity)
--
-- If performance is an issue, then this should spread out the calls across threads
function LaserFinderManager:new(o, storage)
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.storage = storage

    -- passing nil for garbage collection uses default values
    obj.woker_elevated = LaserFinderWorker:new("down elevated", o, storage, Vector4.new(0,0,-1), laser_settings.down_rayLength, laser_settings.down_accuracyThreshold, 1, 1, nil, nil)      -- This is an extra worker that fires from a point above the other to reduce the chance of missing the ground (it can make a smaller patch)

    obj.worker_down = LaserFinderWorker:new("down", o, storage, Vector4.new(0,0,-1), laser_settings.down_rayLength, laser_settings.down_accuracyThreshold, laser_settings.down_stepDistance, laser_settings.down_numSteps, nil, nil)

    obj.workers_horz =
    {
        LaserFinderWorker:new("-x", o, storage, Vector4.new(-1,0,0), laser_settings.side_rayLength, laser_settings.side_accuracyThreshold, laser_settings.side_stepDistance, laser_settings.side_numSteps, nil, nil),
        LaserFinderWorker:new("x", o, storage, Vector4.new(1,0,0), laser_settings.side_rayLength, laser_settings.side_accuracyThreshold, laser_settings.side_stepDistance, laser_settings.side_numSteps, nil, nil),
        LaserFinderWorker:new("-y", o, storage, Vector4.new(0,-1,0), laser_settings.side_rayLength, laser_settings.side_accuracyThreshold, laser_settings.side_stepDistance, laser_settings.side_numSteps, nil, nil),
        LaserFinderWorker:new("y", o, storage, Vector4.new(0,1,0), laser_settings.side_rayLength, laser_settings.side_accuracyThreshold, laser_settings.side_stepDistance, laser_settings.side_numSteps, nil, nil),
    }

    obj.worker_up = LaserFinderWorker:new("up", o, storage, Vector4.new(0,0,1), laser_settings.up_rayLength, laser_settings.up_accuracyThreshold, laser_settings.up_stepDistance, laser_settings.up_numSteps, nil, nil)

    obj.allWorkers =
    {
        obj.woker_elevated,
        obj.worker_down,
        obj.workers_horz[1],
        obj.workers_horz[2],
        obj.workers_horz[3],
        obj.workers_horz[4],
        obj.worker_up,
    }

    return obj
end

-- Call this each frame.  o is the instance of GameObjectAccessor
function LaserFinderManager:Tick(pos, vel)

    local x = pos.x + (vel.x * 0.125)
    local y = pos.y + (vel.y * 0.125)
    local z = pos.z + (vel.z * 0.125)

    -- Fire Rays
    self.worker_down:FireRays(Vector4.new(x, y, z + 0.2, 1))
    
    self.woker_elevated:FireRays(Vector4.new(x, y, z + 2, 1))

    local posHorz = Vector4.new(x, y, z + 0.8, 1)

    for i=1, #self.workers_horz do
        self.workers_horz[i]:FireRays(posHorz)
    end

    self.worker_up:FireRays(Vector4.new(x, y, z + 1.4, 1))

    -- Tick
    for i=1, #self.allWorkers do
        self.allWorkers[i]:Tick(self.o.timer)
    end
end

-- Call this when the laser finders won't be used for a while.  This will clear called points
function LaserFinderManager:Stop()
    for i=1, #self.allWorkers do
        self.allWorkers[i]:Clear()
    end

    self.storage:Clear()
end