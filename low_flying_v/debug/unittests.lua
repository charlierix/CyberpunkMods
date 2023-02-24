function UnitTest_RollingBuffer()
    print("unit testing rolling buffer")
    local buffer = RollingBuffer:new(5)

    print("-------- a")
    buffer:Add("a")
    ReportTable(buffer:GetLatestEntries(3))

    print("-------- b")
    buffer:Add("b")
    ReportTable(buffer:GetLatestEntries(3))

    print("-------- c")
    buffer:Add("c")
    ReportTable(buffer:GetLatestEntries(3))

    print("-------- d")
    buffer:Add("d")
    ReportTable(buffer:GetLatestEntries(3))

    print("-------- e")
    buffer:Add("e")
    ReportTable(buffer:GetLatestEntries(3))

    print("-------- f")
    buffer:Add("f")
    ReportTable(buffer:GetLatestEntries(3))

    print("-------- g")
    buffer:Add("g")
    ReportTable(buffer:GetLatestEntries(3))

    print("-------- h")
    buffer:Add("h")
    ReportTable(buffer:GetLatestEntries(3))

    print("-------- i")
    buffer:Add("i")
    ReportTable(buffer:GetLatestEntries(3))

    print("-------- j")
    buffer:Add("j")
    ReportTable(buffer:GetLatestEntries(3))

    print("-------- k")
    buffer:Add("k")
    ReportTable(buffer:GetLatestEntries(3))
end

function UnitTest_KDashDetector(keys, o, vars, debug)
    -- these would be member variables
    local fastestSpeed = nil
    local wasKDash = false

    if keys.analog_y < -0.8 then
        fastestSpeed = nil
        wasKDash = false
        vars.kdash:Clear()
    end


    local currentSpeed = GetVectorLength(o.vel)
    if (not fastestSpeed) or (currentSpeed > fastestSpeed) then
        fastestSpeed = currentSpeed
    end

    debug.fastestSpeed = tostring(Round(fastestSpeed, 1))


    local shortestForward = vars.kdash:GetShortestForwardInterval()
    if shortestForward then
        debug.shortestForward = tostring(Round(shortestForward, 3))
    else
        debug.shortestForward = "never"
    end


    vars.kdash:DebugElapsedTimes(o.timer, debug)


    if not wasKDash then
        wasKDash = vars.kdash:WasKDashPerformed(o.timer, o.vel)
    end
    debug.wasKDash = wasKDash
end

function UnitTest_StickyList()
    local a = StickyList:new()

    -- three clean adds
    local entry = a:GetNewItem()
    entry.one = "a"
    entry.two = 8

    entry = a:GetNewItem()
    entry.one = "b"
    entry.two = 9

    entry = a:GetNewItem()
    entry.one = "c"
    entry.two = 10

    print("after 3 added")
    ReportStickyList_full(a)

    -- remove
    a:RemoveItem(1)     -- moves 3 into 1's spot

    print("")
    print("after remove")
    ReportStickyList_full(a)

    print("")
    entry = a:GetItem(3)     -- should print an error message

    -- add
    entry = a:GetNewItem()       -- reuses the 3rd entry

    print("")
    print("after add")
    ReportStickyList_full(a)        -- since the values weren't changed, the original a,8 should still be there

    print("")
    entry = a:GetItem(4)     -- should print an error message
end

function UnitTest_RaycastHitStorage()

    local sourceCall = function (k) print("source called: " .. k) end

    local a = RaycastHitStorage:new()
    ReportTable_lite(a, "", Override_ReportTable)

    print("")
    print("------------")
    print("")

    print("adding two points")
    a:Add(Vector4.new(0,0,0,1), sourceCall, "origin")
    a:Add(Vector4.new(12,12,12,1), sourceCall, "do")
    a:Add(Vector4.new(12.1,11.9,12,1), sourceCall, "almost do")

    print("")
    ReportTable_lite(a, "", Override_ReportTable)

    print("")
    print("tick 0.25")
    a:Tick(0.25)

    print("")
    print("getting nearby")
    local nearby = a:GetNearbyPoints(Vector4.new(10,10,10,1), 5)
    --ReportTable(nearby)
    ReportStickyList(nearby, "", Override_ReportTable)

    print("")
    print("tick 0.5")
    a:Tick(0.5)

    print("")
    print("tick 2")
    a:Tick(2)     -- 1st garbage increment

    print("")
    print("tick 4")
    a:Tick(4)

    print("")
    print("tick 6")
    a:Tick(6)     -- (0,0,0) will be collected, because 3 garbage counts occurred (it was never requested)

    print("")
    print("tick 8")
    a:Tick(8)     -- (12,12,12) will be collected, the dupe 12.1 will also be informed

    print("")
    ReportTable_lite(a, "", Override_ReportTable)

    print("")
    print("adding another point")
    a:Add(Vector4.new(3,3,3,1), sourceCall, "recycled")

    print("")
    ReportTable_lite(a, "", Override_ReportTable)

    print("")
    print("more ticks")
    a:Tick(10)
    a:Tick(12)
    a:Tick(14)
    a:Tick(16)

    print("")
    print("final table")
    ReportTable_lite(a, "", Override_ReportTable)
end

function UnitTest_LaserWorker_VecToInt()
    print("-1.5, 1: " .. tostring(LaserFinderWorker_GetIntKey(-1.5, 1)))
    print("-.5, 1: " .. tostring(LaserFinderWorker_GetIntKey(-0.5, 1)))
    print("0, 1: " .. tostring(LaserFinderWorker_GetIntKey(0, 1)))
    print(".5, 1: " .. tostring(LaserFinderWorker_GetIntKey(0.5, 1)))
    print("1.5, 1: " .. tostring(LaserFinderWorker_GetIntKey(1.5, 1)))

    print("")

    print("-3.5, 2: " .. tostring(LaserFinderWorker_GetIntKey(-3.5, 2)))
    print("-2.5, 2: " .. tostring(LaserFinderWorker_GetIntKey(-2.5, 2)))
    print("-1.5, 2: " .. tostring(LaserFinderWorker_GetIntKey(-1.5, 2)))
    print("-.5, 2: " .. tostring(LaserFinderWorker_GetIntKey(-0.5, 2)))
    print("0, 2: " .. tostring(LaserFinderWorker_GetIntKey(0, 2)))
    print(".5, 2: " .. tostring(LaserFinderWorker_GetIntKey(0.5, 2)))
    print("1.5, 2: " .. tostring(LaserFinderWorker_GetIntKey(1.5, 2)))
    print("2.5, 2: " .. tostring(LaserFinderWorker_GetIntKey(2.5, 2)))
    print("3.5, 2: " .. tostring(LaserFinderWorker_GetIntKey(3.5, 2)))
end

function UnitTest_LaserWorker_1(o)

    local fireDir = Vector4.new(0, 0, 1, 1)
    local a = LaserFinderWorker:new("test", o, nil, fireDir, 3, 1, nil, nil, nil)

    a:FireRays(Vector4.new(-1.5, -1.5, -1.5, 1))
    a:FireRays(Vector4.new(-0.5, -0.5, -0.5, 1))
    a:FireRays(Vector4.new(0, 0, 0, 1))
    a:FireRays(Vector4.new(0.5, 0.5, 0.5, 1))
    a:FireRays(Vector4.new(1.5, 1.5, 1.5, 1))
end

function UnitTest_LaserWorker_2(o)
    local fireDir = Vector4.new(0, 0, 1, 1)
    local a = LaserFinderWorker:new("test", o, nil, fireDir, 13, 3, 2, nil, nil)

    a:FireRays(Vector4.new(-2.1, 5.8, -12.3, 1))
end

function UnitTest_LaserWorker_3(o)
    local fireDir = Vector4.new(0, 0, 1, 1)
    local a = LaserFinderWorker:new("test", o, nil, fireDir, 13, 3, 2, nil, nil)

    print("garbageCollectInterval_seconds: " .. tostring(a.garbageCollectInterval_seconds))
    print("garbageCountThreshold: " .. tostring(a.garbageCountThreshold))

    print("tick 0.5")
    a:Tick(0.5)

    print("tick 1.0")
    a:Tick(1.0)

    print("firing -2.1, 5.8, -12.3")
    a:FireRays(Vector4.new(-2.1, 5.8, -12.3, 1))

    print("tick 1.5")
    a:Tick(1.5)

    print("tick 2.0")
    a:Tick(2.0)

    print("tick 2.5")
    a:Tick(2.5)

    print("tick 3.0")
    a:Tick(3.0)

    print("tick 3.5")
    a:Tick(3.5)

    print("tick 4.0")
    a:Tick(4.0)

    print("tick 4.5")
    a:Tick(4.5)

    print("tick 5.0")
    a:Tick(5.0)

    print("tick 5.5")
    a:Tick(5.5)

    print("tick 6.0")
    a:Tick(6.0)

    print("tick 6.5")
    a:Tick(6.5)

    print("tick 7.0")
    a:Tick(7.0)

    print("tick 7.5")
    a:Tick(7.5)

    print("tick 8.0")
    a:Tick(8.0)
end

function UnitTest_LaserWorker_4()
    local storage = RaycastHitStorage:new(o)

    local fireDir = Vector4.new(0, 0, 1, 1)
    local laser = LaserFinderWorker:new("test", o, storage, fireDir, 13, 3, 2, nil, nil)

    print("")
    print("storage tick 1 | " .. tostring(laser.hits:GetCount()))
    storage:Tick(1)

    print("")
    print("fire ray: -2.1, 5.8, -12.3")
    laser:FireRays(Vector4.new(-2.1, 5.8, -12.3, 1))

    print("")
    print("storage tick 2 | " .. tostring(laser.hits:GetCount()))
    storage:Tick(2)

    print("")
    print("storage tick 3 | " .. tostring(laser.hits:GetCount()))
    storage:Tick(3)

    print("")
    print("storage tick 4 | " .. tostring(laser.hits:GetCount()))
    storage:Tick(4)

    print("")
    print("storage tick 5 | " .. tostring(laser.hits:GetCount()))
    storage:Tick(6)

    print("")
    print("storage tick 7 | " .. tostring(laser.hits:GetCount()))
    storage:Tick(7)
end

function UnitTest_LaserManager(o)

    local storage = RaycastHitStorage:new()

    local lasercats = LaserFinderManager:new(o, storage)

    print("")
    print(tostring(o.timer) .. " | storage count: " .. tostring(storage.points:GetCount()))

    print("")
    o:Tick(1)
    lasercats:Tick()
    print(tostring(o.timer) .. " | storage count: " .. tostring(storage.points:GetCount()))

    print("")
    lasercats:Stop()
    print("stopped | storage count: " .. tostring(storage.points:GetCount()))

    print("")
    o:Tick(1)
    lasercats:Tick()
    print(tostring(o.timer) .. " | storage count: " .. tostring(storage.points:GetCount()))

    print("")
    o:Tick(1)
    lasercats:Tick()
    print(tostring(o.timer) .. " | storage count: " .. tostring(storage.points:GetCount()))

    print("")
    o:Tick(1)
    lasercats:Tick()
    print(tostring(o.timer) .. " | storage count: " .. tostring(storage.points:GetCount()))

    print("")
    o:Tick(1)
    lasercats:Tick()
    print(tostring(o.timer) .. " | storage count: " .. tostring(storage.points:GetCount()))
end

function UnitTest_FloatPlayer(const)
    local storage = RaycastHitStorage:new()

    local sourceCall = function (k) print("source called: " .. k) end

    storage:Add(Vector4.new(0, 0, 0, 1), sourceCall, "hello")
    storage:Add(Vector4.new(0, 0, 12, 1), sourceCall, "far")
    storage:Add(Vector4.new(1, 0, 0, 1), sourceCall, "there")

    local x, y, z = FloatPlayer_GetAcceleration(storage, Vector4.new(0, 1, 0, 1), const)

    print(tostring(x) .. ", " .. tostring(y) .. ", " .. tostring(z))
end

function UnitTest_DirFacing_Yaw(o, debug)
    o:GetCamera()

    debug.dirFacing = vec_str(o.lookdir_forward)
    debug.yaw = o.yaw

    debug.yoo = Vect_to_Yaw(o.lookdir_forward.x, o.lookdir_forward.y)


    local x, y = Yaw_to_Vect(o.yaw)
    debug.dirFooing = vec_str(Vector4.new(x, y, 0, 1))
end

function UnitTest_AngleBetween()
    local v1 = Vector4.new(1, 0, 0, 1)
    local v2 = Vector4.new(-1, 0, 0, 1)

    local rad = RadiansBetween2D(v1.x, v1.y, v2.x, v2.y)
    print("rad: " .. tostring(rad))

    local cross = CrossProduct2D(v1.x, v1.y, v2.x, v2.y)
    print("cross: " .. tostring(cross))
end

function UnitTest_Rotation()
    local x, y = RotateVector2D(1, 0, math.pi / 2)
    print(tostring(x) .. ", " .. tostring(y))

    x, y = RotateVector2D(1, 0, -math.pi / 2)
    print(tostring(x) .. ", " .. tostring(y))
end