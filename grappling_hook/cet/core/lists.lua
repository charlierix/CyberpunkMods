---------------------------------- Key/Value Arrays -----------------------------------


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