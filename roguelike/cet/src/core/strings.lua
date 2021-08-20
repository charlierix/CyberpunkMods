-- This builds a string out of the array (doesn't sort)
function String_Join(separator, list)
    if not list then
        return ""
    end

    local retVal = ""

    for i = 1, #list do
        retVal = retVal .. list[i]

        if i < #list then
            retVal = retVal .. separator
        end
    end

    return retVal
end

-- This returns a string that is no longer than the desired length
function String_Cap(text, length, nil_to_emptyString)
    if text == nil then
        if nil_to_emptyString then
            return ""
        else
            return nil
        end
    end

    if string.len(text) < length then
        return text
    end

    return string.sub(text, 1, length)
end