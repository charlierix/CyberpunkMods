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
    -- This function is called when in flight
    -- NOTE: The other mods stop if it's empty string, but since low flying v currently doesn't ship
    -- with redscript, it will be empty string unless they have one of my other mods

    local current = o:Custom_CurrentlyFlying_get()

    if current == "" or current == modNames.low_flying_v then
        return true
    else
        return false
    end
end