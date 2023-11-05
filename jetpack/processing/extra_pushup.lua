------------------------- Interface -------------------------
-- All derived extra classes require this same interface

-- Velocity has to be passed in, because it's stored differently between impulse and teleport based flight
-- NOTE: Can't return 0 energy if nonzero accelerations are returned, or the calling function will ignore them

-- function Extra_:Description()
--     return "quick description"

-- function Extra_:Tick(o, vel, keys, vars)
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

function Extra_PushUp:Tick(o, vel, keys, vars)
    -- Initial press down
    if keys.rmb and not keys.prev_rmb then

        RagdollNPCs_StraightUp(48, self.force, self.randHorz, self.randVert, o)

        o:PlaySound("grenade_charge_1s", vars)

        return 0, 0, 0, self.burnRate
    else
        return 0, 0, 0, 0
    end
end