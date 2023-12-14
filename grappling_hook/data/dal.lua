--http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#numerical_error_and_result_codes
--https://sqlite.org/c3ref/c_abort.html

local this = {}
local DAL = {}

local empty_param = "^^this is an empty param^^"

function DAL.EnsureTablesCreated()
    --https://stackoverflow.com/questions/1601151/how-do-i-check-in-sqlite-whether-a-table-exists

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Settings_Int (Key TEXT NOT NULL UNIQUE, Value INTEGER NOT NULL);") end)

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS InputBindings (Binding TEXT NOT NULL, ActionName TEXT NOT NULL);") end)

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Player (PlayerKey INTEGER NOT NULL UNIQUE, PlayerID INTEGER NOT NULL, JSON_EnergyTank TEXT NOT NULL, GrappleKey1 INTEGER, GrappleKey2 INTEGER, GrappleKey3 INTEGER, GrappleKey4 INTEGER, GrappleKey5 INTEGER, GrappleKey6 INTEGER, Experience REAL NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, PRIMARY KEY(PlayerKey AUTOINCREMENT));") end)

    --TODO: Add a column for straightline vs webswing
    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Grapple (GrappleKey INTEGER NOT NULL UNIQUE, Name TEXT, Experience REAL NOT NULL, JSON TEXT NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, PRIMARY KEY(GrappleKey AUTOINCREMENT));") end)

    -- This should probably be a temp table, but it will be populated across multiple dal calls, so keeping
    -- the table around.  It's up to the caller to truncate first.  Not making the key column unique to
    -- make it more forgiving to the function that populates it
    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS WorkingKeys (Key INTEGER NOT NULL);") end)
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

        errMsg = this.Bind_NonSelect(stmt, "SetSetting_Bool (update)", valueInt, key)
        if errMsg then
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

----------------------------------- Input Bindings ------------------------------------

-- Returns { binding1 = {"action1", "action2"}, binding2 = {"action3", "action4"} }
function DAL.GetAllInputBindings()
    local sucess, rows = pcall(function ()
        local stmt = db:prepare
        [[
            SELECT Binding, ActionName
            FROM InputBindings
        ]]

        local retVal = {}
        local foundOne = false

        for row in this.Bind_Select_MultipleRows_Iterator(stmt, "GetAllInputBindings", empty_param) do
            foundOne = true

            if not retVal[row.Binding] then
                retVal[row.Binding] = {}
            end

            table.insert(retVal[row.Binding], row.ActionName)
        end

        if foundOne then
            return retVal
        else
            return nil
        end
    end)

    if sucess then
        return rows
    else
        return nil
    end
end

-- This overwrites the current binding with the one passed in
function DAL.SetInputBinding(binding, actionNames)
    local sucess, errMsg = pcall(function ()
        -- Delete Old
        local stmt = db:prepare
        [[
            DELETE FROM InputBindings
            WHERE Binding = ?
        ]]

        local errMsg = this.Bind_NonSelect(stmt, "SetInputBinding (delete)", binding)
        if errMsg then
            return errMsg
        end

        if actionNames then
            -- Insert New
            local sql = "INSERT INTO InputBindings VALUES "
            local param_values = {}

            for i = 1, #actionNames do
                local append = "(?, ?)"

                if i < #actionNames then
                    append = append .. ", "
                end

                sql = sql .. append

                table.insert(param_values, binding)
                table.insert(param_values, actionNames[i])
            end

            stmt = db:prepare(sql)

            return this.Bind_NonSelect(stmt, "SetInputBinding (insert", unpack(param_values))
        else
            return nil      -- nothing inserted, so no error message to return
        end
    end)

    if sucess then
        return errMsg
    else
        return "DeleteOldPlayerRows: Unknown Error"
    end
end

--------------------------------------- Player ----------------------------------------

function DAL.InsertPlayer(playerID, energy_tank, grappleKeys, experience)
    local sucess, pkey, errMsg = pcall(function ()
        local time, time_readable = this.GetCurrentTime_AndReadable()
        local json_energy_tank = extern_json.encode(energy_tank)

        local stmt = db:prepare
        [[
            INSERT INTO Player
                (PlayerID, JSON_EnergyTank, GrappleKey1, GrappleKey2, GrappleKey3, GrappleKey4, GrappleKey5, GrappleKey6, Experience, LastUsed, LastUsed_Readable)
            VALUES
                (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]]

        local errMsg = this.Bind_NonSelect(stmt, "InsertPlayer", playerID, json_energy_tank, grappleKeys[1], grappleKeys[2], grappleKeys[3], grappleKeys[4], grappleKeys[5], grappleKeys[6], experience, time, time_readable)
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
                JSON_EnergyTank,
                GrappleKey1,
                GrappleKey2,
                GrappleKey3,
                GrappleKey4,
                GrappleKey5,
                GrappleKey6,
                Experience
            FROM Player
            WHERE PlayerID = ?
            ORDER BY LastUsed DESC
            LIMIT 1
        ]]

        return this.Bind_Select_SingleRow(stmt, "GetLatestPlayer", playerID)
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
                    a.PlayerID = ?
                    ORDER BY a.LastUsed DESC
                    LIMIT 12
                )
        ]]

        local errMsg = this.Bind_NonSelect(stmt, "DeleteOldPlayerRows", playerID, playerID)
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

--------------------------------------- Grapple ---------------------------------------

-- Inserts a grapple entry into the Grapple table
-- Params:
--    grapple: This is a grapple entry (see models\grapple)
-- Returns:
--    primary key or nil
--    error message if primary key is nil
function DAL.InsertGrapple(grapple)
    local sucess, pkey, errMsg = pcall(function ()
        local time, time_readable = this.GetCurrentTime_AndReadable()
        local json = extern_json.encode(grapple)

        local stmt = db:prepare
        [[
            INSERT INTO Grapple
                (Name, Experience, JSON, LastUsed, LastUsed_Readable)
            VALUES
                (?, ?, ?, ?, ?)
        ]]

        local errMsg = this.Bind_NonSelect(stmt, "InsertGrapple", grapple.name, grapple.experience, json, time, time_readable)
        if errMsg then
            return errMsg
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

function DAL.GetGrapple_ByKey(primaryKey)
    local sucess, grapple, errMsg = pcall(function ()
        local stmt = db:prepare
        [[
            SELECT JSON
            FROM Grapple
            WHERE GrappleKey = ?
            LIMIT 1
        ]]

        local row, errMsg = this.Bind_Select_SingleRow(stmt, "GetGrapple_ByKey", primaryKey)
        if row then
            return extern_json.decode(row.JSON), nil
        else
            return nil, errMsg
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
function DAL.GetGrappleKey_ByContent(grapple)
    local sucess, grappleKey, errMsg = pcall(function ()
        local json = extern_json.encode(grapple)

        --NOTE: This could just compare json, since that contains name and experience.  But doing it this way
        --exactly mirrors the insert method (just in case there are bugs)
        local stmt = db:prepare
        [[
            SELECT GrappleKey
            FROM Grapple
            WHERE
                Name = ? AND
                Experience = ? AND
                JSON = ?
            LIMIT 1
        ]]

        local row, errMsg = this.Bind_Select_SingleRow(stmt, "GetGrappleKey_ByContent", grapple.name, grapple.experience, json)
        if row then
            return row.GrappleKey, nil
        else
            return nil, errMsg
        end
    end)

    if sucess then
        return grappleKey, errMsg
    else
        return nil, "GetGrappleKey_ByContent: Unknown Error"
    end
end

-- This returns information about each grapple row, sorted by xp, name
-- Returns
--  { { grapple_key, name, experience, description, date }, {...}, {...}, }
function DAL.GetAvailableGrapples()
    local sucess, rows = pcall(function ()
        local stmt = db:prepare
        [[
            SELECT
                GrappleKey,
                Name,
                Experience,
                JSON,
                LastUsed_Readable
            FROM
                Grapple
            ORDER BY
                Experience, Name
        ]]

        local retVal = {}
        local foundOne = false

        for row in this.Bind_Select_MultipleRows_Iterator(stmt, "GetAvailableGrapples", empty_param) do
            foundOne = true

            retVal[#retVal+1] =
            {
                grapple_key = row.GrappleKey,
                name = row.Name,
                experience = row.Experience,
                description = this.GetGrappleDescription(row.JSON),
                date = row.LastUsed_Readable,
            }
        end

        if foundOne then
            return retVal
        else
            return nil
        end
    end)

    if sucess then
        return rows
    else
        return nil
    end
end

-- These are a set of functions that will delete excess rows from the grapple table (see datautil.ReduceGrappleRows)
function DAL.DeleteOldGrappleRows_TruncateWorkingTable()
   local sucess, errMsg = pcall(function ()
        -- sqlite doesn't have a truncate
        local stmt = db:prepare("DELETE FROM WorkingKeys")

        return this.Bind_NonSelect(stmt, "DeleteOldGrappleRows_TruncateWorkingTable", empty_param)
   end)

   if sucess then
       return errMsg
   else
       return "DeleteOldGrappleRows_TruncateWorkingTable: Unknown Error"
   end
end
function DAL.DeleteOldGrappleRows_KeepReferenced()
    local sucess, errMsg = pcall(function ()
        local stmt = db:prepare
        [[
            INSERT INTO WorkingKeys
            SELECT DISTINCT GrappleKey
            FROM
            (
                SELECT GrappleKey1 AS GrappleKey FROM Player
                UNION ALL
                SELECT GrappleKey2 AS GrappleKey FROM Player
                UNION ALL
                SELECT GrappleKey3 AS GrappleKey FROM Player
                UNION ALL
                SELECT GrappleKey4 AS GrappleKey FROM Player
                UNION ALL
                SELECT GrappleKey5 AS GrappleKey FROM Player
                UNION ALL
                SELECT GrappleKey6 AS GrappleKey FROM Player
            )
            WHERE GrappleKey IS NOT NULL
        ]]

        return this.Bind_NonSelect(stmt, "DeleteOldGrappleRows_KeepReferenced", empty_param)
   end)

   if sucess then
       return errMsg
   else
       return "DeleteOldGrappleRows_KeepReferenced: Unknown Error"
   end
end
function DAL.DeleteOldGrappleRows_GetCandidateGrapples()
    local sucess, rows = pcall(function ()
        local stmt = db:prepare
        [[
            SELECT
                Name, Experience, GrappleKey
            FROM
                Grapple
            WHERE
                GrappleKey NOT IN (SELECT Key FROM WorkingKeys)
            ORDER BY
                Name,
                Experience,
                LastUsed DESC
        ]]

        return this.Bind_Select_MultipleRows_Jagged(stmt, "DeleteOldGrappleRows_GetCandidateGrapples", empty_param)
    end)

    if sucess then
        return rows
    else
        return nil
    end
end
function DAL.DeleteOldGrappleRows_KeepHistorical(keys)
    local sucess, errMsg = pcall(function ()
        local sql = "INSERT INTO WorkingKeys VALUES "
        for i = 1, #keys do
            local append = "(?)"

            if i < #keys then
                append = append .. ", "
            end

            sql = sql .. append
        end

        local stmt = db:prepare(sql)

        return this.Bind_NonSelect(stmt, "DeleteOldGrappleRows_KeepHistorical", unpack(keys))
   end)

   if sucess then
       return errMsg
   else
       return "DeleteOldGrappleRows_KeepHistorical: Unknown Error"
   end
end
function DAL.DeleteOldGrappleRows_DeleteGrapples()
    local sucess, errMsg = pcall(function ()
        local stmt = db:prepare
        [[
            DELETE FROM Grapple
            WHERE GrappleKey NOT IN (SELECT Key FROM WorkingKeys)
        ]]

        return this.Bind_NonSelect(stmt, "DeleteOldGrappleRows_DeleteGrapples", empty_param)
   end)

   if sucess then
       return errMsg
   else
       return "DeleteOldGrappleRows_DeleteGrapples: Unknown Error"
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

function this.GetGrappleDescription(json)
    if not json then
        return ""
    end

    local grapple = extern_json.decode(json)
    if not grapple then
        return ""
    end

    if not grapple.description then
        return ""
    end

    return grapple.description
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