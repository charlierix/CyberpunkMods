local ScannerUtil = {}

function ScannerUtil.AddToMap(map, entity, const)
    if entity:IsPlayer() then
        local pos = ScannerUtil.GetAdjustedAlivePosition(entity:GetWorldPosition())
        map:Add_Alive(entity:GetEntityID(), pos, "Player")        -- GetAffiliation() is off of NPCPuppet, doesn't exist in PlayerPuppet

    elseif entity:IsNPC() then
        if entity:IsDead() then
            map:Add_Dead(entity:GetEntityID(), entity:GetWorldPosition(), entity:GetAffiliation(), entity:GetTotalFrameWoundsDamage())

        elseif entity:IsDefeated() then
            map:Add_Defeated(entity:GetEntityID(), entity:GetWorldPosition(), entity:GetAffiliation())

        else
            local pos = ScannerUtil.GetAdjustedAlivePosition(entity:GetWorldPosition())
            map:Add_Alive(entity:GetEntityID(), pos, entity:GetAffiliation())
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

function ScannerUtil.GetCurrentPosition(entityID, isAlive)
    local entity = Game.FindEntityByID(entityID)
    if not entity then
        return nil
    end

    local pos = entity:GetWorldPosition()

    if isAlive then
        pos = ScannerUtil.GetAdjustedAlivePosition(pos)
    end

    return pos
end

-- entity:GetWorldPosition() retuns the position at the feet.  This returns a position closer to the center of their body
function ScannerUtil.GetAdjustedAlivePosition(pos)
    -- One meter up seems to be a good compromise for a bunch of conditions.  NPCs can be in various animations
    -- that are sitting, crouching, rocking back and forth.  Also children are nearly half height
    --
    -- This position is waist level for a standing npc, head level for a child.  For sitting npcs, it's the correct
    -- height, but a bit too forward.  But sitting npcs are in animation loops where they sometimes lean forward

    return Vector4.new(pos.x, pos.y, pos.z + 1, 1)
end

return ScannerUtil