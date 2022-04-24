local aimswing_raycasts = {}

local this = {}

local up = nil
local c1 = nil
local c2 = nil
local s1 = nil
local s2 = nil

local HORZRADIAL_FROM = 2
local HORZRADIAL_TO = 30
local HORZRADIAL_RADIUS = 24

local LOOK_TO = 30
local LOOK_FROM_RADIUS = 1
local LOOK_TO_RADIUS = 6

function aimswing_raycasts.InitialCone(o, const)
    o:GetCamera()

    if not up then
        this.InitRays()
    end

    local log = DebugRenderLogger:new(true)

    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + 1, 1)

    log:DefineCategory("player", "2F95CC")
    log:Add_Dot(o.pos, "player")
    log:Add_Line(o.pos, AddVectors(o.pos, o.vel), "player")

    log:Add_Dot(from)

    this.RaysLook(o, log, from)

    -- TODO: If they are looking nearly straight up, the horizontal scan is mostly useless.  So try for horizontal, but cap at a max angle from look
    -- (same but opposite when looking down)
    --
    -- An alternative could be current velocity that helps choose the tunnel cast
    this.RaysHorizontal(o, log, from)

    log:Save()
end

function this.InitRays()
    up = Vector4.new(0, 0, 1, 1)

    -- coordinates of a pentagon
    -- https://mathworld.wolfram.com/RegularPentagon.html
    local rad_5 = math.sqrt(5)
    s1 = math.sqrt(10 + 2 * rad_5) / 4      -- x upper
    s2 = math.sqrt(10 - 2 * rad_5) / 4      -- x lower
    c1 = (rad_5 - 1) / 4                    -- y upper
    c2 = (rad_5 + 1) / 4                    -- y lower
end

-- Fires a ray along look direction, and a few around that, somewhat parallel
function this.RaysLook(o, log, from)
    local to = Vector4.new(from.x + o.lookdir_forward.x * LOOK_TO, from.y + o.lookdir_forward.y * LOOK_TO, from.z + o.lookdir_forward.z * LOOK_TO, 1)
    this.FireRay(o, log, from, to)

    local look_up = CrossProduct3D(o.lookdir_right, o.lookdir_forward)

    -- Up
    local near = this.GetPoint_Radial(from, o.lookdir_right, look_up, 0, 1, LOOK_FROM_RADIUS)
    local far = this.GetPoint_Radial(to, o.lookdir_right, look_up, 0, 1, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Up Right
    near = this.GetPoint_Radial(from, o.lookdir_right, look_up, s1, c1, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, look_up, s1, c1, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Down Right
    near = this.GetPoint_Radial(from, o.lookdir_right, look_up, s2, -c2, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, look_up, s2, -c2, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Down Left
    near = this.GetPoint_Radial(from, o.lookdir_right, look_up, -s2, -c2, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, look_up, -s2, -c2, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Up Left
    near = this.GetPoint_Radial(from, o.lookdir_right, look_up, -s1, c1, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, look_up, -s1, c1, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)
end

-- Fires a ray horizontally, and a few outward radially at progressive distances (identifies structures around the player)
function this.RaysHorizontal(o, log, from)
    local forw_horz = GetProjectedVector_AlongPlane(o.lookdir_forward, up)
    local right_horz = GetProjectedVector_AlongPlane(o.lookdir_right, up)

    -- Along horizontal
    this.FireRay(o, log, from, Vector4.new(from.x + forw_horz.x * HORZRADIAL_TO, from.y + forw_horz.y * HORZRADIAL_TO, from.z + forw_horz.z * HORZRADIAL_TO, 1))

    -- Radial around horizontal
    for i = 1, 4, 1 do
        local dist = GetScaledValue(HORZRADIAL_FROM, HORZRADIAL_TO, 1, 4, i)

        local ray_from = Vector4.new(from.x + (forw_horz.x * dist), from.y + (forw_horz.y * dist), from.z + (forw_horz.z * dist), 1)
        log:Add_Dot(ray_from)

        -- Up
        local ray_out = this.GetPoint_Radial(ray_from, right_horz, up, 0, 1, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Up Right
        ray_out = this.GetPoint_Radial(ray_from, right_horz, up, s1, c1, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Down Right
        ray_out = this.GetPoint_Radial(ray_from, right_horz, up, s2, -c2, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Down Left
        ray_out = this.GetPoint_Radial(ray_from, right_horz, up, -s2, -c2, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Up Left
        ray_out = this.GetPoint_Radial(ray_from, right_horz, up, -s1, c1, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)
    end
end

function this.GetPoint_Radial(from, dir_right, dir_up, dist_right, dist_up, ray_dist)
    local x = from.x + (dir_right.x * ray_dist * dist_right) + (dir_up.x * ray_dist * dist_up)
    local y = from.y + (dir_right.y * ray_dist * dist_right) + (dir_up.y * ray_dist * dist_up)
    local z = from.z + (dir_right.z * ray_dist * dist_right) + (dir_up.z * ray_dist * dist_up)

    return Vector4.new(x, y, z, 1)
end

function this.FireRay(o, log, from, to)
    log:Add_Line(from, to)

    local hitPoint = o:RayCast(from, to)
    if hitPoint then
        log:Add_Line(from, hitPoint, nil, "2C2", 2)
    end

end

return aimswing_raycasts