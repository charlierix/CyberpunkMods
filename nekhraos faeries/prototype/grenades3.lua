local PrototypeGrenades3 = {}

local this = {}

function PrototypeGrenades3.ThrowFromSlot(o)

    print("ThrowFromSlot a")

    local player = Game.GetPlayer()
    local transaction = Game.GetTransactionSystem()

    local pos, look_dir = o:GetCrosshairInfo()

    local from = AddVectors(pos, MultiplyVector(look_dir, 4))
    local to = AddVectors(pos, MultiplyVector(look_dir, 6))

    local orientation = GetRandomRotation()

    print("ThrowFromSlot b")

    local item_object, item_data = this.GetGrenadeEntity(player, transaction)

    if not item_object then
        print("item nil")
        do return end
    end

    if not this.Player_Entity_Validations(player, item_object) then
        do return end
    end

    print("ThrowFromSlot c")

    local launchEvent = this.GetLaunchEvent_Default(player, item_object)

    print("ThrowFromSlot d")

    -- Doesn't work.  Try parabola
    --launchEvent.trajectoryParams = this.GetTrajectoryParams_Linear()
    launchEvent.trajectoryParams = this.GetTrajectoryParams_Parabolic(-1, to, 20)

    print("ThrowFromSlot e")

    item_object:QueueEvent(launchEvent)

    print("ThrowFromSlot f")

end

function PrototypeGrenades3.DropFromSlot(o)
    print("DropFromSlot a")

    local player = Game.GetPlayer()
    local transaction = Game.GetTransactionSystem()

    local pos, look_dir = o:GetCrosshairInfo()

    local from = AddVectors(pos, MultiplyVector(look_dir, 4))
    local to = AddVectors(pos, MultiplyVector(look_dir, 6))

    local orientation = GetRandomRotation()

    print("DropFromSlot b")

    local item_object, item_data = this.GetGrenadeEntity(player, transaction)

    if not item_object then
        print("item nil")
        do return end
    end

    if not this.Player_Entity_Validations(player, item_object) then
        do return end
    end

    print("DropFromSlot c")

    local launchEvent = this.GetLaunchEvent_Drop(player, item_object)

    print("DropFromSlot d")

    item_object:QueueEvent(launchEvent)

    print("DropFromSlot e")
end

----------------------------------- Private Methods -----------------------------------

function this.GetGrenadeEntity(player, transaction)
    local item_object = transaction:GetItemInSlot(player, TweakDBID.new("AttachmentSlots.WeaponRight"))        -- only returns something if weapon isn't holstered

    if not item_object then
        return nil, nil

    elseif not IsDefined(item_object) then
        return nil
    end

    local item_data = item_object:GetItemData()

    --TODO: handle other types of projectiles
    if item_data:GetItemType().value == "Gad_Grenade" then
        return nil, nil
    end

    if item_object:IsClientSideOnlyGadget() then
        print("ClientSideOnlyGadget")
        return nil, nil
    end

    return item_object, item_data
end

function this.GetLaunchEvent_Default(player, item_object)
    -- set up event
    local launchEvent = gameprojectileSetUpAndLaunchEvent.new()
    launchEvent.owner = player

    launchEvent.launchParams.launchMode = gameprojectileELaunchMode.FromLogic       -- Default, FromLogic, FromVisuals

    -- launchEvent.launchParams.logicalPositionProvider = entIPositionProvider.CreateStaticPositionProvider(ToWorldPosition(from))
    -- launchEvent.launchParams.logicalOrientationProvider = entIOrientationProvider.CreateStaticOrientationProvider(orientation)

    launchEvent.launchParams.logicalPositionProvider = entIPositionProvider.CreateEntityPositionProvider(item_object)
    launchEvent.launchParams.logicalOrientationProvider = entIOrientationProvider.CreateEntityOrientationProvider(nil, "", item_object)

    launchEvent.launchParams.visualPositionProvider = entIPositionProvider.CreateEntityPositionProvider(item_object)
    launchEvent.launchParams.visualOrientationProvider = entIOrientationProvider.CreateEntityOrientationProvider(nil, "", item_object)

    launchEvent.projectileParams.shootingOffset = 2

    -- I think this is to get the initial velocity.  There doesn't seem to be any static providers like above
    -- This takes gamePuppet.  These are the only classes that seem available
    --  NPCPuppet extends ScriptedPuppet
    --  PlayerPuppet extends ScriptedPuppet
    --      ScriptedPuppet extends gamePuppet
    --          gamePuppet
    --
    -- entIVelocityProvider implements IScriptable, has one function: CalculateVelocity()
    --  CalculateVelocity has no in/out params, IScriptable doesn't have a velocity property
    launchEvent.launchParams.ownerVelocityProvider = MoveComponentVelocityProvider.CreateMoveComponentVelocityProvider(player)

    launchEvent.lerpMultiplier = 15.00

    return launchEvent
end
function this.GetLaunchEvent_Default_NOPREFIX(player, item_object)
    -- set up event
    local launchEvent = gameprojectileSetUpAndLaunchEvent.new()
    launchEvent.owner = player

    launchEvent.launchParams.launchMode = gameprojectileELaunchMode.FromLogic

    -- launchEvent.launchParams.logicalPositionProvider = entIPositionProvider.CreateStaticPositionProvider(ToWorldPosition(from))
    -- launchEvent.launchParams.logicalOrientationProvider = entIOrientationProvider.CreateStaticOrientationProvider(orientation)

    launchEvent.launchParams.logicalPositionProvider = IPositionProvider.CreateEntityPositionProvider(item_object)
    launchEvent.launchParams.logicalOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(nil, "", item_object)

    launchEvent.launchParams.visualPositionProvider = IPositionProvider.CreateEntityPositionProvider(item_object)
    launchEvent.launchParams.visualOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(nil, "", item_object)

    launchEvent.projectileParams.shootingOffset = 2

    -- I think this is to get the initial velocity.  There doesn't seem to be any static providers like above
    -- This takes gamePuppet.  These are the only classes that seem available
    --  NPCPuppet extends ScriptedPuppet
    --  PlayerPuppet extends ScriptedPuppet
    --      ScriptedPuppet extends gamePuppet
    --          gamePuppet
    --
    -- entIVelocityProvider implements IScriptable, has one function: CalculateVelocity()
    --  CalculateVelocity has no in/out params, IScriptable doesn't have a velocity property
    launchEvent.launchParams.ownerVelocityProvider = MoveComponentVelocityProvider.CreateMoveComponentVelocityProvider(player)

    launchEvent.lerpMultiplier = 15.00

    return launchEvent
end

function this.GetLaunchEvent_Drop(player, item_object)
    local dir = Vector4.new(0, 0, -1, 1)

    --local rot = Vector4.ToRotation(dir)
    local rot = GetSingleton('Vector4'):ToRotation(dir)

    --local orientation = EulerAngles.ToQuat(rot);
    local orientation = GetSingleton('EulerAngles'):ToQuat(rot)

    local launchEvent = gameprojectileSetUpAndLaunchEvent.new()

    launchEvent.launchParams.logicalPositionProvider = IPositionProvider.CreateEntityPositionProvider(item_object)
    launchEvent.launchParams.logicalOrientationProvider = IOrientationProvider.CreateStaticOrientationProvider(orientation)

    --Quaternion.SetIdentity(orientation)
    GetSingleton('Quaternion'):SetIdentity(orientation)

    launchEvent.launchParams.visualPositionProvider = IPositionProvider.CreateEntityPositionProvider(item_object)
    launchEvent.launchParams.visualOrientationProvider = IOrientationProvider.CreateStaticOrientationProvider(orientation)

    launchEvent.launchParams.ownerVelocityProvider = MoveComponentVelocityProvider.CreateMoveComponentVelocityProvider(player)

    launchEvent.owner = player

    launchEvent.trajectoryParams = ParabolicTrajectoryParams.GetAccelVelParabolicParams(Vector4.new(0, 0, -9.8, 0), 0.10)

    return launchEvent
end

function this.GetTrajectoryParams_Linear()

    -- this is in base bullet's initialize
    -- protected cb func OnProjectileInitialize(eventData: ref<gameprojectileSetUpEvent>) -> Bool {
    --     let linearParams: ref<LinearTrajectoryParams> = new LinearTrajectoryParams();
    --     linearParams.startVel = this.m_startVelocity;
    --     linearParams.acceleration = this.m_acceleration;
    --     this.m_projectileComponent.AddLinear(linearParams);
    --     this.m_projectileComponent.ToggleAxisRotation(true);
    --     this.m_projectileComponent.AddAxisRotation(new Vector4(0.00, 1.00, 0.00, 0.00), 100.00);
    -- }



    -- I wonder if grenades only work with certain trajectory params

    local trajectoryParams = gameprojectileLinearTrajectoryParams.new()
    trajectoryParams.startVel = 6
    trajectoryParams.acceleration = 4

    return trajectoryParams
end

function this.GetTrajectoryParams_Parabolic(gravity, target_position, throw_angle)
    return gameprojectileParabolicTrajectoryParams.GetAccelTargetAngleParabolicParams(Vector4.new(0, 0, gravity, 0.00), target_position, throw_angle)
end

function this.GetTrajectoryParams_Parabolic_NOPREFIX(gravity, target_position, throw_angle)
    return ParabolicTrajectoryParams.GetAccelTargetAngleParabolicParams(Vector4.new(0, 0, gravity, 0.00), target_position, throw_angle)
end

function this.Player_Entity_Validations(player, item_object)

    return true
end

return PrototypeGrenades3