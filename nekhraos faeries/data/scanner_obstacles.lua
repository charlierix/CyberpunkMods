Scanner_Obstacles = {}

local this = {}

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
    --  { pos, forget_time }
    obj.prev_casts = StickyList:new()

    return obj
end

function Scanner_Obstacles:TEST_Scan2()
    -- Project a point based on eye and look, then snap that point to a grid
    local fromPos = this.GetSourcePos(self)
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
    local entry = self.prev_casts:GetNewItem()
    entry.pos = fromPos
    entry.forget_time = self.o.timer + self.settings.hit_remember_seconds

    debug_render_screen.Add_Dot(fromPos, nil, "8888")

    -- Use an icosahedron to define 20 uniform ray directions (there are several randomly rotated icosahedron to help things
    -- be more random)
    local ico = this.GetRandomIcosahedron(self.icosahedrons)

    for _, face in ipairs(ico) do
        local toPos = AddVectors(fromPos, MultiplyVector(face.norm, self.settings.search_radius))

        local hit, normal, material_cname = self.o:RayCast(fromPos, toPos)

        if hit then
            local material = Game.NameToString(material_cname)
            if not self.material_colors[material] then
                self.material_colors[material] = GetRandomColor_HSV_ToHex(0, 360, 0.5, 0.8, 0.66, 0.85, 0.33, 0.33)
            end

            --debug_render_screen.Add_Line(fromPos, hit, nil, "40F0")
            debug_render_screen.Add_Square(hit, normal, 1.5, 1.5, nil, self.material_colors[material], "6000")
        else
            --debug_render_screen.Add_Line(fromPos, toPos, nil, "4F00")
        end
    end
end

----------------------------------- Private Methods -----------------------------------

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

function this.GetSourcePos(self)
    self.o:GetPlayerInfo()
    local pos1, look_dir = self.o:GetCrosshairInfo()

    local pos2 = Vector4.new
    (
        pos1.x + (look_dir.x * self.settings.scan_from_look_offset),
        pos1.y + (look_dir.y * self.settings.scan_from_look_offset),
        (pos1.z + (look_dir.z * self.settings.scan_from_look_offset)) + self.settings.scan_from_up_offset,
        1
    )

    local pos3 = this.GetSourcePos_Interval(pos2, self.settings.from_interval_xy, self.settings.from_interval_z)

    if self.o:IsPointVisible(pos1, pos3) then
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

function this.DoesPrevCastExist(pos, list)
    for i = 1, list:GetCount(), 1 do
        local entry = list:GetItem(i)

        if IsNearValue_vec4(entry.pos, pos) then
            return true
        end
    end

    return false
end