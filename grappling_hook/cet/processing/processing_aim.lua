function Process_Aim(o, player, state, const, debug, deltaTime)
    -- There's potentially a case to stop right away if standing on the ground if:
    --  there is no air dash
    --  there is no pull force, either by one of:
    --      desired_length ~= nil and (accel_alongGrappleLine ~= nil or springAccel_k ~= nil)
    --      accel_alongLook ~= nil
    --
    -- That's a lot of logic that will just get replicated in the corresponding flight functions

    state.energy = RecoverEnergy(state.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate * const.energyRecoveryPercent_inFlight, deltaTime)

    if state.grapple.aim_straight then
        Process_Aim_Straight(state.grapple.aim_straight, o, player, state, const, debug, deltaTime)

    elseif state.grapple.aim_swing then
        print("Grappling ERROR, finish aim_swing")
        Transition_ToStandard(state, const, debug, o)

    else
        print("Grappling ERROR, unknown aim")
        Transition_ToStandard(state, const, debug, o)
    end
end

function Process_Aim_Straight(aim, o, player, state, const, debug, deltaTime)
    if state.startStopTracker:ShouldStop() then
        -- told to stop aiming, back to standard
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    -- Fire a ray
    o:GetCamera()

    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)

    local hitPoint, _ = RayCast_HitPoint(from, o.lookdir_forward, aim.max_distance, const.grappleMinResolution, o)

    -- See if the ray hit something
    if hitPoint then
        -- Ensure pin is drawn and placed properly (flight pin, not aim pin)
        EnsureMapPinVisible(hitPoint, state.grapple.mappin_name, state, o)

        Transition_ToFlight(state, const, o, from, hitPoint)
        do return end
    end

    -- They're looking at open air, or something that is too far away
    if o.timer - state.startTime > aim.aim_duration then
        if aim.air_dash then
            -- Took too long to aim, switching to air dash
            Transition_ToAirDash(state, o, const, from, aim.max_distance)
        else
            -- Took too long to aim, can't air dash, giving up

            -- Since the grapple didn't happen, give back the energy that was taken at the start of the aim
            -- TODO: May want to only recover 80%
            state.energy = RecoverEnergy(state.energy, player.energy_tank.max_energy, state.grapple.energy_cost, 1)

            Transition_ToStandard(state, const, debug, o)
        end

    else
        -- Still aiming, make sure the map pin is visible
        local aimPoint = Vector4.new(from.x + (o.lookdir_forward.x * aim.max_distance), from.y + (o.lookdir_forward.y * aim.max_distance), from.z + (o.lookdir_forward.z * aim.max_distance), 1)
        EnsureMapPinVisible(aimPoint, aim.mappin_name, state, o)
    end
end