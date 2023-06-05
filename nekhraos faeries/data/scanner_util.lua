local ScannerUtil = {}

function ScannerUtil.AddToMap(map, entity, const)
    if entity:IsPlayer() then
        map:Add_NPC_Alive(entity:GetEntityID(), entity:GetWorldPosition(), "Player")        -- GetAffiliation() is off of NPCPuppet, doesn't exist in PlayerPuppet

    elseif entity:IsNPC() then
        if entity:IsDead() then
            map:Add_NPC_Dead(entity:GetEntityID(), entity:GetWorldPosition(), entity:GetAffiliation(), entity:GetTotalFrameWoundsDamage())

        elseif entity:IsDefeated() then
            map:Add_NPC_Defeated(entity:GetEntityID(), entity:GetWorldPosition(), entity:GetAffiliation())

        else
            map:Add_NPC_Alive(entity:GetEntityID(), entity:GetWorldPosition(), entity:GetAffiliation())
        end

    --elseif Game.NameToString(entity:GetClassName()) == "LootContainerObjectAnimatedByTransform" and Game.NameToString(entity:GetCurrentAppearanceName()):find("_corpse") then
    elseif Game.NameToString(entity:GetCurrentAppearanceName()):find("_corpse") then        -- sometimes it's a gameObject, most times it's LootContainerObjectAnimatedByTransform.  Just use entity:IsContainer() to see if it's holding anything
        map:Add_Corpse_Container(entity:GetEntityID(), entity:GetWorldPosition())

    elseif entity:IsContainer() then
        --NOTE: All loot also seem to be classified as container
        map:Add_Container(entity:GetEntityID(), entity:GetWorldPosition())

    elseif entity:IsDevice() then
        map:Add_Device(entity:GetEntityID(), entity:GetWorldPosition())

    else
        --TODO: get rid of the loot category, since it seems to be container
    end
end

return ScannerUtil