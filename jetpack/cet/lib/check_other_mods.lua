-- These are functions that look at an added property (PlayerPuppet.Custom_CurrentlyFlying), to see if
-- another mod is flying

-- Should jetpack start flight?
function CheckOtherModsFor_FlightStart(currentlyFlying, modNames)
    if (not currentlyFlying) or (currentlyFlying == "") then
        -- No other mod is flying
        return true
    elseif currentlyFlying == modNames.grappling_hook then
        -- It's ok to override grapple
        return true
    else
        -- Something like low flying v also holds in space for up.  Or it's an unknown mod, don't interfere
        return false
    end
end

-- Should jetpack do a safety fire?
function CheckOtherModsFor_SafetyFire(currentlyFlying, modNames)
    if (not currentlyFlying) or (currentlyFlying == "") or (currentlyFlying == modNames.jetpack) then
        -- Nothing is flying, or jetpack owns it
        return true
    else
        -- Some other mod is flying, don't interfere
        return false
    end
end

-- Should jetpack continue flying?
function CheckOtherModsFor_ContinueFlight(o, modNames)
    -- This function is called when in flight.  So if the property is empty string, something went wrong.
    -- Assume that another mod attempted flight and this mod should stop
    if o:Custom_CurrentlyFlying_get() == modNames.jetpack then
        return true
    else
        return false
    end
end