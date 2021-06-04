--http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#numerical_error_and_result_codes
--https://sqlite.org/c3ref/c_abort.html

function EnsureTablesCreated()
    --https://stackoverflow.com/questions/1601151/how-do-i-check-in-sqlite-whether-a-table-exists

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Settings_Int (Key TEXT NOT NULL UNIQUE, Value INTEGER NOT NULL);") end)

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Player (PlayerKey INTEGER NOT NULL UNIQUE, PlayerID INTEGER NOT NULL, JSON_EnergyTank TEXT NOT NULL, GrappleKey1 INTEGER, GrappleKey2 INTEGER, GrappleKey3 INTEGER, GrappleKey4 INTEGER, GrappleKey5 INTEGER, GrappleKey6 INTEGER, Experience REAL NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, PRIMARY KEY(PlayerKey AUTOINCREMENT));") end)

    --TODO: Add a column for straightline vs webswing
    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Grapple (GrappleKey INTEGER NOT NULL UNIQUE, Name TEXT, Experience REAL NOT NULL, JSON TEXT NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, PRIMARY KEY(GrappleKey AUTOINCREMENT));") end)
end

-------------------------------------- Settings ---------------------------------------

-- These are tables that hold key/value pairs.  Making specific tables per datatype.  The Get functions will return
-- the value else default value (so it's like they pretend the row is always there)

-- Returns
--  bool, error message
function GetSetting_Bool(key, default)
    local sucess, value, errMsg = pcall(function ()
        --NOTE: There was no bit or bool datatype, so using int
        local stmt = db:prepare[[ SELECT Value FROM Settings_Int WHERE Key = ? LIMIT 1 ]]

        local err = stmt:bind_values(key)
        if err ~= sqlite3.OK then
            local errMsg = "GetSetting_Bool: bind_values returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return nil, errMsg
        end

        local result = stmt:step()

        if result == sqlite3.ROW then
            local row = stmt:get_named_values()

            if row.Value == 0 then
                return false, nil
            else
                return true, nil        -- it should be 1 for true, 0 for false.  But treat any non zero as true
            end

        elseif result == sqlite3.DONE then
            return default, nil     -- no row found, pretend it was found and return the default value

        else
            return nil, "GetSetting_Bool: Unknown Error: " .. tostring(result)
        end
    end)

    if sucess then
        return value, errMsg
    else
        return nil, "GetSetting_Bool: Unknown Error"
    end
end

-- Inserts/Updates the key/value pair
-- Returns
--  error message or nil
function SetSetting_Bool(key, value)
    local valueInt
    if value then
        valueInt = 1
    else
        valueInt = 0
    end

    local sucess, errMsg = pcall(function ()
        -- Insert
        local stmt = db:prepare[[ INSERT OR IGNORE INTO Settings_Int VALUES(?, ?) ]]

        local err = stmt:bind_values(key, valueInt)
        if err ~= sqlite3.OK then
            local errMsg = "SetSetting_Bool (insert): bind_values returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return errMsg
        end

        err = stmt:step()
        if err ~= sqlite3.DONE then
            local errMsg = "SetSetting_Bool (insert): step returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return errMsg
        end

        err = stmt:finalize()
        if err ~= sqlite3.OK then
            local errMsg = "SetSetting_Bool (insert): finalize returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return errMsg
        end

        -- Update
        stmt = db:prepare[[ UPDATE Settings_Int SET Value = ? WHERE Key = ? ]]

        err = stmt:bind_values(valueInt, key)
        if err ~= sqlite3.OK then
            local errMsg = "SetSetting_Bool (update): bind_values returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return errMsg
        end

        err = stmt:step()
        if err ~= sqlite3.DONE then
            local errMsg = "SetSetting_Bool (update): step returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return errMsg
        end

        err = stmt:finalize()
        if err ~= sqlite3.OK then
            local errMsg = "SetSetting_Bool (update): finalize returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            print(errMsg)
            return errMsg
        end

        return nil
    end)

    if sucess then
        return errMsg
    else
        return "SetSetting_Bool: Unknown Error"
    end
end

--------------------------------------- Player ----------------------------------------

function InsertPlayer(playerID, energy_tank, grappleKeys, experience)
    local sucess, pkey, errMsg = pcall(function ()
        local time, time_readable = GetCurrentTime_AndReadable()
        local json_energy_tank = extern_json.encode(energy_tank)

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
        local json = extern_json.encode(grapple)

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
            return extern_json.decode(row.JSON), nil

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
        local json = extern_json.encode(grapple)

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