local this = {}

local up = nil      -- can't use vector4 before init

function Jump_AvoidOverhangs(impulse, hangPos, normal_horz, o)
    -- Only do this check if they are jumping mostly straight up
    if impulse.z < 0 then
        return impulse
    end

    local impulse_len = GetVectorLength(impulse)
    if IsNearZero(impulse_len) then
        return impulse
    end

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    local impulse_unit = DivideVector(impulse, impulse_len)
    if DotProduct3D(impulse_unit, up) < 0.9 then
        return impulse
    end

    local ray_dist = 2 + 1      -- 2 for the height of the player, then whatever distance above the player to check
    local player_radius = 0.2

    --NOTE: o.pos and hangPos should be the same thing

    local log = this.CreateLog()
    local log_name = "avoid overhangs"
    this.LogWall(log, hangPos, normal_horz)
    this.LogPlayer(log, o.pos, impulse)
    this.LogRayPlate_Up(log, normal_horz, o.pos, ray_dist, player_radius, o)
    this.LogRayPlate_Wall(log, normal_horz, o.pos, 2, player_radius, o)

    --TODO: May need to fire a ray from the perimeter of the player's collision hull
    -- local hit = o:RayCast(o.pos, AddVectors(o.pos, MultiplyVector(impulse_unit, ray_dist)))
    -- if not hit then
    --     return impulse
    -- end

    -- local offset_dist = 1       -- how far to check


    local ray = MultiplyVector(impulse_unit, ray_dist)

    -- Start simple: front / center / rear
    local from = AddVectors(o.pos, MultiplyVector(normal_horz, -player_radius))
    local hit_front, normal_front = o:RayCast(from, AddVectors(from, ray))

    log:Add_Dot(from, "player_ray_start")
    if hit_front then
        log:Add_Dot(hit_front, "player_ray_hit")
        log:Add_Line(hit_front, AddVectors(hit_front, normal_front), "player_ray_hit")
    else
        log:Add_Dot(AddVectors(from, ray), "player_ray_miss")
    end

    local hit_center, normal_center = o:RayCast(o.pos, AddVectors(o.pos, ray))

    log:Add_Dot(o.pos, "player_ray_start")
    if hit_center then
        log:Add_Dot(hit_center, "player_ray_hit")
        log:Add_Line(hit_center, AddVectors(hit_center, normal_center), "player_ray_hit")
    else
        log:Add_Dot(AddVectors(o.pos, ray), "player_ray_miss")
    end


    from = AddVectors(o.pos, MultiplyVector(normal_horz, player_radius))
    local hit_rear, normal_rear = o:RayCast(from, AddVectors(from, ray))

    log:Add_Dot(from, "player_ray_start")
    if hit_rear then
        log:Add_Dot(hit_rear, "player_ray_hit")
        log:Add_Line(hit_rear, AddVectors(hit_rear, normal_rear), "player_ray_hit")
    else
        log:Add_Dot(AddVectors(from, ray), "player_ray_miss")
    end

    log:Save(log_name)

    return impulse
end
function Jump_AvoidOverhangs2(impulse, hangPos, normal_horz, o)
    -- Only do this check if they are jumping mostly straight up
    if impulse.z < 0 then
        return impulse
    end

    local impulse_len = GetVectorLength(impulse)
    if IsNearZero(impulse_len) then
        return impulse
    end

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    local impulse_unit = DivideVector(impulse, impulse_len)
    if DotProduct3D(impulse_unit, up) < 0.75 then
        return impulse
    end

    local ray_dist = 2 + 1.5      -- 2 for the height of the player, then whatever distance above the player to check
    local player_radius = 0.25

    local log = this.CreateLog()
    local log_name = "avoid overhangs2"
    this.LogWall(log, hangPos, normal_horz)
    this.LogPlayer(log, o.pos, impulse)


    local ray = MultiplyVector(impulse_unit, ray_dist)

    -- Front
    local from_front = AddVectors(o.pos, MultiplyVector(normal_horz, -player_radius))
    local to_front = AddVectors(from_front, ray)
    local hit_front, normal_front = o:RayCast(from_front, to_front)

    log:Add_Dot(from_front, "player_ray_start")
    if hit_front then
        log:Add_Dot(hit_front, "player_ray_hit")
        log:Add_Line(hit_front, AddVectors(hit_front, normal_front), "player_ray_hit")
    else
        log:Add_Dot(to_front, "player_ray_miss")
    end

    -- Center
    local to_center = AddVectors(o.pos, ray)
    local hit_center, normal_center = o:RayCast(o.pos, to_center)

    log:Add_Dot(o.pos, "player_ray_start")
    if hit_center then
        log:Add_Dot(hit_center, "player_ray_hit")
        log:Add_Line(hit_center, AddVectors(hit_center, normal_center), "player_ray_hit")
    else
        log:Add_Dot(to_center, "player_ray_miss")
    end

    -- Rear
    local from = AddVectors(o.pos, MultiplyVector(normal_horz, player_radius))
    local to_rear = AddVectors(from, ray)
    local hit_rear, normal_rear = o:RayCast(from, to_rear)

    log:Add_Dot(from, "player_ray_start")
    if hit_rear then
        log:Add_Dot(hit_rear, "player_ray_hit")
        log:Add_Line(hit_rear, AddVectors(hit_rear, normal_rear), "player_ray_hit")
    else
        log:Add_Dot(to_rear, "player_ray_miss")
    end

    -- Extra Rear
    from = AddVectors(o.pos, MultiplyVector(normal_horz, player_radius * 3))
    local to_extrarear = AddVectors(from, ray)
    local hit_extrarear, normal_extrarear = o:RayCast(from, to_extrarear)

    log:Add_Dot(from, "player_ray_start")
    if hit_extrarear then
        log:Add_Dot(hit_extrarear, "player_ray_hit")
        log:Add_Line(hit_extrarear, AddVectors(hit_extrarear, normal_extrarear), "player_ray_hit")
    else
        log:Add_Dot(to_extrarear, "player_ray_miss")
    end

    impulse = this.AvoidOverhangs2_PossiblyRotate(impulse, from_front, hit_front, hit_center, hit_rear, hit_extrarear, to_front, to_center, to_rear, to_extrarear)

    log:Add_Line(o.pos, AddVectors(o.pos, impulse), "final_impulse")



    log:Save(log_name)

    return impulse
end

----------------------------------- Private Methods -----------------------------------

function this.AvoidOverhangs2_PossiblyRotate(impulse, from_front, hit_front, hit_center, hit_rear, hit_extrarear, to_front, to_center, to_rear, to_extrarear)
    if not hit_front then
        return impulse
    end

    if not hit_center then
        return this.AvoidOverhangs2_Rotate(impulse, from_front, hit_front, to_center)
    end

    if not hit_rear then
        return this.AvoidOverhangs2_Rotate(impulse, from_front, hit_center, to_rear)
    end

    if not hit_extrarear then
        return this.AvoidOverhangs2_Rotate(impulse, from_front, hit_rear, to_extrarear)
    end

    return impulse
end
function this.AvoidOverhangs2_Rotate(impulse, from, hit, miss)
    local rotate_to_point = GetClosestPoint_Line_Point(from, SubtractVectors(miss, from), hit)

    local dir_from = ToUnit(SubtractVectors(hit, from))
    local dir_to = ToUnit(SubtractVectors(rotate_to_point, from))

    local quat = GetRotation(dir_from, dir_to, 2)       -- go a little farther

    return RotateVector3D(impulse, quat)
end

function this.CreateLog()
    local log = DebugRenderLogger:new(true)

    log:DefineCategory("player", "FF5", 1)
    log:DefineCategory("wall", "4000", 1)
    log:DefineCategory("final_impulse", "5F5", 1)

    log:DefineCategory("plate_start", "3888", 0.333)
    log:DefineCategory("plate_miss", "6977", 0.333)
    log:DefineCategory("plate_hit", "77A", 0.333)

    log:DefineCategory("player_ray_start", "8CC4", 0.5)
    log:DefineCategory("player_ray_miss", "8ECA", 0.5)
    log:DefineCategory("player_ray_hit", "84CC", 0.5)

    return log
end
function this.LogWall(log, hangPos, normal_horz)
    log:Add_Square(hangPos, normal_horz, 1, 1, "wall")
    log:Add_Dot(hangPos, "wall")
    log:Add_Line(hangPos, AddVectors(hangPos, normal_horz), "wall")
end
function this.LogPlayer(log, pos, impulse)
    log:Add_Dot(pos, "player")
    log:Add_Line(pos, AddVectors(pos, impulse), "player")
end
function this.LogRayPlate_Up(log, normal_horz, pos, ray_dist, player_radius, o)
    local right = CrossProduct3D(normal_horz, up)

    local steps = 4
    local max_dist = 3

    local origin = AddVectors(pos, MultiplyVector(normal_horz, -player_radius))

    for x = -steps, steps, 1 do
        for y = 0, steps * 1.5, 1 do
            local offset_along = MultiplyVector(right, max_dist * (x / steps))
            local offset_out = MultiplyVector(normal_horz, max_dist * (y / steps))

            local from = AddVectors(AddVectors(origin, offset_along), offset_out)
            local to = Vector4.new(from.x, from.y, from.z + ray_dist, 1)

            local hit, normal = o:RayCast(from, to)

            log:Add_Dot(from, "plate_start")

            if hit then
                log:Add_Dot(hit, "plate_hit")
                log:Add_Line(hit, AddVectors(hit, normal), "plate_hit")
            else
                log:Add_Dot(to, "plate_miss")
            end
        end
    end
end
function this.LogRayPlate_Wall(log, normal_horz, pos, ray_dist, player_radius, o)
    local right = CrossProduct3D(normal_horz, up)

    local steps = 4
    local max_dist = 3

    local direction = MultiplyVector(normal_horz, -ray_dist)

    for x = -steps, steps, 1 do
        for y = 0, steps * 2, 1 do
            local offset_along = MultiplyVector(right, max_dist * (x / steps))
            local offset_up = MultiplyVector(up, max_dist * (y / steps))

            local from = AddVectors(AddVectors(pos, offset_along), offset_up)
            local to = AddVectors(from, direction)

            local hit, normal = o:RayCast(from, to)

            log:Add_Dot(from, "plate_start")

            if hit then
                log:Add_Dot(hit, "plate_hit")
                log:Add_Line(hit, AddVectors(hit, normal), "plate_hit")
            else
                log:Add_Dot(to, "plate_miss")
            end
        end
    end
end