-- Returns the latest player by ID (or nil)
-- Returns:
--    PlayerEntry (the type returned is defined in models\Player)
--    PrimaryKey of player
--    Error Message (only populated if the first two are nil)
function GetPlayerEntry(playerID)
    local row, errMsg = GetLatestPlayer(playerID)
    if not row then
        return nil, nil, errMsg
    end

    local grapples, errMsg = GetGrapples(row)
    if not grapples then
        return nil, errMsg
    end

    local player =
    {
        playerID = row.PlayerID,
        energy_tank = Deserialize_Table(row.JSON_EnergyTank),
        grapple1 = grapples[1],
        grapple2 = grapples[2],
        grapple3 = grapples[3],
        grapple4 = grapples[4],
        grapple5 = grapples[5],
        grapple6 = grapples[6],
        experience = row.Experience,
    }

    return player, row.PlayerKey, nil
end

-- This inserts the player
-- Calling it playerEntry, so it doesn't get confused with the instance of the Player class
-- Returns:
--    Primary Key of inserted row
--    Error Message if primkey came back nil, or nil if primkey is populated
function SavePlayer(playerEntry)
    local grappleKeys, errMsg = SaveGrapples(playerEntry)
    if not grappleKeys then
        return nil, errMsg
    end

    return InsertPlayer(playerEntry.playerID, playerEntry.energy_tank, grappleKeys, playerEntry.experience)
end

--------------------------------------- Private Methods ---------------------------------------

-- Returns an array of primary keys or nil if there was an error
-- Second return is error message if the array returned is nil
function SaveGrapples(playerEntry)
    local pkeys = {}

    for i=1, 6 do
        local key = "grapple" .. tostring(i)

        if playerEntry[key] then
            local pkey = GetGrappleKey_ByContent(playerEntry[key])

            if pkey then
                -- The grapple settings are unchanged, point to the existing row
                pkeys[i] = pkey
            else
                -- Newly created, or changed grapple settings.  Create a new row
                local pkey, errMsg = InsertGrapple(playerEntry[key])
                if pkey then
                    pkeys[i] = pkey
                else
                    return nil, key .. ": " .. errMsg
                end
            end
        else
            pkeys[i] = nil      -- not sure if this is necessary
        end
    end

    return pkeys, nil
end
-- Returns an array of grapple entries based on the primary keys in the player row
function GetGrapples(playerRow)
    local grapples = {}

    for i=1, 6 do
        local column = "GrappleKey" .. tostring(i)

        if playerRow[column] then
            local grapple, errMsg = GetGrapple_ByKey(playerRow[column])

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