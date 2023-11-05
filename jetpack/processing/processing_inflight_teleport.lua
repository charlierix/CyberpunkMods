local this = {}

function Process_InFlight_Teleport(o, vars, const, player, keys, debug, deltaTime)
    if not player.mode then
        ExitFlight(vars, debug, o, player)      -- should never get here, unless they pulled up cet and deleted modes mid flight
        do return end
    end

    debug.time_flying_idle = o.timer - vars.lastThrustTime

    if ShouldReboundJump_InFlight(o, vars, player.mode) then
        this.Rebound(o, vars, player.mode)
    end

    if ShouldExitFlight(o, vars, player.mode, deltaTime) then
        this.ExitFlight(o, vars, player, debug)
        do return end
    end

    this.Accelerate(o, vars, const, player.mode, keys, debug, deltaTime)
end

----------------------------------- Private Methods -----------------------------------

function this.Rebound(o, vars, mode)
    vars.last_rebound_time = o.timer
    vars.vel.z = GetReboundImpulse(mode, vars.vel)

    o:PlaySound("lcm_player_double_jump", vars)
end

function this.ExitFlight(o, vars, player, debug)
    if player.mode.jump_land.explosiveLanding and not IsAirborne(o) then
        ExplosivelyLand(o, vars.vel, vars)
    end

    ExitFlight(vars, debug, o, player)
end

function this.Accelerate(o, vars, const, mode, keys, debug, deltaTime)
    -- Convert key presses into acceleration, energy burn
    local accelX, accelY, accelZ, requestedEnergy = GetAccel_Keys(vars, mode, o, debug, deltaTime)

    -- Extra (holding altitude, accel in look dir, slam down...)
    local extraX, extraY, extraZ, extraEnergy = this.Accelerate_Extra(o, vars.vel, keys, vars, mode.extra_rmb, mode.extra_key1, mode.extra_key2)
    accelX = accelX + extraX
    accelY = accelY + extraY
    accelZ = accelZ + extraZ
    requestedEnergy = requestedEnergy + extraEnergy

    local deltaYaw = keys.mouse_x * -0.08

    -- Calculate actual burn
    requestedEnergy = requestedEnergy * deltaTime

    if not IsNearZero(requestedEnergy) and (requestedEnergy < vars.remainBurnTime) then
        vars.lastThrustTime = o.timer
        vars.remainBurnTime = UseBurnTime(vars.remainBurnTime, requestedEnergy, vars.startThrustTime, o.timer)
    else
        accelX = 0
        accelY = 0
        accelZ = mode.accel.gravity

        vars.remainBurnTime = RecoverBurnTime(vars.remainBurnTime, mode.energy.maxBurnTime, mode.energy.recoveryRate, deltaTime)
    end

    -- Drag near max velocity
    local dragX, dragY, dragZ = ClampVelocity_Drag(vars.vel, const.maxSpeed)
    accelX = accelX + dragX
    accelY = accelY + dragY
    accelZ = accelZ + dragZ

    if const.shouldShowDebugWindow then
        PopulateFlightDebug(vars, debug, accelX, accelY, accelZ)
    end

    accelX = accelX * deltaTime
    accelY = accelY * deltaTime
    accelZ = accelZ * deltaTime

    -- Apply accelerations to the current velocity
    vars.vel.x = vars.vel.x + accelX
    vars.vel.y = vars.vel.y + accelY
    vars.vel.z = vars.vel.z + accelZ

    vars.vel = ClampVelocity(vars.vel, const.maxSpeed)      -- the game gets unstable and crashes at high speed.  Probably trying to load scenes too fast, probably machine dependent

    RotateVelocityToLookDir(o, mode, vars, deltaTime, debug)

    -- Try to move in the desired velocity (raycast first)
    local newPos = Vector4.new(o.pos.x + (vars.vel.x * deltaTime), o.pos.y + (vars.vel.y * deltaTime), o.pos.z + (vars.vel.z * deltaTime), 1)

    local isSafe, hit_normal = IsTeleportPointSafe(o.pos, newPos, vars.vel, deltaTime, o)

    if isSafe then
        Process_InFlight_NewPos(o, newPos, deltaYaw)
    else
        Process_InFlight_HitWall(vars.vel, hit_normal, o, vars)
    end

    AdjustTimeSpeed(o, vars, mode, vars.vel)
end
function this.Accelerate_Extra(o, vel, keys, vars, ...)
    local accelX = 0
    local accelY = 0
    local accelZ = 0
    local requestedEnergy = 0

    for i = 1, select("#", ...) do
        local extra = select(i, ...)

        if extra then
            local extraX, extraY, extraZ, extraEnergy = extra:Tick(o, vel, keys, vars)
            accelX = accelX + extraX
            accelY = accelY + extraY
            accelZ = accelZ + extraZ
            requestedEnergy = requestedEnergy + extraEnergy
        end
    end

    return accelX, accelY, accelZ, requestedEnergy
end