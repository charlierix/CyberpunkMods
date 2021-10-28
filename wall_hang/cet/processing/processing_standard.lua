local this = {}

local RADIANS_RIGHTLEFT = 70 * math.pi / 180

local up = nil      -- can't use vector4 before init
local rot_right = nil
local rot_left = nil

local logger = nil

function Process_Standard(o, vars, const, debug, startStopTracker)
    -- Cheapest check is looking at keys
    local isHangDown, isJumpDown = startStopTracker:GetButtonState()
    if not isHangDown and not isJumpDown then

        if logger and logger:IsPopulated() then
            logger:Save("LatchRayTrace")
        end

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

    if not logger then
        logger = DebugRenderLogger:new(not const.shouldShowLogging3D_latchRayTrace)
    end

    -- Fire a few rays, use the closest point
    local fromPos = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.rayFrom_Z, 1)

    local hits = RayCast_NearbyWalls(fromPos, o, logger, const.rayLen)
    if #hits == 0 then
        do return end
    end

    if isHangDown and this.ValidateSlope_Hang(hits[1].normal) then      --NOTE: slope check for hang is pretty much unnecessary.  The IsAirborne eliminates slopes already
        local hangPos = Vector4.new(fromPos.x, fromPos.y, fromPos.z - const.rayFrom_Z, 1)
        Transition_ToHang(vars, const, o, hangPos, hits[1].normal)

    elseif isJumpDown and this.ValidateSlope_Jump(hits[1].normal) then
        local hangPos = Vector4.new(fromPos.x, fromPos.y, fromPos.z - const.rayFrom_Z, 1)
        Transition_ToJump_Calculate(vars, const, o, hangPos, hits[1].normal, startStopTracker)
    end
end

----------------------------------- Private Methods -----------------------------------

-- If the slope is horizontal enough to stand on, this returns false
function this.ValidateSlope_Hang(normal)
    return DotProduct3D(normal, up) < 0.4       -- also allowing them to grab the under side of objects
end
function this.ValidateSlope_Jump(normal)
    return math.abs(DotProduct3D(normal, up)) < 0.6      -- don't allow if they are under overhangs
end