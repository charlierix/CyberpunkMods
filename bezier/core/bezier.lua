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
    local _, counts, current_count = this.GetTotalLength3(segments, count)

    while current_count ~= count do
        local densities = this.GetDensities(segments, counts)

        if current_count < count then
            this.AddCountToSegment(counts, densities)
            current_count = current_count + 1
        else
            this.RemoveCountFromSegment(counts, densities)
            current_count = current_count - 1
        end
    end

    this.EnsureCountsHaveEnds(counts, segments)

    return this.GetSamples(segments, counts)
end
-- Returns points across several segment definitions (linked together into a single path).  count is the total number of sample points to return
--
-- The points are evenly distributed (line segment length between two points is the same).  This looks good for
-- sweeping curves, but pinched curves don't have enough points at the pinch point and look jagged
function GetBezierPoints_Segments_UniformDistribution(count, segments)
    local retVal = {}

    table.insert(retVal, segments[1].end0)

    local percents = {}
    for i = 2, count - 1, 1 do
        table.insert(percents, (i - 1) / (count - 1))
    end

    local normalized_percents = this.ConvertToNormalizedPositions_TotalToLocal(percents, segments)

    for i = 1, #normalized_percents, 1 do
        -- Calculate the bezier point
        table.insert(retVal, GetBezierPoint_ControlPoints(normalized_percents[i].Segment_Local_Percent, segments[normalized_percents[i].Segment_Index].combined))
    end

    table.insert(retVal, segments[#segments].end1)     --NOTE: If the segment is a closed curve, this is the same point as retVal[1].  May want a boolean that tells whether the last point should be replicated

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
        return this.GetBezierSegments_Open(ends, along)
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

    local adjusted_along_1, adjusted_along_2 = this.GetAdjustedRatios(ends[#ends], ends[1], ends[2], along)
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

    return retVal
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

    return retVal
end

-- p1,p2,p3 are points (Vector4)
-- along is percent along each line segment (a length to make the control point away from end point)
function this.GetAdjustedRatios(p1, p2, p3, along)
    local len_12 = math.sqrt(GetVectorDiffLengthSqr(p2, p1))
    local len_23 = math.sqrt(GetVectorDiffLengthSqr(p3, p2))

    local v12 = Vector4.new((p2.x - p1.x) / len_12, (p2.y - p1.y) / len_12, (p2.z - p1.z) / len_12, 1)      -- needs to be a unit vector for the dot product to make sense
    local v23 = Vector4.new((p3.x - p2.x) / len_23, (p3.y - p2.y) / len_23, (p3.z - p2.z) / len_23, 1)

    -- Adjust at extreme angles
    local dot = DotProduct3D(v12, v23)

    if dot < -0.9 then
        along = GetScaledValue(along / 3, along, -1, -0.9, dot)     -- pinched.  need to reduce so it doesn't get so loopy

    elseif dot > 0.25 then
        along = GetScaledValue(along, along * 2, 0.25, 1, dot)       -- obtuse.  expanding so it becomes a smoother curve
    end

    if along > 0.5 then
        along = 0.5     -- if length goes beyond midpoint, the final curve looks bad
    end

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

    local control_line_unit
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
function this.GetTotalLength3(segments, count)
    local total_len = 0

    for i = 1, #segments, 1 do
        total_len = total_len + segments[i].length_quick
    end

    local counts = {}
    local current_count = 0

    for i = 1, #segments, 1 do
        local ratio = segments[i].length_quick / total_len
        table.insert(counts, Round(count * ratio))

        current_count = current_count + counts[#counts]
    end

    return total_len, counts, current_count
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

-- This walks through the list of desired percents and returns percents to use that when applied to the bezier
-- will be that desired percent
--
-- This is a loop for optimization reasons, which requires the percents to be streamed in ascending order
--private static IEnumerable<NormalizedPosPointer> ConvertToNormalizedPositions(IEnumerable<double> total_percents, BezierSegment3D_wpf[] segments)
function this.ConvertToNormalizedPositions_TotalToLocal(total_percents, segments)
    local total_len, cumulative_lengths = this.GetCumulativeLengths(segments)

    local prev_percent = 0
    local segment_index = 1
    local sample_index = 1

    local retVal = {}

    for i = 1, #total_percents, 1 do
        if total_percents[i] < prev_percent then
            LogError("ConvertToNormalizedPositions: The percents must be passed in ascending order.  current: " .. tostring(total_percents[i]) .. ", prev: " .. tostring(prev_percent))
        end

        prev_percent = total_percents[i]

        -- Get the location along the entire path
        local portion_total_len = total_len * total_percents[i]

        -- Advance to the appropriate segment
        while cumulative_lengths[segment_index + 1] < portion_total_len do
            segment_index = segment_index + 1
        end

        -- Get the percent of the current segment
        local local_len = portion_total_len - cumulative_lengths[segment_index]
        local local_percent_desired = local_len / segments[segment_index].length_quick
        local local_percent_actual = this.GetInputForOutput(local_percent_desired, segments[segment_index].percents)

        table.insert(retVal,
        {
            Desired_Index = sample_index,
            Total_Percent = total_percents[i],
            Segment_Index = segment_index,
            Segment_Local_Percent = local_percent_actual,
        })

        sample_index = sample_index + 1
    end

    return retVal
end
--private static IEnumerable<NormalizedPosPointer> ConvertToNormalizedPositions(IEnumerable<(int segment_index, double percent_along_segment)> local_percents, BezierSegment3D_wpf[] segments)
function this.ConvertToNormalizedPositions_LocalToTotal(local_percents, segments)
    local total_len, cumulative_lengths = this.GetCumulativeLengths(segments)

    local prev_index = 1
    local prev_percent = 0
    local sample_index = 1

    local retVal = {}

    for i = 1, #local_percents, 1 do
        if local_percents[i].segment_index < prev_index or (local_percents[i].segment_index == prev_index and local_percents[i].percent_along_segment < prev_percent) then
            LogError("The percents must be passed in ascending order.  current: " .. tostring(local_percents[i].segment_index) .. " - " .. tostring(local_percents[i].percent_along_segment) .. ", prev: " .. tostring(prev_index) .. " - " .. tostring(prev_percent))
        end

        prev_index = local_percents[i].segment_index
        prev_percent = local_percents[i].percent_along_segment

        local from_len = cumulative_lengths[local_percents[i].segment_index]
        local to_len = cumulative_lengths[local_percents[i].segment_index + 1]      -- there is one more entry in cumulative_lengths.  Element 0 is always 0

        local lerp_len = LERP(from_len, to_len, local_percents[i].percent_along_segment)

        table.insert(retVal,
        {
            Desired_Index = sample_index,
            Total_Percent = lerp_len / total_len,
            Segment_Index = local_percents[i].segment_index,
            Segment_Local_Percent = local_percents[i].percent_along_segment,
        })

        sample_index = sample_index + 1
    end

    return retVal
end

--private static (double total_len, double[] cumulative_lengths) GetCumulativeLengths(BezierSegment3D_wpf[] segments)
function this.GetCumulativeLengths(segments)
    -- Get the total length of the curve
    local total_len = 0
    local cumulative_lengths = {}

    table.insert(cumulative_lengths, 0)

    for i = 1, #segments, 1 do
        total_len = total_len + segments[i].length_quick
        table.insert(cumulative_lengths, cumulative_lengths[i] + segments[i].length_quick)
    end

    return total_len, cumulative_lengths
end

-- For percents, see BezierSegment.this.GetInputOutputPercents
--private static double GetInputForOutput(double output, (double input, double output)[] percents)
function this.GetInputForOutput(output, percents)
    if output <= 0 then
        return 0
    elseif output >= 1 then
        return 1
    end

    for i = 1, #percents, 1 do
        if output <= percents[i].output then
            return GetScaledValue(percents[i - 1].input, percents[i].input, percents[i - 1].output, percents[i].output, output)
        end
    end

    LogError("GetInputForOutput: Couldn't find input for output: " .. tostring(output))
end

function this.GetDensities(segments, counts)
    local retVal = {}

    for i = 1, #segments, 1 do
        table.insert(retVal,
        {
            Index = i,
            Density_Minus = (counts[i] - 1) / segments[i].length_quick,
            Density_Current = counts[i] / segments[i].length_quick,
            Density_Plus = (counts[i] + 1) / segments[i].length_quick,
        })
    end

    return retVal
end

function this.AddCountToSegment(counts, densities)
    --#region NOPE

    --var best = densities.
    --    OrderBy(o => o.Density_Plus).
    --    ToArray();

    --var projections = Enumerable.Range(0, densities.Length).
    --    Select(o => densities.
    --        Select(p => new
    --        {
    --            item = p,
    --            density = p.Index == o ?
    --                p.Density_Plus :
    --                p.Density_Current,
    --        }).
    --        OrderBy(p => p.density).
    --        ToArray()).
    --    Select((o,i) => new
    --    {
    --        index = i,
    --        count_prev = counts[i],
    --        count_new = counts[i] + 1,
    --        projected_densities = o,
    --        gap = o[^1].density - o[0].density,
    --    }).
    --    OrderBy(o => o.gap).
    --    ToArray();


    --var window = new Debug3DWindow();

    --var graphs = projections.
    --    Select(o => Debug3DWindow.GetGraph(o.projected_densities.Select(p => p.density).ToArray(), o.index.ToString())).
    --    ToArray();

    --window.AddGraphs(graphs, new Point3D(), 1);

    --window.Show();

    --counts[projections[0].index]++;

    --#endregion

    -- In this case, add to the one with the lowest density
    local best_index = -1
    local best_density = 1000000        --math.maxinteger      -- maxinteger is nil

    for i = 1, #densities, 1 do
        if densities[i].Density_Current < best_density then
            best_index = densities[i].Index     -- probably the same as i
            best_density = densities[i].Density_Current
        end
    end

    counts[best_index] = counts[best_index] + 1
end
function this.RemoveCountFromSegment(counts, densities)
    --#region NOPE

    --var best = densities.
    --    OrderByDescending(o => o.Density_Current).
    --    ToArray();

    -- In this case, use the one that after removing, it's still the highest density (it's the segment that will have the least impact of removal)
    --NO: need to use aspects of the projected query
    --var best = densities.
    --    OrderByDescending(o => o.Density_Minus).        
    --    ToArray();

    --counts[best[0].Index]--;



    --var projections = Enumerable.Range(0, densities.Length).
    --    Select(o => densities.
    --        Select(p => new
    --        {
    --            item = p,
    --            density = p.Index == o ?
    --                p.Density_Minus :
    --                p.Density_Current,
    --        }).
    --        OrderByDescending(p => p.density).
    --        ToArray()).
    --    Select((o, i) => new
    --    {
    --        index = i,
    --        count_prev = counts[i],
    --        count_new = counts[i] - 1,
    --        projected_densities = o,
    --        gap = o[0].density - o[^1].density,
    --    }).
    --    OrderBy(o => o.gap).
    --    ToArray();


    --var window = new Debug3DWindow();

    --var graphs = projections.
    --    Select(o => Debug3DWindow.GetGraph(o.projected_densities.Select(p => p.density).ToArray(), o.index.ToString())).
    --    ToArray();

    --window.AddGraphs(graphs, new Point3D(), 1);

    --window.Show();

    --counts[projections[0].index]--;

    --#endregion



    -- Remove the index that will have the least impact
    -- var projections = Enumerable.Range(0, densities.Length).
    --     Select(o => densities.
    --         Select(p => new
    --         {
    --             item = p,
    --             density = p.Index == o ?
    --                 p.Density_Minus :
    --                 p.Density_Current,
    --         }).
    --         OrderByDescending(p => p.density).
    --         ToArray()).
    --     Select((o, i) => new
    --     {
    --         index = i,
    --         projected_densities = o,        -- this is what the densities look like with that single index removed
    --         lowest_density = o.Min(p => p.density),
    --     }).
    --     OrderByDescending(o => o.lowest_density).
    --     ToArray();

    local projections1 = {}

    for i = 1, #densities, 1 do
        table.insert(projections1, this.RemoveCountFromSegment_Projection1(i, densities))
    end

    local projections2 = {}

    for i = 1, #projections1, 1 do
        table.insert(projections2,
        {
            index = i,
            projected_densities = projections1[i],      -- this is what the densities look like with that single index removed
            lowest_density = Min(projections1[i], function(o) return o.density end),
        })
    end

    table.sort(projections2, function(a, b) return a.lowest_density > b.lowest_density end)

    counts[projections2[1].index] = counts[projections2[1].index] - 1
end
function this.RemoveCountFromSegment_Projection1(index, densities)
    local retVal = {}

    for i = 1, #densities, 1 do
        local density
        if densities[i].Index == index then
            density = densities[i].Density_Minus
        else
            density = densities[i].Density_Current
        end

        table.insert(retVal,
        {
            item = densities[i],
            density = density,
        })
    end

    table.sort(retVal, function(a, b) return a.density > b.density end)

    return retVal
end

function this.EnsureCountsHaveEnds(counts, segments)
    local first = false
    if counts[1] == 0 then
        this.RemoveCountFromSegment(counts, this.GetDensities(segments, counts))
        first = true
    end

    -- There's no need to add to the last, since in GetSamples, it adds one to all but the first segment
    --bool last = false;
    --if (counts.Length > 0 && counts[^1] == 0)
    --{
    --    RemoveCountFromSegment(counts, getDensities(counts));
    --    last = true;
    --}

    if first then
        counts[1] = counts[1] + 1
    end

    --if(last)
    --    counts[^1]++;
end

function this.GetSamples(segments, counts)        --, is_closed)
    local retVal = {}

    for i = 1, #segments, 1 do
        local count_adjusted = counts[i]
        local take_first = true

        if i > 1 then  -- || is_closed)        -- turns out the first point of the first segment is needed
            -- The first point of i is the same as the last point of i-1.  If this is closed, then the last
            -- point of ^1 will be used as the first point of 0
            count_adjusted = count_adjusted + 1
            take_first = false
        end

        if count_adjusted == 0 then
            -- this will happen if a segment is so short compared to other segments that it becomes a rounding error

        elseif count_adjusted == 1 then
            if i == 1 then
                table.insert(retVal, segments[i].end0)
            elseif i == #segments then
                table.insert(retVal, segments[i].end1)
            else
                table.insert(retVal, Vector4.new(segments[i].end0.x + segments[i].end1.x / 2, segments[i].end0.y + segments[i].end1.y / 2, segments[i].end0.z + segments[i].end1.z / 2, 1))        -- just take the average of the two
            end

        else
            local points = GetBezierPoints_Segment(count_adjusted, segments[i])

            local start = 1
            if not take_first then
                start = 2
            end

            for j = start, #points, 1 do
                table.insert(retVal, points[j])
            end
        end
    end

    return retVal
end