-- These are accessors to custom properties that are shared by flight based mods.  They
-- are a way for the mods to talk to each other so only one is performing flight at a time

--NOTE: This custom property is added using redscript.  This mod doesn't use redscript (it
--will when sounds are added).  So if they only have this mod installed, these calls will
--silently fail, but they are pointless without either jetpack or grappling hook anyway
--(or any future mod that uses this property)

-- @addField(PlayerPuppet)
-- public let Custom_CurrentlyFlying: String;

function Custom_CurrentlyFlying_get(player)
    local sucess, result = pcall(
        function(p) return p.Custom_CurrentlyFlying end,
        player)

    if sucess then
        return result
    else
        return false
    end
end

-- function Custom_CurrentlyFlying_set(player, value)
--     pcall(function(p, v) p.Custom_CurrentlyFlying = v end,
--         player, value)
-- end

-- This will set the property to this grappling hook mod's string
function Custom_CurrentlyFlying_StartFlight(player, modNames)
    pcall(function(p, mn)
        p.Custom_CurrentlyFlying = mn.low_flying_v
    end, player, modNames)
end

-- This will clear the property only if grappling hook is still current
function Custom_CurrentlyFlying_Clear(player, modNames)
    pcall(function(p, mn)
        local current = p.Custom_CurrentlyFlying

        if current == mn.low_flying_v then
            p.Custom_CurrentlyFlying = ""
        end
    end, player, modNames)
end