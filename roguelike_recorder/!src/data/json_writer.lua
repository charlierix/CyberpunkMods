local this = {}

local FOLDER_PLAYERPOS = "player pos/"

function Save_SpawnPoint(spawn)
    --TODO: Build the json manually to ensure property order and whitespace
    --local json = extern_json.encode(spawn)
    local json = this.GetJSON_SpawnPoint(spawn)

    local filename = FOLDER_PLAYERPOS .. os.date('%Y-%m-%d %H-%M-%S') .. ".json"

    local handle = io.open(filename, "w+")
    handle:write(json)
    handle:close()
end

----------------------------------- Private Methods -----------------------------------

function this.GetJSON_SpawnPoint(spawn)
    local retVal = '{\n'

    retVal = retVal .. '\t"author": "' .. this.GetString(spawn.author) .. '",\n'
    retVal = retVal .. '\t"description": "' .. this.GetString(spawn.description) .. '",\n'
    retVal = retVal .. '\t"tags": [' .. this.GetStringArrayContents(spawn.tags) .. '],\n'
    retVal = retVal .. '\n'
    retVal = retVal .. '\t"modded_parkour": "' .. this.GetString(spawn.modded_parkour) .. '",\n'
    retVal = retVal .. '\n'
    retVal = retVal .. '\t"position_x": ' .. this.GetNumber(spawn.position_x, 2) .. ',\n'
    retVal = retVal .. '\t"position_y": ' .. this.GetNumber(spawn.position_y, 2) .. ',\n'
    retVal = retVal .. '\t"position_z": ' .. this.GetNumber(spawn.position_z, 2) .. ',\n'
    retVal = retVal .. '\n'
    retVal = retVal .. '\t"yaw": ' .. this.GetNumber(spawn.yaw, 1) .. '\n'
    retVal = retVal .. '}'

    return retVal
end

--TODO: call extern_json.escape_char for each character
function this.GetString(text)
    if text == nil then
        return ""
    else
        return tostring(text)
    end
end

function this.GetNumber(value, rounding)
    if not value then
        return "0"
    end

    return tostring(Round(value, rounding))
end

function this.GetStringArrayContents(array)
    if not array or #array == 0 then
        return ""
    end

    local retVal = ""

    for i = 1, #array do
        if i > 1 then
            retVal = retVal .. ", "
        end

        retVal = retVal .. this.GetString(array[i])
    end

    return retVal
end