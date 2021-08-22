local this = {}

-- This is called each tick when they aren't in flight (just walking around)
-- Timer has already been updated and it's verified that they aren't in a vehicle
-- or in the menu
function Process_Standard(o, vars, keys, debug, const)
    if keys.forceFlight and CheckOtherModsFor_FlightStart(o, const.modNames) then
        this.ApplyImpulse(o, const)

        -- Need to let a small amount of time to pass for the impulse to take effect
        Transition_ToImpulseLaunch(o, vars, const)
        do return end
    end

    vars.kdash:StoreInputs(o.timer, keys.forward and not keys.prev_forward, keys.jump and not keys.prev_jump, keys.rmb and not keys.prev_rmb)
    if vars.kdash:WasKDashPerformed(o.timer, o.vel, debug) and CheckOtherModsFor_FlightStart(o, const.modNames) then
        Transition_ToFlight(o, vars, const)
        do return end
    end
end

----------------------------------- Private Methods -----------------------------------

-- This will pop the player up and forward.  If flight starts immediately while standing on the ground, then
-- the player will clip below the ground
function this.ApplyImpulse(o, const)
    local x = 0
    local y = 0

    o:GetCamera()
    if o.lookdir_forward then       -- should always be true
        local len2D = GetVectorLength2D(o.lookdir_forward.x, o.lookdir_forward.y)

        if len2D > 0.1 then
            x = o.lookdir_forward.x / len2D * const.launch_horz
            y = o.lookdir_forward.y / len2D * const.launch_horz
        end
    end

    o.player:LowFlyingV_AddImpulse(x, y, const.launch_vert)
end