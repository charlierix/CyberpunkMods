local this = {}

function PossiblySafetyFire(o, vars, const, debug, deltaTime)
    -- Only want to consider safety firing after grappling
    if not vars.isSafetyFireCandidate then
        do return end
    end

    -- If another mod is flying, then don't interfere
    if not o:Custom_CurrentlyFlying_IsOwnerOrNone() then
        do return end
    end

    local safetyFireHit = GetSafetyFireHitPoint(o, o.pos, o.vel, deltaTime)     -- even though redscript won't kill on impact, it still plays pain and stagger animations on hard landings

    if safetyFireHit then
        -- They're about to hit hard.  Teleport just above the ground, which sets velocity to zero
        Transition_ToStandard(vars, const, debug, o)
        vars.isSafetyFireCandidate = false

        SafetyFire(o, safetyFireHit)

    elseif not IsAirborne(o) then
        -- They're on the ground.  Stopping doing the safety fire check
        vars.isSafetyFireCandidate = false
    end
end

function GetSafetyFireHitPoint_STRAIGHTDOWN(o, pos, velZ, deltaTime)
    if velZ > -16 then
        return nil
    end

    local searchDist = math.abs(velZ * deltaTime * 4)

    -- Direct Center
    local hitPoint = o:RayCast(pos, GetPoint(pos, Vector4.new(0, 0, -1, 1), searchDist))
    if hitPoint then
        return hitPoint
    end

    -- Four Corners

    -- Landing on screens and slats is the worst case scenario.  The direction down needs to go
    -- at a slight angle to increase the chance of seeing them
    --
    -- So, normalizing the vector (.1, .1, 1) becomes
    -- len = 1.009950493836207795336338591707
    -- x,y = 0.09901475467
    -- z   = 0.99014754298

    local from = Vector4.new(pos.x - 0.02, pos.y - 0.02, pos.z, 1)
    hitPoint = o:RayCast(from, GetPoint(from, Vector4.new(-0.09901475467, -0.09901475467, -0.99014754298, 1), searchDist))
    if hitPoint then
        return hitPoint
    end

    from = Vector4.new(pos.x + 0.02, pos.y - 0.02, pos.z, 1)
    hitPoint = o:RayCast(from, GetPoint(from, Vector4.new(0.09901475467, -0.09901475467, -0.99014754298, 1), searchDist))
    if hitPoint then
        return hitPoint
    end

    from = Vector4.new(pos.x + 0.02, pos.y + 0.02, pos.z, 1)
    hitPoint = o:RayCast(from, GetPoint(from, Vector4.new(0.09901475467, 0.09901475467, -0.99014754298, 1), searchDist))
    if hitPoint then
        return hitPoint
    end

    from = Vector4.new(pos.x - 0.02, pos.y + 0.02, pos.z, 1)
    hitPoint = o:RayCast(from, GetPoint(from, Vector4.new(-0.09901475467, 0.09901475467, -0.99014754298, 1), searchDist))
    if hitPoint then
        return hitPoint
    end

    return nil
end

function GetSafetyFireHitPoint(o, pos, vel, deltaTime)
    if vel.z > -16 then
        return nil
    end

    --local searchDist = math.abs(velZ * deltaTime * 4)
    local speed = GetVectorLength(vel)
    local searchDist = speed * deltaTime * 4
    local velUnit = DivideVector(vel, speed)

    -- Direct Center
    local hitPoint = o:RayCast(pos, GetPoint(pos, velUnit, searchDist))
    if hitPoint then
        return hitPoint
    end

    -- Four Corners

    -- Landing on screens and slats is the worst case scenario.  The direction down needs to go
    -- at a slight angle to increase the chance of seeing them

    local from = Vector4.new(pos.x - 0.02, pos.y - 0.02, pos.z, 1)
    hitPoint = o:RayCast(from, GetPoint(from, velUnit, searchDist))
    if hitPoint then
        return hitPoint
    end

    from = Vector4.new(pos.x + 0.02, pos.y - 0.02, pos.z, 1)
    hitPoint = o:RayCast(from, GetPoint(from, velUnit, searchDist))
    if hitPoint then
        return hitPoint
    end

    from = Vector4.new(pos.x + 0.02, pos.y + 0.02, pos.z, 1)
    hitPoint = o:RayCast(from, GetPoint(from, velUnit, searchDist))
    if hitPoint then
        return hitPoint
    end

    from = Vector4.new(pos.x - 0.02, pos.y + 0.02, pos.z, 1)
    hitPoint = o:RayCast(from, GetPoint(from, velUnit, searchDist))
    if hitPoint then
        return hitPoint
    end

    return nil
end

function SafetyFire(o, groundPoint)
    -- Calling teleport sets velocity to zero, so this should eliminate death from fall damage
    -- Need to go slightly above where they are currently or they will still die - fine tuning
    -- these params was kind of fun and morbid :)
    o:Teleport(Vector4.new(o.pos.x, o.pos.y, groundPoint.z + 0.3, 1), o.yaw)
end

--NOTE: The way the game does it is precalculate what the speed would be at impact.  This avoids
--raycasts, but doesn't allow for anything but simple parabolic flight
-- protected final const func IsFallHeightAcceptable(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
--     let acceptableFallingSpeed: Float;
--     let verticalSpeed: Float;
--     acceptableFallingSpeed = this.GetFallingSpeedBasedOnHeight(scriptInterface, this.GetStaticFloatParameter("minFallHeight", 3.00));
--     verticalSpeed = this.GetVerticalSpeed(scriptInterface);
--     if verticalSpeed < acceptableFallingSpeed {
--       return true;
--     };
--     return false;
--   }

-- protected final const func GetFallingSpeedBasedOnHeight(scriptInterface: ref<StateGameScriptInterface>, height: Float) -> Float {
--     let speed: Float;
--     let acc: Float;
--     let locomotionParameters: ref<LocomotionParameters>;
--     if height < 0.00 {
--       return 0.00;
--     };
--     locomotionParameters = new LocomotionParameters();
--     this.GetStateDefaultLocomotionParameters(scriptInterface, locomotionParameters);
--     acc = AbsF(locomotionParameters.GetUpwardsGravity(this.GetStaticFloatParameter("defaultGravity", -16.00)));
--     speed = 0.00;
--     if acc != 0.00 {
--       speed = acc * SqrtF(2.00 * height / acc);
--     };
--     return speed * -1.00;
--   }