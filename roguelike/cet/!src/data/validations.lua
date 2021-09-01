function ValidateTags(tags)
    if not tags then
        -- Tags are optional, so it's ok if they are nil
        return true, nil
    end

    if type(tags) ~= "table" then
        return false, "tags must be a list: " .. type(tags)
    end

    for i = 1, #tags do       --NOTE: It's possible that this is a key/value list, but it will never be used that way, so it will only eat up memory
        if type(tags[i]) ~= "string" then
            return false, "all tags must be strings: " .. type(tags[i])
        end
    end

    return true, nil
end

function ValidateType_prop(object, itemname, typename)
    return ValidateType_var(object[itemname], itemname, typename)
end
function ValidateType_var(item, itemname, typename)
    if item == nil then
        return false, itemname .. " is nil"

    elseif type(item) ~= typename then
        return false, itemname .. " isn't a " .. typename .. ": " .. type(item)

    else
        return true, nil
    end
end