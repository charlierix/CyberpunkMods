---------------------------------- Key/Value Arrays -----------------------------------

function Contains_Key(list, key)
    for k, _ in pairs(list) do
        if k == key then
            return true
        end
    end

    return false
end
function Contains_Value(list, value)
    for _, v in pairs(list) do
        if v == value then
            return true
        end
    end

    return false
end

----------------------------------- Indexed Arrays ------------------------------------

function Insert(list, entry, index)
    -- This might be a duplication of table.insert, making my own for the sake of certainty

    -- Add
    if index == nil or index > #list then
        list[#list+1] = entry
        do return end
    end

    -- Make room
    for i = #list + 1, index + 1, -1 do
        list[i] = list[i - 1]
    end

    -- Insert it
    list[index] = entry
end

-- This inserts the entry into the list, maintaining sort
-- comparer is a pointer to a compare func (see Comparer() lower in this file)
function InsertSorted(list, entry, comparer)
    for i = 1, #list do
        local diff = comparer(entry, list[i])
        if diff < 0 then
            Insert(list, entry, i)
            do return end
        end
    end

    -- Add to the end
    list[#list+1] = entry
end

-- Returns true if all the values in A are contained in B
function Is_A_SubsetOf_B(list_a, list_b)
    for i = 1, #list_a do
        if not Contains(list_b, list_a[i]) then
            return false
        end
    end

    return true
end

function Contains(list, testValue)
    for i = 1, #list do
        if list[i] == testValue then
            return true
        end
    end

    return false
end

-------------------------------------- Iterators --------------------------------------

-- Iterates the list, but sorted by key
-- Usage:
--  for key, value in pairs_sorted(list) do
--  end
function pairs_sorted(list)
    local keys = {}

    -- populate the table that holds the keys
    for key in pairs(list) do
        table.insert(keys, key)
    end

    -- sort the keys
    table.sort(keys)

    local i = 0

    -- return an iterator that returns the next keyvalue pair each time it's called
    return function ()
        i = i + 1
        if i <= #keys then
            return keys[i], list[keys[i]]
        else
            return nil, nil
        end
    end
end

------------------------------------ Helper Functs ------------------------------------

-- This compares two items, returns an int
-- Returns
--  -1 if entry1 < entry2
--   0 if entry1 == entry2
--   1 if entry1 > entry2
function Comparer(item1, item2)
    if item1 < item2 then
        return -1
    elseif item1 > item2 then
        return 1
    else
        return 0
    end
end

---------------------------------------- LINQ -----------------------------------------

-- local new_list = Select(list, function(o) return o.propname end)
function Select(list, selector)
    local retVal = {}

    for _, item in pairs(list) do
        local value = selector(item)
        table.insert(retVal, value)
    end

    return retVal
end

--public static IEnumerable<TResult> SelectMany<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, IEnumerable<TResult>> selector)
function SelectMany(list, selector)
    local retVal = {}

    for _, item in pairs(list) do
        local sub_list = selector(item)

        for _, sub_item in pairs(sub_list) do
            table.insert(retVal, sub_item)
        end
    end

    return retVal
end

-- local new_list = Where(list, function(o) return o.propname == "match" end)
function Where(list, predicate)
    local retVal = {}

    for _, item in pairs(list) do
        if predicate(item) then
            table.insert(retVal, item)
        end
    end

    return retVal
end
