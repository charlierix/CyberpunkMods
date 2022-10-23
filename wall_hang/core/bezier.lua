local this = {}

------------------ Get points along the curve (at regular intervals) ------------------

function GetBezierPoints_SingleControl(count, from, control, to)
    return GetBezierPoints_ControlPoints(count, { from, control, to})
end
function GetBezierPoints_TwoControl(count, from, control0, control1, to)
    return GetBezierPoints_ControlPoints(count, { from, control0, control1, to})
end
function GetBezierPoints_MultiControl(count, from, controls, to)
    local control_points = {}

    table.insert(control_points, from)

    for i = 1, #controls, 1 do
        table.insert(control_points, controls[i])
    end

    table.insert(control_points, to)

    return GetBezierPoints_ControlPoints(count, control_points)
end
function GetBezierPoints_ControlPoints(count, control_points)
    if not control_points or #control_points == 0 then
        return this.GetRepeatingArray(count, Vector4.new(0, 0, 0, 1))      -- nothing passed in, return 0s
    elseif #control_points == 1 then
        return this.GetRepeatingArray(count, control_points[1])     -- only a single point passed in
    end

    local retVal = {}

    table.insert(retVal, control_points[1])

    for i = 1, count - 2, 1 do
        table.insert(retVal, GetBezierPoint_ControlPoints(i / (count - 1), control_points))
    end

    table.insert(retVal, control_points[#control_points])

    return retVal
end
function GetBezierPoints_Segment(count, segment)
    return GetBezierPoints_ControlPoints(count, segment.combined)
end
function GetBezierPoints_Segments(count, segments)
    local total_len, cumulative_lengths = this.GetTotalLength2(segments)

    local retVal = {}

    table.insert(retVal, segments[1].end0)

    local index = 1

    for i = 2, count - 1, 1 do
        -- Get the location along the entire path
        local total_percent = (i - 1) / (count - 1)
        local portion_total_len = total_len * total_percent

        -- Advance to the appropriate segment
        while cumulative_lengths[index + 1] < portion_total_len do
            index = index + 1
        end

        -- Get the percent of the current segment
        local local_len = portion_total_len - cumulative_lengths[index]
        local local_percent = local_len / segments[index].length_quick

        -- Calculate the bezier point
        table.insert(retVal, GetBezierPoint_ControlPoints(local_percent, segments[index].combined))
    end

    table.insert(retVal, segments[#segments].end1)      --NOTE: If the segment is a closed curve, this is the same point as retVal[0].  May want a boolean that tells whether the last point should be replicated

    return retVal
end

------------------------- Get a single point along the curve --------------------------

-- takes an array of BezierSegment
-- percent is the percent across the whole path
function GetBezierPoint_Segments(percent, segments)
    --TODO: If the bezier is closed, make it circular
    if percent <= 0 then
        return segments[1].end0
    elseif percent >= 1 then
        return segments[#segments].end1
    end

    local totalLength = this.GetTotalLength1(segments)

    local from_percent = 0
    for i = 1, #segments, 1 do
        local to_percent = from_percent + (segments[i].length_quick / totalLength)

        if percent >= from_percent and percent <= to_percent then
            local local_percent = ((percent - from_percent) * totalLength) / segments[i].length_quick

            return GetBezierPoint_Segment(local_percent, segments[i])
        end

        from_percent = to_percent
    end

    return segments[#segments].end1     -- execution should never get here
end
-- takes an instance of BezierSegment
function GetBezierPoint_Segment(percent, segment)
    return GetBezierPoint_ControlPoints(percent, segment.combined)
end
-- control_points is an array of Vector4
-- The first and last points are the endpoints of the line segment.  The interior points control the curve
-- The line will touch the first and last, but not the interior control points
function GetBezierPoint_ControlPoints(percent, control_points)
    -- http://www.cubic.org/docs/bezier.htm

    if not control_points or #control_points == 0 then
        return Vector4.new(0, 0, 0, 1)      -- nothing passed in, return 0
    elseif #control_points == 1 then
        return control_points[1]     -- only a single point passed in
    end

    local prev = control_points
    local current = nil

    for outer = #control_points, 2, -1 do
        current = {}

        for inner = 1, outer - 1, 1 do
            current[inner] = LERP_vec4(prev[inner], prev[inner + 1], percent)
        end

        prev = current
    end

    return current[1]       -- by the time execution gets here, the array only has one element
end

----------------------------------- Bezier Builders -----------------------------------

-- This is a helper method that creates a bezier definition that runs through a set of points
--
-- ends (Vector4):
--      These are the end points that the beziers run through
-- along (float):
--      This is how far out the control points should be pulled from the end points (it is a percent of that line segment's length)
--      Values between 0.1 and 0.25 give good results
-- isClosed:
--      True: The assumption is that ends[1] and ends[len] aren't the same point.  This will add an extra segment to create a closed curve.
--      False: This method compares ends[1] and ends[len].  If they are the same point, it makes a closed curve.  If they are different, it makes an open curve.
-- returns:
--      array of BezierSegment
function GetBezierSegments(ends, along, isClosed)
    if isClosed then
        return this.GetBezierSegments_Closed(ends, along)
    end

    if #ends > 2 and IsNearValue_vec4(ends[1], ends[#ends]) then
        local ends_closed = table.move(ends, 1, #ends-1, 1, {})
        return this.GetBezierSegments_Closed(ends_closed, along)     -- removing the last point, which is redundant
    else
        return this.GetBezierSegments_Open(ends, along);
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetBezierSegments_Closed(ends, along)
    --NOTE: The difference between closed and open is closed has one more segment that loops back to zero (and a control point for point zero)

    -- Precalculate the control points
    local controls = {}
    for i = 2, #ends, 1 do
        local last_index
        if i == #ends then
            last_index = 1
        else
            last_index = i + 1
        end

        local adjusted_along_1, adjusted_along_2 = this.GetAdjustedRatios(ends[i - 1], ends[i], ends[last_index], along)

        table.insert(controls, this.GetControlPoints_Middle(ends[i - 1], ends[i], ends[last_index], adjusted_along_1, adjusted_along_2))
    end

    local adjusted_along_1, adjusted_along_2 = this.GetAdjustedRatios(ends[#ends], ends[0], ends[1], along)
    local extra_control = this.GetControlPoints_Middle(ends[#ends], ends[1], ends[2], adjusted_along_1, adjusted_along_2)      -- loop back

    -- Build the return segments
    local retVal = {}

    for i = 1, #ends, 1 do
        local ctrl0
        if i == 1 then
            ctrl0 = extra_control[2]
        else
            ctrl0 = controls[i - 1][2]
        end

        local ctrl1
        if i == #ends then
            ctrl1 = extra_control[1]
        else
            ctrl1 = controls[i][1]
        end

        local lastIndex
        if i == #ends then
            lastIndex = 1
        else
            lastIndex = i + 1
        end

        table.insert(retVal, BezierSegment:new(ends[i], ends[lastIndex], this.GetArray(ctrl0, ctrl1)))
    end

    return retVal;
end
function this.GetBezierSegments_Open(ends, along)
    -- Precalculate the control points
    local controls = {}

    for i = 2, #ends - 1, 1 do
        local adjusted_along_1, adjusted_along_2 = this.GetAdjustedRatios(ends[i - 1], ends[i], ends[i + 1], along)

        table.insert(controls, this.GetControlPoints_Middle(ends[i - 1], ends[i], ends[i + 1], adjusted_along_1, adjusted_along_2))
    end

    -- Build the return segments
    local retVal = {}

    for i = 1, #ends - 1, 1 do
        local ctrl0
        if i == 1 then
            ctrl0 = nil
        else
            ctrl0 = controls[i - 1][2]
        end

        local ctrl1
        if i == #ends - 1 then
            ctrl1 = nil
        else
            ctrl1 = controls[i][1]
        end

        table.insert(retVal, BezierSegment:new(ends[i], ends[i + 1], this.GetArray(ctrl0, ctrl1)))
    end

    return retVal;
end

-- p1,p2,p3 are points (Vector4)
-- along is percent along each line segment (a length to make the control point away from end point)
function this.GetAdjustedRatios(p1, p2, p3, along)
    local len_12 = math.sqrt(GetVectorDiffLengthSqr(p2, p1))
    local len_23 = math.sqrt(GetVectorDiffLengthSqr(p3, p2))

    -- The shorter segment gets the full amount, and the longer segment gets an adjusted amount

    if IsNearValue(len_12, len_23) then
        return along, along

    elseif len_12 < len_23 then
        return along, along * (len_12 / len_23)

    else
        return along * (len_23 / len_12), along
    end
end

-- This is a helper method to generate control points
--
-- A bezier curve will always go through the end points.  It will use the control points to pull it off the direct
-- line segment.
-- 
-- When two bezier segments are linked, the curve will be smooth if the two control points for the shared
-- end point are in a line.
-- 
-- This method takes the three end points, and returns the two control points for the middle end point (end2)
-- 
-- The returned control points will be colinear with end2
--
-- percent_along_12: This is the percent of the 1-2 segment's length
-- percent_along_23: This is the percent of the 2-3 segment's length
--
-- returns (two element array):
-- Item1: control point for end2 for the 1-2 bezier segment (this is the last point in control_points)
-- Item2: control point for end2 for the 2-3 bezier segment (this is the first point in control_points)
function this.GetControlPoints_Middle(end1, end2, end3, percent_along_12, percent_along_23)
    local dir21 = SubtractVectors(end1, end2)
    local dir23 = SubtractVectors(end3, end2)

    local dir21_len = GetVectorLength(dir21)
    local dir23_len = GetVectorLength(dir23)

    if IsNearZero(dir21_len) or IsNearZero(dir23_len) then
        -- Two of the points are sitting on top of each other
        return { end2, end2 }
    end

    local control_line = this.GetControlPoints_Middle_ControlLine(DivideVector(dir21, dir21_len), DivideVector(dir23, dir23_len))
    if not control_line then
        -- The directions are either on top of each other, or pointing directly away from each other, or
        -- some of the end points are the same.
        --
        -- Just return control points that are the same as the middle point.  This could be improved in the
        -- future if certain cases look bad
        return { end2, end2 }
    end

    local control_line_unit;
    if DotProduct3D(dir21, control_line) > 0 then
        -- Control line is toward end 1
        control_line_unit = ToUnit(control_line)
    else
        -- Control line is toward end 3
        control_line_unit = ToUnit(Negate(control_line))
    end

    local control21 = AddVectors(end2, MultiplyVector(control_line_unit, dir21_len * percent_along_12))
    local control23 = SubtractVectors(end2, MultiplyVector(control_line_unit, dir23_len * percent_along_23))

    return { control21, control23 }
end

function this.GetControlPoints_Middle_ControlLine(dir21_unit, dir23_unit)
    local dot = DotProduct3D(dir21_unit, dir23_unit)
    if IsNearValue(dot, 1) or IsNearValue(dot, -1) then
        return nil
    end

    local axis
    if IsNearValue(dot, -1) then
        -- The two lines are colinear.  Can't return null because the calling function will return arbitrary points which is wrong.  Come
        -- up with a random orth to one of the vectors so that the below portion of this function will choose accurate control points
        axis = GetArbitraryOrthogonal(dir21_unit)
    else
        axis = CrossProduct3D(dir21_unit, dir23_unit)
    end

    -- Get the vector directly between the two directions
    local between = RotateVector3D_axis_radian(dir21_unit, axis, Dot_to_Radians(dot) / 2)

    -- Now get the vector that is orthogonal to that between vector.  This is the line that
    -- the control points will be along
    return CrossProduct3D(between, axis)        -- length doesn't really matter for this.  It could also point in the exact opposite direction, and that wouldn't matter
end

function this.GetTotalLength1(segments)
    local retVal = 0

    for i = 1, #segments, 1 do
        retVal = retVal + segments[i].length_quick
    end

    return retVal
end
function this.GetTotalLength2(segments)

    local total_len = 0
    local cumulative_lengths = {}        -- this is one larger than #segments

    table.insert(cumulative_lengths, 0)

    for i = 2, #segments + 1, 1 do
        total_len = total_len + segments[i - 1].length_quick
        cumulative_lengths[i] = cumulative_lengths[i - 1] + segments[i - 1].length_quick
    end

    return total_len, cumulative_lengths
end

function this.GetRepeatingArray(count, value)
    local retVal = {}

    for i = 1, count, 1 do
        table.insert(retVal, value)
    end

    return retVal
end

-- Turns the two points into an array (either of the points could be nil)
function this.GetArray(p1, p2)
    local retVal = {}

    if p1 then
        table.insert(retVal, p1)
    end

    if p2 then
        table.insert(retVal, p2)
    end

    return retVal
end