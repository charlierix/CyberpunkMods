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
    local neighbors = this.DeserializeJSON("!configs/neighbors.json")

    for i = 1, orbs:GetCount(), 1 do
        local item = orbs:GetItem(i)

        item.orb.neighbors = neighbors
        item.orb.swarm.neighbors = neighbors
    end
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

-- Small wrapper to file.open and json.decode
-- Returns
--  object, nil
--  nil, errMsg
function this.DeserializeJSON(filename)
    local handle = io.open(filename, "r")
    local json = handle:read("*all")

    local sucess, retVal = pcall(
        function(j) return extern_json.decode(j) end,
        json)

    if sucess then
        return retVal, nil
    else
        return nil, tostring(retVal)      -- when pcall has an error, the second value returned is the error message, otherwise it't the successful return value.  It should already be a sting, but doing a tostring just to be safe
    end
end

return OrbPool