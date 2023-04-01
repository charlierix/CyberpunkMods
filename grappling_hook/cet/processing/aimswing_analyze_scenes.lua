local swing_raycasts = require("processing/aimswing_raycasts")

local this = {}
local aimswing_analyze_scenes = {}

local ALLOW_LATCH = true
--local LATCH_MAX_LOOK_DOT = -0.85
local LATCH_MAX_LOOK_DOT = -0.71
--local LATCH_MAX_VEL_DOT = -0.75
local LATCH_MAX_VEL_DOT = -0.6
local LATCH_MAX_DIST = 14

-- Called when firing a swing from the ground.  After the initial calculations, this is called and does some raycasts
-- to possible alter the grapple

---@return Vector4 anchor_pos Either the point passed in or an altered one
---@return number accel_mult Could be used to weaken the accel
---@return boolean is_latch_hit If true, the grapple should pull to the wall, then stick like a rope
function aimswing_analyze_scenes.FromGround(position, look_dir, anchor_pos, anchor_dist, o)
    -- Fire a ray to see if the path is clear
    local hit, normal = o:RayCast(position, anchor_pos)
    if hit then
        -- Not clear, set anchor point at hit
        return hit, 1, this.ShouldLatch(position, look_dir, nil, hit, normal)
    end




    -- do some ray casts
    --local hits = swing_raycasts.Cylinder(o, position, look_dir, anchor_dist)


    -- if they are trying to jump at enemy npcs, adjust that
    --  config should tell whether to do this


    -- if they are trying to jump onto a ledge, adjust for that
    --  need to be able to tell the difference between jumping onto a ledge and just jumping over an obstacle


    -- if angle is low/mid and the area is cluttered, reduce the anchor dist and accel
    --  jumping mostly staight up probably shouldn't be limited - they just want to get out of there




    return anchor_pos, 1, false
end

---@return Vector4 anchor_pos Either the point passed in or an altered one
---@return number accel_mult Could be used to weaken the accel
---@return boolean is_latch_hit If true, the grapple should pull to the wall, then stick like a rope
function aimswing_analyze_scenes.Slingshot(position, look_dir, vel, anchor_pos, anchor_dist, o)
    -- Fire a ray to see if the path is clear
    local hit, normal = o:RayCast(position, anchor_pos)
    if hit then
        -- Not clear, set anchor point at hit
        return hit, 1, this.ShouldLatch(position, look_dir, hit, normal)
    end






    return anchor_pos, 1, false
end

----------------------------------- Private Methods -----------------------------------

function this.ShouldLatch(position, look_dir, hit, normal)
    if not ALLOW_LATCH then
        return false
    end

    local dist_sqr = GetVectorDiffLengthSqr(position, hit)
    if dist_sqr > LATCH_MAX_DIST * LATCH_MAX_DIST then
        return false
    end

    local dot_look = DotProduct3D(look_dir, normal)

    debug_render_screen.Add_Dot(hit, nil, "B6EB80")
    debug_render_screen.Add_Line(hit, AddVectors(hit, normal), nil, "B6EB80")
    debug_render_screen.Add_Text(AddVectors(hit, MultiplyVector(normal, -0.05)), "dot look: " .. tostring(Round(dot_look, 2)), nil, "636B5A", "DBEEC8")

    if dot_look > LATCH_MAX_LOOK_DOT then     -- max is negative because -1 would be looking directly at the wall's normal
        return false
    end

    -- this just makes it too strict
    -- if vel_unit and DotProduct3D(vel_unit, normal) > LATCH_MAX_VEL_DOT then
    --     return false
    -- end

    return true
end

return aimswing_analyze_scenes