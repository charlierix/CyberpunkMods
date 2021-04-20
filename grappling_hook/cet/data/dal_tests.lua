function CreateTestTables()
    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS TokenGenerator (TokenName TEXT NOT NULL UNIQUE, NextValue INTEGER NOT NULL);") end)

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS TestTable1 (Col1 INTEGER);") end)
    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS TestTable2 (Col1 TEXT);") end)

end

-- Token Table (likely won't keep this)
-- There was a problem with the upload failing immediately after loading.  The short term fix was to
-- call db:close() in shutdown, but that was fixed in the next cet release
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


function InsertTest()
    -------- None of these work.  exec seems to be the problem

    --local stmt = db:prepare[[ INSERT INTO TestTable1 VALUES(:Col1) ]]
    --local stmt = db:prepare[[ INSERT INTO TestTable1 VALUES(?) ]]
    --local stmt = db:prepare("INSERT INTO TestTable1 (Col1) VALUES (?)")

    --local err = stmt:bind({ Col1 = 1234 }):exec()
    --local err = stmt:bind_values(1234):exec()

    --------


    -- this works
    local stmt = db:prepare[[ INSERT INTO TestTable2 VALUES(?) ]]

    stmt:bind_values("aaa")

    stmt:step()
    stmt:finalize()
end