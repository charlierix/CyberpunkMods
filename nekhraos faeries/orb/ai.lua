Orb_AI = {}

local this = {}

local SHOW_DEBUG = true

--TODO: Move these constants to a class/json
local NEARBY_REFRESH_RATE = 0.5     -- how often to refresh the list of local items from map (seconds)
--local NEARBY_SEARCH_RADIUS = 12
local NEARBY_SEARCH_RADIUS = 24

function Orb_AI:new(props, map)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.props = props
    obj.map = map

    obj.target_item = nil
    obj.pulled_target_time = 0

    obj.qual_vect = qual_vect.GetVector_Random()
    obj.qual_vect_unit = ToUnit_ND(obj.qual_vect)

    return obj
end

function Orb_AI:Tick(deltaTime)

    -- Have a boredom meter

    -- If boredom is low, don't look for anything to do, just do standard swarmbot stuff

    -- As boredom rises, look for stuff on the map


    -- get nearby
    -- sort by combination of dot product, distance, mood



    local nearby = self.map:GetNearby_ObjectiveItems(self.props.pos, NEARBY_SEARCH_RADIUS)

    for _, objective_item in ipairs(nearby) do


        if SHOW_DEBUG then
            this.Debug_ShowItem(objective_item, self.props.pos, self.qual_vect_unit, self.props.o)
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Debug_ShowItem(objective_item, pos, qual_vect_unit, o)
    local OFFSET_X = 0.03
    local OFFSET_Z = 0.25

    o:GetCamera()
    local offset_right = MultiplyVector(o.lookdir_right, OFFSET_X)



    -- Distance
    local distance = math.sqrt(GetVectorDiffLengthSqr(pos, objective_item.pos))

    local dist_percent = 1 - Clamp(0, 1, distance / NEARBY_SEARCH_RADIUS)
    local dist_color = this.Debug_GetColor(dist_percent)

    debug_render_screen.Add_Dot(SubtractVectors(objective_item.pos, offset_right), nil, dist_color, nil, true)



    -- Dot Product
    local dot = DotProductND(qual_vect_unit, objective_item.qualifier_unit)

    -- This runs percent from -1=0 to 1=1
    --local dot_percent = 1 - (math.acos(dot) / math.pi)      -- arccos to change dot to linear.  dividing by pi to get it back to 0 to 1

    -- This runs percent from -1=-1 to 1=1
    local dot_percent = 1 - ((2 * math.acos(dot)) / math.pi)      -- arccos to change dot to linear.  dividing by pi to get it back to 0 to 1

    local dot_color = this.Debug_GetColor(dot_percent)

    debug_render_screen.Add_Dot(objective_item.pos, nil, dot_color, nil, true)

    -- local report = "dot: " .. tostring(Round(dot, 2)) .. "\r\ndot_percent: " .. tostring(Round(dot_percent, 2))
    -- debug_render_screen.Add_Text(Vector4.new(objective_item.pos.x, objective_item.pos.y, objective_item.pos.z - OFFSET_Z, 1), report, nil, "6222", "FFF", nil, true)



    -- Final Score
    --TODO: use an animation curve
    local dist_score = dist_percent ^ 0.5

    local dot_score = Clamp(0, 1, dot_percent)      -- ignores -1

    local score = dist_score * dot_score

    local score_color = this.Debug_GetColor(score)

    debug_render_screen.Add_Dot(AddVectors(objective_item.pos, offset_right), nil, score_color, nil, true)
end
function this.Debug_GetColor(percent)
    local mid = "D4B85D"

    if percent < 0.5 then
        return Color_LERP_Hex("D92F23", mid, percent * 2)
    else
        return Color_LERP_Hex(mid, "1CC41A", (percent - 0.5) * 2)
    end
end