--http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#numerical_error_and_result_codes

function EnsureTablesCreated()
    --https://stackoverflow.com/questions/1601151/how-do-i-check-in-sqlite-whether-a-table-exists

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS TokenGenerator (TokenName TEXT NOT NULL UNIQUE, NextValue INTEGER NOT NULL);") end)
end

-- Token Table (likely won't keep this)
function GetNextToken(tokenName, baseNum, increment)
    --https://stackoverflow.com/questions/3647454/increment-counter-or-insert-row-in-one-statement-in-sqlite

    if not baseNum or baseNum < 0 then
        baseNum = 0
    end

    if not increment or increment < 1 then
        increment = 1
    end

    local sucess, result = pcall(function ()
        -- Create or Increment
        -- local sql = "INSERT OR IGNORE INTO TokenGenerator VALUES ('" .. tokenName .. "', 0);\r\n"
        -- sql = sql .. "UPDATE TokenGenerator SET NextValue = NextValue + " .. tostring(increment) .. " WHERE TokenName = '" .. tokenName .. "';\r\n"

        -- db:exec(sql)

        -- db:exec("INSERT OR IGNORE INTO TokenGenerator VALUES ('" .. tokenName .. "', 0);")
        -- db:exec("UPDATE TokenGenerator SET NextValue = NextValue + " .. tostring(increment) .. " WHERE TokenName = '" .. tokenName .. "';")



        --TODO: Need to enforce basenum: next = max(basenum+increment, next+increment)
        --local sql = "BEGIN TRANSACTION;\r\n"      -- transaction has a high chance of locking the database until they quit the game
        --sql = sql .. "INSERT OR IGNORE INTO TokenGenerator VALUES ('" .. tokenName .. "', " .. tostring(baseNum) .. ");\r\n"
        local sql = "INSERT OR IGNORE INTO TokenGenerator VALUES ('" .. tokenName .. "', " .. tostring(baseNum) .. ");\r\n"
        sql = sql .. "UPDATE TokenGenerator SET NextValue = NextValue + " .. tostring(increment) .. " WHERE TokenName = '" .. tokenName .. "';"
        --sql = sql .. "COMMIT;"

        print(sql)

        db:exec(sql)




        -- Select current value
        for row, _ in db:rows("SELECT NextValue FROM TokenGenerator WHERE TokenName = '" .. tokenName .. "';") do
            return row[1]
        end

        print("no row found")
        return nil      -- should never happen
    end)

    if sucess then
        return result
    else
        print("db error")
        return nil
    end
end
function GetNextToken2(tokenName, baseNum, increment)
    --https://stackoverflow.com/questions/3647454/increment-counter-or-insert-row-in-one-statement-in-sqlite

    if not baseNum or baseNum < 0 then
        baseNum = 0
    end

    if not increment or increment < 1 then
        increment = 1
    end

    local sucess, result = pcall(function ()

        -- local sql = "INSERT OR IGNORE INTO TokenGenerator VALUES ('" .. tokenName .. "', " .. tostring(baseNum) .. ");"
        -- local err = db:exec(sql)

        -- if err ~= 0 then
        --     print(sql)
        --     print("err: " .. tostring(err))
        -- end

        -- sql = "UPDATE TokenGenerator SET NextValue = NextValue + " .. tostring(increment) .. " WHERE TokenName = '" .. tokenName .. "';"
        -- err = db:exec(sql)

        -- if err ~= 0 then
        --     print(sql)
        --     print("err: " .. tostring(err))
        -- end






        local sql = "INSERT OR IGNORE INTO TokenGenerator VALUES ('" .. tokenName .. "', " .. tostring(baseNum) .. ");\r\n"
        sql = sql .. "UPDATE TokenGenerator SET NextValue = NextValue + " .. tostring(increment) .. " WHERE TokenName = '" .. tokenName .. "';"

        local err = db:exec(sql)

        if err ~= 0 then
            print(sql)
            print("err: " .. tostring(err))
            print(tostring(db:errmsg()))
        end








        -- Select current value
        for row, _ in db:rows("SELECT NextValue FROM TokenGenerator WHERE TokenName = '" .. tokenName .. "';") do
            return row[1]
        end

        print("no row found")
        return nil      -- should never happen
    end)

    if sucess then
        return result
    else
        print("db error")
        return nil
    end
end
function GetCurrentToken(tokenName)
    local sucess, result = pcall(function ()
        -- Select current value
        for row, _ in db:rows("SELECT NextValue FROM TokenGenerator WHERE TokenName = '" .. tokenName .. "';") do
            return row[1]
        end

        print("no row found")
        return nil      -- should never happen
    end)

    if sucess then
        return result
    else
        print("db error")
        return nil
    end
end