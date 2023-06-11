Orb_AI = {}

local this = {}

local SHOW_DEBUG = false

function Orb_AI:new(props, map, interested_items, goals)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.props = props
    obj.map = map
    obj.interested_items = interested_items
    obj.goals = goals

    obj.next_scan_time = 0

    obj.qual_vect = qual_vect.GetVector_Random()
    obj.qual_vect_unit = ToUnit_ND(obj.qual_vect)

    return obj
end

function Orb_AI:Tick(deltaTime)
    if SHOW_DEBUG then
        this.Debug_ShowItems(self)
    end


    -- Have a boredom meter

    -- If boredom is low, don't look for anything to do, just do standard swarmbot stuff

    -- As boredom rises, look for stuff on the map



    --TODO: go through the interested_items and possibly interact with one if close enough



    if self.props.o.timer >= self.next_scan_time then
        self.next_scan_time = self.props.o.timer + GetScaledValue(self.goals.refresh_rate_seconds * 0.9, self.goals.refresh_rate_seconds * 1.1, 0, 1, math.random())
        this.Scan(self)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Scan(self)
    self.interested_items:Clear()

    local nearby = self.map:GetNearby_ObjectiveItems(self.props.pos, self.goals.search_radius)

    for _, objective_item in ipairs(nearby) do
        -- See if the item should be flown to
        local percent = this.AnalyzeItem(objective_item, self.props.pos, self.qual_vect_unit, self.goals.search_radius)
        if percent then
            local interested_item = self.interested_items:GetNewItem()
            interested_item.item = objective_item
            interested_item.percent = percent
        end
    end
end

function this.AnalyzeItem(objective_item, pos, qual_vect_unit, search_radius)
    local dist_percent = this.AnalyzeItem_Distance(pos, objective_item.pos, search_radius)
    local dot_percent = this.AnalyzeItem_DotProduct(qual_vect_unit, objective_item.qualifier_unit)
    local score_percent = this.AnalyzeItem_Score(dist_percent, dot_percent)

    --TODO: compare with boredom level to see if it should be considered or not

    if score_percent > 0.25 then
        return score_percent
    else
        return nil
    end
end
function this.AnalyzeItem_Distance(pos, objective_item_pos, search_radius)
    local distance = math.sqrt(GetVectorDiffLengthSqr(pos, objective_item_pos))
    return 1 - Clamp(0, 1, distance / search_radius)
end
function this.AnalyzeItem_DotProduct(vect1, vect2)
    local dot = DotProductND(vect1, vect2)

    -- This runs percent from -1=0 to 1=1
    --return 1 - (math.acos(dot) / math.pi)      -- arccos to change dot to linear.  dividing by pi to get it back to 0 to 1

    -- This runs percent from -1=-1 to 1=1
    return 1 - ((2 * math.acos(dot)) / math.pi)      -- arccos to change dot to linear.  dividing by pi to get it back to 0 to 1
end
function this.AnalyzeItem_Score(dist_percent, dot_percent)
    local ACTFUNC_MULT = 4

    --TODO: use an animation curve
    local dist_score = dist_percent ^ 0.5

    local dot_score = Clamp(0, 1, dot_percent)      -- ignores -1

    -- tanh activation function
    local combo = dist_score * dot_score

    local e_posx = math.exp(ACTFUNC_MULT * combo)
    local e_negx = math.exp(ACTFUNC_MULT * -combo)

    return (e_posx - e_negx) / (e_posx + e_negx)
end

function this.Debug_ShowItems(self)
    local nearby = self.map:GetNearby_ObjectiveItems(self.props.pos, self.goals.search_radius)

    for _, objective_item in ipairs(nearby) do
        this.Debug_ShowItem(objective_item, self.props.pos, self.qual_vect_unit, self.props.o, self.goals.search_radius)
    end
end
function this.Debug_ShowItem(objective_item, pos, qual_vect_unit, o, search_radius)
    local OFFSET_X = 0.03
    local OFFSET_Z = 0.25

    o:GetCamera()
    local offset_right = MultiplyVector(o.lookdir_right, OFFSET_X)

    -- Distance
    local dist_percent = this.AnalyzeItem_Distance(pos, objective_item.pos, search_radius)
    local dist_color = this.Debug_GetColor(dist_percent)

    debug_render_screen.Add_Dot(SubtractVectors(objective_item.pos, offset_right), nil, dist_color, nil, true)

    -- Dot Product
    local dot_percent = this.AnalyzeItem_DotProduct(qual_vect_unit, objective_item.qualifier_unit)
    local dot_color = this.Debug_GetColor(dot_percent)

    debug_render_screen.Add_Dot(objective_item.pos, nil, dot_color, nil, true)

    -- local report = "dot: " .. tostring(Round(dot, 2)) .. "\r\ndot_percent: " .. tostring(Round(dot_percent, 2))
    -- debug_render_screen.Add_Text(Vector4.new(objective_item.pos.x, objective_item.pos.y, objective_item.pos.z - OFFSET_Z, 1), report, nil, "6222", "FFF", nil, true)

    -- Final Score
    local score = this.AnalyzeItem_Score(dist_percent, dot_percent)
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