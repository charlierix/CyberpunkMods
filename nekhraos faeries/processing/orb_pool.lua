local OrbPool = {}

local this = {}

-- Each item has these props:
--  orb     instance of orb
local orbs = StickyList:new()

function OrbPool.Tick(o, deltaTime)
    if orbs:GetCount() == 0 then
        do return end
    end

    local eye_pos, look_dir = o:GetCrosshairInfo()

    local index = 1

    while index <= orbs:GetCount() do
        local item = orbs:GetItem(index)

        item.orb:Tick(eye_pos, look_dir, deltaTime)

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

-- Adds an orb based on the body definition (velocity is optional)
function OrbPool.Add(body_def, o, vel)
    local item = orbs:GetNewItem()
    item.orb = Orb:new(o, body_def.pos, vel)
end

function OrbPool.Clear()
    orbs:Clear()
end

-- TODO: if the number of orbs is too large, periodically cluster with K-Means
-- TODO: give an option for a weighted search.  ai could define goals as an ND vector, so there's a search for orbs in physical space and another search for orbs in goal space
-- Returns all the items within radius, sorted by distance
--  { {orb, dist_sqr}, ... }
function OrbPool.FindNearby(center, radius, exclude_id)
    local retVal = {}

    for i = 1, orbs:GetCount(), 1 do
        local item = orbs:GetItem(i)

        if not exclude_id or item.orb.props.id ~= exclude_id then
            local dist_sqr = GetVectorDiffLengthSqr(center, item.orb.props.pos)
            if dist_sqr <= radius * radius then
                this.FindNearby_Add(retVal, item.orb, dist_sqr)
            end
        end
    end

    return retVal
end

-- Using this method should avoid the bots forming spherical groupings
function OrbPool.FindNearby_Cone(center, radius, look_dir_unit, min_dot, exclude_id)
    local retVal = {}

    for i = 1, orbs:GetCount(), 1 do
        local item = orbs:GetItem(i)

        if not exclude_id or item.orb.props.id ~= exclude_id then
            local dist_sqr = GetVectorDiffLengthSqr(center, item.orb.props.pos)
            if dist_sqr <= radius * radius then
                if IsNearZero() then
                    this.FindNearby_Add(retVal, item.orb, dist_sqr)
                else
                    local direction_unit = DivideVector(SubtractVectors(item.orb.props.pos, center), math.sqrt(dist_sqr))
                    if DotProduct3D(look_dir_unit, direction_unit) >= min_dot then
                        this.FindNearby_Add(retVal, item.orb, dist_sqr)
                    end
                end
            end
        end
    end

    return retVal
end

function OrbPool.TEST_OverwriteConfigs_FromJSON()
    local limits = settings_util.Limits()
    local neighbors = settings_util.Neighbors()

    for i = 1, orbs:GetCount(), 1 do
        local item = orbs:GetItem(i)

        item.orb.limits = limits
        item.orb.swarm.limits = limits

        item.orb.neighbors = neighbors
        item.orb.swarm.neighbors = neighbors
    end
end

function OrbPool.TEST_CompareNeighbors(o)
    local orb = Orb:new(o, Vector4.new(0, 0, 0, 1))

    print("-------------- orb.neighbors --------------")
    ReportTable(orb.neighbors)

    local neighbors = this.DeserializeJSON("!configs/neighbors.json")

    print("-------------- json neighbors --------------")
    ReportTable(neighbors)
end

----------------------------------- Private Methods -----------------------------------

function this.DebugSummary()
    local count = orbs:GetCount()
    if count == 0 then
        do return end
    end

    local report = "dist\tspd\trspd"

    for i = 1, count, 1 do
        report = report .. "\r\n"

        local orb = orbs:GetItem(i).orb

        local distance = math.sqrt(GetVectorDiffLengthSqr(orb.props.o.pos, orb.props.pos))

        local speed = GetVectorLength(orb.props.vel)

        local vel = orb.props.o:Custom_CurrentlyFlying_GetVelocity(orb.props.o.vel)
        local rel_speed = GetVectorLength(SubtractVectors(orb.props.vel, vel))

        report = report .. tostring(Round(distance, 0)) .. "\t" .. tostring(Round(speed, 0)) .. "\t" .. tostring(Round(rel_speed, 0))
    end

    debug_render_screen.Add_Text2D(0.95, 0.5, report, nil, "89081729", "FFF", nil, true)
end

-- This adds the item and keeps the list sorted by dist_sqr
function this.FindNearby_Add(retVal, orb, dist_sqr)
    local new_item =
    {
        orb = orb,
        dist_sqr = dist_sqr,
    }

    for index, item in ipairs(retVal) do
        if dist_sqr < item.dist_sqr then
            table.insert(retVal, index, new_item)
            do return end
        end
    end

    table.insert(retVal, new_item)
end

return OrbPool