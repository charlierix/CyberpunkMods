local PrototypeGrenades = {}

local this = {}

local types_grenade = { "Gad_Grenade" }

function PrototypeGrenades.ThrowStraight(from, to)
    local item_data = this.GetRandomGrenade_item()
    if not item_data then
        print("no grenades in inventory")
        do return end
    end

    print("ThrowStraight a: " .. tostring(item_data))

    local entity = this.SpawnEntity(item_data)




    local launchEvent = gameprojectileSetUpAndLaunchEvent.new()

    print("ThrowStraight b")

    -- leaving it alone probably defaults to default (whatever that is)
    --launchEvent.launchParams.launchMode = gameprojectileELaunchMode.FromLogic;


    --ERROR: Function 'CreateEntityPositionProvider' parameter 1 must be handle:entEntity.
    --(item is gameItemData)
    launchEvent.launchParams.logicalPositionProvider = IPositionProvider.CreateEntityPositionProvider(item_data)



    print("ThrowStraight c")


    -- launchEvent.launchParams.logicalOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(null, n"", ownerPuppet);
    -- launchEvent.launchParams.visualPositionProvider = IPositionProvider.CreateEntityPositionProvider(item);
    -- launchEvent.launchParams.visualOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(null, n"", item);
    -- launchEvent.launchParams.ownerVelocityProvider = MoveComponentVelocityProvider.CreateMoveComponentVelocityProvider(ownerPuppet);



end

function PrototypeGrenades.SpawnGrenade_ATTEMPT1(position)
    local item_data = this.GetRandomGrenade_item()
    if not item_data then
        print("no grenades in inventory")
        do return end
    end

    print("SpawnGrenade a: " .. tostring(item_data))

    local entity = this.SpawnEntity_item(item_data)

    print("SpawnGrenade b: " .. tostring(entity))
    
end

function PrototypeGrenades.SpawnGrenade_ATTEMPT2(position, const)
    local record_id = this.GetRandomGrenade_recordid()

    this.SpawnEntity_recordid(record_id, position, const)
end

----------------------------------- Private Methods -----------------------------------

--TODO: instead of looking in player's inventory, just have names of all grenades and create one
function this.GetRandomGrenade_item()
    local player = Game.GetPlayer()
    local transaction = Game.GetTransactionSystem()

    local success, items = transaction:GetItemList(player)
    if not success then
        return nil
    end

    local grenades = this.GetGrenades(items)
    if #grenades == 0 then
        return nil
    end

    return grenades[math.random(#grenades)]
end

function this.GetRandomGrenade_recordid()
    -- https://www.vg247.com/cyberpunk-2077-console-commands
    local all_grenades =
    {
        -- BioHaz Grenade
        "Items.GrenadeBiohazardHoming",
        "Items.GrenadeBiohazardRegular",

        -- EMP Grenade
        "Items.GrenadeEMPHoming",
        "Items.GrenadeEMPRegular",
        "Items.GrenadeEMPSticky",

        -- X-22 Flashbang Grenade",
        "Items.GrenadeFlashHoming",
        "Items.GrenadeFlashRegular",

        -- F-GX Frag Grenade
        "Items.GrenadeFragRegular",
        "Items.GrenadeFragHoming",
        "Items.GrenadeFragSticky",

        -- Incendiary Grenade
        "Items.GrenadeIncendiaryRegular",
        "Items.GrenadeIncendiaryHoming",
        "Items.GrenadeIncendiarySticky",

        -- Recon Grenade
        "Items.GrenadeReconRegular",
        "Items.GrenadeReconSticky",

        -- Other Grenades
        "Items.GrenadeCuttingRegular",
    }

    return all_grenades[math.random(#all_grenades)]
end

function this.GetGrenades(items)
    local retVal = {}

    for i = 1, #items do
        if Contains(types_grenade, items[i]:GetItemType().value) then
            retVal[#retVal+1] = items[i]
        end
    end

    return retVal
end

function this.SpawnEntity_item(item_data)
    -- https://nativedb.red4ext.com/gameItemData
    -- https://nativedb.red4ext.com/gameItemID
    local gameItemID = item_data:GetID()
    local tweakID = gameItemID.id

    -- sounds like codeware covers this way better than the built in game tools (getting event of when it actually spawns)
    -- https://github.com/psiberx/cp2077-codeware/wiki#spawning-entities

    -- the alternative would be
    -- exEntitySpawner

    local spec = DynamicEntitySpec.new()









    
end
function this.SpawnEntity_recordid(record_id, position, const)
    -- https://github.com/psiberx/cp2077-codeware/wiki#spawning-entities
    -- \Cyberpunk 2077\r6\scripts\Codeware\Codeware.Global.reds
    local spec = DynamicEntitySpec.new()

    spec.recordID = record_id

    spec.appearanceName = "random"

    spec.position = position
    spec.orientation = GetRandomRotation()

    spec.persistState = false
    spec.persistSpawn = false
    spec.alwaysSpawned = false
    spec.spawnInView = true
    spec.tags = { const.mod_name }

    -- this probably can't be done here, need to wire in attach event and 
    local spawner = Game.GetDynamicEntitySystem()





end

return PrototypeGrenades