Recorder = {}

function Recorder:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    -- key is material, value is index
    obj.materials = {}
    -- These are stored as strings
    -- "hit_x|hit_y|hit_z|norm_x|norm_y|norm_z|material_index"
    obj.points = {}

    return obj
end

function Recorder:Tick()
    
end

function Recorder:Stop()
    
end