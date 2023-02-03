local this = {}

local Z_CONSIDER = -16
local Z_DMG_MIN = -18
local Z_DMG_MAX = -30
local Z_MENU = -200     -- I was doing something in the menu, came back and velocity was -297, but haven't been able to recreate.  Adding in this check just to be safe.  Jumping off the arasaka tower got up to -120 (falling from airplane heigts can get faster)

function PossiblySafetyFire(o, player, vars, const, debug, deltaTime)
    -- See if this mod is set up to do fall damage reduction
    if player.fall_damage == const.fall_damage.none then
        do return end
    end

    -- If another mod is flying, then don't interfere
    if not o:Custom_CurrentlyFlying_IsOwnerOrNone() then
        do return end
    end

    local safetyFireHit = this.GetSafetyFireHitPoint(o, o.pos, o.vel, deltaTime)

    if safetyFireHit then
        local vel_z = o.vel.z

        -- They're about to hit hard.  Teleport just above the ground, which sets velocity to zero
        Transition_ToStandard(vars, const, debug, o)        -- this shouldn't be needed, but won't hurt anything (this function is only called by standard in this mod)

        this.SafetyFire(o, safetyFireHit)

        -- Possibly damage the player
        if player.fall_damage == const.fall_damage.damage_safe then
            this.Damage_Safe(o, vel_z)

        elseif player.fall_damage == const.fall_damage.damage_lethal then
            this.Damage_Lethal(o, vel_z)
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetSafetyFireHitPoint_STRAIGHTDOWN(o, pos, velZ, deltaTime)
    if velZ > Z_CONSIDER then
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

function this.GetSafetyFireHitPoint(o, pos, vel, deltaTime)
    if vel.z > Z_CONSIDER then
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

function this.SafetyFire(o, groundPoint)
    -- Calling teleport sets velocity to zero, so this should eliminate death from fall damage
    -- Need to go slightly above where they are currently or they will still die - fine tuning
    -- these params was kind of fun and morbid :)
    o:Teleport(Vector4.new(o.pos.x, o.pos.y, groundPoint.z + 0.3, 1), o.yaw)
end

-- This will take the player down to as little as 5% health
function this.Damage_Safe(o, vel_z)
    if vel_z > Z_DMG_MIN or vel_z < Z_MENU then
        do return end
    end

    local health = o:GetPlayerHealth_Percent()      -- health is a whole number between 0 and 100
    local health_gap = health - 5
    if health_gap <= 0 then
        do return end
    end

    local remove
    if vel_z < Z_DMG_MAX then
        remove = 1
    else
        remove = GetScaledValue(0, 1, Z_DMG_MIN, Z_DMG_MAX, vel_z)
    end

    remove = remove * health_gap        -- health gap is health above 5%.  So a 100% removal would take the final health down to 5%.  50% removal takes health 50% toward 5% (so if health is 60% with a 50% removal, final health will be 32.5%)

    o:SetPlayerHealth_Percent(-remove, true)
    this.PlayPainSound(o)
end
-- This will remove up to 95% of the player's health, so they will die if their starting health is too low
function this.Damage_Lethal(o, vel_z)
    if vel_z > Z_DMG_MIN or vel_z < Z_MENU then
        do return end
    end

    local remove
    if vel_z < Z_DMG_MAX then
        remove = 95
    else
        remove = GetScaledValue(0, 95, Z_DMG_MIN, Z_DMG_MAX, vel_z)
    end

    o:SetPlayerHealth_Percent(-remove, true)
    this.PlayPainSound(o)
end

function this.PlayPainSound(o)
    --TODO: play a sound, maybe based on damage taken
end

function this.NOTES()
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
end