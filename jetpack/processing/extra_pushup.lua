------------------------- Interface -------------------------
-- All derived extra classes require this same interface

-- Velocity has to be passed in, because it's stored differently between impulse and teleport based flight
-- NOTE: Can't return 0 energy if nonzero accelerations are returned, or the calling function will ignore them
-- NOTE: deltaTime is only passed in for informational reasons.  The caller will reduce accelerations and requestedEnergy by deltaTime

-- function Extra_:Description()
--     return "quick description"

-- function Extra_:Tick(o, vel, keys, vars, deltaTime)
--     return accelX, accelY, accelZ, requestedEnergy
-------------------------------------------------------------

Extra_PushUp = {}

function Extra_PushUp:new(force, randHorz, randVert, burnRate, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.extra_type = const.extra_type.pushup
    obj.force = force
    obj.randHorz = randHorz
    obj.randVert = randVert
    obj.burnRate = burnRate

    return obj
end

function Extra_PushUp:Description()
    return "npc lift"
end

function Extra_PushUp:Tick(o, vel, keys, vars, deltaTime)
    -- Initial press down
    if keys.rmb and not keys.prev_rmb then
        RagdollNPCs_StraightUp(48, self.force, self.randHorz, self.randVert, o)

        o:PlaySound("grenade_charge_1s", vars)

        local burnRate = self.burnRate
        if IsNearZero(deltaTime) then
            burnRate = 0
        else
            burnRate = burnRate / deltaTime     -- since the caller will reduce burn rate by deltaTime, the returned value needs to be inflated so that the final requestedEnergy is constant
        end

        return 0, 0, 0, burnRate
    else
        return 0, 0, 0, 0
    end
end