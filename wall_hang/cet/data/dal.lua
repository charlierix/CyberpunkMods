--http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#numerical_error_and_result_codes
--https://sqlite.org/c3ref/c_abort.html

local this = {}
local empty_param = "^^this is an empty param^^"

function EnsureTablesCreated()
    --https://stackoverflow.com/questions/1601151/how-do-i-check-in-sqlite-whether-a-table-exists

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Settings_Int (Key TEXT NOT NULL UNIQUE, Value INTEGER NOT NULL);") end)

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Settings_Float (Key TEXT NOT NULL UNIQUE, Value REAL NOT NULL);") end)

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS InputBindings (Binding TEXT NOT NULL, ActionName TEXT NOT NULL);") end)

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Player_Arcade (JSON TEXT NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, IgnoreKey INTEGER UNIQUE);") end)
end

-------------------------------------- Settings ---------------------------------------

-- These are tables that hold key/value pairs.  Making specific tables per datatype.  The Get functions will return
-- the value else default value (so it's like they pretend the row is always there)

-- Returns
--  bool, error message
function GetSetting_Bool(key, default)
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
function SetSetting_Bool(key, value)
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

-- Returns
--  floating point value, error message
function GetSetting_Float(key, default)
    local sucess, value, errMsg = pcall(function ()
        local stmt = db:prepare
        [[
            SELECT Value
            FROM Settings_Float
            WHERE Key = ?
            LIMIT 1
        ]]

        local row, _ = this.Bind_Select_SingleRow(stmt, "GetSetting_Float", key)
        if row then
            return row.Value
        else
            return default, nil     -- no row found or error, pretend it was found and return the default value
        end
    end)

    if sucess then
        return value, errMsg
    else
        return default, "GetSetting_Float: Unknown Error"
    end
end
-- Inserts/Updates the key/value pair
-- Returns
--  error message or nil
function SetSetting_Float(key, value)
    local sucess, errMsg = pcall(function ()
        -- Insert
        local stmt = db:prepare
        [[
            INSERT OR IGNORE INTO Settings_Float
            VALUES(?, ?)
        ]]

        local errMsg = this.Bind_NonSelect(stmt, "SetSetting_Float (insert)", key, value)
        if errMsg then
            return errMsg
        end

        -- Update
        stmt = db:prepare
        [[
            UPDATE Settings_Float
            SET Value = ?
            WHERE Key = ?
        ]]

        errMsg = this.Bind_NonSelect(stmt, "SetSetting_Float (update)", value, key)
        if errMsg then
            return errMsg
        end

        return nil
    end)

    if sucess then
        return errMsg
    else
        return "SetSetting_Float: Unknown Error"
    end
end

----------------------------------- Input Bindings ------------------------------------

-- Returns { binding1 = {"action1", "action2"}, binding2 = {"action3", "action4"} }
function GetAllInputBindings()
    local sucess, rows = pcall(function ()
        local stmt = db:prepare
        [[
            SELECT Binding, ActionName
            FROM InputBindings
        ]]

        local retVal = {}
        local foundOne = false

        for row in this.Bind_Select_MultiplRows_Iterator(stmt, "GetAllInputBindings", empty_param) do
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
function SetInputBinding(binding, actionNames)
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

------------------------------------ Player Arcade ------------------------------------

-- This returns the json (or nil)
function GetPlayerArcade()
    local sucess, player, errMsg = pcall(function ()
        --NOTE: There should never be more than one row, but it's easy enough to order desc and limit 1
        local stmt = db:prepare
        [[
            SELECT JSON
            FROM Player_Arcade
            ORDER BY LastUsed DESC
            LIMIT 1
        ]]

        local row, errMsg = this.Bind_Select_SingleRow(stmt, "GetPlayerArcade")
        if row then
            return row.JSON, errMsg
        else
            return nil, errMsg
        end
    end)

    if sucess then
        return player, errMsg
    else
        return nil, "GetPlayerArcade: Unknown Error"
    end
end
function SetPlayerArcade(json)
    local sucess, errMsg = pcall(function ()
        local time, time_readable = this.GetCurrentTime_AndReadable()

        -- Insert
        -- NOTE: the 'or ignore' relies on IgnoreKey being unique.  Hardcoding to 1 so there will never be more than one row
        local stmt = db:prepare
        [[
            INSERT OR IGNORE INTO Player_Arcade
                (JSON, LastUsed, LastUsed_Readable, IgnoreKey)
            VALUES
                (?, ?, ?, ?)
        ]]

        local errMsg = this.Bind_NonSelect(stmt, "SetPlayerArcade (insert)", json, time, time_readable, 1)
        if errMsg then
            return errMsg
        end

        -- Update
        stmt = db:prepare
        [[
            UPDATE Player_Arcade
            SET
                JSON = ?,
                LastUsed = ?,
                LastUsed_Readable = ?
        ]]

        errMsg = this.Bind_NonSelect(stmt, "SetPlayerArcade (update)", json, time, time_readable)
        if errMsg then
            return errMsg
        end

        return nil
    end)

    if sucess then
        return errMsg
    else
        return "SetPlayerArcade: Unknown Error"
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
function this.Bind_Select_MultiplRows_Iterator(stmt, name, ...)
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
function this.Bind_Select_MultiplRows_Jagged(stmt, name, ...)
    local retVal = {}
    local index = 1

    for row in this.Bind_Select_MultiplRows_Iterator(stmt, name, ...) do
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