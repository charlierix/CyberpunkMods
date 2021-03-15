function GhostForward(dist, shouldExtendWhenLookingUp, o)
    o:GetCamera()

    local dist_up = dist

    -- If they are looking straight up, increase the jump distance, otherwise they tend to
    -- clip halfway through the floor and fall back down, requiring a couple quick presses
    -- to succeed
    --
    -- the position is at the player's feet, so there is no need to extend when looking down
    if shouldExtendWhenLookingUp and (o.lookdir_forward.z > 0.85) then      -- since look direction is a unit vector, this acts like a crude dot product with z up
        dist_up = dist * 2.5
    end

    -- It's ok if they are looking slightly up or down from z=0.  The game will put them back
    -- on the ground
    local newPos = Vector4.new(o.pos.x + (o.lookdir_forward.x * dist), o.pos.y + (o.lookdir_forward.y * dist), o.pos.z + (o.lookdir_forward.z * dist_up), o.pos.w)       -- w is always 1

    o:Teleport(newPos, o.yaw)
end