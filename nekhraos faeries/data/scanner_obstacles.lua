Scanner_Obstacles = {}

local this = {}

local SHOW_DEBUG = false

function Scanner_Obstacles:new(o)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o

    -- models\swarmbot_obstacles.cs
    obj.settings = settings_util.Obstacles()

    obj.material_colors = {}

    obj.icosahedrons = {}       -- gets populated from jsons when first needed

    -- list of:
    --  { pos, forget_time, debug_ids }
    obj.prev_casts = StickyList:new()

    obj.next_scan_time = 0

    return obj
end

function Scanner_Obstacles:Tick()
    -- If there aren't orbs, then there's nothing to do
    if orb_pool.GetCount() == 0 then
        do return end       -- don't waste processor checking if there's cleanup.  The next time there's an orb, all the old stuff will get cleaned up
    end

    -- Remove old scan points
    this.RemoveOldScanPoints(self.prev_casts, self.o.timer)

    -- Trying to scan every frame would be excessive
    if self.o.timer < self.next_scan_time then
        do return end
    end

    -- If moving too fast, all the detected obstacles will be behind the player, so there's no point in scanning
    -- beyond a certain speed
    local vel = self.o:Custom_CurrentlyFlying_GetVelocity(self.o.vel)       -- a mod could be flying, so use that velocity else the velocity known by the game
    local speed_sqr = GetVectorLengthSqr(vel)
    if speed_sqr > self.settings.max_speed * self.settings.max_speed then
        do return end
    end

    self.next_scan_time = self.o.timer + GetScaledValue(self.settings.scan_refresh_seconds * 0.9, self.settings.scan_refresh_seconds * 1.1, 0, 1, math.random())

    local speed = math.sqrt(speed_sqr)

    -- Get scan from point
    local fromPos = this.GetSourcePos(self.o, self.settings, speed)
    if not fromPos then
        do return end       -- the point is behind a wall
    end

    -- See if that point has recently been scanned from
    if this.DoesPrevCastExist(fromPos, self.prev_casts) then
        do return end
    end

    -- Store the scan point
    local entry = this.CreatePrevCast(self.o, self.prev_casts, self.settings, fromPos)

    if SHOW_DEBUG then
        this.ShowDebug_ScanPoint(entry, fromPos)
    end

    -- Use an icosahedron to define 20 uniform ray directions (there are several randomly rotated icosahedrons to help things
    -- be more random)
    local ico = this.GetRandomIcosahedron(self.icosahedrons)

    for _, face in ipairs(ico) do
        local toPos = AddVectors(fromPos, MultiplyVector(face.norm, self.settings.scan_radius))

        local hit, normal, material_cname = self.o:RayCast(fromPos, toPos)

        if hit then
            nono_squares.AddRayHit(hit, normal, material_cname)
        end

        if SHOW_DEBUG then
            this.ShowDebug_Hit(entry, fromPos, hit, normal, material_cname, self.material_colors)
        end
    end
end

function Scanner_Obstacles:TEST_Scan2(call_nono_test)
    -- Project a point based on eye and look, then snap that point to a grid
    local fromPos = this.GetSourcePos(self.o, self.settings, 0)
    if not fromPos then
        print("from point isn't visible, skipping the scan")
        do return end
    end

    -- See if that point has recently been scanned from
    if this.DoesPrevCastExist(fromPos, self.prev_casts) then
        print("from point already exists, skipping the scan")
        do return end
    end

    -- Store the scan point
    local entry = this.CreatePrevCast(self.o, self.prev_casts, self.settings, fromPos)

    if SHOW_DEBUG then
        this.ShowDebug_ScanPoint(entry, fromPos)
    end

    -- Use an icosahedron to define 20 uniform ray directions (there are several randomly rotated icosahedrons to help things
    -- be more random)
    local ico = this.GetRandomIcosahedron(self.icosahedrons)

    local hits = {}

    for _, face in ipairs(ico) do
        local toPos = AddVectors(fromPos, MultiplyVector(face.norm, self.settings.scan_radius))

        local hit, normal, material_cname = self.o:RayCast(fromPos, toPos)

        if SHOW_DEBUG then
            this.ShowDebug_Hit(entry, fromPos, hit, normal, material_cname, self.material_colors)
        end

        if hit then
            table.insert(hits, { hit = hit, normal = normal, material = material_cname})
        end
    end

    if call_nono_test then
        nono_squares.TEST_AddHits(hits)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.RemoveOldScanPoints(list, time)
    local index = 1

    while index <= list:GetCount() do
        local entry = list:GetItem(index)

        if time > entry.forget_time then
            if SHOW_DEBUG then
                for _, id in ipairs(entry.debug_ids) do
                    debug_render_screen.Remove(id)
                end
            end

            list:RemoveItem(index)
        else
            index = index + 1
        end
    end
end

function this.GetRandomIcosahedron(list)
    local MAX_COUNT = 24

    if #list == 0 then
        -- List is empty, load the unrotated ico from json
        table.insert(list, this.LoadIcosahedronFromConfig())
        return list[1]
    end

    -- Pick a random ico (unrotated or one of the randomly rotated variants)
    local index = math.random(MAX_COUNT)
    if index <= #list then
        return list[index]
    end

    -- Random rotation at index doesn't exist, create and return one more (don't want to create all rotations at once to avoid
    -- a big execution spike)
    table.insert(list, this.GetRotatedIcosahedron(list[1]))
    return list[#list]
end

function this.LoadIcosahedronFromConfig()
    local ico_deserialized = DeserializeJSON("!configs/icosahedron.json")

    local retVal = {}

    for _, face in ipairs(ico_deserialized.ico) do
        table.insert(retVal,
        {
            pos = Vector4.new(face.pos_x, face.pos_y, face.pos_z, 1),
            norm = Vector4.new(face.norm_x, face.norm_y, face.norm_z, 1),
        })
    end

    return retVal
end

function this.GetRotatedIcosahedron(ico)
    local quat = GetRandomRotation()

    local retVal = {}

    for _, face in ipairs(ico) do
        table.insert(retVal,
        {
            pos = RotateVector3D(face.pos, quat),
            norm = RotateVector3D(face.norm, quat),
        })
    end

    return retVal
end

function this.GetSourcePos(o, settings, speed)
    o:GetPlayerInfo()
    local pos1, look_dir = o:GetCrosshairInfo()

    local look_offset = GetScaledValue(settings.scan_from_look_offset_zero, settings.scan_from_look_offset_max, 0, settings.max_speed, speed)
    look_offset = Clamp(settings.scan_from_look_offset_zero, settings.scan_from_look_offset_max, look_offset)


    local pos2 = Vector4.new
    (
        pos1.x + (look_dir.x * look_offset),
        pos1.y + (look_dir.y * look_offset),
        (pos1.z + (look_dir.z * look_offset)) + settings.scan_from_up_offset,
        1
    )

    local pos3 = this.GetSourcePos_Interval(pos2, settings.from_interval_xy, settings.from_interval_z)

    if o:IsPointVisible(pos1, pos3) then
        return pos3
    else
        return nil
    end
end
function this.GetSourcePos_Interval(pos, interval_xy, interval_z)
    -- I think it's divide pos.x and y by interval_xy
    -- take floor of that
    -- multiply by that floored to get the returned xy

    local x = math.floor(pos.x / interval_xy) * interval_xy
    local y = math.floor(pos.y / interval_xy) * interval_xy
    local z = math.floor(pos.z / interval_z) * interval_z

    return Vector4.new(x, y, z, 1)
end

function this.CreatePrevCast(o, prev_casts, settings, pos)
    local entry = prev_casts:GetNewItem()
    entry.pos = pos
    entry.forget_time = o.timer + settings.hit_remember_seconds

    if SHOW_DEBUG then
        entry.debug_ids = {}
    end

    return entry
end

function this.DoesPrevCastExist(pos, list)
    for i = 1, list:GetCount(), 1 do
        local entry = list:GetItem(i)

        if IsNearValue_vec4(entry.pos, pos) then
            return true
        end
    end

    return false
end

function this.ShowDebug_ScanPoint(entry, fromPos)
    table.insert(entry.debug_ids, debug_render_screen.Add_Dot(fromPos, nil, "8888"))
end
function this.ShowDebug_Hit(entry, fromPos, hit, normal, material_cname, material_colors)
    if hit then
        local material = Game.NameToString(material_cname)
        if not material_colors[material] then
            material_colors[material] = GetRandomColor_HSV_ToHex(0, 360, 0.5, 0.8, 0.66, 0.85, 0.33, 0.33)
        end

        --table.insert(entry.debug_ids, debug_render_screen.Add_Line(fromPos, hit, nil, "40F0"))
        table.insert(entry.debug_ids, debug_render_screen.Add_Square(hit, normal, 1.5, 1.5, nil, material_colors[material], "6000"))
    else
        --table.insert(entry.debug_ids, debug_render_screen.Add_Line(fromPos, toPos, nil, "4F00"))
    end
end