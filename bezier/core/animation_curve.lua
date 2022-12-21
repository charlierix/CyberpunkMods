local this = {}

AnimationCurve = {}

function AnimationCurve:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.keyvalues = {}

    -- private record Derived
    -- {
    --     public BezierSegment3D_wpf[] Bezier { get; init; }

    --     public (double key, double value)[] Bezier_Samples { get; init; }

    --     public double Min_Key { get; init; }
    --     public double Max_Key { get; init; }
    --     public double Min_Value { get; init; }
    --     public double Max_Value { get; init; }
    -- }
    obj.derived = nil       -- this is lazy built (so that all calls to AddKeyValue can be made first)
    
    return obj
end

function AnimationCurve:AddKeyValue(key, value)
    table.insert(self.keyvalues, { key = key, value = value })

    table.sort(self.keyvalues, function(a, b) return a.key < b.key end)

    self.derived = nil
end

function AnimationCurve:Evaluate(key)
    if #self.keyvalues == 0 then
        return 0
    end

    self.derived = this.EnsureDerivedCreated(self.derived, self.keyvalues)

    --TODO: these should extend a ray from the first/last segment of the bezier (this will fail if the bezier is too curvy and points back)
    if key <= self.keyvalues[1].key then
        return self.keyvalues[1].value
    end

    if key >= self.keyvalues[#self.keyvalues].key then
        return self.keyvalues[#self.keyvalues].value
    end

    --NOTE: If the curve is too wild, there will be multiple spots with the same X coords.  ex, the curve around the pipe loops back: _/|/
    --I can't think of a good way to fix this, I think it's just a consequence of trying to map to xy coords

    for i = 2, #self.derived.Bezier_Samples, 1 do
        if key <= self.derived.Bezier_Samples[i].key then
            -- get the percent from prev to next key
            local percent = GetScaledValue(0, 1, self.derived.Bezier_Samples[i - 1].key, self.derived.Bezier_Samples[i].key, key)

            -- get the corresponding value along the two points
            return LERP(self.derived.Bezier_Samples[i - 1].value, self.derived.Bezier_Samples[i].value, percent)
        end
    end

    local dump = String_Join(", ", Select(self.derived.Bezier_Samples, function(o) return tostring(o.key) end))
    print("AnimationCurve.Evaluate: Didn't find key: " .. tostring(key) .. " | " .. dump)
end

function AnimationCurve:Min_Key()
     self.derived = this.EnsureDerivedCreated(self.derived, self.keyvalues)
     return self.derived.Min_Key
end
function AnimationCurve:Max_Key()
     self.derived = this.EnsureDerivedCreated(self.derived, self.keyvalues)
     return self.derived.Max_Key
end
function AnimationCurve:Min_Value()
     self.derived = this.EnsureDerivedCreated(self.derived, self.keyvalues)
     return self.derived.Min_Value
end
function AnimationCurve:Max_Value()
     self.derived = this.EnsureDerivedCreated(self.derived, self.keyvalues)
     return self.derived.Max_Value
end

function AnimationCurve:NumPoints()
    return #self.keyvalues
end

function AnimationCurve:Bezier()
    self.derived = this.EnsureDerivedCreated(self.derived, self.keyvalues)
    return self.derived.Bezier
end

----------------------------------- Private Methods -----------------------------------

function this.EnsureDerivedCreated(derived, keyvalues)
    if derived == nil then
        derived = this.BuildDerived(keyvalues)
    end

    return derived
end
function this.BuildDerived(keyvalues)
    if #keyvalues == 0 then
        return
        {
            Bezier = {},
            Bezier_Samples = {},
            Min_Key = 0,
            Max_Key = 0,
            Min_Value = 0,
            Max_Value = 0,
        }

    elseif #keyvalues == 1 then
        return
        {
            Bezier = {},
            Bezier_Samples = { keyvalues[1] },
            Min_Key = keyvalues[1].key,
            Max_Key = keyvalues[1].key,
            Min_Value = keyvalues[1].value,
            Max_Value = keyvalues[1].value,
        }

    elseif #keyvalues == 2 then
        return
        {
            Bezier =
            {
                BezierSegment:new(
                    Vector4.new(keyvalues[1].key, keyvalues[1].value, 0, 1),
                    Vector4.new(keyvalues[2].key, keyvalues[2].value, 0, 1),
                    {})
            },
            Bezier_Samples = { keyvalues[1], keyvalues[2] },
            Min_Key = keyvalues[1].key,
            Max_Key = keyvalues[2].key,
            Min_Value = keyvalues[1].value,
            Max_Value = keyvalues[2].value,
        }
    end

    local segments = this.BuildBezier(keyvalues)

    return
    {
        Bezier = segments,

        Bezier_Samples = this.BuildBezierSamples(keyvalues, segments),

        Min_Key = Min(keyvalues, function(o) return o.key end),
        Max_Key = Max(keyvalues, function(o) return o.key end),
        Min_Value = Min(keyvalues, function(o) return o.value end),
        Max_Value = Max(keyvalues, function(o) return o.value end),
    }
end
function this.BuildBezier(keyvalues)
    local points = {}
    for i = 1, #keyvalues, 1 do
        table.insert(points, Vector4.new(keyvalues[i].key, keyvalues[i].value, 0, 1))
    end

    return GetBezierSegments(points, 0.12, false)
end
function this.BuildBezierSamples(keyvalues, segments)
    local total_len_keys = keyvalues[#keyvalues].key - keyvalues[1].key;

    -- Find the closest distance between keys
    local closest_key_dist = 1000000000
    for i = 1, #keyvalues - 1, 1 do
        local dist = keyvalues[i + 1].key - keyvalues[i].key        -- the list is already sorted

        if dist < closest_key_dist then
            closest_key_dist = dist
        end
    end

    if IsNearZero(closest_key_dist) then
        closest_key_dist = 0.01
    end

    -- Get more samples than the keyvalues
    local count = math.min(math.ceil((total_len_keys / closest_key_dist) * 16), 144)

    local points = GetBezierPoints_Segments(count, segments)

    local retVal = {}

    for i = 1, #points, 1 do
        table.insert(retVal, { key = points[i].x, value = points[i].y })
    end

    return retVal
end