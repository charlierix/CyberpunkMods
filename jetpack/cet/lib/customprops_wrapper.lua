-- These are wrappers to properties defined in redscript that aren't critical for jetpack
-- to function (more like nice to have).  So if the user didn't install redscript, these
-- functions silently fail and just pretend it's there

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

-- @addField(PlayerPuppet)
-- public let Custom_SuppressFalling: Bool;
function Get_Custom_SuppressFalling(player)
    local sucess, result = pcall(
        function(p) return p.Custom_SuppressFalling end,
        player)

    if sucess then
        return result
    else
        return false
    end
end
function Set_Custom_SuppressFalling(player, value)
    pcall(function(p, v) p.Custom_SuppressFalling = v end,
        player, value)
end
