local this = {}

local ROUND = 3
local FOLDER = "scan recordings/"
local HEADER_MATERIALS = "--- Materials ---"
local HEADER_HITS = "--- Hits ---"

Recorder = {}

function Recorder:new(o, const, includeVehicles)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.const = const
    obj.includeVehicles = includeVehicles

    obj.materials_mat_index = {}        -- key is material, value is index
    obj.materials_index_mat = {}        -- list of materials, key is int

    -- These are stored as strings
    -- "hit_x|hit_y|hit_z|norm_x|norm_y|norm_z|material_index"
    obj.hits = {}

    --obj.pos       -- this is the player's position at start time, used to build a filename

    return obj
end

function Recorder:Tick()
    self.o:GetPlayerInfo()
    -- self.o:GetCamera()
    -- if not self.o.player or not self.o.camera then
    --     do return end
    -- end

    if not self.o.player then
        do return end
    end

    if not self.pos then
        self.pos = self.o.pos
    end

    --self:FireRay_LookDir()

    for i = 1, self.const.raysPerFrame do
        self:FireRay_Random()
    end
end

function Recorder:Stop()
    if #self.hits == 0 then
        do return end
    end

    local filename = this.GetFilename(self.pos)

    local handle = io.open(filename, "w+")

    this.WriteSection_Materials(handle, self.materials_index_mat)

    handle:write("\n\n")

    this.WriteSection_Hits(handle, self.hits)

    handle:close()
end

----------------------------------- Private Methods -----------------------------------

function Recorder:FireRay_LookDir()
    local fromPos = Vector4.new(self.o.pos.x, self.o.pos.y, self.o.pos.z + 1.7, 1)
    local toPos = Vector4.new(fromPos.x + (self.o.lookdir_forward.x * self.const.rayLen), fromPos.y + (self.o.lookdir_forward.y * self.const.rayLen), fromPos.z + (self.o.lookdir_forward.z * self.const.rayLen), 1)

    local hit, normal, material = self.o:RayCast(fromPos, toPos, self.includeVehicles)

    self:StoreHit(hit, normal, material)
end
function Recorder:FireRay_Random()
    local height = math.random(self.const.rayHeightMin, self.const.rayHeightMax)

    local direction = GetRandomVector_Spherical_Shell(self.const.rayLen)

    local fromPos = Vector4.new(self.o.pos.x, self.o.pos.y, self.o.pos.z + height, 1)
    local toPos = Vector4.new(fromPos.x + direction.x, fromPos.y + direction.y, fromPos.z + direction.z, 1)

    local hit, normal, material = self.o:RayCast(fromPos, toPos, self.includeVehicles)

    self:StoreHit(hit, normal, material)
end

function Recorder:StoreHit(hit, normal, material)
    if not hit then
        do return end
    end

    local mat_index = this.GetMaterialIndex(material, self.materials_mat_index, self.materials_index_mat)

    local entry =
        tostring(Round(hit.x, ROUND)) .. "|" ..
        tostring(Round(hit.y, ROUND)) .. "|" ..
        tostring(Round(hit.z, ROUND)) .. "|" ..
        tostring(Round(normal.x, ROUND)) .. "|" ..
        tostring(Round(normal.y, ROUND)) .. "|" ..
        tostring(Round(normal.z, ROUND)) .. "|" ..
        tostring(mat_index)

    self.hits[#self.hits+1] = entry
end

function this.GetMaterialIndex(material, mat_index, index_mat)
    -- Look for existing
    local retVal = mat_index[material]      -- the assumption is that this string lookup is faster than a sequential scan.  If that's not the case, then just have the single index_mat list
    if retVal then
        return retVal
    end

    -- This material hasn't been seen yet, add to the lists
    index_mat[#index_mat+1] = material
    mat_index[material] = #index_mat

    return #index_mat
end

function this.GetFilename(pos)
    return
        FOLDER ..
        os.date('%Y-%m-%d %H-%M-%S') .. " - " ..
        tostring(Round(pos.x)) .. ", " ..
        tostring(Round(pos.y)) .. ", " ..
        tostring(Round(pos.z)) ..
        ".txt"
end

function this.WriteSection_Materials(handle, materials)
    handle:write(HEADER_MATERIALS .. "\n")

    for i = 1, #materials do
        handle:write(tostring(i) .. "\t" .. materials[i] .. "\n")
    end
end
function this.WriteSection_Hits(handle, hits)
    handle:write(HEADER_HITS .. "\n")

    for i = 1, #hits do
        handle:write(hits[i] .. "\n")
    end
end