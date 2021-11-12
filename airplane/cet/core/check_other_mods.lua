-- These are functions that look at an added property (PlayerPuppet.Custom_CurrentlyFlying), to see if
-- another mod is flying

-- Should airplane start flying?
function CheckOtherModsFor_FlightStart(o, modNames)
    -- Since airplane is activated by a hotkey, it should override any existing flight
    return true

    -- local currentlyFlying = o:Custom_CurrentlyFlying_get()

    -- if (not currentlyFlying) or (currentlyFlying == "") then
    --     -- No other mod is flying
    --     return true

    -- else
    --     -- Something unknown is running, don't interfere
    --     return false
    -- end
end

-- Should airplane continue flying?
function CheckOtherModsFor_ContinueFlight(o, modNames)
    -- This function is called when in flight.  So if the property is empty string, something went wrong.
    -- Assume that another mod attempted flight and this mod should stop
    if o:Custom_CurrentlyFlying_get() == modNames.airplane then
        return true
    else
        return false
    end
end