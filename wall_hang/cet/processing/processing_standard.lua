local this = {}

local RADIANS_RIGHTLEFT = 70 * math.pi / 180

local up = nil      -- can't use vector4 before init
local rot_right = nil
local rot_left = nil

function Process_Standard(o, vars, const, debug, startStopTracker)
    -- Cheapest check is looking at keys
    local isHangDown, isJumpDown = startStopTracker:GetButtonState()
    if not isHangDown and not isJumpDown then
        do return end
    end

    -- Next cheapest is a single raycast down
    if not IsAirborne(o) then
        startStopTracker:ResetHangLatch()
        do return end
    end

    -- Next is a ray cast along look.  Was going to go with several, but one seems to be good enough
    o:GetCamera()
    if not o.lookdir_forward then
        startStopTracker:ResetHangLatch()
        do return end
    end

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    -- Fire a few rays, use the closest point
    local fromPos = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.rayFrom_Z, 1)

    local hit, normal = this.FireRays(fromPos, o, const)
    if not hit then
        do return end
    end

    if isHangDown and this.ValidateSlope_Hang(normal) then      --NOTE: slope check for hang is pretty much unnecessary.  The IsAirborne eliminates slopes already
        local hangPos = Vector4.new(fromPos.x, fromPos.y, fromPos.z - const.rayFrom_Z, 1)
        Transition_ToHang(vars, const, o, hangPos, normal)

    elseif isJumpDown and this.ValidateSlope_Jump(normal) then
        local hangPos = Vector4.new(fromPos.x, fromPos.y, fromPos.z - const.rayFrom_Z, 1)
        Transition_ToJump_Calculate(vars, const, o, hangPos, normal, startStopTracker)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.FireRays_ORIG(fromPos, o, const)
    local rayDir = this.GetDirectionHorz(o.lookdir_forward)

    --local fromPos = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.rayFrom_Z, 1)
    --local toPos = Vector4.new(fromPos.x + (rayDir.x * const.rayLen), fromPos.y + (rayDir.y * const.rayLen), fromPos.z + const.rayFrom_Z + (rayDir.z * const.rayLen), 1)       -- z constant was being added twice
    local toPos = Vector4.new(fromPos.x + (rayDir.x * const.rayLen), fromPos.y + (rayDir.y * const.rayLen), fromPos.z + (rayDir.z * const.rayLen), 1)

    local hit, normal = o:RayCast(fromPos, toPos, true)

    return hit, normal
end
function this.FireRays(fromPos, o, const)
    local hit_final = nil
    local normal_final = nil

    if not rot_right then
        rot_right = Quaternion_FromAxisRadians(up, -RADIANS_RIGHTLEFT)
        rot_left = Quaternion_FromAxisRadians(up, RADIANS_RIGHTLEFT)
    end

    -- Up
    local hit, normal = this.FireRay(fromPos, up, o, const)
    hit_final, normal_final = this.ReturnClosestHit(hit_final, normal_final, hit, normal, o.pos)

    -- Dir facing
    hit, normal = this.FireRay(fromPos, o.lookdir_forward, o, const)
    hit_final, normal_final = this.ReturnClosestHit(hit_final, normal_final, hit, normal, o.pos)

    -- Horizontal facing
    local horz_forward = this.GetDirectionHorz(o.lookdir_forward)
    hit, normal = this.FireRay(fromPos, horz_forward, o, const)
    hit_final, normal_final = this.ReturnClosestHit(hit_final, normal_final, hit, normal, o.pos)

    -- Horizontal right
    local horz_right = RotateVector3D(horz_forward, rot_right)
    hit, normal = this.FireRay(fromPos, horz_right, o, const)
    hit_final, normal_final = this.ReturnClosestHit(hit_final, normal_final, hit, normal, o.pos)

    -- Horizontal left
    local horz_left = RotateVector3D(horz_forward, rot_left)
    hit, normal = this.FireRay(fromPos, horz_left, o, const)
    hit_final, normal_final = this.ReturnClosestHit(hit_final, normal_final, hit, normal, o.pos)

    return hit_final, normal_final
end
-- This fires a ray, if there's a hit, it finds the closest point on the plane and tries that
function this.FireRay(fromPos, direction, o, const)
    local toPos = Vector4.new(fromPos.x + (direction.x * const.rayLen), fromPos.y + (direction.y * const.rayLen), fromPos.z + (direction.z * const.rayLen), 1)

    local hit, normal = o:RayCast(fromPos, toPos, true)


    --TODO: Find the closest point on plane, see if that's a hit and use that
    --GetClosestPoint_Plane_Point()



    return hit, normal
end
function this.ReturnClosestHit(hit1, norm1, hit2, norm2, pos)
    if not hit1 and not hit2 then
        return nil, nil

    elseif hit1 and not hit2 then
        return hit1, norm1

    elseif hit2 and not hit1 then
        return hit2, norm2
    end

    local dist1 = GetVectorDiffLengthSqr(pos, hit1)
    local dist2 = GetVectorDiffLengthSqr(pos, hit2)

    if dist1 < dist2 then
        return hit1, norm1
    else
        return hit2, norm2
    end
end

function this.GetDirectionHorz(lookdir)
    local onPlane = GetProjectedVector_AlongPlane(lookdir, up)

    local len = GetVectorLength(onPlane)

    return Vector4.new(onPlane.x / len, onPlane.y / len, onPlane.z / len, 1)
end

-- If the slope is horizontal enough to stand on, this returns false
function this.ValidateSlope_Hang(normal)
    return DotProduct3D(normal, up) < 0.4       -- also allowing them to grab the under side of objects
end
function this.ValidateSlope_Jump(normal)
    return math.abs(DotProduct3D(normal, up)) < 0.6      -- don't allow if they are under overhangs
end