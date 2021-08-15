------------------------- Interface -------------------------
-- All derived right mouse button classes require this same interface

-- Velocity has to be passed in, because it's stored differently between redscript and cet flight
-- NOTE: Can't return 0 energy if nonzero accelerations are returned, or the calling function will ignore them

-- function RMB_:Description()
--     return "quick description"

-- function RMB_:Tick(o, vel, keys, vars)
--     return accelX, accelY, accelZ, requestedEnergy
-------------------------------------------------------------

RMB_PushUp = {}

function RMB_PushUp:new(force, randHorz, randVert, burnRate)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    self.force = force
    self.randHorz = randHorz
    self.randVert = randVert
    self.burnRate = burnRate

    return obj
end

function RMB_PushUp:Description()
    return "npc lift"
end

function RMB_PushUp:Tick(o, vel, keys, vars)
    -- Initial press down
    if keys.rmb and not keys.prev_rmb then

        o:RagdollNPCs_StraightUp(48, self.force, self.randHorz, self.randVert)

        o:PlaySound("grenade_charge_1s", vars)

        return 0, 0, 0, self.burnRate
    else
        return 0, 0, 0, 0
    end
end