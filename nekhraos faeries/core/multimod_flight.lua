--custom_currentlyFlying_current
--custom_currentlyFlying_velX
--custom_currentlyFlying_velY
--custom_currentlyFlying_velZ

local multimod_flight = {}

local this = {}

local CUSTOM_FLIGHT_OFFSET = 1234567
local VELOCITY_MULT = 100

local m_flight_key = nil
local controlswitched_current_key = nil

-- This returns true if this mod is owner of flight, or the setting is blank (returns false if another mod is flying)
-- It is readonly (doesn't set anything)
function multimod_flight.IsOwnerOrNone(quest, wrappers)
    local current = wrappers.GetQuestFactStr(quest, "custom_currentlyFlying_current")

    if current == nil or type(current) ~= "number" then     -- only ints can be stored in quest facts, but just making sure
        return true

    elseif current == 0 then
        return true

    elseif m_flight_key and current == m_flight_key then
        return true

    else
        return false
    end
end

-- This is meant to be called on a regular basis from a function that isn't currently flying (is_owner was thrown in just because)
-- Treat it like an event
function multimod_flight.HasControlSwitched(quest, wrappers)
    local current = wrappers.GetQuestFactStr(quest, "custom_currentlyFlying_current")

    local changed = current ~= controlswitched_current_key
    controlswitched_current_key = current

    local is_empty = current == nil or type(current) ~= "number" or current == 0

    local is_owner = not is_empty and m_flight_key and current == m_flight_key

    return
        changed,
        is_empty,
        is_owner
end

-- This just returns whether it's possible to start flight.  It is readonly (doesn't set anything)
function multimod_flight.CanStartFlight(quest, wrappers)
    return this.CanStartFlight(quest, wrappers, m_flight_key)
end

-- This tries to take ownership of flight.  If there is another mod flying that doesn't allow interruption, then this
-- will return false
-- Returns:
--  bool: Whether this mod has control of flight
--  vect4: The player's current velocity
function multimod_flight.TryStartFlight(quest, wrappers, allow_interruption, velocity)
    if this.CanStartFlight(quest, wrappers, m_flight_key) then
        local return_vel = this.GetStartingVelocity(quest, wrappers, velocity)

        m_flight_key = this.StoreFlightKey(quest, wrappers, allow_interruption)

        this.StoreVelocity(quest, wrappers, return_vel)

        return true, return_vel
    else
        return false, nil
    end
end

-- If a mod is currently flying, this returns that velocity.  Otherwise returns velocity passed in
function multimod_flight.GetVelocity(quest, wrappers, velocity)
    if this.IsAnyModFlying(quest, wrappers) then
        return this.GetStartingVelocity(quest, wrappers, velocity)
    else
        return velocity
    end
end

-- This makes sure that another mod hasn't taken over flight.  This also stores the current velocity
-- Returns:
--  bool (true if this mod is still the owner of flight)
function multimod_flight.Update(quest, wrappers, velocity)
    if this.IsFlightOwner(quest, wrappers, m_flight_key) then
        this.StoreVelocity(quest, wrappers, velocity)
        return true
    else
        return false
    end
end

-- This tells other mods that this mod is no longer flying
function multimod_flight.Clear(quest, wrappers)
    if this.IsFlightOwner(quest, wrappers, m_flight_key) then
        this.ClearFlight(quest, wrappers)
    end

    m_flight_key = nil
end

----------------------------------- Private Methods -----------------------------------

function this.CanStartFlight(quest, wrappers, flight_key)
    local current = wrappers.GetQuestFactStr(quest, "custom_currentlyFlying_current")

    if current == nil or type(current) ~= "number" then     -- only ints can be stored in quest facts, but just making sure
        return true

    elseif current >= 0 then        -- positive numbers mean that flight can be interrupted
        return true

    elseif flight_key and current == flight_key then
        return true     -- it's not interruptible, but it was initiated by this mod, so go ahead and say it's interruptible
    end

    local diff = os.time() - -current       -- negating currect, since it's negative

    return diff > 3 * 60       -- three minutes is enough time to freeze out flight.  If it's longer than that, then the flight probably wan't cleaned up properly
end
function this.IsAnyModFlying(quest, wrappers)
    local current = wrappers.GetQuestFactStr(quest, "custom_currentlyFlying_current")

    if current == nil or type(current) ~= "number" then     -- only ints can be stored in quest facts, but just making sure
        return true
    end

    local diff = os.time() - math.abs(current)      -- current could be positive (allows interruption) or negative (can't be interrupted)

    return diff < 36 * 60       -- is owner used 3 minutes, but using a longer time here in case they are just flying around
end

function this.GetStartingVelocity(quest, wrappers, velocity)
    local x = wrappers.GetQuestFactStr(quest, "custom_currentlyFlying_velX")
    local y = wrappers.GetQuestFactStr(quest, "custom_currentlyFlying_velY")
    local z = wrappers.GetQuestFactStr(quest, "custom_currentlyFlying_velZ")

    if (not x or x == 0) and (not y or y == 0) and (not z or z == 0) then       -- the quest fact comes back as zero when there is no entry
        if velocity then
            return velocity
        else
            return Vector4.new(0, 0, 0, 1)
        end
    end

    -- since default is zero, a known offset is added to the result to make zero velocity store as non zero
    -- since it's an integer, the velocity is multiplied by 100
    x = (x - CUSTOM_FLIGHT_OFFSET) / VELOCITY_MULT
    y = (y - CUSTOM_FLIGHT_OFFSET) / VELOCITY_MULT
    z = (z - CUSTOM_FLIGHT_OFFSET) / VELOCITY_MULT

    return Vector4.new(x, y, z, 1)
end

function this.StoreVelocity(quest, wrappers, velocity)
    local x, y, z

    if velocity then
        x = velocity.x
        y = velocity.y
        z = velocity.z
    else
        x = 0
        y = 0
        z = 0
    end

    x = Round((x * VELOCITY_MULT) + CUSTOM_FLIGHT_OFFSET, 0)       -- rounding, because it must be an integer
    y = Round((y * VELOCITY_MULT) + CUSTOM_FLIGHT_OFFSET, 0)
    z = Round((z * VELOCITY_MULT) + CUSTOM_FLIGHT_OFFSET, 0)

    wrappers.SetQuestFactStr(quest, "custom_currentlyFlying_velX", x)
    wrappers.SetQuestFactStr(quest, "custom_currentlyFlying_velY", y)
    wrappers.SetQuestFactStr(quest, "custom_currentlyFlying_velZ", z)
end

function this.StoreFlightKey(quest, wrappers, can_interrupt)
    local id = os.time()

    if not can_interrupt then
        id = -id        -- instead of storing an extra fact, just make it negative
    end

    wrappers.SetQuestFactStr(quest, "custom_currentlyFlying_current", id)

    return id
end

function this.IsFlightOwner(quest, wrappers, flight_key)
    if not flight_key then      -- should never happen, but just make sure
        return false
    end

    local current = wrappers.GetQuestFactStr(quest, "custom_currentlyFlying_current")

    return current == flight_key
end

function this.ClearFlight(quest, wrappers)
    wrappers.SetQuestFactStr(quest, "custom_currentlyFlying_current", 0)
    wrappers.SetQuestFactStr(quest, "custom_currentlyFlying_velX", 0)
    wrappers.SetQuestFactStr(quest, "custom_currentlyFlying_velY", 0)
    wrappers.SetQuestFactStr(quest, "custom_currentlyFlying_velZ", 0)
end

return multimod_flight