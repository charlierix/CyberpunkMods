local OrbPool = {}

local this = {}

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

    if debug_render_screen.IsEnabled() then
        this.DebugSummary()
    end
end

-- Adds an orb based on the body definition
function OrbPool.Add(body_def, o)
    local item = orbs:GetNewItem()
    item.orb = Orb:new(o, body_def.pos)
end

----------------------------------- Private Methods -----------------------------------

function this.DebugSummary()
    local count = orbs:GetCount()
    if count == 0 then
        do return end
    end

    local report = "dist\tspeed"

    for i = 1, count, 1 do
        report = report .. "\r\n"

        local orb = orbs:GetItem(i).orb

        local distance = math.sqrt(GetVectorDiffLengthSqr(orb.props.o.pos, orb.props.pos))
        local speed = GetVectorLength(SubtractVectors(orb.props.vel, orb.props.o.vel))

        report = report .. tostring(Round(distance, 1)) .. "\t" .. tostring(Round(speed, 1))
    end

    debug_render_screen.Add_Text2D(0.9, 0.5, report, nil, "89081729", "FFF", nil, true)
end

return OrbPool