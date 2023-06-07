local QualifierVector = {}

local this = {}

-- See this.BuildVector for the meaning of each axis of the vector

function QualifierVector.GetVector_Player()
    this.BuildVector(true, false, false, false, false, false, false)
end

function QualifierVector.GetVector_Body(map_body, const)
    local entity = Game.FindEntityByID(map_body.entityID)
    if not entity or not IsDefined(entity) then
        return this.BuildVector(false, false, false, false, false, false, false)
    end

    -- Dead Body
    if map_body.body_type == const.map_body_type.CorpseContainer or map_body.body_type == const.map_body_type.NPC_Dead or map_body.body_type == const.map_body_type.NPC_Defeated then
        local has_loot = entity:IsContainer()
        return this.BuildVector(false, false, false, true, false, false, has_loot)

    -- Live NPC
    elseif map_body.body_type == const.map_body_type.NPC_Alive then
        if entity:IsPlayer() or entity:IsFriendlyTowardsPlayer() then
            return this.BuildVector(true, false, false, false, false, false, false)
        end

        local is_hackable = entity:IsQuickHackAble()

        if entity:IsHostile() then
            return this.BuildVector(false, false, true, false, is_hackable, false, false)
        else
            return this.BuildVector(false, true, false, false, is_hackable, false, false)
        end

    else
        -- Error case, just say they're a neutral person
        this.BuildVector(false, true, false, false, false, false, false)
    end
end

function QualifierVector.GetVector_Container(map_container)
    local entity = Game.FindEntityByID(map_container.entityID)
    if not entity or not IsDefined(entity) then
        return this.BuildVector(false, false, false, false, false, false, false)
    end

    local is_container = entity:IsContainer()

    return this.BuildVector(false, false, false, false, false, false, is_container)
end

function QualifierVector.GetVector_Device(map_device)
    local entity = Game.FindEntityByID(map_device.entityID)
    if not entity or not IsDefined(entity) then
        return this.BuildVector(false, false, false, false, false, false, false)
    end

    local is_hackable = entity:IsQuickHackAble()
    local is_explosive = entity:IsExplosive()

    return this.BuildVector(false, false, false, false, is_hackable, is_explosive, false)
end

function QualifierVector.GetVector_Loot(map_loot)
    local entity = Game.FindEntityByID(map_loot.entityID)
    if not entity or not IsDefined(entity) then
        return this.BuildVector(false, false, false, false, false, false, false)
    end

    return this.BuildVector(false, false, false, false, false, false, true)
end

function QualifierVector.GetVector_Random()
    --TODO: may want to get a random vector inside sphere

    return
    {
        math.random(),
        math.random(),
        math.random(),
        math.random(),
        math.random(),
        math.random(),
        math.random(),
    }
end

----------------------------------- Private Methods -----------------------------------

function this.BuildVector(person_friendly, person_neutral, person_enemy, person_dead, hackable, explosive, loot)
    local retVal =
    {
        this.BoolToAxis(person_friendly),
        this.BoolToAxis(person_neutral),
        this.BoolToAxis(person_enemy),
        this.BoolToAxis(person_dead),
        this.BoolToAxis(hackable),
        this.BoolToAxis(explosive),
        this.BoolToAxis(loot),
    }

    return ToUnit_ND(retVal)
end

function this.BoolToAxis(bool)
    if bool then
        return 1
    else
        return 0
    end
end

return QualifierVector