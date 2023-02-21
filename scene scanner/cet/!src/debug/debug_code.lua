function PopulateDebug(debug, o, vars, recorder)
    local hitCount = 0
    if recorder then
        hitCount = #recorder.hits
    end

    debug.hit_count = hitCount

    debug.timer = Round(o.timer, 1)
end