local PrototypeGrenades2 = {}

local this = {}

function PrototypeGrenades2.ThrowFromSlot(from, to)
    local orientation = GetRandomRotation()

    -- get item
    --local playerPuppet = 

    local player = Game.GetPlayer()
    local transaction = Game.GetTransactionSystem()






    --Limai — 03/22/2022 11:11 AM
    -- Does anyone know how to get the weapon ID from this code?
    -- Game.GetTransactionSystem():GetItemInSlot(player, TweakDBID.new("AttachmentSlots.WeaponRight"))


    --anygoodname — 03/22/2022 11:21 AM
    -- GetItemInSlot() returns gameItemObject
    -- gameItemObject:GetItemID() returns gameItemID
    -- gameItemID.id is TweakDBID

    -- GetItemInSlot(...):GetItemID().id



    --local item = transaction:GetItemInSlot(player, record.AttachmentSlot().GetID());
    local item = transaction:GetItemInSlot(player, TweakDBID.new("AttachmentSlots.WeaponRight"));



    -- set up event
    local launchEvent = gameprojectileSetUpAndLaunchEvent.new()
    launchEvent.owner = playerPuppet;

    launchEvent.launchParams.logicalPositionProvider = entIPositionProvider.CreateStaticPositionProvider(from)
    launchEvent.launchParams.logicalOrientationProvider = entIOrientationProvider.CreateStaticOrientationProvider(orientation)

    launchEvent.launchParams.visualPositionProvider = entIPositionProvider.CreateEntityPositionProvider(item)
    launchEvent.launchParams.visualOrientationProvider = entIOrientationProvider.CreateEntityOrientationProvider(nil, "", item)

    -- I think this is to get the initial velocity.  There doesn't seem to be any static providers like above
    -- This takes gamePuppet.  These are the only classes that seem available
    --  NPCPuppet extends ScriptedPuppet
    --  PlayerPuppet extends ScriptedPuppet
    --      ScriptedPuppet extends gamePuppet
    --          gamePuppet
    --
    -- entIVelocityProvider implements IScriptable, has one function: CalculateVelocity()
    --  CalculateVelocity has no in/out params, IScriptable doesn't have a velocity property
    launchEvent.launchParams.ownerVelocityProvider = MoveComponentVelocityProvider.CreateMoveComponentVelocityProvider(playerPuppet)

    launchEvent.lerpMultiplier = 15.00;

    local trajectoryParams = gameprojectileLinearTrajectoryParams.new()
    trajectoryParams.startVel = 0
    trajectoryParams.acceleration = 4

    launchEvent.trajectoryParams = trajectoryParams






    item:QueueEvent(launchEvent)



end

----------------------------------- Private Methods -----------------------------------

return PrototypeGrenades2