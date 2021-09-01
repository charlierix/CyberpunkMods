Collection_BossArea = {}

local this = {}

local FOLDER = "boss areas"

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
                if not this.LoadNPCs(folder .. "/" .. subfolder.name, npcs, const) then
                    do return end
                end

            elseif subfolder.name == "spawns" then
                if not this.LoadSpawns(folder .. "/" .. subfolder.name, spawns, const) then
                    do return end
                end
            end
        end

    end


    -- Final validation



    -- Add the area


end

function this.LoadAbout(folder, const)
    local retVal = nil

    for _, file in pairs(dir(folder)) do
        if file.type == const.filetype.file and file.name == "about.json" then
            -- Deserialize, validate the file
            retVal = this.LoadAbout_Deserialize(folder .. "/" .. file.name, const)
            if not retVal then
                do return end
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
    local about, errMsg = DeserializeJSON(file)
    if not about then
        AddError_BossArea(file .. "\n\tCouldn't parse as json\n\t" .. errMsg)
        do return end
    end

    -- Check required fields, datatypes
    local success, errMsg = this.ValidateAbout(about, const)
    if not success then
        AddError_BossArea(file .. "\n\t" .. errMsg)
        do return end
    end

    -- Cap string lengths
    about.author = Cap_Author(about.author)
    about.description = Cap_Description(about.description)
    Cap_Tags(about.tags)

    -- Create vector
    about.center = Vector4.new(about.center_x, about.center_y, about.center_z, 1)

   return about
end
function this.ValidateAbout(about, const)
    local success, errMsg = ValidateTags(about.tags)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(about, "modded_parkour", const.types.string)
    if not success then
        return false, errMsg
    end

    if not Contains_Key(const.modded_parkour, about.modded_parkour) then
        return false, "modded_parkour has invalid value: " .. about.modded_parkour
    end

    success, errMsg = ValidateType_prop(about, "center_x", const.types.number)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(about, "center_y", const.types.number)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(about, "center_z", const.types.number)
    if not success then
        return false, errMsg
    end

    success, errMsg = ValidateType_prop(about, "yaw", const.types.number)
    if not success then
        return false, errMsg
    end

    return true, nil
end



function this.LoadNPCs(folder, list, const)
    
end

function this.LoadSpawns(folder, list, const)
    
end