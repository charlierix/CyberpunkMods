local this = {}

local ROUND = 3

Recorder = {}

function Recorder:new(o, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.const = const

    obj.materials_mat_index = {}        -- key is material, value is index
    obj.materials_index_mat = {}        -- list of materials, key is int

    -- These are stored as strings
    -- "hit_x|hit_y|hit_z|norm_x|norm_y|norm_z|material_index"
    obj.points = {}

    return obj
end

function Recorder:Tick()
    self.o:GetPlayerInfo()
    self.o:GetCamera()
    if not self.o.player or not self.o.camera then
        do return end
    end

    local fromPos = Vector4.new(self.o.pos.x, self.o.pos.y, self.o.pos.z + 1.7, 1)
    local toPos = Vector4.new(fromPos.x + (self.o.lookdir_forward.x * self.const.rayLen), fromPos.y + (self.o.lookdir_forward.y * self.const.rayLen), fromPos.z + (self.o.lookdir_forward.z * self.const.rayLen), 1)

    local hit, normal, material = self.o:RayCast(fromPos, toPos, self.const.includeVehicles)
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

    self.points[#self.points+1] = entry
end

function Recorder:Stop()
    
end

----------------------------------- Private Methods -----------------------------------

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