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
        if file.type == "file" and file.name:match("%.json$") then
            -- Deserialize, validate the file.  Either store it or log an error
            this.LoadFile(FOLDER, file, self.spawn_points, self.const)
        end
    end

    FlushErrorFiles()
end

function this.LoadFile(folder, file, list, const)
    -- Parse json
    local handle = io.open(folder .. "/" .. file.name, "r")
    local json = handle:read("*all")

    local sucess, spawn = pcall(
        function(j) return extern_json.decode(j) end,
        json)

    if not sucess then
        AddError_Spawn(file.name .. "\n\tCouldn't parse as json\n\t" .. tostring(spawn))      -- when pcall has an error, the second value returned is the error message, otherwise it't the successful return value (spawn instance in this case)
        do return end
    end

    -- Check required fields, datatypes
    local success, errMsg = this.ValidateSpawn(spawn, const)
    if not success then
        AddError_Spawn(file.name .. "\n\t" .. errMsg)
        do return end
    end

    -- Cap string lengths
    spawn.author = String_Cap(spawn.author, 72)
    spawn.description = String_Cap(spawn.description, 1024)

    if spawn.tags then
        for i = 1, #spawn.tags do
            spawn.tags[i] = String_Cap(spawn.tags[i], 24)
        end
    end

    spawn.position = Vector4.new(spawn.position_x, spawn.position_y, spawn.position_z, 1)

    -- Store it
    list[#list+1] = spawn
end

function this.ValidateSpawn(spawn, const)
    if spawn.tags then
        if type(spawn.tags) ~= "table" then
            return false, "tags must be a list: " .. type(spawn.tags)
        end

        for i = 1, #spawn.tags do       --NOTE: It's possible that this is a key/value list, but it will never be used that way, so it will only eat up memory
            if type(spawn.tags[i]) ~= "string" then
                return false, "all tags must be strings: " .. type(spawn.tags[i])
            end
        end
    end

    local istype, errMsg = this.ValidateType(spawn.modded_parkour, "modded_parkour", "string")
    if not istype then
        return false, errMsg
    end

    if not Contains_Key(const.modded_parkour, spawn.modded_parkour) then
        return false, "modded_parkour has invalid value: " .. spawn.modded_parkour
    end

    istype, errMsg = this.ValidateType(spawn.position_x, "position_x", "number")
    if not istype then
        return false, errMsg
    end

    istype, errMsg = this.ValidateType(spawn.position_y, "position_y", "number")
    if not istype then
        return false, errMsg
    end

    istype, errMsg = this.ValidateType(spawn.position_z, "position_z", "number")
    if not istype then
        return false, errMsg
    end

    istype, errMsg = this.ValidateType(spawn.yaw, "yaw", "number")
    if not istype then
        return false, errMsg
    end

    return true, nil
end

--TODO: Move this to a util
function this.ValidateType(item, itemname, typename)
    if item == nil then
        return false, itemname .. " is nil"

    elseif type(item) ~= typename then
        return false, itemname .. " isn't a " .. typename .. ": " .. type(item)

    else
        return true, nil
    end
end