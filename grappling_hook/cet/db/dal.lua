function EnsureTablesCreated()
    --https://stackoverflow.com/questions/1601151/how-do-i-check-in-sqlite-whether-a-table-exists

    pcall(function () db:exec("CREATE TABLE IF NOT EXISTS TokenGenerator (TokenName TEXT NOT NULL UNIQUE, NextValue INTEGER NOT NULL);") end)
end

function GetNextToken(tokenName)
    --https://stackoverflow.com/questions/3647454/increment-counter-or-insert-row-in-one-statement-in-sqlite

    local sucess, result = pcall(function ()
        -- Create or Increment
        local sql = "INSERT OR IGNORE INTO TokenGenerator VALUES ('" .. tokenName .. "', 0);\r\n"
        sql = sql .. "UPDATE TokenGenerator SET NextValue = NextValue + 1 WHERE TokenName = '" .. tokenName .. "';\r\n"

        db:exec(sql)

        -- Select current value
        for row, _ in db:rows("SELECT NextValue FROM TokenGenerator WHERE TokenName = '" .. tokenName .. "';") do
            return row[1]
        end

        return nil      -- should never happen
    end)

    if sucess then
        return result
    else
        return nil
    end
end
