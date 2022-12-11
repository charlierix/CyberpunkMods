local this = {}

-- This is a wrapper to the actual ValueUpdates.getDecrementIncrement functions.  Needed to use a string for
-- the function name so the updown can be cleanly serialized/deserialized
function CallReferenced_DecrementIncrement(key, currentValue)
    return this[key](currentValue)
end

------------------------- Custom DecrementIncrement Functions -------------------------

-- Elsewhere (in grappling hook), this is referenced like this:
-- antigrav_percent_update =
-- {
--     min = antigrav_percents[1],
--     max = antigrav_percents[#antigrav_percents],
--     getDecrementIncrement = "AntiGrav_Percent_IncDec",
-- },


--NOTE: This needs to be global so defaults.lua can reference min/max
-- antigrav_percents = { 0.15, 0.3, 0.4, 0.5, 0.6, 0.65, 0.7, 0.75, 0.8, 0.825, 0.85, 0.875, 0.9, 0.925, 0.95 }

-- function this.AntiGrav_Percent_IncDec(current)
--     local index = this.GetAntiGravPercentIndex(current)
--     if not index then
--         return nil, nil
--     end

--     --NOTE: These calculations subtract using current and not antigrav_percents[index].  This is to try to counteract math drift

--     local dec = nil
--     if index > 1 then
--         dec = current - antigrav_percents[index - 1]        -- the value needs to be positive
--     end

--     local inc = nil
--     if index < #antigrav_percents then
--         inc = antigrav_percents[index + 1] - current
--     end

--     return dec, inc
-- end
-- function this.GetAntiGravPercentIndex(current)
--     for i = 1, #antigrav_percents do
--         if IsNearValue_custom(antigrav_percents[i], current, 0.015) then     -- no need to be too strict
--             return i
--         end
--     end

--     return nil
-- end