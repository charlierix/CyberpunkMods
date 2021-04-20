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

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Player (PlayerKey INTEGER NOT NULL UNIQUE, PlayerID INTEGER NOT NULL, JSON_Energy_Tank TEXT NOT NULL, GrappleKey1 INTEGER, GrappleKey2 INTEGER, GrappleKey3 INTEGER, GrappleKey4 INTEGER, GrappleKey5 INTEGER, GrappleKey6 INTEGER, Experience REAL NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, PRIMARY KEY(PlayerKey AUTOINCREMENT));") end)

    --TODO: Add a column for straightline vs webswing
    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Grapple (GrappleKey INTEGER NOT NULL UNIQUE, Name TEXT, Experience REAL NOT NULL, JSON TEXT NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, PRIMARY KEY(GrappleKey AUTOINCREMENT));") end)
end

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
function GetGrapple(primaryKey)
    -- select top 1 from Grapple where GrappleKey = primaryKey
end
-- This finds grapples that can be used by the amount of experience passed in
function FindGrapples(targetExperience)
    -- Need to also get distinct name, but get the largest experience for each of those distinct names

    --select * from grapple
    --where experience <= targetExperience
    --order by experience desc
end

-- This returns an int and a human readable string of that time (yyyy-mm-dd hh:mm:ss), that can be stored
-- in a table
function GetCurrentTime_AndReadable()
    local time = os.time()
    local time_readable = os.date("%Y-%m-%d %H:%M:%S", time)

    return time, time_readable
end