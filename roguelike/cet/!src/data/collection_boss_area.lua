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

    for _, file_folder in pairs(dir(FOLDER)) do
        if file_folder.type == self.const.filetype.directory then
            -- Folder containing subfolders and little json files
            this.LoadArea_folder(FOLDER .. "/" .. file_folder.name, self.boss_areas, self.const)

        elseif file_folder.type == self.const.filetype.file and file_folder.name:match("%.json$") then
            -- Single json file containing everything
            this.LoadArea_file(FOLDER .. "/" .. file_folder.name, self.boss_areas, self.const)
        end
    end

    CloseErrorFiles()
end

function this.LoadArea_file(file, list, const)
    -- Parse json
    local area, errMsg = DeserializeJSON(file)
    if not area then
        AddError_BossArea(file .. "\n\tCouldn't parse as json\n\t" .. errMsg)
        do return end
    end

    -- About
    if not this.FinishAbout(file, area.about, const) then
        do return end
    end

    -- NPCs
    local success, errMsg = ValidateType_prop(area, "npcs", const.types.table, true)
    if not success then
        AddError_BossArea(file .. "\n\t" .. errMsg)
        do return end
    end

    for i = 1, #area.npcs do
        if not this.FinishNPC(file, area.npcs[i], area.about.center, const) then
            do return end
        end
    end

    -- Spawns
    success, errMsg = ValidateType_prop(area, "spawns", const.types.table, false)
    if not success then
        AddError_BossArea(file .. "\n\t" .. errMsg)
        do return end
    end

    if not area.spawns then
        area.spawns = {}
    end

    for i = 1, #area.spawns do
        if not this.FinishSpawn(file, area.spawns[i], area.about.center, const) then
            do return end
        end
    end

    -- Final validation
    success, errMsg = this.ValidateArea(area.about, area.npcs, area.spawns, const)
    if not success then
        AddError_BossArea(file .. "\n\t" .. errMsg)
        do return end
    end

    -- Add to the list
    list[#list+1] = area
end
function this.LoadArea_folder(folder, list, const)
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
            local finalFilename = folder .. "/" .. file.name

            -- Parse json
            local about, errMsg = DeserializeJSON(finalFilename)
            if not about then
                AddError_BossArea(finalFilename .. "\n\tCouldn't parse as json\n\t" .. errMsg)
                return nil
            end

            -- Validate and set final property values
            if this.FinishAbout(finalFilename, about, const) then
                retVal = about
            else
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
function this.FinishAbout(file, about, const)
    -- Check required fields, datatypes
    local success, errMsg = this.ValidateAbout(about, const)
    if not success then
        AddError_BossArea(file .. "\n\t" .. errMsg)
        return false
    end

    -- Cap string lengths
    about.author = Cap_Author(about.author)
    about.description = Cap_Description(about.description)
    Cap_Tags(about.tags)

    -- Create vector
    about.center = Vector4.new(about.center_x, about.center_y, about.center_z, 1)

   return true
end
function this.ValidateAbout(about, const)
    local success, errMsg = ValidateType_var(about, "about", const.types.table, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(about, "author", const.types.string, false)
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
            local finalFilename = folder .. "/" .. file.name

            -- Parse json
            local npc, errMsg = DeserializeJSON(finalFilename)
            if not npc then
                AddError_BossArea(finalFilename .. "\n\tCouldn't parse as json\n\t" .. errMsg)
                return false
            end

            -- Validate and set final property values
            if this.FinishNPC(finalFilename, npc, center, const) then
                list[#list+1] = npc
            else
                return false
            end
        end
    end

    return true
end
function this.FinishNPC(file, npc, center, const)
    -- Check required fields, datatypes
    local success, errMsg = this.ValidateNPC(npc, const)
    if not success then
        AddError_BossArea(file .. "\n\t" .. errMsg)
        return false
    end

    npc.entity_path = Cap_Entity(npc.entity_path)
    npc.appearance = Cap_Entity(npc.appearance)       -- reusing the same entity function until there's a reason not to

    -- Create vector
    npc.position = Vector4.new(npc.position_x, npc.position_y, npc.position_z, 1)

    local distanceSqr = GetVectorDiffLengthSqr(center, npc.position)
    if distanceSqr > MAX_RADIUS * MAX_RADIUS then
        AddError_BossArea(file .. "\n\t" .. "NPC is too far away from the center: " .. tostring(math.sqrt(distanceSqr)))
        return false
    end

    return true
end
function this.ValidateNPC(npc, const)
    local success, errMsg = ValidateType_var(npc, "npc", const.types.table, true)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(npc, "entity_path", const.types.string, true)
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
            local finalFilename = folder .. "/" .. file.name

            -- Parse json
            local spawn, errMsg = DeserializeJSON(finalFilename)
            if not spawn then
                AddError_BossArea(finalFilename .. "\n\tCouldn't parse as json\n\t" .. errMsg)
                return false
            end

            -- Validate and set final property values
            if this.FinishSpawn(finalFilename, spawn, center, const) then
                list[#list+1] = spawn
            else
                return false
            end
        end
    end

    return true
end
function this.FinishSpawn(file, spawn, center, const)
    -- Check required fields, datatypes
    local success, errMsg = this.ValidateSpawn(spawn, const)
    if not success then
        AddError_BossArea(file .. "\n\t" .. errMsg)
        return false
    end

    -- Create vector
    spawn.position = Vector4.new(spawn.position_x, spawn.position_y, spawn.position_z, 1)

    local distanceSqr = GetVectorDiffLengthSqr(center, spawn.position)
    if distanceSqr > MAX_RADIUS * MAX_RADIUS then
        AddError_BossArea(file .. "\n\t" .. "Spawn point is too far away from the center: " .. tostring(math.sqrt(distanceSqr)))
        return false
    end

   return true
end
function this.ValidateSpawn(spawn, const)
    local success, errMsg = ValidateType_var(spawn, "spawn", const.types.table, true)
    if not success then
        return false, errMsg
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