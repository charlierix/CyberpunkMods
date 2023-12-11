--http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#numerical_error_and_result_codes
--https://sqlite.org/c3ref/c_abort.html

local this = {}
local DAL = {}

local empty_param = "^^this is an empty param^^"

function DAL.EnsureTablesCreated()
    --https://stackoverflow.com/questions/1601151/how-do-i-check-in-sqlite-whether-a-table-exists

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS mode (modeIndex INTEGER);") end)

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Settings_Int (Key TEXT NOT NULL UNIQUE, Value INTEGER NOT NULL);") end)

    --TODO: json for misc settings (like progress bar visibility)
    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Player (PlayerKey INTEGER NOT NULL UNIQUE, PlayerID INTEGER NOT NULL, ModeKeys TEXT NOT NULL, ModeIndex INTEGER NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, PRIMARY KEY(PlayerKey AUTOINCREMENT));") end)

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Mode2 (ModeKey INTEGER NOT NULL UNIQUE, Name TEXT, JSON TEXT NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, PRIMARY KEY(ModeKey AUTOINCREMENT));") end)
end

-------------------------------------- Settings ---------------------------------------

-- These are tables that hold key/value pairs.  Making specific tables per datatype.  The Get functions will return
-- the value else default value (so it's like they pretend the row is always there)

-- Returns
--  bool, error message
function DAL.GetSetting_Bool(key, default)
    local sucess, value, errMsg = pcall(function ()
        --NOTE: There was no bit or bool datatype, so using int
        local stmt = db:prepare
        [[
            SELECT Value
            FROM Settings_Int
            WHERE Key = ?
            LIMIT 1
        ]]

        local row, _ = this.Bind_Select_SingleRow(stmt, "GetSetting_Bool", key)
        if row then
            if row.Value == 0 then
                return false, nil
            else
                return true, nil        -- it should be 1 for true, 0 for false.  But treat any non zero as true
            end
        else
            return default, nil     -- no row found or error, pretend it was found and return the default value
        end
    end)

    if sucess then
        return value, errMsg
    else
        return default, "GetSetting_Bool: Unknown Error"        -- getting this with a prerelease of cet that doesn't have db support
    end
end
-- Inserts/Updates the key/value pair
-- Returns
--  error message or nil
function DAL.SetSetting_Bool(key, value)
    local valueInt
    if value then
        valueInt = 1
    else
        valueInt = 0
    end

    local sucess, errMsg = pcall(function ()
        -- Insert
        local stmt = db:prepare
        [[
            INSERT OR IGNORE INTO Settings_Int
            VALUES(?, ?)
        ]]

        local errMsg = this.Bind_NonSelect(stmt, "SetSetting_Bool (insert)", key, valueInt)
        if errMsg then
            return errMsg
        end

        -- Update
        stmt = db:prepare
        [[
            UPDATE Settings_Int
            SET Value = ?
            WHERE Key = ?
        ]]

        return this.Bind_NonSelect(stmt, "SetSetting_Bool (update)", valueInt, key)
    end)

    if sucess then
        return errMsg
    else
        return "SetSetting_Bool: Unknown Error"
    end
end

-- Returns
--  integer value, error message
function DAL.GetSetting_Int(key, default)
    local sucess, value, errMsg = pcall(function ()
        local stmt = db:prepare
        [[
            SELECT Value
            FROM Settings_Int
            WHERE Key = ?
            LIMIT 1
        ]]

        local row, _ = this.Bind_Select_SingleRow(stmt, "GetSetting_Int", key)
        if row then
            return row.Value
        else
            return default, nil     -- no row found or error, pretend it was found and return the default value
        end
    end)

    if sucess then
        return value, errMsg
    else
        return default, "GetSetting_Int: Unknown Error"
    end
end
-- Inserts/Updates the key/value pair
-- Returns
--  error message or nil
function DAL.SetSetting_Int(key, value)
    local sucess, errMsg = pcall(function ()
        -- Insert
        local stmt = db:prepare
        [[
            INSERT OR IGNORE INTO Settings_Int
            VALUES(?, ?)
        ]]

        local errMsg = this.Bind_NonSelect(stmt, "SetSetting_Int (insert)", key, value)
        if errMsg then
            return errMsg
        end

        -- Update
        stmt = db:prepare
        [[
            UPDATE Settings_Int
            SET Value = ?
            WHERE Key = ?
        ]]

        return this.Bind_NonSelect(stmt, "SetSetting_Int (update)", value, key)
    end)

    if sucess then
        return errMsg
    else
        return "SetSetting_Int: Unknown Error"
    end
end

--------------------------------------- Player ----------------------------------------

function DAL.InsertPlayer(playerID, modeKeys, modeIndex)
    local sucess, pkey, errMsg = pcall(function ()
        local time, time_readable = this.GetCurrentTime_AndReadable()
        local modeKeys_text = this.ModeKeys_List_to_String(modeKeys)

        local stmt = db:prepare
        [[
            INSERT INTO Player
                (PlayerID, ModeKeys, ModeIndex, LastUsed, LastUsed_Readable)
            VALUES
                (?, ?, ?, ?, ?)
        ]]

        local errMsg = this.Bind_NonSelect(stmt, "InsertPlayer", playerID, modeKeys_text, modeIndex, time, time_readable)
        if errMsg then
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

function DAL.UpdatePlayer_ModeIndex(playerKey, modeIndex)
    local sucess, errMsg = pcall(function ()
        local time, time_readable = this.GetCurrentTime_AndReadable()

        local stmt = db:prepare
        [[
            UPDATE Player
            SET
                ModeIndex = ?,
                LastUsed = ?,
                LastUsed_Readable = ?
            WHERE PlayerKey = ?
        ]]

        return this.Bind_NonSelect(stmt, "UpdatePlayer_ModeIndex", modeIndex, time, time_readable, playerKey)
    end)

    if sucess then
        return errMsg
    else
        return "UpdatePlayer_ModeIndex: Unknown Error"
    end
end

-- Returns the most recently saved players for each playerID
function DAL.GetLatestPlayers()
    local sucess, players, errMsg = pcall(function ()
        local stmt = db:prepare
        [[
            SELECT
                PlayerKey,
                PlayerID,
                ModeKeys,
                ModeIndex,
                LastUsed,
                LastUsed_Readable
            FROM Player
            WHERE PlayerKey IN
                (
                    SELECT MAX(a.PlayerKey)
                    FROM Player a
                    GROUP BY a.PlayerID
                )
        ]]

        local retVal = {}

        for row in this.Bind_Select_MultipleRows_Iterator(stmt, "GetLatestPlayers") do
            if row then
                -- Don't want to return an internal implementation of the list.  Callers expect a regular array of ints
                if row.ModeKeys then
                    row.ModeKeys = this.ModeKeys_String_to_List(row.ModeKeys)
                end

                table.insert(retVal, row)
            else
                return nil, "Unknown error retrieving latest players"
            end
        end

        return retVal, nil
    end)

    if sucess then
        return players, errMsg
    else
        return nil, "GetLatestPlayer: Unknown Error"
    end
end

-- This finds the most recently saved player based on their playerID (not the primary key, but the playerID that's
-- stored in the save file)
-- Returns:
--    Array with column names as keys (or nil).  These are the column names as they're stored in the db, not models\player
--    Error message if returned row is nil
function DAL.GetLatestPlayer(playerID)
    local sucess, player, errMsg = pcall(function ()
        local stmt = db:prepare
        [[
            SELECT
                PlayerKey,
                PlayerID,
                ModeKeys,
                ModeIndex
            FROM Player
            WHERE PlayerID = ?
            ORDER BY LastUsed DESC
            LIMIT 1
        ]]

        local row, errMsg = this.Bind_Select_SingleRow(stmt, "GetLatestPlayer", playerID)

        -- Don't want to return an internal implementation of the list.  Callers expect a regular array of ints
        if row and row.ModeKeys then
            row.ModeKeys = this.ModeKeys_String_to_List(row.ModeKeys)
        end

        return row, errMsg
    end)

    if sucess then
        return player, errMsg
    else
        return nil, "GetLatestPlayer: Unknown Error"
    end
end

-- This deletes all but the last 12 rows of player, for the playerID
-- Returns
--  Error Message or nil
function DAL.DeleteOldPlayerRows(playerID)
    local sucess, errMsg = pcall(function ()
        -- Can't use joins, so a subquery seems to be the only option.  There shouldn't be enough rows to really matter anyway

        local stmt = db:prepare
        [[
            DELETE FROM Player
            WHERE
                PlayerID = ? AND
                PlayerKey NOT IN
                (
                    SELECT a.PlayerKey
                    FROM Player a
                    ORDER BY a.LastUsed DESC
                    LIMIT 12
                )
        ]]

        local errMsg = this.Bind_NonSelect(stmt, "DeleteOldPlayerRows", playerID)
        if errMsg then
            return errMsg
        end
    end)

    if sucess then
        return errMsg
    else
        return "DeleteOldPlayerRows: Unknown Error"
    end
end

---------------------------------------- Mode2 ----------------------------------------

-- Inserts a mode entry into the Mode2 table
-- Params:
--    mode_name: name given to the mode (this is inside of the json, but also stored explicitely in a column)
--    mode_json: This is a json from a mode entry (see models\mode)
-- Returns:
--    primary key or nil
--    error message if primary key is nil
function DAL.InsertMode(mode_name, mode_json)
    local sucess, pkey, errMsg = pcall(function ()
        local time, time_readable = this.GetCurrentTime_AndReadable()

        local stmt = db:prepare
        [[
            INSERT INTO Mode2
                (Name, JSON, LastUsed, LastUsed_Readable)
            VALUES
                (?, ?, ?, ?)
        ]]

        local errMsg = this.Bind_NonSelect(stmt, "InsertMode", mode_name, mode_json, time, time_readable)
        if errMsg then
            return nil, errMsg
        end

        -- This is the primary key of the inserted row
        return db:last_insert_rowid(), nil
    end)

    if sucess then
        return pkey, errMsg
    else
        return nil, "InsertMode: Unknown Error"
    end
end

-- Returns the json of a mode
function DAL.GetMode_ByKey(primaryKey)
    local sucess, mode, errMsg = pcall(function ()
        local stmt = db:prepare
        [[
            SELECT JSON
            FROM Mode2
            WHERE ModeKey = ?
            LIMIT 1
        ]]

        local row, errMsg = this.Bind_Select_SingleRow(stmt, "GetMode_ByKey", primaryKey)
        if row then
            return row.JSON, nil
        else
            return nil, errMsg
        end
    end)

    if sucess then
        return mode, errMsg
    else
        return nil, "GetMode_ByKey: Unknown Error"
    end
end

-- WARNING: This function doesn't work, not sure why.  It fails in Bind_Select_MultipleRows_Iterator stmt:bind_values(...)
-- Returns a list of { ModeKey, JSON } of modes by primary keys
function DAL.GetModes_ByKeys(...)
    local arg = {...}
    local param_arr = arg[1]        -- it puts the array in an array with one element

    local sucess, modes, errMsg = pcall(function ()
        local sql =
        [[
            SELECT
                ModeKey,
                JSON
            FROM Mode2
            WHERE ModeKey IN (]]

        for i = 1, #param_arr, 1 do
            if i > 1 then
                sql = sql .. ", "
            end

            sql = sql .. "?"
        end

        sql = sql .. ")"

        local stmt = db:prepare(sql)

        local retVal = {}

        for row in this.Bind_Select_MultipleRows_Iterator(stmt, "GetModes_ByKeys", table.unpack(param_arr)) do      -- unpacking args would give an array.  Need to unpack that inner array
            if row then
                table.insert(retVal, row)
            else
                return nil, "Error retrieving modes: " .. String_Join(", ", param_arr)
            end
        end

        return retVal, nil
    end)

    if sucess then
        return modes, errMsg
    else
        return nil, "GetModes_ByKeys: Unknown Error"
    end
end

-- This is nearly identical to InsertMode, except it's a select.  It's used to avoid unnecessarily
-- inserting dupes
function DAL.GetModeKey_ByContent(mode_name, mode_json)
    local sucess, modeKey, errMsg = pcall(function ()
        --NOTE: This could just compare json, since that contains name and experience.  But doing it this way
        --exactly mirrors the insert method (just in case there are bugs)
        local stmt = db:prepare
        [[
            SELECT ModeKey
            FROM Mode2
            WHERE
                Name = ? AND
                JSON = ?
            LIMIT 1
        ]]

        local row, errMsg = this.Bind_Select_SingleRow(stmt, "GetModeKey_ByContent", mode_name, mode_json)
        if row then
            return row.ModeKey, nil
        else
            return nil, errMsg
        end
    end)

    if sucess then
        return modeKey, errMsg
    else
        return nil, "GetModeKey_ByContent: Unknown Error"
    end
end

function DAL.GetAllModeKeys()
    local sucess, modeKey, errMsg = pcall(function ()
        local stmt = db:prepare
        [[
            SELECT ModeKey
            FROM Mode2
        ]]

        local retVal = {}

        for row in this.Bind_Select_MultipleRows_Iterator(stmt, "GetAllModeKeys") do
            if row then
                table.insert(retVal, row.ModeKey)
            else
                return nil, "Error retrieving all mode keys"
            end
        end

        return retVal, nil
    end)

    if sucess then
        return modeKey, errMsg
    else
        return nil, "GetAllModeKeys: Unknown Error"
    end
end

function DAL.DeleteAllModes_ExceptKeys(...)
    local arg = {...}
    local param_arr = arg[1]        -- it puts the array in an array with one element

    local sucess, errMsg = pcall(function ()
        local sql =
        [[
            DELETE FROM Mode2
            WHERE
                ModeKey NOT IN
                (]]

        for i = 1, #param_arr, 1 do
            if i > 1 then
                sql = sql .. ", "
            end

            sql = sql .. "?"
        end

        sql = sql .. ")"

        local stmt = db:prepare(sql)

        local errMsg = this.Bind_NonSelect(stmt, "DeleteAllModes_ExceptKeys", table.unpack(param_arr))      -- unpacking the inner array (unpacking args would just pass in the array as a single argument)
        if errMsg then
            return errMsg
        end
    end)

    if sucess then
        return errMsg
    else
        return "DeleteOldPlayerRows: Unknown Error"
    end
end

----------------------------------- Private Methods -----------------------------------

-- This returns an int and a human readable string of that time (yyyy-mm-dd hh:mm:ss), that can be stored
-- in a table
function this.GetCurrentTime_AndReadable()
    local time = os.time()
    local time_readable = os.date("%Y-%m-%d %H:%M:%S", time)

    return time, time_readable
end

-- Converts a list of ints into a space delimited string
function this.ModeKeys_List_to_String(modeKeys)
    if not modeKeys then
        return ""
    end

    local retVal = ""

    for _, modeKey in ipairs(modeKeys) do
        if retVal ~= "" then
            retVal = retVal .. " "
        end

        retVal = retVal .. tostring(modeKey)
    end

    return retVal
end
-- Converts a space delimited string of keys into an array of ints
function this.ModeKeys_String_to_List(modeKeys)
    local retVal = {}

    for key in string.gmatch(modeKeys, "%d+") do        -- description was space delimited, but just grab each set of numbers regardless how they are delimited
        table.insert(retVal, tonumber(key))
    end

    return retVal
end

-- Select statements have the same set of checks.  This binds the values, then returns the row
-- Params
--  stmt    what comes back from db:prepare
--  name    string describing the function (used for logging errors)
--  ...     arbitrary number of params that get passed to bind values.  These need to line up with the ?'s in the sql statement
-- Returns
--  row or nil
--  errMsg or nil
function this.Bind_Select_SingleRow(stmt, name, ...)
    if not this.IsEmptyParam(...) then
        local err = stmt:bind_values(...)
        if err ~= sqlite3.OK then
            local errMsg = name .. ": bind_values returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            LogError(errMsg)
            return nil, errMsg
        end
    end

    local result = stmt:step()

    if result == sqlite3.ROW then
        local row = stmt:get_named_values()
        return row, nil

    elseif result == sqlite3.DONE then
        return nil, name .. ": No Rows Found"

    else
        return nil, name .. ": Unknown Error: " .. tostring(result)
    end
end

-- Same idea as the single row version, but this returns an iterator function.  Each time that function is
-- called, it returns the next row (nil when there are no more rows to return)
-- NOTE: This doesn't bother with returning error messages.  If there is an error, it just pretends no rows found
function this.Bind_Select_MultipleRows_Iterator(stmt, name, ...)
    if not this.IsEmptyParam(...) then
        local err = stmt:bind_values(...)

        if err ~= sqlite3.OK then
            LogError(name .. ": bind_values returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")")

            return function ()
                -- The error was already logged, so this is just a function that does nothing and returns nil for the row
                return nil
            end
        end
    end

    return function ()
        local result = stmt:step()

        if result == sqlite3.ROW then
            local row = stmt:get_named_values()
            return row

        elseif result == sqlite3.DONE then
            return nil

        else
            LogError(name .. ": Unknown Error: " .. tostring(result))
            return nil
        end
    end
end
-- Instead of returning an iterator, forcing the caller to keep calling in a loop, this returns the entire result
-- as a single array of row arrays
-- WARNING: Be careful not to request something huge.  The other function is more memory efficient
function this.Bind_Select_MultipleRows_Jagged(stmt, name, ...)
    local retVal = {}
    local index = 1

    for row in this.Bind_Select_MultipleRows_Iterator(stmt, name, ...) do
        retVal[index] = row
        index = index + 1
    end

    return retVal
end

-- Non select statements (insert/update/delete) all have the same set of checks to do, so this just
-- packs them into a single function call
-- Params
--  stmt    what comes back from db:prepare
--  name    string describing the function (used for logging errors)
--  ...     arbitrary number of params that get passed to bind values.  These need to line up with the ?'s in the sql statement
-- Returns
--  error message or nil
function this.Bind_NonSelect(stmt, name, ...)
    if not this.IsEmptyParam(...) then
        local err = stmt:bind_values(...)
        if err ~= sqlite3.OK then
            local errMsg = name .. ": bind_values returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
            LogError(errMsg)
            return errMsg
        end
    end

    local err = stmt:step()
    if err ~= sqlite3.DONE then
        local errMsg = name .. ": step returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
        LogError(errMsg)
        return errMsg
    end

    err = stmt:finalize()
    if err ~= sqlite3.OK then
        local errMsg = name .. ": finalize returned an error: " .. tostring(err) .. " (" .. tostring(db:errmsg()) .. ")"
        LogError(errMsg)
        return errMsg
    end

    return nil
end

function this.IsEmptyParam(...)
    return
        select("#", ...) == 1 and               -- count
        type(select(1, ...)) == "string" and    -- getting the first item
        select(1, ...) == empty_param
end

return DAL