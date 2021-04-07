function EnsureTablesCreated()
    --https://stackoverflow.com/questions/1601151/how-do-i-check-in-sqlite-whether-a-table-exists

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS TokenGenerator (TokenName TEXT NOT NULL UNIQUE, NextValue INTEGER NOT NULL);") end)
end

function GetNextToken(tokenName, baseNum, increment)
    --https://stackoverflow.com/questions/3647454/increment-counter-or-insert-row-in-one-statement-in-sqlite

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
        local sql = "INSERT OR IGNORE INTO TokenGenerator VALUES ('" .. tokenName .. "', " .. tostring(baseNum) .. ");\r\n"
        sql = sql .. "UPDATE TokenGenerator SET NextValue = NextValue + " .. tostring(increment) .. " WHERE TokenName = '" .. tokenName .. "';"

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
