--TODO: The concept of this function is flawed.  Switch to using time
function GetNextPlayerID(shouldBurnIDs, currentID)
    -- If ID passed in is > 0, then burn IDs

    -- They probably deleted the database, so need to start generating IDs after the last
    -- was issued.  This will reduce the chance or generating a new ID that happens to be
    -- the same as another save file's

    -- There's no guarantee though.  Say there are two save files:
    --  A plays for a while with ID 1
    --  B gets ID 2
    --
    --  They reset the DB while playing B, get ID of 2 + 5031 = 5033
    --  They delete the DB, switch to A, get ID of 1 + 5030 = 5031 (rand just happens to pick something very near prev random)
    --  They make char C, then D
    --  Char D now has the same ID as A

    local baseNum = 0
    if currentID and currentID > 0 then
        baseNum = currentID + 1
    end

    local increment = 1
    if shouldBurnIDs then
        increment = math.random(100, 100000) -- this will support up to 20,000 resets
    end

    return GetNextToken("PlayerUniqueID", baseNum, increment)
end

function GetPlayerEntry(playerID)
    return nil
end