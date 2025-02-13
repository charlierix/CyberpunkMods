local DataUtil = {}

local this =
{
    INPUTDEVICE_ANY = 0,                -- these are the values in the int table
    INPUTDEVICE_KEYBOARDMOUSEONLY = 1,
    INPUTDEVICE_CONTROLLERONLY = 2,
}

-- Returns the latest player by ID (or nil)
-- Returns:
--    PlayerEntry (the type returned is defined in models\Player)
--    PrimaryKey of player
--    Error Message (only populated if the first two are nil)
function DataUtil.GetPlayerEntry(playerID, const)
    local row, errMsg = dal.GetLatestPlayer(playerID)
    if not row then
        return nil, nil, errMsg
    end

    local grapples, errMsg = this.GetGrapples(row)
    if not grapples then
        return nil, nil, errMsg
    end

    local player =
    {
        playerID = row.PlayerID,
        energy_tank = extern_json.decode(row.JSON_EnergyTank),
        grapple1 = grapples[1],
        grapple2 = grapples[2],
        grapple3 = grapples[3],
        grapple4 = grapples[4],
        grapple5 = grapples[5],
        grapple6 = grapples[6],
        experience = row.Experience,
    }

    this.RepairPlayer(player, const)       -- don't bother saving a repaired player.  The next time they hit save, the changes will get stored

    return player, row.PlayerKey, nil
end

-- This inserts the player
-- Calling it playerEntry, so it doesn't get confused with the instance of the Player class
-- Returns:
--    Primary Key of inserted row
--    Error Message if primkey came back nil, or nil if primkey is populated
function DataUtil.SavePlayer(playerEntry)
    local grappleKeys, errMsg, grapplesChanged = this.SaveGrapples(playerEntry)
    if not grappleKeys then
        return nil, errMsg
    end

    local playerKey, errMsg dal.InsertPlayer(playerEntry.playerID, playerEntry.energy_tank, grappleKeys, playerEntry.experience)

    if math.random(72) == 1 then
        dal.DeleteOldPlayerRows(playerEntry.playerID)

    elseif grapplesChanged and math.random(72) == 1 then
        this.ReduceGrappleRows()
    -- elseif grapplesChanged and math.random(288) == 1 then
    --     VacuumDB()
    end

    return playerKey, errMsg
end

function DataUtil.GetInputDevice(const)
    local value_int = dal.GetSetting_Int(const.settings.InputDevice, this.INPUTDEVICE_ANY)
    if value_int == nil then        -- this will only happen if there's a db error
        value_int = this.INPUTDEVICE_ANY
    end

    if value_int == this.INPUTDEVICE_ANY then
        return const.input_device.Any

    elseif value_int == this.INPUTDEVICE_KEYBOARDMOUSEONLY then
        return const.input_device.KeyboardMouseOnly

    elseif value_int == this.INPUTDEVICE_CONTROLLERONLY then
        return const.input_device.ControllerOnly

    else
        LogError("Unknown value for " .. const.settings.InputDevice .. ": " .. tostring(value_int) .. ".  Defaulting to Any")
        return const.input_device.Any
    end
end
function DataUtil.SetInputDevice(input_device, const)
    local value_int = nil

    if input_device == const.input_device.Any then
        value_int = this.INPUTDEVICE_ANY

    elseif input_device == const.input_device.KeyboardMouseOnly then
        value_int = this.INPUTDEVICE_KEYBOARDMOUSEONLY

    elseif input_device == const.input_device.ControllerOnly then
        value_int = this.INPUTDEVICE_CONTROLLERONLY

    else
        LogError("Unknown value for const.input_device: " .. tostring(input_device) .. ".  Skipping the save to db")
    end

    if value_int ~= nil then
        dal.SetSetting_Int(const.settings.InputDevice, value_int)
    end
end

----------------------------------- Private Methods -----------------------------------

-- Returns an array of primary keys or nil if there was an error
-- Second return is error message if the array returned is nil
function this.SaveGrapples(playerEntry)
    local pkeys = {}
    local hadChange = false

    for i=1, 6 do
        local key = "grapple" .. tostring(i)

        if playerEntry[key] then
            local pkey = dal.GetGrappleKey_ByContent(playerEntry[key])

            if pkey then
                -- The grapple settings are unchanged, point to the existing row
                pkeys[i] = pkey
            else
                -- Newly created, or changed grapple settings.  Create a new row
                local pkey, errMsg = dal.InsertGrapple(playerEntry[key])
                if pkey then
                    pkeys[i] = pkey
                else
                    return nil, key .. ": " .. errMsg
                end

                hadChange = true
            end
        else
            pkeys[i] = nil      -- not sure if this is necessary
        end
    end

    return pkeys, nil, hadChange
end
-- Returns an array of grapple entries based on the primary keys in the player row
function this.GetGrapples(playerRow)
    local grapples = {}

    for i=1, 6 do
        local column = "GrappleKey" .. tostring(i)

        if playerRow[column] then
            local grapple, errMsg = dal.GetGrapple_ByKey(playerRow[column])

            if grapple then
                grapples[i] = grapple
            else
                return nil, column .. ": " .. errMsg
            end
        else
            grapples[i] = nil       -- not sure if this is necessary
        end
    end

    return grapples, nil
end

-- If the player has old versions of data, this will bring it up to new versions
function this.RepairPlayer(player, const)
    for i = 1, 6 do
        local grapple = player["grapple" .. tostring(i)]

        this.EnsureActivationKeyAction(grapple, const)
        this.RefundAirDash(player, grapple)
        this.RepairVisuals(grapple, const)
    end

    -- The original update wasn't as generous.  Just swap out with the new
    -- default.  Don't bother refunding any possible xp gap
    player.energy_tank.max_energy_update = GetDefault_EnergyTank().max_energy_update
end

function this.EnsureActivationKeyAction(grapple, const)
    if not grapple then
        do return end
    end

    if not grapple.activation_key_action then
        grapple.activation_key_action = const.activation_key_action.Activate
    end
end

function this.RefundAirDash(player, grapple)
    if not (grapple and grapple.aim_straight and grapple.aim_straight.air_dash) then
        -- They don't have airdash
        do return end
    end

    -- Give back the xp cost of the airdash
    player.experience = player.experience + grapple.aim_straight.air_dash.experience

    -- Now get rid of it
    grapple.aim_straight.air_dash = nil
end

function this.RepairVisuals(grapple, const)
    if not grapple then
        do return end
    end

    if not grapple.visuals then
        grapple.visuals = GetDefault_Visuals(const)
    end
end

function this.ReduceGrappleRows()
    -- BEGIN TRANSACTION        -- there won't be multiple threads hitting the db, so there's not much point in the extra complication.  The only real statement is the final delete.  Everything before it could be stopped in the middle without consequence

    dal.DeleteOldGrappleRows_TruncateWorkingTable()     -- could probably use a temp table instead.  Not sure about the pros and cons

    -- Store all the keys that are pointed to by player table
    dal.DeleteOldGrappleRows_KeepReferenced()

    -- Get the remaining rows that aren't pointed to by player
    local rows = dal.DeleteOldGrappleRows_GetCandidateGrapples()

    -- ReportTable(rows)
    -- print("")

    -- The rows are sorted on name first, so scan through the rows processing each name independently
    local nameIterator = this.IterateGrappleRows_Name(rows)
    while true do
        local fromIndex, toIndex = nameIterator()
        if not fromIndex then
            break
        end

        --print(tostring(fromIndex) .. " [" .. rows[fromIndex].Name .. "], " .. tostring(toIndex) .. " [" .. rows[toIndex].Name .. "]")

        -- Within this set, keep an even spread of experience.  This way, if they want to load a grapple,
        -- but only have X experience to spend, they might choose one of these as a starting point
        local keep = this.GetKeysToKeep(rows, fromIndex, toIndex)

        -- print("")
        -- print("keep: " .. rows[fromIndex].Name)
        -- ReportTable(keep)

        -- print("")
        -- print("keep xp:")
        -- this.ReportXP(rows, keep)

        -- Put these in the temp table
        dal.DeleteOldGrappleRows_KeepHistorical(keep)
    end

    -- Now delete everything that isn't in the temp table
    dal.DeleteOldGrappleRows_DeleteGrapples()

    -- COMMIT TRANSACTION
end

-- This returns an iterator function.  Each time it's called it returns the from,to index of
-- the rows containing the next name
-- Params
--  rows    grapple rows sorted by name
-- Returns
--  function() returns fromIndex, toIndex
function this.IterateGrappleRows_Name(rows)
    if not rows or #rows == 0 then
        -- No rows, return an iterator that always reports finished
        return function ()
            return nil, nil
        end
    end

    local fromIndex = 1
    local name = rows[1].Name
    local i = 1

    return function ()
        while true do
            if not fromIndex then
                -- Already returned end of rows
                return nil, nil
            end

            i = i + 1

            if i > #rows then
                -- End of rows, return the last set
                local fromIndex2 = fromIndex
                fromIndex = nil

                return fromIndex2, #rows
            end

            if rows[i].Name ~= name then
                -- New name, return the indices of the previous name
                local fromIndex2 = fromIndex
                fromIndex = i
                name = rows[i].Name

                return fromIndex2, i - 1
            end
        end
    end
end

local KEEP_COUNT = 12

function this.GetKeysToKeep(rows, fromIndex, toIndex)
    if toIndex - fromIndex + 1 < KEEP_COUNT * 1.5 then
        -- Too few rows, return them all
        local retVal = {}
        for i = fromIndex, toIndex do
            retVal[fromIndex - i + 1] = rows[fromIndex].GrappleKey
        end

        return retVal
    end

    -- First Pass: find the rows with the closest experience to each interval
    local retVal = this.GetKeysToKeep_ClosestXP(rows, fromIndex, toIndex)

    -- Second Pass: pick random rows until count it satisfied
    this.GetKeysToKeep_Random(rows, fromIndex, toIndex, retVal)

    return retVal
end
function this.GetKeysToKeep_ClosestXP(rows, fromIndex, toIndex)
    local retVal = {}
    local keptIndices = {}

    -- There's no need to scan for the first interval, it will always be from index.  The same can't
    -- be said about toIndex, because the rows are sorted by date desc.  So there could be several
    -- rows with the same xp, but the first encountered needs to be kept
    keptIndices[#keptIndices+1] = 1
    retVal[#retVal+1] = rows[fromIndex].GrappleKey

    local interval = (rows[toIndex].Experience - rows[fromIndex].Experience) / (KEEP_COUNT - 1)

    for keepCntr = 1, KEEP_COUNT - 1 do
        local targetXP = rows[fromIndex].Experience + (interval * keepCntr)

        local bestIndex = nil
        local bestDistance = nil

        for i = 1, toIndex - fromIndex + 1 do
            if not this.Contains(keptIndices, i) then
                local dist = math.abs(rows[fromIndex + i - 1].Experience - targetXP)

                if dist <= targetXP and (not bestDistance or dist < bestDistance) then
                    bestIndex = i
                    bestDistance = dist
                end
            end
        end

        if bestIndex then
            keptIndices[#keptIndices+1] = bestIndex
            retVal[#retVal+1] = rows[fromIndex + bestIndex - 1].GrappleKey
        end
    end

    return retVal
end
function this.GetKeysToKeep_Random(rows, fromIndex, toIndex, retVal)
    if #retVal >= KEEP_COUNT then
        -- It's full, there's nothing more to do
        do return end
    end

    -- Build an array of indices between from and to that don't contain the keys in retVal
    local remaining = this.GetKeysToKeep_Random_BuildKeysArr(rows, fromIndex, toIndex, retVal)
    local lastIndex = #remaining

    while #retVal < KEEP_COUNT and lastIndex > 0 do
        -- Pick a random key from the list
        --
        -- The only time this function is called is when there are gaps in xp usage, which means there is
        -- clustering around certain costs.  It wouldn't be much use to try to get an even spread, so instead
        -- choosing random seems to be the best choice
        local index = math.random(lastIndex)

        retVal[#retVal+1] = remaining[index]

        remaining[index] = remaining[lastIndex]
        lastIndex = lastIndex - 1
    end
end
function this.GetKeysToKeep_Random_BuildKeysArr(rows, fromIndex, toIndex, kept)
    local retVal = {}

    for i = 0, toIndex - fromIndex do
        if not this.Contains(kept, rows[fromIndex + i].GrappleKey) then
            retVal[#retVal+1] = rows[fromIndex + i].GrappleKey
        end
    end

    return retVal
end

function this.ReportXP(rows, keys)
    for outer = 1, #keys do
        for inner = 1, #rows do
            if rows[inner].GrappleKey == keys[outer] then
                print(tostring(rows[inner].Experience))
                --print(rows[inner].Name .. "|" .. rows[inner].GrappleKey .. "|" .. rows[inner].Experience)
                break;
            end
        end
    end
end

function this.Contains(list, value)
    for i = 1, #list do
        if list[i] == value then
            return true
        end
    end

    return false
end

return DataUtil