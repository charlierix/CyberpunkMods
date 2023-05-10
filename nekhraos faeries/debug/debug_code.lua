local this = {}

function PopulateDebug(debug, o, keys)
    debug.proceed = keys.proceed
    debug.crouching = o:IsCrouching()
end