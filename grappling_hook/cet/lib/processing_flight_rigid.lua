function Process_Flight_Rigid(o, state, const, debug, deltaTime)
    if state.startStopTracker:ShouldStop() then
        -- told to stop swinging, back to standard
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    --TODO: If standing on the ground, then cancel

    local playerAnchor = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)

    local grappleDir = SubtractVectors(state.rayHit, playerAnchor)
    local grappleLen = math.abs(GetVectorLengthSqr(grappleDir))
    local grappleDirUnit = DivideVector(grappleDir, grappleLen)

    local args = const.rigid

    if DotProduct3D(o.lookdir_forward, grappleDirUnit) < args.minDot then
        -- They looked too far away
        Transition_ToStandard(state, const, debug, o)
        do return end
    end











end