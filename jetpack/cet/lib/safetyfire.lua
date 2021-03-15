function GetSafetyFireHitPoint(o, pos, velZ, mode, deltaTime)
    if (not mode.shouldSafetyFire) or (velZ > -16) then
        return nil
    end

    local searchDist = math.abs(velZ * deltaTime * 4)

    -- Direct Center
    local hitPoint = RayCast_HitPoint(pos, Vector4.new(0, 0, -1, 1), searchDist, 0.1, o)
    if hitPoint then
        return hitPoint
    end

    -- Four Corners

    -- Landing on screens and slats are the worst case scenario.  The direction down needs to go
    -- at a slight angle to increase the chance of seeing them
    --
    -- So, normalizing the vector (.1, .1, 1) becomes
    -- len = 1.009950493836207795336338591707
    -- x,y = 0.09901475467
    -- z   = 0.99014754298

    hitPoint = RayCast_HitPoint(Vector4.new(pos.x - 0.02, pos.y - 0.02, pos.z, 1), Vector4.new(-0.09901475467, -0.09901475467, -0.99014754298, 1), searchDist, 0.1, o)
    if hitPoint then
        return hitPoint
    end

    hitPoint = RayCast_HitPoint(Vector4.new(pos.x + 0.02, pos.y - 0.02, pos.z, 1), Vector4.new(0.09901475467, -0.09901475467, -0.99014754298, 1), searchDist, 0.1, o)
    if hitPoint then
        return hitPoint
    end

    hitPoint = RayCast_HitPoint(Vector4.new(pos.x + 0.02, pos.y + 0.02, pos.z, 1), Vector4.new(0.09901475467, 0.09901475467, -0.99014754298, 1), searchDist, 0.1, o)
    if hitPoint then
        return hitPoint
    end

    hitPoint = RayCast_HitPoint(Vector4.new(pos.x - 0.02, pos.y + 0.02, pos.z, 1), Vector4.new(-0.09901475467, 0.09901475467, -0.99014754298, 1), searchDist, 0.1, o)
    if hitPoint then
        return hitPoint
    end

    return nil
end

function SafetyFire(o, groundPoint)
    -- Calling teleport sets velocity to zero, so this should eliminate death from fall damage
    -- Need to go slightly above where they are currently or they will still die - fine tuning
    -- these params was kind of fun and morbid :)
    o:Teleport(Vector4.new(o.pos.x, o.pos.y, groundPoint.z + 0.3, 1), o.yaw)
end
