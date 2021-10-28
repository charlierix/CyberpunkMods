local this = {}

-- This asks storage for nearby points, applies repulsion forces, returns acceleration
-- NOTE: The values returned are per second.  Actual applied acceleration will need to be multiplied
-- by deltaTime
function FloatPlayer_GetAcceleration(storage, pos, const)
    local maxDist = math.max(const.linear_maxDist, const.inverse_maxDist);
    local closestSeen = nil

    local nearbyPoints = storage:GetNearbyPoints(pos, maxDist)

    local x = 0
    local y = 0
    local z = 0

    for i=1, nearbyPoints:GetCount() do
        local repulsor = nearbyPoints:GetItem(i).point.point

        local distance = math.sqrt(GetVectorDiffLengthSqr(pos, repulsor))

        if (not closestSeen) or (distance < closestSeen) then
            closestSeen = distance
        end

        local direction = Vector4.new((pos.x - repulsor.x) / distance, (pos.y - repulsor.y) / distance, (pos.z - repulsor.z) / distance, 1)

        local lin_x, lin_y, lin_z  = this.GetRepulseAccel_Linear(direction, distance, const.linear_maxDist, const.linear_maxAccel)
        x = x + lin_x
        y = y + lin_y
        z = z + lin_z

        local inv_x, inv_y, inv_z = this.GetRepulseAccel_Inverse(direction, distance, const.inverse_maxDist, const.inverse_maxAccel, const.inverse_c);
        x = x + inv_x
        y = y + inv_y
        z = z + inv_z

        local sqr_x, sqr_y, sqr_z = this.GetRepulseAccel_InvSqr(direction, distance, const.inverseSqr_maxDist, const.inverseSqr_maxAccel, const.inverseSqr_c)
        x = x + sqr_x
        y = y + sqr_y
        z = z + sqr_z
    end

    return x, y, z, closestSeen, maxDist
end

----------------------------------- Private Methods -----------------------------------

-- Force climbs linearly from 0 to max
--Vector3? GetRepulseAccel_Linear(Vector3 directionUnit, float distance, float maxDist, float maxAccel)
function this.GetRepulseAccel_Linear(directionUnit, distance, maxDist, maxAccel)
    if distance > maxDist then
        return 0, 0, 0
    end

    local normalizedDist = distance / maxDist

    local accel = -normalizedDist + 1       -- force will be 1 at dist0 and 0 at dist1
    accel = accel * maxAccel

    --return MultiplyVector(directionUnit, accel)
    return directionUnit.x * accel, directionUnit.y * accel, directionUnit.z * accel
end

-- Force grows 1/x
--Vector3? GetRepulseAccel_Inverse(Vector3 directionUnit, float distance, float maxDist, float maxAccel, float constant)
function this.GetRepulseAccel_Inverse(directionUnit, distance, maxDist, maxAccel, constant)
    if distance > maxDist then
        return 0, 0, 0
    end

    local normalizedDist = distance / maxDist

    local accel = 1 / (constant * normalizedDist)
    accel = accel * maxAccel;

    if accel > maxAccel then
        accel = maxAccel
    end

    return directionUnit.x * accel, directionUnit.y * accel, directionUnit.z * accel
end

-- Force is 1/x^2
function this.GetRepulseAccel_InvSqr(directionUnit, distance, maxDist, maxAccel, constant)
    if distance > maxDist then
        return 0, 0, 0
    end

    local normalizedDist = distance / maxDist

    --local accel = 1 / (constant * normalizedDist)^2
    local accel = constant * normalizedDist
    accel = accel * accel
    accel = 1 / accel
    accel = accel * maxAccel;

    if accel > maxAccel then
        accel = maxAccel
    end

    return directionUnit.x * accel, directionUnit.y * accel, directionUnit.z * accel
end