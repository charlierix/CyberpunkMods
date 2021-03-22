function GetGrappleLine(o, state, const)
    local playerAnchor = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)

    local grappleDir = SubtractVectors(state.rayHit, playerAnchor)
    local grappleLen = GetVectorLength(grappleDir)
    local grappleDirUnit = DivideVector(grappleDir, grappleLen)

    return playerAnchor, grappleDir, grappleLen, grappleDirUnit
end