local this = {}

function PopulateDebug(debug, o, keys)
    debug.proceed = keys.proceed
    debug.crouching = o:IsCrouching()

    local vel = o:Custom_CurrentlyFlying_GetVelocity(o.vel)
    debug.vel = vec_str(vel)
    debug.vel_speed = tostring(Round(GetVectorLength(vel), 1))

    debug.pos = vec_str(o.pos)
end