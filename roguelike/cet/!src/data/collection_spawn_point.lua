Collection_SpawnPoint = {}

local this = {}

local FOLDER = "spawn points"

function Collection_SpawnPoint:new(const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.const = const

    obj.spawn_points = nil

    return obj
end

-- This will return a random spawn point
function Collection_SpawnPoint:GetRandom(center, radius_min, radius_max, is3D)
    self:EnsureLoaded()

    return FindRandom_Position(self.spawn_points, center, radius_min, radius_max, is3D)
end

----------------------------------- Private Methods -----------------------------------

function Collection_SpawnPoint:EnsureLoaded()
    if self.spawn_points then
        do return end
    end

    ClearDeserializeErrorLogs()

    self.spawn_points = {}

    for _, file in pairs(dir(FOLDER)) do
        if file.type == self.const.filetype.file and file.name:match("%.json$") then
            -- Deserialize, validate the file.  Either store it or log an error
            this.LoadFile(FOLDER, file.name, self.spawn_points, self.const)
        end
    end

    CloseErrorFiles()
end

function this.LoadFile(folder, file, list, const)
    -- Parse json
    local spawn, errMsg = DeserializeJSON(folder .. "/" .. file)
    if not spawn then
        AddError_Spawn(file .. "\n\tCouldn't parse as json\n\t" .. errMsg)
        do return end
    end

    -- Check required fields, datatypes
    local success, errMsg = this.ValidateSpawn(spawn, const)
    if not success then
        AddError_Spawn(file .. "\n\t" .. errMsg)
        do return end
    end

    -- Cap string lengths
    spawn.author = Cap_Author(spawn.author)
    spawn.description = Cap_Description(spawn.description)
    Cap_Tags(spawn.tags)

    -- Create vector
    spawn.position = Vector4.new(spawn.position_x, spawn.position_y, spawn.position_z, 1)

    -- Store it
    list[#list+1] = spawn
end

function this.ValidateSpawn(spawn, const)
    local success, errMsg = ValidateType_prop(spawn, "author", const.types.string, false)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(spawn, "description", const.types.string, false)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateTags(spawn.tags)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(spawn, "modded_parkour", const.types.string, true)
    if not success then
        return false, errMsg
    end

    if not Contains_Key(const.modded_parkour, spawn.modded_parkour) then
        return false, "modded_parkour has invalid value: " .. spawn.modded_parkour
    end

    success, errMsg = ValidateType_prop(spawn, "position_x", const.types.number, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(spawn, "position_y", const.types.number, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(spawn, "position_z", const.types.number, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(spawn, "yaw", const.types.number, true)
    if not success then
        return false, errMsg
    end

    return true, nil
end

