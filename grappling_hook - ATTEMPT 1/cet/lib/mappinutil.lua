-- There isn't much in this file, but it keeps the hardcodings in one place

-- This either creates or moves the pin.  Also makes sure the pin is showing the desired icon
function EnsureMapPinVisible(pos, name, state, o)
    if state.mappinID then
        -- It already exists, just move it
        o:MovePin(state.mappinID, pos)

        -- See if the icon changed
        if state.mappinName ~= name then
            o:ChangePinIcon(state.mappinID, name)
        end
    else
        -- It's nil, create it
        state.mappinID = o:CreatePin(pos, name)
        state.mappinName = name
    end
end

function EnsureMapPinRemoved(state, o)
    if state.mappinID then
        o:RemovePin(state.mappinID)
        state.mappinID = nil
        state.mappinName = nil
    end
end