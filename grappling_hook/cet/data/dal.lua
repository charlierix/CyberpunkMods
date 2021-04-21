--http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#numerical_error_and_result_codes
--https://sqlite.org/c3ref/c_abort.html


--TODO: Make a function that removes old rows

--TODO: Once this version is proven, rework to have a Grapple table.  Put pure functions in this
--file, a manager function in datautil:
--  datautil.StorePlayer(array)
--      handle each grapple separately
--          find latest grapple row, insert new if unique
--      insert new player row, with primary keys to grapples
--          json for the remaining columns

-- GetPlayerEntry needs to find the db row and 


function EnsureTablesCreated()
    --https://stackoverflow.com/questions/1601151/how-do-i-check-in-sqlite-whether-a-table-exists

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Player (PlayerKey INTEGER NOT NULL UNIQUE, PlayerID INTEGER NOT NULL, JSON_EnergyTank TEXT NOT NULL, GrappleKey1 INTEGER, GrappleKey2 INTEGER, GrappleKey3 INTEGER, GrappleKey4 INTEGER, GrappleKey5 INTEGER, GrappleKey6 INTEGER, Experience REAL NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, PRIMARY KEY(PlayerKey AUTOINCREMENT));") end)

    --TODO: Add a column for straightline vs webswing
    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Grapple (GrappleKey INTEGER NOT NULL UNIQUE, Name TEXT, Experience REAL NOT NULL, JSON TEXT NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, PRIMARY KEY(GrappleKey AUTOINCREMENT));") end)
end

--------------------------------------- Player ----------------------------------------

function InsertPlayer(playerID, energy_tank, grappleKeys, experience)
    local sucess, pkey, errMsg = pcall(function ()
        local time, time_readable = GetCurrentTime_AndReadable()
        local json_energy_tank = Serialize_Table(energy_tank)

        local stmt = db:prepare[[ INSERT INTO Player (PlayerID, JSON_EnergyTank, GrappleKey1, GrappleKey2, GrappleKey3, GrappleKey4, GrappleKey5, GrappleKey6, Experience, LastUsed, LastUsed_Readable) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ]]

        local err = stmt:bind_values(playerID, json_energy_tank, grappleKeys[1], grappleKeys[2], grappleKeys[3], grappleKeys[4], grappleKeys[5], grappleKeys[6], experience, time, time_readable)
        if err ~= sqlite3.OK then
            local errMsg = "InsertPlayer: bind_values returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return nil, errMsg
        end

        err = stmt:step()
        if err ~= sqlite3.DONE then
            local errMsg = "InsertPlayer: step returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return nil, errMsg
        end

        err = stmt:finalize()
        if err ~= sqlite3.OK then
            local errMsg = "InsertPlayer: finalize returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return nil, errMsg
        end

        -- This is the primary key of the inserted row
        return db:last_insert_rowid(), nil
    end)

    if sucess then
        return pkey, errMsg
    else
        return nil, "InsertPlayer: Unknown Error"
    end
end

-- This finds the most recently saved player based on their playerID (not the primary key, but the playerID that's
-- stored in the save file)
-- Returns:
--    Array with column names as keys (or nil).  These are the column names as they're stored in the db, not models\player
--    Error message if returned row is nil
function GetLatestPlayer(playerID)
    local sucess, grapple, errMsg = pcall(function ()
        local stmt = db:prepare[[ SELECT PlayerKey, PlayerID, JSON_EnergyTank, GrappleKey1, GrappleKey2, GrappleKey3, GrappleKey4, GrappleKey5, GrappleKey6, Experience FROM Player WHERE PlayerID = ? ORDER BY LastUsed DESC LIMIT 1 ]]

        local err = stmt:bind_values(playerID)
        if err ~= sqlite3.OK then
            local errMsg = "GetLatestPlayer: bind_values returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return nil, errMsg
        end

        local result = stmt:step()

        if result == sqlite3.ROW then
            local row = stmt:get_named_values()
            return row, nil

        elseif result == sqlite3.DONE then
            return nil, "GetLatestPlayer: No Rows Found"

        else
            return nil, "GetLatestPlayer: Unknown Error: " .. tostring(result)
        end
    end)

    if sucess then
        return grapple, errMsg
    else
        return nil, "GetLatestPlayer: Unknown Error"
    end
end

function UpdatePlayerExperience(playerKey, experience)
    
end

--------------------------------------- Grapple ---------------------------------------

-- Inserts a grapple entry into the Grapple table
-- Params:
--    grapple: This is a grapple entry (see models\grapple)
-- Returns:
--    primary key or nil
--    error message if primary key is nil
function InsertGrapple(grapple)
    local sucess, pkey, errMsg = pcall(function ()
        local time, time_readable = GetCurrentTime_AndReadable()
        local json = Serialize_Table(grapple)

        local stmt = db:prepare[[ INSERT INTO Grapple (Name, Experience, JSON, LastUsed, LastUsed_Readable) VALUES (?, ?, ?, ?, ?) ]]

        local err = stmt:bind_values(grapple.name, grapple.experience, json, time, time_readable)
        if err ~= sqlite3.OK then
            local errMsg = "InsertGrapple: bind_values returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return nil, errMsg
        end

        err = stmt:step()
        if err ~= sqlite3.DONE then
            local errMsg = "InsertGrapple: step returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return nil, errMsg
        end

        err = stmt:finalize()
        if err ~= sqlite3.OK then
            local errMsg = "InsertGrapple: finalize returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return nil, errMsg
        end

        -- This is the primary key of the inserted row
        return db:last_insert_rowid(), nil
    end)

    if sucess then
        return pkey, errMsg
    else
        return nil, "InsertGrapple: Unknown Error"
    end
end

function GetGrapple_ByKey(primaryKey)
    local sucess, grapple, errMsg = pcall(function ()
        local stmt = db:prepare[[ SELECT JSON FROM Grapple WHERE GrappleKey = ? LIMIT 1 ]]

        local err = stmt:bind_values(primaryKey)
        if err ~= sqlite3.OK then
            local errMsg = "GetGrapple_ByKey: bind_values returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return nil, errMsg
        end

        local result = stmt:step()

        if result == sqlite3.ROW then
            local row = stmt:get_named_values()
            return Deserialize_Table(row.JSON), nil

        elseif result == sqlite3.DONE then
            return nil, "GetGrapple_ByKey: No Rows Found"

        else
            return nil, "GetGrapple_ByKey: Unknown Error: " .. tostring(result)
        end
    end)

    if sucess then
        return grapple, errMsg
    else
        return nil, "GetGrapple_ByKey: Unknown Error"
    end
end

-- This is nearly identical to InsertGrapple, except it's a select.  It's used to avoid unnecessarily
-- inserting dupes
function GetGrappleKey_ByContent(grapple)
    local sucess, grappleKey, errMsg = pcall(function ()
        local json = Serialize_Table(grapple)

        --NOTE: This could just compare json, since that contains name and experience.  But doing it this way
        --exactly mirrors the insert method (just in case there are bugs)
        local stmt = db:prepare[[ SELECT GrappleKey FROM Grapple WHERE Name = ? AND Experience = ? AND JSON = ? LIMIT 1 ]]

        local err = stmt:bind_values(grapple.name, grapple.experience, json)
        if err ~= sqlite3.OK then
            local errMsg = "GetGrappleKey_ByContent: bind_values returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return nil, errMsg
        end

        local result = stmt:step()

        if result == sqlite3.ROW then
            local row = stmt:get_named_values()
            return row.GrappleKey, nil

        elseif result == sqlite3.DONE then
            return nil, "GetGrappleKey_ByContent: No Rows Found"

        else
            return nil, "GetGrappleKey_ByContent: Unknown Error: " .. tostring(result)
        end
    end)

    if sucess then
        return grappleKey, errMsg
    else
        return nil, "GetGrappleKey_ByContent: Unknown Error"
    end
end

-- This finds grapples that can be used by the amount of experience passed in
function FindGrapples(targetExperience)
    -- Need to also get distinct name, but get the largest experience for each of those distinct names

    --select * from grapple
    --where experience <= targetExperience
    --order by experience desc
end

----------------------------------- Private Methods -----------------------------------

-- This returns an int and a human readable string of that time (yyyy-mm-dd hh:mm:ss), that can be stored
-- in a table
function GetCurrentTime_AndReadable()
    local time = os.time()
    local time_readable = os.date("%Y-%m-%d %H:%M:%S", time)

    return time, time_readable
end