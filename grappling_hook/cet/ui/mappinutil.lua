-- There isn't much in this file, but it keeps the hardcodings in one place

-- This either creates or moves the pin.  Also makes sure the pin is showing the desired icon
function EnsureMapPinVisible(pos, name, vars, o)
    -- See if the icon changed
    if vars.mappinID and vars.mappinName ~= name then
        EnsureMapPinRemoved(vars, o)        --o:ChangePinIcon(vars.mappinID, name) doesn't work reliablly
    end

    if vars.mappinID then
        -- It already exists, just move it
        o:MovePin(vars.mappinID, pos)
    else
        -- It's nil, create it
        vars.mappinID = o:CreatePin(pos, name)
        vars.mappinName = name
    end
end

function EnsureMapPinRemoved(vars, o)
    if vars.mappinID then
        o:RemovePin(vars.mappinID)
        vars.mappinID = nil
        vars.mappinName = nil
    end
end