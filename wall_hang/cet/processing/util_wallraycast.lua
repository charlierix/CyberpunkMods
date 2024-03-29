local this = {}

local up = nil      -- can't use vector4 before init

local RADIANS_RIGHTLEFT = 70 * math.pi / 180
local rot_right = nil
local rot_left = nil

--TODO: If garbage collection doesn't like all the array creation/destruction, switch to rolling buffer

-- Returns array of hits, sorted by distance from source
--  { hit, normal, distSqr }[]
function RayCast_NearbyWalls_Initial(fromPos, o, log, rayLen)
    local retVal = {}

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    if not rot_right then
        rot_right = Quaternion_FromAxisRadians(up, -RADIANS_RIGHTLEFT)
        rot_left = Quaternion_FromAxisRadians(up, RADIANS_RIGHTLEFT)
    end

    this.EnsureLogSetup(log)

    log:NewFrame()
    log:Add_Dot(fromPos, "player")

    -- Up
    this.FireRay(retVal, fromPos, fromPos, up, rayLen, o, log)

    -- Dir facing
    this.FireRay(retVal, fromPos, fromPos, o.lookdir_forward, rayLen, o, log)

    -- Horizontal facing
    local horz_forward = this.GetDirectionHorz(o.lookdir_forward)
    this.FireRay(retVal, fromPos, fromPos, horz_forward, rayLen, o, log)

    -- Horizontal right
    local horz_right = RotateVector3D(horz_forward, rot_right)
    this.FireRay(retVal, fromPos, fromPos, horz_right, rayLen, o, log)

    -- Horizontal left
    local horz_left = RotateVector3D(horz_forward, rot_left)
    this.FireRay(retVal, fromPos, fromPos, horz_left, rayLen, o, log)

    -- Horizontal backward
    local horz_backward = Negate(horz_forward)
    this.FireRay(retVal, fromPos, fromPos, horz_backward, rayLen, o, log)

    if #retVal > 0 then
        log:Add_Line(fromPos, retVal[1].hit, "closest")
    end

    return retVal
end

-- Fires rays from fromPos, distance is calculated from move_position
-- The ray directions sweep from anti normal toward move direction (and some to the side)
-- Returns
--  { hit, normal, distSqr }[]
function RayCast_NearbyWalls_CrawlBasic(fromPos, move_position, move_direction, existing_normal, o, log, rayLen)
    --local SLIDE_TO = 0.2        -- first rays pointing straight at the plane start at fromPos.  Rays that sweep along direction arc will slide toward the plane

    local DIRANGLE_FROM = 0     -- starting at -normal
    local DIRANGLE_TO = 100     -- going to normal
    local SIDEANGLE_FROMTO = 35 -- starting at right, ending at -right

    local STEPS_DIR = 4
    local STEPS_SIDE = 1        -- 1 straight down, then these steps

    local radianDelta_dir = Degrees_to_Radians((DIRANGLE_TO - DIRANGLE_FROM) / (STEPS_DIR - 1))
    local radianDelta_leftright = Degrees_to_Radians(SIDEANGLE_FROMTO / STEPS_SIDE)

    this.EnsureLogSetup(log)
    log:NewFrame()
    log:Add_Dot(fromPos, "player")

    local right = CrossProduct3D(move_direction, existing_normal)
    local down = MultiplyVector(existing_normal, -1)

    local retVal = {}

    this.FireRays_DirectionSweep(retVal, STEPS_DIR, fromPos, move_position, down, right, radianDelta_dir, rayLen, o, log)

    for i = 1, STEPS_SIDE, 1 do
        local quat = Quaternion_FromAxisRadians(move_direction, radianDelta_leftright * i)
        this.FireRays_DirectionSweep(retVal, STEPS_DIR, fromPos, move_position, RotateVector3D(down, quat), right, radianDelta_dir, rayLen, o, log)

        quat = Quaternion_FromAxisRadians(move_direction, -radianDelta_leftright * i)
        this.FireRays_DirectionSweep(retVal, STEPS_DIR, fromPos, move_position, RotateVector3D(down, quat), right, radianDelta_dir, rayLen, o, log)
    end

    return retVal
end

-- This fires rays from different locations on an arc toward the same point
-- This is to try to find other walls around a corner
-- NOTE: This doesn't fire a ray straight down, since it's assumed that was already tried
-- Returns
--  { hit, normal, rayStart, distSqr }[]
function RayCast_NearbyWalls_CrawlBasic_OutsideCorner(fromPos, move_position, move_direction, existing_normal, arc_radius, rayLen, o, log)
    local FINAL_ANGLE = 120
    --local SIDEANGLE_FROMTO = 35 -- starting at right, ending at -right

    local STEPS_ARC = 6     -- need a bunch of samples, because
    --local STEPS_SIDE = 1        -- 1 straight down, then these steps

    local radianDelta_arc = Degrees_to_Radians(FINAL_ANGLE / STEPS_ARC)

    this.EnsureLogSetup(log)

    --local right = CrossProduct3D(move_direction, existing_normal)
    local right = CrossProduct3D(existing_normal, move_direction)       -- since the rotation is at center, it's backward (so right is actually left)
    local radius_arm = MultiplyVector(existing_normal, arc_radius)
    local center = AddVectors(fromPos, MultiplyVector(radius_arm, -1))
    local ray = MultiplyVector(existing_normal, -rayLen)

    local retVal = {}

    --TODO: add rayStart to the hit array
    this.FireRays_ArcSweep(retVal, STEPS_ARC, move_position, center, right, radius_arm, radianDelta_arc, ray, o, log)




    return retVal
end

----------------------------------- Private Methods -----------------------------------

function this.EnsureLogSetup(log)
    if #log.categories == 0 then
        log:DefineCategory("player", "FF5", 2)
        log:DefineCategory("miss", "822", 0.75)
        log:DefineCategory("hit", "4C4", 1)
        log:DefineCategory("planePoint_hit", "0F0", 1)
        log:DefineCategory("planePoint_miss", "F00", 1)
        log:DefineCategory("wall", "4000", 1)
        log:DefineCategory("closest", "FFF", 1.5)
    end
end

function this.FireRays_DirectionSweep(hits, count, fromPos, move_position, down, right, radianDelta_dir, rayLen, o, log)
    this.FireRay(hits, fromPos, move_position, down, rayLen, o, log)        -- this is the 0 step

    for i = 1, count - 1, 1 do      -- 0 is no rotation, so start at one
        local quat = Quaternion_FromAxisRadians(right, radianDelta_dir * i)
        this.FireRay(hits, fromPos, move_position, RotateVector3D(down, quat), rayLen, o, log)
    end
end

function this.FireRays_ArcSweep(hits, count, move_position, center, right, radius_arm, radianDelta, ray_initial, o, log)
    for i = 1, count do
        local quat = Quaternion_FromAxisRadians(right, radianDelta * i)
        local rayStart = AddVectors(center, RotateVector3D(radius_arm, quat))
        local ray = RotateVector3D(ray_initial, quat)

        log:Add_Dot(rayStart, "player")

        this.FireRay_ToPoint(hits, rayStart, move_position, AddVectors(rayStart, ray), o, log)
    end
end

-- Fires a ray.  Stores that hit as well as the closest point on the plane to the player
-- testPos is what the distance is calculated from
function this.FireRay(other_hits, fromPos, testPos, direction, rayLen, o, log)
    local toPos = Vector4.new(fromPos.x + (direction.x * rayLen), fromPos.y + (direction.y * rayLen), fromPos.z + (direction.z * rayLen), 1)

    this.FireRay_ToPoint(other_hits, fromPos, testPos, toPos, o, log)
end
function this.FireRay_ToPoint(other_hits, fromPos, testPos, toPos, o, log)
    local hit, normal = o:RayCast(fromPos, toPos)

    if not hit then
        log:Add_Line(fromPos, toPos, "miss")
        do return end
    end

    log:Add_Square(hit, normal, 1, 1, "wall")
    log:Add_Line(fromPos, hit, "hit")

    this.AddHit(fromPos, testPos, hit, normal, other_hits)

    local planePoint = GetClosestPoint_Plane_Point(hit, normal, fromPos)
    if not planePoint then
        do return end       -- should never happen
    end

    toPos.x = fromPos.x + ((planePoint.x - fromPos.x) * 1.1)
    toPos.y = fromPos.y + ((planePoint.y - fromPos.y) * 1.1)
    toPos.z = fromPos.z + ((planePoint.z - fromPos.z) * 1.1)

    hit, normal = o:RayCast(fromPos, toPos)

    if hit then
        log:Add_Dot(planePoint, "planePoint_hit")
        this.AddHit(fromPos, testPos, planePoint, normal, other_hits)
    else
        log:Add_Dot(planePoint, "planePoint_miss")
    end
end

function this.AddHit(rayStart, testPos, hit, normal, other_hits)
    local distSqr = GetVectorDiffLengthSqr(testPos, hit)

    for i = 1, #other_hits do
        if IsNearValue_vec4(hit, other_hits[i].hit) then
            -- This is a duplicate with an existing it.  Don't store it
            do return end
        end

        if distSqr < other_hits[i].distSqr then
            -- This is closer.  Insert in front to keep the list sorted
            table.insert(other_hits, i,
            {
                rayStart = rayStart,
                hit = hit,
                normal = normal,
                distSqr = distSqr,
            })

            do return end
        end
    end

    -- This is the farthest (or first).  Add to the end of the list
    other_hits[#other_hits+1] =
    {
        rayStart = rayStart,
        hit = hit,
        normal = normal,
        distSqr = distSqr,
    }
end

function this.GetDirectionHorz(lookdir)
    local onPlane = GetProjectedVector_AlongPlane(lookdir, up)

    local len = GetVectorLength(onPlane)

    return Vector4.new(onPlane.x / len, onPlane.y / len, onPlane.z / len, 1)
end