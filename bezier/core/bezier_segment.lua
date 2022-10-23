local this = {}

BezierSegment = {}

function BezierSegment:new(end0, end1, control_points)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.end0 = end0
    obj.end1 = end1
    obj.control_points = control_points

    obj.combined = this.GetCombined(end0, end1, control_points)

    obj.length_quick = this.GetLengthQuick(obj.combined)

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

-- This is a rough approximation of the length of the bezier.  It will likely be shorter than the actual length
--
-- Some suggestions on how to do it right:
-- http://math.stackexchange.com/questions/12186/arc-length-of-b%C3%A9zier-curves
-- http://www.carlosicaza.com/2012/08/12/an-more-efficient-way-of-calculating-the-length-of-a-bezier-curve-part-ii/
function this.GetLengthQuick(combined)
    local retVal = 0

    for i = 1, #combined - 1, 1 do
        retVal = retVal + GetVectorDiffLengthSqr(combined[i], combined[i + 1])
    end

    return math.sqrt(retVal)
end