-- This is used to see if the player just initiated a Kerenzikov Dash
--
-- Kerenzikov is a cyberware that slows time when you block.  So if the player blocks
-- (right mouse button) while dashing (spamming forward button), time will slow down.
-- Then if they are still spamming the forward button (dashing) when time goes to normal,
-- the game screws up and the player is traveling at super speed
--
-- They also need to jump around the same moment that time returns to normal.  Otherwise
-- they'll just walk it off (when airborne, speed it preserved)

KDashInputTracker = {}

function KDashInputTracker:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.forward = RollingBuffer:new(6)
    obj.jump = RollingBuffer:new(6)
    obj.rmb = RollingBuffer:new(3)      -- only need 1, but it doesn't really hurt to have a few

    return obj
end

-- Call this each tick, telling which inputs were just released (not actively pressed, but just let
-- up ... would also work if initial down)
function KDashInputTracker:StoreInputs(timer, ispressed_forward, ispressed_jump, ispressed_rmb)
    if ispressed_forward then
        self.forward:Add(timer)
    end

    if ispressed_jump then
        self.jump:Add(timer)
    end

    if ispressed_rmb then
        self.rmb:Add(timer)
    end
end

-- Call this each tick to see if they just initiated a kdash
function KDashInputTracker:WasKDashPerformed(timer, velocity, debug)
    local speedSqr = GetVectorLengthSqr(velocity)
    if (speedSqr < (20 * 20)) or (speedSqr > (120 * 120)) then      -- the max speed cap helps protect against returning true when in the inventory screen (velocity goes absurdly high) --- this check was written before menu detection.  This function now won't be called, but if they're going that fast, it's not because of kerenzikov
        --debug.kdash = "speed"
        return false
    end

    local lastRMB = self.rmb:GetLastEntry()
    if (not lastRMB) or ((timer - lastRMB) > 5) then
        debug.kdash = "rmb"
        return false
    end

    local shortestForward = self:GetShortestForwardInterval()
    if (not shortestForward) or (shortestForward > 0.3) then
        debug.kdash = "forward dash"
        return false
    end

    local lastJump = self.jump:GetLastEntry()
    if (not lastJump) or ((timer - lastJump) > 3) then
        debug.kdash = "jump"
        return false
    end

    debug.kdash = "dashhhhhhhhhhhhhhhh"

    return true
end

-- This looks for when they're spamming the forward button (trying to start a dash)
function KDashInputTracker:GetShortestForwardInterval()
    local forwards = self.forward:GetLatestEntries(self.forward:GetSize())

    local smallest = nil

    for i=1, #forwards-1 do
        local current = forwards[i] - forwards[i+1]
        if (not smallest) or (current < smallest) then
            smallest = current
        end
    end

    return smallest
end

-- Forgets history, so that a new kdash needs to be performed before this returns true again
function KDashInputTracker:Clear()
    self.forward:Clear()
    self.jump:Clear()
    self.rmb:Clear()
end

-- Just for debugging
function KDashInputTracker:DebugElapsedTimes(timer, debug)
    -- Forward
    local lastForward = self.forward:GetLastEntry()
    if lastForward then
        debug.elapsed_forward = tostring(Round(timer - lastForward, 1))
    else
        debug.elapsed_forward = "never"
    end

    -- Jump
    local lastJump = self.jump:GetLastEntry()
    if lastJump then
        debug.elapsed_jump = tostring(Round(timer - lastJump, 1))
    else
        debug.elapsed_jump = "never"
    end

    -- RMB
    local lastRMB = self.rmb:GetLastEntry()
    if lastRMB then
        debug.elapsed_rmb = tostring(Round(timer - lastRMB, 1))
    else
        debug.elapsed_rmb = "never"
    end
end
