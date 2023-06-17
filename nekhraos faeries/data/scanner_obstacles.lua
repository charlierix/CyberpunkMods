Scanner_Obstacles = {}

local this = {}

function Scanner_Obstacles:new(o, search_radius)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.search_radius = search_radius

    obj.material_colors = {}

    obj.icosahedrons = {}       -- gets populated from jsons when first needed

    return obj
end

function Scanner_Obstacles:TEST_Scan()
    this.EnsureIcoLoaded(self)

    -- project a point forward from eyes 2 meters
    self.o:GetPlayerInfo()
    local pos, look_dir = self.o:GetCrosshairInfo()

    local center = AddVectors(pos, MultiplyVector(look_dir, 2))

    -- scan using ico's offsets and normals
    for _, face in ipairs(self.icosahedrons[math.random(#self.icosahedrons)]) do
        local fromPos = Vector4.new(center.x + face.pos.x, center.y + face.pos.y, center.z + face.pos.z, 1)
        local toPos = Vector4.new(fromPos.x + face.norm.x * self.search_radius, fromPos.y + face.norm.y * self.search_radius, fromPos.z + face.norm.z * self.search_radius, 1)

        local hit, normal, material_cname = self.o:RayCast(fromPos, toPos)

        if hit then
            local material = Game.NameToString(material_cname)
            if not self.material_colors[material] then
                self.material_colors[material] = GetRandomColor_HSV_ToHex(0, 360, 0.5, 0.8, 0.66, 0.85, 0.5, 0.5)
            end

            debug_render_screen.Add_Line(fromPos, hit, nil, "40F0")
            debug_render_screen.Add_Square(hit, normal, 1.5, 1.5, nil, self.material_colors[material], "000")
        else
            debug_render_screen.Add_Line(fromPos, toPos, nil, "4F00")
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function this.EnsureIcoLoaded(self)
    local FOLDER = "!configs"

    if #self.icosahedrons > 0 then
        do return end
    end

    for _, file_folder in pairs(dir(FOLDER)) do
        --icosahedron 0.json
        if file_folder.type == "file" and file_folder.name:match("^icosahedron.+json$") then
            print("loading file: " .. file_folder.name)

            local ico_deserialized = DeserializeJSON(FOLDER .. "/" .. file_folder.name)

            local ico = {}

            for _, face in ipairs(ico_deserialized.ico) do
                table.insert(ico,
                {
                    pos = Vector4.new(face.pos_x, face.pos_y, face.pos_z, 1),
                    norm = Vector4.new(face.norm_x, face.norm_y, face.norm_z, 1),
                })
            end

            table.insert(self.icosahedrons, ico)
        end
    end
end