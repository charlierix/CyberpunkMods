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
        map:Add_Container(entity:GetEntityID(), entity:GetWorldPosition())

    elseif entity:IsDevice() then
        map:Add_Device(entity:GetEntityID(), entity:GetWorldPosition())

    else
        --TODO: figure out what loot is
        -- debug_render_screen.Add_Dot(pos, nil, color)
        -- debug_render_screen.Add_Text(Vector4.new(pos.x, pos.y, pos.z - 0.5, 1), report, nil, "6322", "FFF")
    end
end

return ScannerUtil