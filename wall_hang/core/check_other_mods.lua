-- These are functions that look at an added property (PlayerPuppet.Custom_CurrentlyFlying), to see if
-- another mod is flying

-- Should wallhang start hanging/jumping?
function CheckOtherModsFor_FlightStart(o, modNames)
    local currentlyFlying = o:Custom_CurrentlyFlying_get()

    if (not currentlyFlying) or (currentlyFlying == "") then
        -- No other mod is flying
        return true

    elseif In(currentlyFlying, modNames.grappling_hook, modNames.jetpack, modNames.low_flying_v) then
        -- It's ok to override these
        return true

    else
        -- Something unknown is running, don't interfere
        return false
    end
end

-- Should wallhang continue hanging/jumping?
function CheckOtherModsFor_ContinueFlight(o, modNames)
    -- This function is called when in flight.  So if the property is empty string, something went wrong.
    -- Assume that another mod attempted flight and this mod should stop
    if o:Custom_CurrentlyFlying_get() == modNames.wall_hang then
        return true
    else
        return false
    end
end