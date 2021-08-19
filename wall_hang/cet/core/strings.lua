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