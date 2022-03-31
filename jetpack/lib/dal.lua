-- This stores the index in a single column, single row table.  It doesn't listen for errors (it's not that
-- critical if this doesn't work)
function UpdateModeIndex(index)
    -- Don't bother with drop table, just create and ignore error if it already exists
    -- Can't name the column index, that's a reserved word
    pcall(function () db:exec("CREATE TABLE mode (modeIndex INTEGER);") end)

    pcall(function ()
        -- There is no truncate, just delete with no where
        db:exec("DELETE FROM mode;")

        db:exec("INSERT INTO mode VALUES(" .. tostring(index) .. ");")
    end)
end

function GetModeIndex()
    local sucess, result = pcall(function ()
        for row, _ in db:rows("SELECT modeIndex FROM mode LIMIT 1;") do
            return row[1]
        end

        -- There should always be exactly one row, but just default to zero if there are no rows
        return 0
    end)

    if sucess then
        --print("query succeeded: " .. tostring(result))
        return result
    else
        --print("query failed")
        return 0
    end
end