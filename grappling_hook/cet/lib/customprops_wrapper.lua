-- These are accessors to custom properties that are shared by flight based mods.  They
-- are a way for the mods to talk to each other so only one is performing flight at a time

-- @addField(PlayerPuppet)
-- public let Custom_IsFlying: Bool;
function Get_Custom_IsFlying(player)
    local sucess, result = pcall(
        function(p) return p.Custom_IsFlying end,
        player)

    if sucess then
        return result
    else
        return false
    end
end
function Set_Custom_IsFlying(player, value)
    pcall(function(p, v) p.Custom_IsFlying = v end,
        player, value)
end
