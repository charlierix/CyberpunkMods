local this = {}

local RADIANS_RIGHTLEFT = 70 * math.pi / 180

local up = nil      -- can't use vector4 before init
local rot_right = nil
local rot_left = nil

--TODO: If garbage collection doesn't like all the array creation/destruction, switch to rolling buffer

-- Returns array of hits, sorted by distance from source
--  { hit, normal, distSqr }[]
function RayCast_NearbyWalls(fromPos, o, log, rayLen)
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
    this.FireRay(retVal, fromPos, up, rayLen, o, log)

    -- Dir facing
    this.FireRay(retVal, fromPos, o.lookdir_forward, rayLen, o, log)

    -- Horizontal facing
    local horz_forward = this.GetDirectionHorz(o.lookdir_forward)
    this.FireRay(retVal, fromPos, horz_forward, rayLen, o, log)

    -- Horizontal right
    local horz_right = RotateVector3D(horz_forward, rot_right)
    this.FireRay(retVal, fromPos, horz_right, rayLen, o, log)

    -- Horizontal left
    local horz_left = RotateVector3D(horz_forward, rot_left)
    this.FireRay(retVal, fromPos, horz_left, rayLen, o, log)

    if #retVal > 0 then
        log:Add_Line(fromPos, retVal[1].hit, "closest")
    end

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

-- Fires a ray.  Stores that hit as well as the closest point on the plane to the player
function this.FireRay(other_hits, fromPos, direction, rayLen, o, log)
    local toPos = Vector4.new(fromPos.x + (direction.x * rayLen), fromPos.y + (direction.y * rayLen), fromPos.z + (direction.z * rayLen), 1)

    local hit, normal = o:RayCast(fromPos, toPos, true)

    if not hit then
        log:Add_Line(fromPos, toPos, "miss")
        do return end
    end

    log:Add_Square(hit, normal, 1, 1, "wall")
    log:Add_Line(fromPos, hit, "hit")

    this.AddHit(fromPos, hit, normal, other_hits)

    local planePoint = GetClosestPoint_Plane_Point(hit, normal, fromPos)
    if not planePoint then
        do return end       -- should never happen
    end

    toPos.x = fromPos.x + ((planePoint.x - fromPos.x) * 1.1)
    toPos.y = fromPos.y + ((planePoint.y - fromPos.y) * 1.1)
    toPos.z = fromPos.z + ((planePoint.z - fromPos.z) * 1.1)

    hit, normal = o:RayCast(fromPos, toPos, true)

    if hit then
        log:Add_Dot(planePoint, "planePoint_hit")
        this.AddHit(fromPos, planePoint, normal, other_hits)
    else
        log:Add_Dot(planePoint, "planePoint_miss")
    end
end

function this.AddHit(fromPos, hit, normal, other_hits)
    local distSqr = GetVectorDiffLengthSqr(fromPos, hit)

    for i = 1, #other_hits do
        if IsNearValue_vec4(hit, other_hits[i].hit) then
            -- This is a duplicate with an existing it.  Don't store it
            do return end
        end

        if distSqr < other_hits[i].distSqr then
            -- This is closer.  Insert in front to keep the list sorted
            table.insert(other_hits, i,
            {
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