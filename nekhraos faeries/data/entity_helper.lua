local EntityHelper = {}

function EntityHelper.GetIDHash_Entity(entity)
    return EntityHelper.GetIDHash_ID(entity:GetEntityID())
end

function EntityHelper.GetIDHash_ID(entityID)
    return tostring(entityID.hash)      -- int64 in game, but cet uses float.  Convert to string to be safe
end

return EntityHelper