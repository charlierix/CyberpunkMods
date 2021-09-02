Collection_BossArea = {}

local this = {}

local FOLDER = "boss areas"
local MAX_RADIUS = 144

function Collection_BossArea:new(const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.const = const

    obj.boss_areas = nil

    return obj
end

function Collection_BossArea:GetRandom(center, radius_min, radius_max, is3D)
    self:EnsureLoaded()

end

----------------------------------- Private Methods -----------------------------------

function Collection_BossArea:EnsureLoaded()
    if self.boss_areas then
        do return end
    end

    ClearDeserializeErrorLogs()

    self.boss_areas = {}

    for _, folder in pairs(dir(FOLDER)) do

        --TODO: Also accept single json containing the same thing as the folder structure

        if folder.type == self.const.filetype.directory then
            this.LoadArea(FOLDER .. "/" .. folder.name, self.boss_areas, self.const)
        end
    end

    CloseErrorFiles()
end

function this.LoadArea(folder, list, const)
    local about = this.LoadAbout(folder, const)
    if not about then
        do return end
    end

    --local decorations = {}
    --local drops = {}
    local npcs = {}
    local spawns = {}

    -- Scan for sub folders
    for _, subfolder in pairs(dir(folder)) do
        if subfolder.type == const.filetype.directory then
            if subfolder.name == "decorations" then
                --TODO: Implement decorations (may want a separate folder for building pieces (ceilings/walls/floors))

            elseif subfolder.name == "drops" then
                --TODO: Implement drops (these are loot boxes that spawn after conditions are met)

            elseif subfolder.name == "npcs" then
                if not this.LoadNPCs(folder .. "/" .. subfolder.name, npcs, about.center, const) then
                    do return end
                end

            elseif subfolder.name == "spawns" then
                if not this.LoadSpawns(folder .. "/" .. subfolder.name, spawns, about.center, const) then
                    do return end
                end
            end
        end
    end

    -- Final validation
    local success, errMsg = this.ValidateArea(about, npcs, spawns, const)
    if not success then
        AddError_BossArea(folder .. "\n\t" .. errMsg)
        do return end
    end

    -- Add the area
    list[#list+1] =
    {
        about = about,
        npcs = npcs,
        spawns = spawns,
    }
end
function this.ValidateArea(about, npcs, spawns, const)
    if #npcs == 0 then
        return false, "Must have at least one npc"
    end

    if about.modded_parkour == const.modded_parkour.unreachable and #spawns == 0 then
        return false, "Spawn points are required when modded_parkour is unreachable"
    end

    return true, nil
end

function this.LoadAbout(folder, const)
    local retVal = nil

    for _, file in pairs(dir(folder)) do
        if file.type == const.filetype.file and file.name == "about.json" then
            -- Deserialize, validate the file
            retVal = this.LoadAbout_Deserialize(folder .. "/" .. file.name, const)
            if not retVal then
                return nil
            end
        end
    end

    if not retVal then
        AddError_BossArea(folder .. "\n\tDidn't find about.json")
        return nil
    end

    return retVal
end
function this.LoadAbout_Deserialize(file, const)
    -- Parse json
    local retVal, errMsg = DeserializeJSON(file)
    if not retVal then
        AddError_BossArea(file .. "\n\tCouldn't parse as json\n\t" .. errMsg)
        return nil
    end

    -- Check required fields, datatypes
    local success, errMsg = this.ValidateAbout(retVal, const)
    if not success then
        AddError_BossArea(file .. "\n\t" .. errMsg)
        return nil
    end

    -- Cap string lengths
    retVal.author = Cap_Author(retVal.author)
    retVal.description = Cap_Description(retVal.description)
    Cap_Tags(retVal.tags)

    -- Create vector
    retVal.center = Vector4.new(retVal.center_x, retVal.center_y, retVal.center_z, 1)

   return retVal
end
function this.ValidateAbout(about, const)
    local success, errMsg = ValidateType_prop(about, "author", const.types.string, false)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(about, "description", const.types.string, false)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateTags(about.tags)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(about, "modded_parkour", const.types.string, true)
    if not success then
        return false, errMsg
    end

    if not Contains_Key(const.modded_parkour, about.modded_parkour) then
        return false, "modded_parkour has invalid value: " .. about.modded_parkour
    end

    success, errMsg = ValidateType_prop(about, "center_x", const.types.number, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(about, "center_y", const.types.number, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(about, "center_z", const.types.number, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(about, "yaw", const.types.number, true)
    if not success then
        return false, errMsg
    end

    return true, nil
end

function this.LoadNPCs(folder, list, center, const)
    for _, file in pairs(dir(folder)) do
        if file.type == const.filetype.file and file.name:match("%.json$") then
            -- Deserialize, validate the file
            local npc = this.LoadNPCs_Deserialize(folder .. "/" .. file.name, center, const)
            if not npc then
                return false
            end

            list[#list+1] = npc
        end
    end

    return true
end
function this.LoadNPCs_Deserialize(file, center, const)
    -- Parse json
    local retVal, errMsg = DeserializeJSON(file)
    if not retVal then
        AddError_BossArea(file .. "\n\tCouldn't parse as json\n\t" .. errMsg)
        return nil
    end

    -- Check required fields, datatypes
    local success, errMsg = this.ValidateNPC(retVal, const)
    if not success then
        AddError_BossArea(file .. "\n\t" .. errMsg)
        return nil
    end

    retVal.entity_path = Cap_Entity(retVal.entity_path)
    retVal.appearance = Cap_Entity(retVal.appearance)       -- reusing the same entity function until there's a reason not to

    -- Create vector
    retVal.position = Vector4.new(retVal.position_x, retVal.position_y, retVal.position_z, 1)

    local distanceSqr = GetVectorDiffLengthSqr(center, retVal.position)
    if distanceSqr > MAX_RADIUS * MAX_RADIUS then
        AddError_BossArea(file .. "\n\t" .. "NPC is too far away from the center: " .. tostring(math.sqrt(distanceSqr)))
        return nil
    end

    return retVal
end
function this.ValidateNPC(npc, const)
    local success, errMsg = ValidateType_prop(npc, "entity_path", const.types.string, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(npc, "appearance", const.types.string, false)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(npc, "position_x", const.types.number, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(npc, "position_y", const.types.number, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(npc, "position_z", const.types.number, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(npc, "yaw", const.types.number, true)
    if not success then
        return false, errMsg
    end

    return true, nil
end

function this.LoadSpawns(folder, list, center, const)
    for _, file in pairs(dir(folder)) do
        if file.type == const.filetype.file and file.name:match("%.json$") then
            -- Deserialize, validate the file
            local spawn = this.LoadSpawns_Deserialize(folder .. "/" .. file.name, center, const)
            if not spawn then
                return false
            end

            list[#list+1] = spawn
        end
    end

    return true
end
function this.LoadSpawns_Deserialize(file, center, const)
    -- Parse json
    local retVal, errMsg = DeserializeJSON(file)
    if not retVal then
        AddError_BossArea(file .. "\n\tCouldn't parse as json\n\t" .. errMsg)
        return nil
    end

    -- Check required fields, datatypes
    local success, errMsg = this.ValidateSpawn(retVal, const)
    if not success then
        AddError_BossArea(file .. "\n\t" .. errMsg)
        return nil
    end

    -- Create vector
    retVal.position = Vector4.new(retVal.position_x, retVal.position_y, retVal.position_z, 1)

    local distanceSqr = GetVectorDiffLengthSqr(center, retVal.position)
    if distanceSqr > MAX_RADIUS * MAX_RADIUS then
        AddError_BossArea(file .. "\n\t" .. "Spawn point is too far away from the center: " .. tostring(math.sqrt(distanceSqr)))
        return nil
    end

   return retVal
end
function this.ValidateSpawn(spawn, const)
    local success, errMsg = ValidateType_prop(spawn, "position_x", const.types.number, true)
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