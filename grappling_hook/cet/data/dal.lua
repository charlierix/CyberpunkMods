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

    --TODO: Just call this Player.  Don't store the whole thing in a single json, put each grapple instance in the grapple table
    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS PlayerSaves (PlayerID INTEGER NOT NULL, Name TEXT, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, Serialized TEXT NOT NULL);") end)

    --TODO: Add a column for straightline vs webswing
    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS Grapple (GrappleKey INTEGER NOT NULL UNIQUE, Name TEXT, Experience REAL NOT NULL, LastUsed INTEGER NOT NULL, LastUsed_Readable TEXT NOT NULL, JSON TEXT NOT NULL, PRIMARY KEY(GrappleKey AUTOINCREMENT));") end)
end

function InsertPlayer(playerID, name, json)

    print("insert a")

    local time, time_readable = GetCurrentTime_AndReadable()

    print("insert b")

    -- This is flawed, it doesn't escape quotes, allows sql injection
    --local sql = "INSERT INTO PlayerSaves VALUES (" .. tostring(playerID) .. ", '" .. name .. "', ".. tostring(time) .. ", '" .. time_readable .. "', '" .. json .. "');"

    --pcall(function ()

        print("insert c")

        --https://stackoverflow.com/questions/1224806/how-to-quote-values-for-luasql

        --local stmt = db:prepare[[ INSERT INTO tbl(first_name, last_name) VALUES(:first_name, :last_name) ]]
        --local stmt = db:prepare[[ INSERT INTO PlayerSaves(PlayerID, Name, LastUsed, LastUsed_Readable, Serialized) VALUES(:PlayerID, :Name, :LastUsed, :LastUsed_Readable, :Serialized) ]]
        local stmt = db:prepare[[ INSERT INTO PlayerSaves VALUES(:PlayerID, :Name, :LastUsed, :LastUsed_Readable, :Serialized) ]]

        print("insert d")

        -- print("PlayerID = " .. tostring(playerID))
        -- print("Name = " .. tostring(name))
        -- print("LastUsed = " .. tostring(time))
        -- print("LastUsed_Readable = " .. tostring(time_readable))
        -- print("Serialized = " .. tostring(json))

        local err = stmt:bind({ PlayerID = playerID, Name = name, LastUsed = time, LastUsed_Readable = time_readable, Serialized = json }):exec()
        --local err = stmt:bind(playerID, name, time, time_readable, json):exec()

        print("insert e: " .. tostring(err))

        if err == 0 then
            print("huh")
        end

        if err ~= 0 then
            print("err: " .. tostring(err))
            print(tostring(db:errmsg()))
        end

    --end)
end

function InsertGrapple(grapple)


    --TODO: pcall

    local time, time_readable = GetCurrentTime_AndReadable()
    local json = Serialize_Table(grapple)

    local stmt = db:prepare[[ INSERT INTO Grapple (Name, Experience, LastUsed, LastUsed_Readable, JSON) VALUES (?, ?, ?, ?, ?) ]]

    local err = stmt:bind_values(grapple.name, grapple.experience, time, time_readable, json)
    if err ~= sqlite3.OK then
        print("InsertGrapple: bind_values returned an error: " .. tostring(err))
        return nil
    end

    err = stmt:step()
    if err ~= sqlite3.DONE then
        print("InsertGrapple: step returned an error: " .. tostring(err))
        return nil
    end

    err = stmt:finalize()
    if err ~= sqlite3.OK then
        print("InsertGrapple: finalize returned an error: " .. tostring(err))
        return nil
    end

    -- This is the primary key of the inserted row
    return db:last_insert_rowid()




end
function GetGrapple(primaryKey)
    
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