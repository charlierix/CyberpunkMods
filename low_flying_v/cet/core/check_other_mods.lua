-- These are functions that look at an added property (PlayerPuppet.Custom_CurrentlyFlying), to see if
-- another mod is flying

-- Should start flight?
function CheckOtherModsFor_FlightStart(o, modNames)
    local currentlyFlying = o:Custom_CurrentlyFlying_get()

    --NOTE: Jetpack and Grappling Hook have an elseif desciding which mods are ok to override
    --LowFlyingV should only start from a kerenzikov dash, so not allowing it to start when
    --already flying

    if (not currentlyFlying) or (currentlyFlying == "") then
        -- No other mod is flying
        return true
    else
        -- Something unknown is running, don't interfere
        return false
    end
end

-- Should continue flying?
function CheckOtherModsFor_ContinueFlight(o, modNames)
    -- This function is called when in flight.  So if the property is empty string, something went wrong.
    -- Assume that another mod attempted flight and this mod should stop
    if o:Custom_CurrentlyFlying_get() == modNames.low_flying_v then
        return true
    else
        return false
    end
end