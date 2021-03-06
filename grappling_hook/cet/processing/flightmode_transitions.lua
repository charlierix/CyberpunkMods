local this = {}

-- This can come from any state back to standard (the other mods called this ExitFlight)
function Transition_ToStandard(vars, const, debug, o)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if vars.flightMode == const.flightModes.standard then
        do return end
    end

    vars.flightMode = const.flightModes.standard
    o:Custom_CurrentlyFlying_Clear()

    vars.grapple = nil
    vars.airdash = nil

    vars.startStopTracker:ResetKeyDowns()

    EnsureMapPinRemoved(vars, o)
end

-- This can come from any state into aiming
-- Returns false if there's not enough energy
function Transition_ToAim(grapple, vars, const, o, shouldConsumeEnergy)
    if shouldConsumeEnergy then
        if vars.energy < grapple.energy_cost then
            -- Notify the player that energy is too low
            vars.animation_lowEnergy:ActivateAnimation()
            return false
        else
            vars.energy = vars.energy - grapple.energy_cost
        end
    end

    vars.flightMode = const.flightModes.aim
    o:Custom_CurrentlyFlying_StartFlight()

    vars.grapple = grapple

    -- Don't want this misreporting.  Force the user to let go of the keys before this sees any new
    -- action attempt
    vars.startStopTracker:ResetKeyDowns()

    vars.startTime = o.timer

    return true
end

-- This goes from aim into flight (or airdash to flight)
-- There's no need to check for energy, that was done when trying to aim
function Transition_ToFlight(vars, const, o, rayFrom, rayHit)
    vars.flightMode = const.flightModes.flight
    o:Custom_CurrentlyFlying_StartFlight()

    -- vars.grapple is already populated by aim

    --TODO: When webswing and zipline get implemented, need a way to tell them apart from straightline
    this.PlaySound_Grapple(vars, o)

    vars.startTime = o.timer

    vars.rayFrom = rayFrom
    vars.rayHit = rayHit
    vars.distToHit = math.sqrt(GetVectorDiffLengthSqr(rayHit, rayFrom))

    vars.hasBeenAirborne = false
    vars.initialAirborneTime = nil
end

-- This gets called when they exit flight by looking too far away while still airborne
function Transition_ToAntiGrav(vars, const, o)
    vars.flightMode = const.flightModes.antigrav
    o:Custom_CurrentlyFlying_StartFlight()      -- it's already the correct value, just being complete

    vars.startTime = o.timer
end

-- This happens when they aimed too long without a hit, moving into airdash flight
function Transition_ToAirDash(airdash, vars, const, o, rayFrom, lookDist)
    vars.flightMode = const.flightModes.airdash
    o:Custom_CurrentlyFlying_StartFlight()

    vars.airdash = airdash

    vars.startTime = o.timer

    vars.rayFrom = rayFrom
    vars.rayLength = lookDist

    vars.hasBeenAirborne = false
    vars.initialAirborneTime = nil


    --TODO: Play a sound


end

----------------------------------- Private Methods -----------------------------------

this.sounds_grapple =
{
    "w_cyb_monowire_whip_grapple",		-- that's just kind of obvious :)
    "q003_sc_08_whip_whoosh",
    "w_cyb_whip_wire_throw",
}

function this.PlaySound_Grapple(vars, o)
    local sound = this.GetRandomSound(this.sounds_grapple)
    o:PlaySound(sound, vars)
end

function this.GetRandomSound(list)
    return list[math.random(#list)]
end