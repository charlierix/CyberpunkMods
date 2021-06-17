-- These are functions that look at an added property (PlayerPuppet.Custom_CurrentlyFlying), to see if
-- another mod is flying

-- Should grapple start flight?
function CheckOtherModsFor_FlightStart(o, modNames)
    local currentlyFlying = o:Custom_CurrentlyFlying_get()

    if (not currentlyFlying) or (currentlyFlying == "") then
        -- No other mod is flying
        return true
    elseif (currentlyFlying == modNames.grappling_hook) or (currentlyFlying == modNames.jetpack) or (currentlyFlying == modNames.low_flying_v) then
        -- It's ok to override these
        --NOTE: Included grappling_hook so they can fire a new grapple mid swing
        return true
    else
        -- Something unknown is running, don't interfere
        return false
    end
end

-- Should grapple do a safety fire?
function CheckOtherModsFor_SafetyFire(o, modNames)
    local currentlyFlying = o:Custom_CurrentlyFlying_get()

    if (not currentlyFlying) or (currentlyFlying == "") or (currentlyFlying == modNames.grappling_hook) then
        -- Nothing else is flying
        return true
    else
        -- Some other mod is flying, don't interfere
        return false
    end
end

-- Should grapple continue flying?
function CheckOtherModsFor_ContinueFlight(o, modNames)
    -- This function is called when in flight.  So if the property is empty string, something went wrong.
    -- Assume that another mod attempted flight and this mod should stop
    if o:Custom_CurrentlyFlying_get() == modNames.grappling_hook then
        return true
    else
        return false
    end
end