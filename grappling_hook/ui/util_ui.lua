-- This is used when an optional component is bought/sold.  The buy/sell price needs to be stored in
-- changes independently of the regular changes.experience
--
-- They may have upgraded/downgraded the component, but the buy/sell price is the initial cost when
-- the window was first shown
function PopulateBuySell(hasNow, startedWith, changes, key, initialCost)
    if hasNow then
        if startedWith then
            changes[key] = 0        -- started with it, unchecked at some point, now they're putting it back.  There is no extra cost
        else
            changes[key] = -initialCost     -- started without, so this is the purchase cost
        end
    else
        if startedWith then
            changes[key] = initialCost      -- started with it, now selling it, so gain the experience
        else
            changes[key] = 0        -- started without, purchased, now removing again
        end
    end
end