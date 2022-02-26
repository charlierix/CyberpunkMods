-- This does a single ray cast to see if it is obscured
function IsRayCastHit(fromPos, dirX, dirY, dirZ, o)
    return not o:IsPointVisible(fromPos, Vector4.new(fromPos.x + dirX, fromPos.y + dirY, fromPos.z + dirZ, fromPos.w))
end

--TODO: Options for what to return
function RayCast_Closest(spatial, from_pos, to_pos)
    -- it would be cool if QueryFilter.ALL() worked here, but it doesn't
    local filters = {
        "Dynamic",      -- Movable Objects
        "Vehicle",
        "Static",       -- Buildings, Concrete Roads, Crates, etc
        --"Water",
        "Terrain",
        "PlayerBlocker",        -- Trees, Billboards, Barriers
    }

    local closest = nil
    local closest_distsqr = nil

    for i = 1, #filters do
		local success, result = spatial:SyncRaycastByCollisionGroup(from_pos, to_pos, filters[i], false, false)

        if success then
            --print("hit: " .. filters[i] .. " | " .. tostring(result.material))

            local dist_sqr = GetVectorDiffLengthSqr(from_pos, result.position)

            if closest == nil or dist_sqr < closest_distsqr then
                closest = result
                closest_distsqr = dist_sqr
            end
        else
            --print("miss: " .. filters[i])
        end
    end

    return closest
end