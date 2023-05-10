local OrbPool = {}

-- Each item has these props:
--  orb     instance of orb
local orbs = StickyList:new()

function OrbPool.Tick(deltaTime)
    local index = 1

    while index <= orbs:GetCount() do
        local item = orbs:GetItem(index)

        item.orb:Tick(deltaTime)

        if item.orb:ShouldRemove() then
            item.orb = nil
            orbs:RemoveItem(index)
        else
            index = index + 1
        end
    end
end

-- Adds an orb based on the body definition
function OrbPool.Add(body_def, o)
    local item = orbs:GetNewItem()
    item.orb = Orb:new(o, body_def.pos)
end

return OrbPool