local this = {}

local up = nil      -- can't use vector4 before init

function Process_Standard(o, vars, const, debug, startStopTracker)
    -- Cheapest check is looking at keys
    local isHangDown, isJumpDown = startStopTracker:GetButtonState()
    if not isHangDown and not isJumpDown then
        do return end
    end

    -- Next cheapest is a single raycast down
    if not IsAirborne(o) then
        do return end
    end

    -- Next is a ray cast along look.  Was going to go with several, but one seems to be good enough
    o:GetCamera()
    if not o.lookdir_forward then
        do return end
    end

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    local rayDir = this.GetDirectionHorz(o.lookdir_forward)

    local fromPos = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.rayFrom_Z, 1)
    --local toPos = Vector4.new(fromPos.x + (o.lookdir_forward.x * const.rayLen), fromPos.y + (o.lookdir_forward.y * const.rayLen), fromPos.z + const.rayFrom_Z + (o.lookdir_forward.z * const.rayLen), 1)
    local toPos = Vector4.new(fromPos.x + (rayDir.x * const.rayLen), fromPos.y + (rayDir.y * const.rayLen), fromPos.z + const.rayFrom_Z + (rayDir.z * const.rayLen), 1)

    --TODO: This misses the wall when they are looking mostly straight up.  Should probably fire a ray out (along the component of up that is perp to up)
    local hit, normal = o:RayCast(fromPos, toPos, true)
    if not hit then
        do return end
    end

    if isHangDown and this.ValidateSlope_Hang(normal) then      --NOTE: slope check for hang is pretty much unnecessary.  The IsAirborne eliminates slopes already
        local hangPos = Vector4.new(fromPos.x, fromPos.y, fromPos.z - const.rayFrom_Z, 1)
        Transition_ToHang(vars, const, o, hangPos, normal)

    elseif isJumpDown and this.ValidateSlope_Jump(normal) then
        local hangPos = Vector4.new(fromPos.x, fromPos.y, fromPos.z - const.rayFrom_Z, 1)
        Transition_ToJump_Calculate(vars, const, o, hangPos, normal)
    end
end

----------------------------------- Private Methods -----------------------------------

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