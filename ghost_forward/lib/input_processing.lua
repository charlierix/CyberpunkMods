function ResetKeys(keys)
    for key, value in pairs(keys) do
        if type(value) == "boolean" then
            keys[key] = false
        end
    end
end
