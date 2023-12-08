local this = {}

BezierSegment = {}

-- end0, end1: these are begin and end points of the bezier segment (Vector4)
-- control_points: these are used to pull the curve (Vector4)
-- sample_count_mult: can be left nil.  Used by GetBezierPoints_Segments to more evenly distribute points across the whole path
function BezierSegment:new(end0, end1, control_points, sample_count_mult)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.end0 = end0
    obj.end1 = end1
    obj.control_points = control_points

    obj.combined = this.GetCombined(end0, end1, control_points)

    local sample_count = this.GetSampleCount(sample_count_mult)
    local percents, lengths, length_quick, samples = this.AnalyzeCurve(end0, end1, control_points, obj.combined, sample_count)

    obj.length_quick = length_quick
    obj.percents = percents
    obj.lengths = lengths
    obj.samples = samples       -- { percent_along, sample }[]

    return obj
end

function this.GetCombined(end0, end1, control_points)
    local retVal = {}

    table.insert(retVal, end0)

    if control_points then
        for i = 1, #control_points, 1 do
            table.insert(retVal, control_points[i])
        end
    end

    table.insert(retVal, end1)

    return retVal
end

function this.GetSampleCount(mult)
    local DEFAULT = 12

    if mult == nil then
        return DEFAULT
    else
        return math.ceil(DEFAULT * mult)
    end
end

-- Return vars
--(double input, double output)[] percents,
--double[] lengths,
--double length_quick,
--{ double percent_along, Point3D sample }[]
function this.AnalyzeCurve(end0, end1, controlPoints, combined, count)
    if not controlPoints or #controlPoints == 0 then        -- just a regular line segment
        return
            {
                { 0, 0 },
                { 1, 1 },
            },
            { math.sqrt(GetVectorDiffLengthSqr(end1, end0)) },
            math.sqrt(GetVectorDiffLengthSqr(end1, end0)),
            { end0, end1 }
    end

    local samples = GetBezierPoints_ControlPoints(count, combined)

    local lengths = this.GetSegmentLengths(samples)

    local length_quick = this.Sum(lengths)

    local percents = this.GetInputOutputPercents(samples, lengths, length_quick)

    local samples2 = this.GetSamples(samples)

    return percents, lengths, length_quick, samples2
end

function this.GetSegmentLengths(samples)
    local retVal = {}

    for i = 1, #samples - 1, 1 do
        table.insert(retVal, math.sqrt(GetVectorDiffLengthSqr(samples[i + 1], samples[i])))
    end

    return retVal
end

-- Returns
--(double input, double output)[]
function this.GetInputOutputPercents(samples, lengths, length_quick)
    local retVal = {}

    table.insert(retVal, { input = 0, output = 0 })

    local input_inc = 1 / (#samples - 1)
    local sum_input = 0
    local sum_output = 0

    for i = 1, #lengths - 1, 1 do       -- no need to calculate the last one, it's always going to become (1,1)
        sum_input = sum_input + input_inc
        sum_output = sum_output + lengths[i]

        table.insert(retVal, { input = sum_input, output = sum_output / length_quick })
    end

    table.insert(retVal, { input = 1, output = 1 })

    return retVal;
end

function this.Sum(values)
    local retVal = 0

    for i = 1, #values, 1 do
        retVal = retVal + values[i]
    end

    return retVal
end

function this.GetSamples(samples)
    local retVal = {}

    for i = 1, #samples, 1 do
        table.insert(retVal,
        {
            percent_along = i / #samples,
            sample = samples[i]
        })
    end

    return retVal
end