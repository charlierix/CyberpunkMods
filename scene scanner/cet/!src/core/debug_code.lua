function PopulateDebug(debug, o, vars, recorder)
    local pointCount = 0
    if recorder then
        pointCount = #recorder.points
    end

    debug.point_count = pointCount

    debug.timer = Round(o.timer, 1)
end