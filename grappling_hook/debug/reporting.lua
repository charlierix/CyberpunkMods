--TODO: Instead of print, try spdlog.info("some text")
-- that should go into the local log file

-- This is a more verbose report (has extra print statements)
function ReportTable(val, indent)
    if not indent then
        indent = ""
    end

    print(indent .. tostring(val))      -- this just returns table and its id

    if not val then
        do return end
    end

    if type(val) == "table" then
        --#val is only non zero if the keys are integers
        --print("count: " .. #val)      -- this returns the max index of the array (1 based)  NOTE: This is reporting zero when the keys are strings

        for key, value in pairs(val) do
            if not value then
                print(indent .. key .. " | " .. tostring(value))        -- either nil or false
            elseif type(value) == "table" then
                print(indent .. key .. ":")
                ReportTable(value, indent .. "   ")
            else
                print(indent .. key .. " | " .. tostring(value))
            end
        end
    else
        print(indent .. "not a table. printing type")
        print(indent .. type(val))
    end

    --print("finished reporting table")
end

-- This only prints the key, values
------------ Params
-- val                  a table to print the contents of
-- indent               whitespace to print in front of each row (nil, "", "   ", etc)
-- overrideChildReport  an optional function that gets called when child tables are encountered.  It gives the caller
--                      a chance to print a custom report specific to a table's type
--                      ------------ Params
--                      childtable, indent
--                      ------------ Returns
--                      true:   the function reported the child table, this function should do nothing
--                      false:  the function didn't handle the child table, this function needs to recurse
function ReportTable_lite(val, indent, overrideChildReport)
    if not val then
        do return end
    end

    if not indent then
        indent = ""
    end

    if type(val) == "table" then
        --#val is only non zero if the keys are integers
        --print("count: " .. #val)      -- this returns the max index of the array (1 based)  NOTE: This is reporting zero when the keys are strings

        -- Sort it
        local keys = {}

        for k in pairs(val) do
          if type(k) ~= "string" then
            error("invalid table: mixed or invalid key types: " .. type(k))
          end

          table.insert(keys, k)
        end

        table.sort(keys)

        --for key, value in pairs(val) do
        for _, k in ipairs(keys) do     -- iterate over the sorted list
            local key = k
            local value = val[k]

            if not value then
                print(indent .. key .. " | " .. tostring(value))        -- either nil or false
            elseif type(value) == "table" then
                print(indent .. key .. ":")

                local shouldRecurse = true
                if overrideChildReport then
                    shouldRecurse = not overrideChildReport(value, indent .. "   ")
                end

                if shouldRecurse then
                    ReportTable_lite(value, indent .. "   ", overrideChildReport)
                end
            else
                print(indent .. key .. " | " .. tostring(value))
            end
        end
    else
        print(indent .. "not a table (" .. type(val) .. ")")
    end
end


-- This should probably be removed.  There are lots of posts talking about:
-- Dump(class, false)       -- generic lua function?  (doesn't work on tables)
-- GameDump(class)          -- game specific debug function
function MemberDump(obj)
    if not obj then
        print("obj is nil")
        do return end
    end

    print(obj)
    print(type(obj))
    print("---------------")

    for key,value in pairs(getmetatable(obj)) do
        print(key, value)
    end
end

function ReportStickyList(list, indent, overrideChildReport)
    if not indent then
        indent = ""
    end

    for i=1, list:GetCount() do
        local item = list:GetItem(i)

        if type(item) == "table" then
            print(indent .. tostring(i) .. ":")

            local shouldReportTable = true
            if overrideChildReport then
                shouldReportTable = not overrideChildReport(item, indent .. "   ")
            end

            if shouldReportTable then
                ReportTable_lite(item, indent .. "   ")
            end
        else
            print(indent .. tostring(i) .. " | " .. tostring(item))
        end
    end
end

function ReportStickyList_full(list, indent)
    if not indent then
        indent = ""
    end

    for i=1, list.count do
        local item = list.table[i]

        local text = indent .. tostring(i)
        if type(item) == "table" then
            --text = text .. " (table):"        -- the word table is distracting
            text = text .. ":"
        else
            text = text .. " | " .. tostring(item)
        end

        if i > list.maxIndex then
            text = text .. " ----- garbage"
        end

        print(text)

        if type(item) == "table" then
            ReportTable_lite(item, indent .. "   ")
        end
    end
end

-- This checks to see if the table is an instance of known types and uses custom report functions instead
function Override_ReportTable(childtable, indent)
    -- StickyList
    local isSticky = IsInstance(childtable, StickyList)
    if isSticky then
        --print(indent .. "--- Showing StickyList ---")
        ReportStickyList(childtable, indent, Override_ReportTable)
        return true
    end

    -- Regular table or unknown type of instance
    return false
end