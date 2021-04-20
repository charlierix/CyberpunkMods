-- Returns the latest player by ID (or nil)
-- The type returned is defined in models\Player
function GetPlayerEntry(playerID)
    return nil
end

function SavePlayer(playerEntry)



    local grappleIDs, errMsg = SaveGrapples(playerEntry)
    if not grappleIDs then
        return false, errMsg
    end


    --ReportTable_lite(grappleIDs)





end

--------------------------------------- Private Methods ---------------------------------------

-- Returns an array of primary keys or nil if there was an error
-- Second return is error message if the array returned is nil
function SaveGrapples(playerEntry)
    local ids = {}

    --TODO: May want an extra check to only insert if changed

    for i=1, 6 do
        local key = "grapple" .. tostring(i)

        if playerEntry[key] then
            local pkey, errMsg = InsertGrapple(playerEntry[key])
            if pkey then
                ids[i] = pkey
            else
                return nil, key .. ": " .. errMsg
            end
        end
    end

    return ids, nil
end