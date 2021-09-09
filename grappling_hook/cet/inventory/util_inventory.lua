local this = {}

local types_shotgun = { "Wea_ShotgunDual", "Wea_Shotgun" }
local types_knife = { "Wea_Knife" }
local types_silencer = { "Prt_Muzzle" }
local types_grenade = { "Gad_Grenade" }
local types_clothes = { "Clo_Legs", "Clo_InnerChest", "Clo_OuterChest", "Clo_Outfit" }
local types_money = { "Gen_Misc" }

local count_shotgun = 1
local count_knife = 3
local count_silencer = 1
local count_grenade = 4
local count_clothes = 6
local count_money = 12000

-- This looks at inventory for what's necessary to  unlock grapple, returns a report that can be used
-- to fill out a ui
-- Returns
-- { {description, requiredCount, requiredCount_display, availableCount, availableCount_display, unlockType, items}, {}, ... }
function GetUnlockReport(o, const)
    local retVal = {}

    local items = o:GetInventoryList()
    --ReportTable(items)

    local found = this.FindItems(items, types_shotgun, nil, false, o)
    this.AddToUnlockReport(retVal, "shotgun", count_shotgun, #found, nil, nil, const.unlockType.shotgun, found)

    found = this.FindItems(items, types_knife, nil, false, o)
    this.AddToUnlockReport(retVal, "knives or tantos", count_knife, #found, nil, nil, const.unlockType.knife, found)

    found = this.FindItems(items, types_silencer, nil, false, o)        -- proved that this doesn't return silencers that are attached to weapons
    this.AddToUnlockReport(retVal, "silencer", count_silencer, #found, nil, nil, const.unlockType.silencer, found)

    found = this.FindItems(items, types_grenade, "emp", true, o)        --IsEquipped isn't working for grenades, but it doesn't really matter whether they are equipped or not
    local count = this.GetQuantityValue(found)
    this.AddToUnlockReport(retVal, "emp grenades", count_grenade, count, nil, nil, const.unlockType.grenade, found)

    found = this.FindItems(items, types_clothes, nil, false, o)
    this.AddToUnlockReport(retVal, "clothes (not head or footware)", count_clothes, #found, nil, nil, const.unlockType.clothes, found)

    found = this.FindItems(items, types_money, "money", true, o)
    count = this.GetQuantityValue(found)
    this.AddToUnlockReport(retVal, "eurodollars", count_money, count, tostring(Round(count_money / 1000)) .. "K", tostring(Round(math.floor(count / 1000))) .. "K", const.unlockType.money, found)

    return retVal
end

-- This will unlock the grapple if they have enough crafting material in their inventory
-- If they don't have enough, false and an error message are returned
--
-- Returns succuss, errMsg
--  True: Items were removed from inventory and grappling hook was unlocked
--  False: Requirements weren't met, nothing was done
function TryUnlockGrapple(o, player, const)
    -- No point in writing all the logic twice.  All the filtering is done when getting report
    local report = GetUnlockReport(o, const)

    -- Make sure all the requirements were met

    -- Remove items


    -- Unlock
    --player:UnlockPlayer()




end

---------------------------------------------------------------------------------------

function ReportInventory_All(o)

    o:GetPlayerInfo()
    if not o.player then
        print("no player")
        do return end
    end

    local transaction = Game.GetTransactionSystem()

    local success, items = transaction:GetItemList(o.player)
    if not success then
        print("couldn't get item list")
        do return end
    end

    --ReportTable(items)

    this.SortBy_ItemType(items)
    --this.SortBy_ItemType_Name(items)

    for i = 1, #items do
        print(items[i]:GetItemType().value .. "            GetItemType().value")
        --print(items[i]:GetName())
        print(items[i]:GetNameAsString() .. "            GetNameAsString()")
        --print(tostring(items[i]:GetID()) .. "            GetID()")
        --print(tostring(items[i]:GetID():GetTDBID()) .. "            GetID():GetTDBID()")

        -- local id = items[i]:GetID():GetTDBID()
        -- local test = TweakDBID.new(id, ".displayName")       -- it doesn't work like that.  It looks like displayName is meant to work with the get localized function
        -- print(tostring(test))

        print("count: " .. tostring(items[i]:GetQuantity()) .. "            GetQuantity()")

        -- local quality = o:GetItemQuality(items[i])
        -- print(tostring(quality) .. " | " .. type(quality) .. " || " .. tostring(quality.value) .. " | " .. tostring(type(quality.value)))
        print(o:GetItemQuality(items[i]))


        print("   ")
    end

end

function ReportInventory_UnlockCandidates(o)
    o:GetPlayerInfo()
    if not o.player then
        print("no player")
        do return end
    end

    local equipmentSystem = Game.GetScriptableSystemsContainer():Get('EquipmentSystem')
    if not equipmentSystem then
        print("no equipment system")
        do return end
    end

    local transaction = Game.GetTransactionSystem()

    local success, items = transaction:GetItemList(o.player)
    if not success then
        print("couldn't get item list")
        do return end
    end

    this.SortBy_ItemType(items)

    for i = 1, #items do
        local itemtype = items[i]:GetItemType().value

        if this.InAny(itemtype, types_shotgun, types_knife, types_clothes, types_silencer, types_grenade, types_money) then

            print(itemtype)
            print(items[i]:GetNameAsString())
            print(tostring(items[i]:GetQuantity()))
            print("is equipped: " .. tostring(equipmentSystem:IsEquipped(o.player, items[i]:GetID())))

            print("quality: " .. tostring(o:GetItemQuality(items[i])))

            print("   ")
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function this.AddToUnlockReport(report, description, requiredCount, availableCount, requiredCount_display, availableCount_display, unlockType, items)
    local required_display = requiredCount_display
    if not required_display then
        required_display = tostring(requiredCount)
    end

    local avail_display = availableCount_display
    if not avail_display then
        avail_display = tostring(availableCount)
    end

    report[#report+1] =
    {
        description = description,
        requiredCount = requiredCount,
        requiredCount_display = required_display,
        availableCount = availableCount,
        availableCount_display = avail_display,
        unlockType = unlockType,
        items = items,
    }
end

function this.GetQuantityValue(items)
    if #items ~= 1 then
        return 0
    end

    return items[1]:GetQuantity()
end

function this.FindItems(items, types, name, canBeEquipped, o)
    local retVal = {}

    for i = 1, #items do
        if this.IsMatchingItem(items[i], types, name, canBeEquipped, o) then
            retVal[#retVal+1] = items[i]
        end
    end

    return retVal
end
function this.IsMatchingItem(item, types, name, canBeEquipped, o)
    if not Contains(types, item:GetItemType().value) then
        return false
    end

    if name and item:GetNameAsString() ~= name then
        return false
    end

    if not canBeEquipped and o:IsItem_Equipped(item) then
        return false
    end

    if o:IsItem_Quest(item) or o:IsItem_Iconic(item) or o:IsItem_Legendary(item) then
        return false
    end

    return true
end

function this.SortBy_ItemType(items)
    local compare = function (a, b)
        return a:GetItemType().value < b:GetItemType().value
    end

    table.sort(items, compare)
end

function this.SortBy_ItemType_Name(items)
    local compare = function (a, b)
        if a:GetItemType().value < b:GetItemType().value then
            return true
        end

        return a:GetNameAsString() < b:GetNameAsString()
    end

    table.sort(items, compare)
end

-- Each of the items in ... is a list of valid items (... is a jagged list of candidates)
function this.InAny(testValue, ...)
    for i = 1, select("#", ...) do
        local list = select(i, ...)

        if Contains(list, testValue) then
            return true
        end
    end

    return false
end

function this.Debug_ReportItems(items, o)
    for i = 1, #items do
        print(items[i]:GetItemType().value)
        print(items[i]:GetNameAsString())
        print("count: " .. tostring(items[i]:GetQuantity()) .. "            GetQuantity()")
        print("is equipped: " .. tostring(o:IsItem_Equipped(items[i])))
        print("   ")
    end
end

function this.NOTES_TransactionSystem()
    -- TransactionSystem    https://redscript.redmodding.org/#18114
    -- gameItemData         https://redscript.redmodding.org/#15783
    -- gamedataItemType     https://redscript.redmodding.org/#2494


    -- donk7413 — 03/24/2021
    -- how to check the amount of a item in player inventory ?

    -- psiberx — 03/24/2021
    -- depends on the kind of an item
    -- for stackable items like money or heals:
    -- Game.GetTransactionSystem():GetItemQuantity(Game.GetPlayer(), itemId)
    -- for weapons, clothing, etc. you have to iterate through inventory manually and compare tweakdbid
    
    -- psiberx — 03/24/2021
    -- to get ItemID from TweakDBID:
    -- 1. GetSingleton('gameItemID'):FromTDBID(tweakDbId)
    -- 2. ItemID.new(tweakDbId, seed) -- if you know the seed and want to recreate the exact ItemID
    -- 3. ItemID.new(tweakDbId) -- this is only applicable for non-randomizable items (like money, components, etc.)

    -- psiberx — 02/17/2021
    -- items like clothing have randomization, when you do gameItemID:FromTDBID(tdbid) you get the ItemID with random seed, and this is the actual unique ID of the item
    -- HasItem checks only for this unique instance, but not if you have any  instance of the Items.Boots_09_basic_01
    -- you can define one specific seed, and then you can reliable check if the item is in the inventory
    -- but in this case you also can't use Game.AddToInventory, because you can't add an item with fixed seed with that function
    
    
    -- psiberx — 04/05/2021
    -- local photoPuppetComponent, weaponItems, weaponIndex
    
    -- registerForEvent('onInit', function()
    --     Observe('PhotoModePlayerEntityComponent', 'ListAllItems', function(self)
    --         photoPuppetComponent = self
    --         weaponItems = {}
    --         weaponIndex = 0
            
    --         local _, items = Game.GetTransactionSystem():GetItemList(Game.GetPlayer())
            
    --         for _, itemData in ipairs(items) do
    --             if itemData:GetItemType().value:find('^Wea_') then
    --                 table.insert(weaponItems, itemData)
    --             end
    --         end
    --     end)
    -- end)
    
    -- registerHotkey('EquipInPhoto', 'Equip next weapon in photo', function()
    --     weaponIndex = weaponIndex + 1
        
    --     if weaponIndex > #weaponItems then
    --         weaponIndex = 1
    --     end
        
    --     local weaponId = weaponItems[weaponIndex]:GetID()
        
    --     photoPuppetComponent:AddAmmoForWeapon(weaponId)
    --     photoPuppetComponent:PutOnFakeItem(weaponId)
    --     photoPuppetComponent.currentWeaponInSlot = weaponId
    -- end)
    -- with this you can equip even katanas, but there is no correct pose for it, so it's kind of pointless
    -- add more filtering on supported item types and everything should be fine
    -- also it seems like it will work for any items, clothing too, but I didn't check




    -- psiberx — 04/15/2021
    -- besides fixes the latest update adds some operators support for basic types in lua:
    -- -- Compare basic types
    -- print(Vector3.new(1, 2, 3) == ToVector3{ x = 1, y = 2, z = 3 }) -- true

    -- -- Compare enums
    -- print(Enum.new("ActiveMode", 3) == Enum.new("ActiveMode", "COMBAT")) -- true
    -- print(Enum.new("gameGameVersion", "Current") == Enum.new("gameGameVersion", "CP77_Patch_1_2_Hotfix1")) -- true

    -- -- Compare and concatenate TweakDBID
    -- local weaponId = TweakDBID.new("Items.Preset_Igla_Default")
    -- local weaponNameId = TweakDBID.new("Items.Preset_Igla_Default.displayName")
    -- print(weaponId + ".displayName" == weaponNameId) -- true
    -- print(weaponId .. ".displayName" == weaponNameId) -- true



    -- psiberx — 02/10/2021
    -- Getting the localized name of an item:
    -- print(Game.GetLocalizedTextByKey(TDB.GetLocKey('Items.Boots_06_basic_01.displayName')))

    -- Getting the localized name of an item from an ItemID / TweakDBID:
    -- local equipmentSystem = Game.GetScriptableSystemsContainer():Get('EquipmentSystem')

    -- -- Get the ItemID of the item equipped in the Inner Torso slot
    -- local innerTorsoItemID = equipmentSystem:GetActiveItem(Game.GetPlayer(), 'InnerChest')
    
    -- -- Get the TweakDBID of the "displayName" property of the TweakDB record
    -- local displayNameTweakDBID = TweakDBID.new(innerTorsoItemID.id, '.displayName')
    
    -- -- Get the localization key (LocKey) of the "displayName" property
    -- local displayNameLocKey = TDB.GetLocKey(displayNameTweakDBID)
    
    -- -- Get localized text by LocKey
    -- print(Game.GetLocalizedTextByKey(displayNameLocKey))



    -- psiberx — 02/10/2021
    -- this is what you getting with the GetID().id --  TweakDBID.new("Items.Boots_06_basic_01")
    -- this is what you need -- TweakDBID.new("Items.Boots_06_basic_01.displayName")

    --TweakDBID.new(recordID, '.entityTemplatePath')

    
end

function this.NOTES_InventoryDataManagerV2()

    -- InventoryDataManagerV2   https://redscript.redmodding.org/#18779

    --public GetPlayerInventoryDataExcludingLoadout(): array<InventoryItemData>

    

    -- equipmentsystem:
    --public IsEquipped(owner: GameObject, item: ItemID): Bool



    -- psiberx — 03/05/2021
    -- local equipmentSystem = Game.GetScriptableSystemsContainer():Get('EquipmentSystem')
    -- local inventoryDataManager = equipmentSystem:GetPlayerData(Game.GetPlayer()):GetInventoryManager()
    
    -- local items = inventoryDataManager['GetPlayerInventoryData;gamedataEquipmentAreaBoolarray<ItemModParams>'](inventoryDataManager, 'QuickSlot', false, {})

end

function this.NOTES_USING_WEAPON()


    -- Til W. — 08/17/2021
    -- Does someone know how I can get the objectID of the currently equipped weapon?    

    -- psiberx — 08/17/2021
    -- GameObject.GetActiveWeapon(player).GetEntityID() or GetTransactionSystem(game).GetItemInSlot(player, t"AttachmentSlots.WeaponRight").GetEntityID()    

    -- RMK — 08/17/2021
    -- You can get info about equipped items with InventoryDataManagerV2 which you just have to initialize with a PlayerPuppet.
    -- Or what psiberx posted :slight_smile:



    -- From immersive first person
    -- function Helpers.HasWeapon()
    --     local player = Game.GetPlayer()
    --     if player then
    --         local ts = Game.GetTransactionSystem()
    --         return ts and ts:GetItemInSlot(player, TweakDBID.new("AttachmentSlots.WeaponRight")) ~= nil
    --     end
    --     return false
    -- end
    
end

function this.SPECIFIC_ITEMS()



    ------------ shotgun ------------
    -- items[i]:GetItemType().value
    --  Wea_ShotgunDual
    --  Wea_Shotgun

    ------------ knives or tantos ------------
    -- items[i]:GetItemType().value
    --  Wea_Knife
    
    ------------ clothes ------------
    -- items[i]:GetItemType().value
    --  Clo_Legs
    --  Clo_InnerChest
    --  Clo_OuterChest
    --  Clo_Outfit


    
    ------------ silencer ------------
    -- items[i]:GetItemType().value
    --  Prt_Muzzle
    
    ------------ emp grenades ------------
    -- items[i]:GetItemType().value
    --  Gad_Grenade



    --?????????

    -- items[i]:GetQuantity()


    
    ------------ money ------------
    -- items[i]:GetItemType().value
    --  Gen_Misc

    -- items[i]:GetNameAsString()
    --  money

    -- items[i]:GetQuantity()
    
    
end