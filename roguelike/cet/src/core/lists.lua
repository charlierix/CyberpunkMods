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