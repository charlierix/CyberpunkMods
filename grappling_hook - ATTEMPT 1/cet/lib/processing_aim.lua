function Process_Aim_Pull(o, state, const, debug)
    Process_Aim_Common(o, state, const, debug, const.pull)
end

function Process_Aim_Rigid(o, state, const, debug)
    if not IsAirborne(o) then
        -- Standing on the ground, cancelling
        Transition_ToStandard(state, const, debug, o)
    end

    Process_Aim_Common(o, state, const, debug, const.rigid)
end

function Process_Aim_Common(o, state, const, debug, args)
    if state.startStopTracker:ShouldStop() then
        -- told to stop aiming, back to standard
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    -- Fire a ray
    o:GetCamera()

    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)

    local hitPoint, _ = RayCast_HitPoint(from, o.lookdir_forward, args.maxDistance, const.grappleMinResolution, o)

    -- See if the ray hit something
    if hitPoint then
        -- Ensure pin is drawn and placed properly
        EnsureMapPinVisible(hitPoint, args.mappinName, state, o)

        Transition_ToFlight(state, o, args.flightMode, from, hitPoint)
        do return end
    end

    -- They're looking at open air, or something that is too far away
    if o.timer - state.startTime > const.aim_duration then
        if args.allowAirDash then
            -- Took too long to aim, switching to air dash
            Transition_ToAirDash(state, o, const, from, args.maxDistance)
        else
            -- Took too long to aim, can't air dash, giving up
            Transition_ToStandard(state, const, debug, o)
        end

    else
        -- Still aiming, make sure the map pin is visible
        local aimPoint = Vector4.new(from.x + (o.lookdir_forward.x * args.maxDistance), from.y + (o.lookdir_forward.y * args.maxDistance), from.z + (o.lookdir_forward.z * args.maxDistance), 1)
        EnsureMapPinVisible(aimPoint, const.mappinName_aim, state, o)
    end
end