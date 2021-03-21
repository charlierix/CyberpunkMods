-- There isn't much in this file, but it keeps the hardcodings in one place

-- This either creates or moves the pin (it assumes that if the pin already exists, it's already
-- the proper name)
function EnsureMapPinVisible(pos, name, state, o)
    if state.mappinID then
        -- It already exists, just move it
        o:MovePin(state.mappinID, pos)
    else
        -- It's nil, create it
        state.mappinID = o:CreatePin(pos, name)
    end
end

function EnsureMapPinRemoved(state, o)
    if state.mappinID then
        o:RemovePin(state.mappinID)
        state.mappinID = nil
    end
end