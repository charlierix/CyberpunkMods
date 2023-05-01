local this = {}

-- This is a wrapper to the actual ValueUpdates.getDecrementIncrement functions.  Needed to use a string for
-- the function name so the updown can be cleanly serialized/deserialized
function CallReferenced_DecrementIncrement(key, currentValue)
    return this[key](currentValue)
end

------------------------- Custom DecrementIncrement Functions -------------------------

--NOTE: These need to be global so defaults.lua can reference min/max
antigrav_percents = { 0.15, 0.3, 0.4, 0.5, 0.6, 0.65, 0.7, 0.75, 0.8, 0.825, 0.85, 0.875, 0.9, 0.925, 0.95 }
boost_accels = { 2, 4, 6, 8, 10, 12, 15, 18, 21, 24, 28, 32, 36 }

function this.AntiGrav_Percent_IncDec(current)
    return this.Get_IncDec(current, antigrav_percents, 0.015)
end

function this.BoostAccel_IncDec(current)
    return this.Get_IncDec(current, boost_accels, 0.2)
end

function this.Get_IncDec(current, list, epsilon)
    local index = this.GetIndexIntoList(current, list, epsilon)
    if not index then
        return nil, nil
    end

    --NOTE: These calculations subtract using current and not list[index].  This is to try to counteract math drift

    local dec = nil
    if index > 1 then
        dec = current - list[index - 1]        -- the value needs to be positive
    end

    local inc = nil
    if index < #list then
        inc = list[index + 1] - current
    end

    return dec, inc
end
function this.GetIndexIntoList(current, list, epsilon)
    for i = 1, #list do
        if IsNearValue_custom(list[i], current, epsilon) then     -- no need to be too strict
            return i
        end
    end

    return nil
end
