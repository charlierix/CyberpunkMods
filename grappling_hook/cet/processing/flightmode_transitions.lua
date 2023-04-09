local this = {}

-- This can come from any state back to standard (the other mods called this ExitFlight)
function Transition_ToStandard(vars, const, debug, o)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if vars.flightMode == const.flightModes.standard then
        do return end
    end

    this.TransferVelocity_Teleport_Standard(vars, o)

    vars.flightMode = const.flightModes.standard
    o:Custom_CurrentlyFlying_Clear()

    vars.grapple = nil
    vars.airdash = nil
    vars.airanchor = nil

    vars.startStopTracker:ResetKeyDowns()

    vars.swingprops_override:Clear()

    EnsureMapPinRemoved(vars, o)
    grapple_render.Clear()
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

    local vel
    if vars.vel then
        vel = vars.vel
    else
        vel = o.vel
    end

    local started, final_vel = o:Custom_CurrentlyFlying_TryStartFlight(true, vel)
    if not started then
        return false
    end

    -- Custom_CurrentlyFlying_TryStartFlight is applying an impulse, but web swing is switching to vars.vel before the impulse
    -- has time to take affect, so o.vel is still zero (that's my theory at least)
    --
    -- Explicitly setting this will guarantee the other mod's velocity is remembered.  If it's a straight grapple that uses
    -- impulse based flight, this.TransferVelocity_Teleport_Standard will apply an impulse
    vars.vel = final_vel

    vars.flightMode = const.flightModes.aim

    vars.grapple = grapple

    -- Don't want this misreporting.  Force the user to let go of the keys before this sees any new
    -- action attempt
    --
    -- Swing has a boost if they keep held down, so tell the tracker to remember the keys that triggered
    -- this aim
    vars.startStopTracker:ResetKeyDowns(true)

    vars.startTime = o.timer

    grapple_render.Clear()

    return true
end

-- This happens when they aimed too long without a hit, moving into airdash flight
function Transition_ToAirDash(airdash, vars, const, o, rayFrom, lookDist)
    vars.flightMode = const.flightModes.airdash

    this.TransferVelocity_Teleport_Standard(vars, o)

    vars.airdash = airdash

    vars.startTime = o.timer

    vars.rayFrom = rayFrom
    vars.rayLength = lookDist

    vars.hasBeenAirborne = false
    vars.initialAirborneTime = nil


    --TODO: Play a sound


end

-- This goes from aim into flight (or airdash to flight)
-- There's no need to check for energy, that was done when trying to aim
-- NOTE: airanchor should only be passed in when flight is using it (a solid wall hit doesn't use air anchor)
function Transition_ToFlight_Straight(vars, const, o, rayFrom, rayHit, airanchor, stopplane_point, stopplane_normal)
    vars.flightMode = const.flightModes.flight_straight

    this.TransferVelocity_Teleport_Standard(vars, o)

    -- vars.grapple is already populated by aim

    --TODO: When webswing and zipline get implemented, need a way to tell them apart from straightline
    this.PlaySound_Grapple(vars, o)

    vars.startTime = o.timer

    vars.rayFrom = rayFrom
    vars.rayHit = rayHit
    vars.distToHit = math.sqrt(GetVectorDiffLengthSqr(rayHit, rayFrom))

    vars.airanchor = airanchor

    vars.stop_planes:Clear()
    this.AddStopPlane(vars.stop_planes, stopplane_point, stopplane_normal)

    vars.stopplane_point = stopplane_point
    vars.stopplane_normal = stopplane_normal

    vars.hasBeenAirborne = false
    vars.initialAirborneTime = nil
end

-- This goes from aim into flight
-- There's no need to check for energy, that was done when trying to aim
function Transition_ToFlight_Swing(grapple, vars, const, o, rayFrom, rayHit, airanchor, popping_up, stopplane_point1, stopplane_normal1, stopplane_point2, stopplane_normal2, stopplane_point3, stopplane_normal3)
    vars.flightMode = const.flightModes.flight_swing

    this.TransferVelocity_Standard_Teleport(vars, o)

    vars.grapple = grapple      -- this was populated in Transition_ToAim, but aim swing redefines it based on the situation

    --TODO: When webswing and zipline get implemented, need a way to tell them apart from straightline
    this.PlaySound_Grapple(vars, o)

    vars.startTime = o.timer

    vars.rayFrom = rayFrom
    vars.rayHit = rayHit
    vars.distToHit = math.sqrt(GetVectorDiffLengthSqr(rayHit, rayFrom))

    vars.airanchor = airanchor

    vars.popping_up = popping_up

    vars.stop_planes:Clear()
    this.AddStopPlane(vars.stop_planes, stopplane_point1, stopplane_normal1)
    this.AddStopPlane(vars.stop_planes, stopplane_point2, stopplane_normal2)
    this.AddStopPlane(vars.stop_planes, stopplane_point3, stopplane_normal3)

    vars.hasBeenAirborne = false
    vars.initialAirborneTime = nil

    vars.swing_freefall_starttime = nil
end

-- This gets called when they exit flight by looking too far away while still airborne
function Transition_ToAntiGrav(vars, const, o)
    vars.flightMode = const.flightModes.antigrav

    vars.startTime = o.timer

    grapple_render.Clear()
end

-- When swing is done, it goes into freefall mode until they collide with the ground or a wall (or kick off another grapple)
function Transition_ToFreeFall(vars, const, o)
    vars.flightMode = const.flightModes.freefall

    vars.startTime = o.timer

    --vars.vel is already populated, so there's nothing more to set up

    grapple_render.Clear()
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

function this.AddStopPlane(list, point, normal)
    if point and normal then
        local plane = list:GetNewItem()
        plane.point = point
        plane.normal = normal
    end
end

function this.TransferVelocity_Teleport_Standard(vars, o)
    if vars.vel then
        -- transistion from teleport based flight to standard (o.vel should be zero when vars.vel is set)
        o:AddImpulse(vars.vel.x - o.vel.x, vars.vel.y - o.vel.y, vars.vel.z - o.vel.z)
        vars.vel = nil
    end
end
function this.TransferVelocity_Standard_Teleport(vars, o)
    if not vars.vel then
        vars.vel = Vector4.new(o.vel.x, o.vel.y, o.vel.z, 1)
    end
end