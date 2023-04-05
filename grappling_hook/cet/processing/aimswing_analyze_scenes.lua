local swing_raycasts = require("processing/aimswing_raycasts")

local this = {}
local aimswing_analyze_scenes = {}

local ALLOW_LATCH = true
local LATCH_MAX_LOOK_DOT = -0.71
local LATCH_MAX_VEL_DOT = -0.6
local LATCH_MAX_DIST = 14

-- Called when firing a swing from the ground.  After the initial calculations, this is called and does some raycasts
-- to possible alter the grapple

---@return Vector4 anchor_pos Either the point passed in or an altered one
---@return number accel_mult Could be used to weaken the accel
---@return boolean is_latch_hit If true, the grapple should pull to the wall, then stick like a rope
function aimswing_analyze_scenes.FromGround(position, look_dir, anchor_pos, anchor_dist, o, debug_cat1, debug_cat2)
    -- Fire a ray to see if the path is clear
    local hit, normal = o:RayCast(position, anchor_pos)
    if hit then
        -- Not clear, set anchor point at hit
        return hit, 1, this.ShouldLatch(position, look_dir, nil, hit, normal)
    end




    -- do some ray casts

    local hits, num_calls = swing_raycasts.Cylinder2(o, position, look_dir, anchor_dist * 1.5, 0, 1)
    local pressure = this.GetHitPressure(hits, num_calls, position, look_dir)

    debug_render_screen.Add_Text2D(nil, nil, "pressure: " .. tostring(Round(pressure, 2)), debug_cat1)






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
function aimswing_analyze_scenes.Slingshot(position, look_dir, vel, anchor_pos, anchor_dist, speed_look, o, debug_cat1, debug_cat2)
    -- Fire a ray to see if the path is clear
    local hit, normal = o:RayCast(position, anchor_pos)
    if hit then
        -- Not clear, set anchor point at hit
        return hit, 1, this.ShouldLatch(position, look_dir, hit, normal)
    end


    local hits, num_calls = swing_raycasts.Cylinder2(o, position, look_dir, anchor_dist * 1.5, speed_look, 1)
    local pressure = this.GetHitPressure(hits, num_calls, position, look_dir)

    debug_render_screen.Add_Text2D(nil, nil, "pressure: " .. tostring(Round(pressure, 2)), debug_cat1)



    return anchor_pos, 1, false
end

-- returns: destination position, should latch
function aimswing_analyze_scenes.UnderSwing(position, look_dir, vel, dest_pos, dest_dist, speed_look, o, debug_cat1, debug_cat2)

    -- ************** scene rays **************

    -- do some wide scans of the area, decide if the destination should be pulled forward or back

    local hits, num_calls = swing_raycasts.Cylinder2(o, position, look_dir, dest_dist * 1.5, speed_look, 1.5)
    local pressure = this.GetHitPressure(hits, num_calls, position, look_dir)

    debug_render_screen.Add_Text2D(nil, nil, "pressure: " .. tostring(Round(pressure, 2)), debug_cat1)


    -- ************** path rays **************

    -- ray from head to dest position

    -- calculate expected dip

    -- a few rays to cover that area

    -- and some to the side



    --------------- no blockers ---------------

    -- return normal


    --------------- fully blocked ---------------

    -- possibly allow latch, or just return normally


    --------------- near miss, gap below ---------------

    -- adjust the desination down and/or forward

    --------------- near miss, gap above ---------------

    -- ajust the desination up and/or back




    return dest_pos, false
end

-- returns anchor position, release point, should latch
function aimswing_analyze_scenes.TossUp(position, anchor_pos, release_point, speed_look, o, debug_cat1, debug_cat2)


    local cast_dir = SubtractVectors(release_point, position)
    local cast_len = GetVectorLength(cast_dir)
    cast_dir = MultiplyVector(cast_dir, 1 / cast_len)

    local hits, num_calls = swing_raycasts.Cylinder2(o, position, cast_dir, cast_len * 1.5, speed_look, 1.5)
    local pressure = this.GetHitPressure(hits, num_calls, position, cast_dir)

    debug_render_screen.Add_Text2D(nil, nil, "pressure: " .. tostring(Round(pressure, 2)), debug_cat1)


    -- toss up would need to adjust anchor and release proportionally

    return anchor_pos, release_point, false
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

function this.GetHitPressure(hits, num_calls, position, look_dir)
    local PRESSURE_ZERO = 4
    local PRESSURE_RADIUS = 1
    local RADIUS = 8        --TODO: may want to adjust based on speed

    local sum_pressure = 0

    for _, hit in ipairs(hits) do
        local line_point = GetClosestPoint_Line_Point(position, look_dir, hit)
        local hit_dist = math.sqrt(GetVectorDiffLengthSqr(hit, line_point))

        --TODO: may want 1/x style
        local pressure = Clamp(0, PRESSURE_ZERO, GetScaledValue(PRESSURE_ZERO, PRESSURE_RADIUS, 0, RADIUS, hit_dist))

        sum_pressure = sum_pressure + pressure
    end

    return sum_pressure / num_calls
end

return aimswing_analyze_scenes