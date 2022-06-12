local this = {}

-- Generates points inside the volume of a cone that are evenly distributed (they try to all
-- be the same distance from each other)
--
-- NOTE: The function is called cone, but it's a spherical cap, not flat
function GetConePointsEvenDistribution(count, axis, angle, minRadius, maxRadius, iterations, log)
    local points = this.GetInitialPoints(count, axis, 0, angle, minRadius, maxRadius)

    this.LogPoints(log, points)

    local axis_unit, orth_unit, dot_at_angle = this.GetExtraProps_Cone(axis, angle)

    this.DistributeCone(points, axis_unit, orth_unit, angle, dot_at_angle, minRadius, maxRadius, 0, iterations, log)

    return points
end

----------------------------------- Private Methods -----------------------------------

function this.GetInitialPoints(count, axis, minAngle, maxAngle, minRadius, maxRadius)
    local minRand = GetRandomForPhi(Degrees_to_Radians(minAngle))
    local maxRand = GetRandomForPhi(Degrees_to_Radians(maxAngle))
    minRand, maxRand = MinMax(minRand, maxRand)

    local rot = GetRotation(Vector4.new(0, 0, 1, 1), axis)

    local retVal = {}

    for i = 1, count do
        local theta = math.random() * 2 * math.pi
        local phi = GetPhiForRandom(GetScaledValue(minRand, maxRand, 0, 1, math.random()))
        local radius = minRadius + ((maxRadius - minRadius) * math.sqrt(math.random()))     -- without the square root, there is more chance at the center than the edges

        local sinPhi = math.sin(phi)

        retVal[i] = Vector4.new
        (
            radius * math.cos(theta) * sinPhi,
            radius * math.sin(theta) * sinPhi,
            radius * math.cos(phi)
        )

        retVal[i] = RotateVector3D(retVal[i], rot)
    end

    return retVal
end

-- Returns
--  axis.tounit
--  orth.tounit
--  dot product at angle
function this.GetExtraProps_Cone(axis, angle)
    local axis_unit = ToUnit(axis)
    local orth = ToUnit(GetArbitraryOrthogonal(axis_unit))

    local rotated = RotateVector3D_axis_angle(axis_unit, orth, angle)

    local dot = DotProduct3D(axis_unit, rotated)

    return axis_unit, orth, dot
end

function this.DistributeCone(points, axisUnit, orthUnit, angle, maxDotProduct, heightMin, heightMax, stopRadiusPercent, stopIterationCount, log)
    local MOVEPERCENT = 0.1

    this.CapToCone(points, axisUnit, orthUnit, angle, maxDotProduct, heightMin, heightMax)

    local aabb_min, aabb_max = GetAABB(points)

    local aabb_radius = GetVectorLength(SubtractVectors(aabb_max, aabb_min)) / 2
    local stopAmount = aabb_radius * stopRadiusPercent

    local minDistance = this.GetMinDistance_Cone(points, aabb_radius * 2)

    local heightMinSquared = heightMin * heightMin
    local heightMaxSquared = heightMax * heightMax

    for i = 1, stopIterationCount do
        local amountMoved = this.MoveStep_Cone(points, MOVEPERCENT, axisUnit, orthUnit, angle, maxDotProduct, heightMin, heightMax, heightMinSquared, heightMaxSquared, minDistance)

        this.LogPoints(log, points)

        if amountMoved < stopAmount then
            do return end
        end
    end
end

-- Applies forces to the points to push them away from each other, makes sure they stay inside the cone
--
-- Returns the largest distance that a point moved
function this.MoveStep_Cone(points, percent, axisUnit, orthUnit, angle, maxDotProduct, heightMin, heightMax, heightMinSquared, heightMaxSquared, minDistance)
    -- Find shortest pair lengths
    local pairs = this.GetShortestPair(points)
    if #pairs == 0 then
        return 0
    end

    -- Move the shortest pair away from each other (based on how far they are away from the avg)
    local avg = this.GetAverageLength(pairs)        -- pairs.Average(o => o.LengthRatio);

    -- Artificially increase repulsive pressure
    if avg < minDistance then
        avg = minDistance
    end

    local distToMoveMax = avg - pairs[1].length
    if IsNearZero(distToMoveMax) then
        return 0        -- Found equilbrium
    end

    for i = 1, #pairs do
        -- Only want to move them if they are less than average
        if pairs[i].length >= avg then
            break       -- they are sorted, so the rest of the list will also be greater
        end

        -- Figure out how far they should move
        local distToMoveRatio = avg - pairs[i].length
        local actualPercent = (distToMoveRatio / distToMoveMax) * percent       -- don't use the full percent.  Reduce it based on the ratio of this distance with the max distance

        local moveDist = distToMoveRatio * actualPercent * pairs[i].length

        -- Unit vector
        local displaceUnit
        if IsNearZero(pairs[i].length) then
            displaceUnit = GetRandomVector_Spherical_Shell(1)
        else
            displaceUnit = ToUnit(pairs[i].link)
        end

        -- Move points
        local point = points[pairs[i].index1]
        local displace = MultiplyVector(displaceUnit, moveDist * -0.5)
        point = AddVectors(point, displace)
        point = this.CapToCone_Point(point, axisUnit, orthUnit, angle, maxDotProduct, heightMin, heightMax, heightMinSquared, heightMaxSquared)
        points[pairs[i].index1] = point

        point = points[pairs[i].index2]
        displace = MultiplyVector(displaceUnit, moveDist * 0.5)
        point = AddVectors(point, displace)
        point = this.CapToCone_Point(point, axisUnit, orthUnit, angle, maxDotProduct, heightMin, heightMax, heightMinSquared, heightMaxSquared)
        points[pairs[i].index2] = point
    end

    return distToMoveMax
end

-- Returns an array of ShortPair objects:
--  int index1
--  int index2
--  double length
--  Vector3D link       (lua's vector4)
function this.GetShortestPair(points)
    local retVal = {}

    for outer = 1, #points do
        local currentShortest = nil

        -- Find the closest point to points[outer]
        for inner = 1, #points do
            if inner ~= outer then
                local link = SubtractVectors(points[inner], points[outer])
                local lenSqr = GetVectorLengthSqr(link)

                if currentShortest == nil or lenSqr < currentShortest.lenSqr then
                    currentShortest =
                    {
                        index = inner,
                        lenSqr = lenSqr,
                        link = link,
                    }
                end
            end
        end

        if currentShortest ~= nil then
            local index1, index2 = MinMax(outer, currentShortest.index)
            local foundExisting = false
            for i = 1, #retVal do
                if index1 == retVal[i].index1 and index2 == retVal[i].index2 then
                    foundExisting = true
                    break
                end
            end

            -- There could be two points close to each other (A-B, B-A), but a third point will be closer to only one of them (C-B).  Only store
            -- two link entries (A-B, B-C)
            if not foundExisting then
                local element =
                {
                    index1 = index1,
                    index2 = index2,
                    length = math.sqrt(currentShortest.lenSqr),
                    link = currentShortest.link,
                }

                InsertSorted(retVal, element, this.GetShortestPair_Comparer)
            end
        end
    end

    return retVal
end
function this.GetShortestPair_Comparer(item1, item2)
    if item1.length < item2.length then
        return -1
    elseif item1.length > item2.length then
        return 1
    else
        return 0
    end
end

function this.GetAverageLength(pairs)
    if #pairs == 0 then
        return 0
    end

    local total = 0

    for i = 1, #pairs do
        total = total + pairs[i].length
    end

    return total / #pairs
end

-- Without this, a 2 point request will never pull from each other
--
-- This was copied from MathND's cube
--
-- I didn't experiment too much with these values, but they seem pretty good
function this.GetMinDistance_Cone(points, aabb_length)
    -- When there is no min distance, they get too relaxed.  If there are a lot of points, there are still holes after lots of iterations - sort
    -- of like the points form mesh crystals with voids between.  There's no pressure to push into those voids
    --
    -- But with such a large min distance, there's more outward pressure and they fill the entire volume better

    --int dimensions = aabb.min.Length;
    local dimensions = 3

    local num_points = #points

    local numerator = aabb_length * 3 / 4
    local divisor = num_points ^ (1 / dimensions)       -- getting an error if directly using #points, may have just needed parenthesis:  attempt to perform arithmetic on local 'points' (a table value)

    return numerator / divisor
end

function this.CapToCone(points, axisUnit, orthUnit, angle, maxDotProduct, heightMin, heightMax)
    local heightMinSquared = heightMin * heightMin
    local heightMaxSquared = heightMax * heightMax

    for i = 1, #points do
        points[i] = this.CapToCone_Point(points[i], axisUnit, orthUnit, angle, maxDotProduct, heightMin, heightMax, heightMinSquared, heightMaxSquared)
    end
end
function this.CapToCone_Point(point, axisUnit, orthUnit, angle, maxDotProduct, heightMin, heightMax, heightMinSquared, heightMaxSquared)
    local hadChange = false

    local heightSquared = GetVectorLengthSqr(point)

    -- Handle zero length when not allowed
    if IsNearZero(heightSquared) then
        if heightMin > 0 then
            local new_points = this.GetInitialPoints(1, axisUnit, 0, angle, heightMin, heightMax)
            point = new_points[1]
        end

        return point
    end

    -- Cap Angle
    local posUnit = ToUnit(point)

    if DotProduct3D(posUnit, axisUnit) < maxDotProduct then
        local cross = CrossProduct3D(axisUnit, posUnit)
        posUnit = RotateVector3D_axis_angle(axisUnit, cross, angle)
        hadChange = true
    end

    -- Cap Height
    if heightSquared < heightMinSquared then
        heightSquared = heightMinSquared
        hadChange = true
    elseif heightSquared > heightMaxSquared then
        heightSquared = heightMaxSquared
        hadChange = true
    end

    -- Update Position
    if hadChange then
        point = MultiplyVector(posUnit, math.sqrt(heightSquared))
    end

    return point
end

function this.LogPoints(log, points)
    log:NewFrame()

    for i = 1, #points do
        log:Add_Dot(points[i])
    end
end