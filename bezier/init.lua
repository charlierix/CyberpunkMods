require "core/bezier"
require "core/bezier_segment"
require "core/debug_render_logger"
require "core/math_basic"
require "core/math_vector"
extern_json = require "external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

local this = {}

registerHotkey("BezierTester_Single", "single", function()
    local log = this.GetLogger()

    local from = GetRandomVector_Spherical(0, 4)
    local to = GetRandomVector_Spherical(0, 4)

    log:Add_Dot(from, "end")
    log:Add_Dot(to, "end")

    local controls = {}
    local count = math.random(1, 6)
    log:WriteLine_Global("count: " .. tostring(count))
    for i = 1, count, 1 do
        table.insert(controls, GetRandomVector_Spherical(0, 4))
        log:Add_Dot(controls[#controls], "control")
    end

    local bezier_seg = BezierSegment:new(from, to, controls)

    -- These are some other overloads.  Creating an instance of BezierSegment is really only needed when making a
    -- path through multiple bezier segments (the multi hotkey example)
    --local samples = GetBezierPoints_SingleControl(36, from, controls[1], to)
    --local samples = GetBezierPoints_TwoControl(36, from, controls[1], controls[2], to)
    --local samples = GetBezierPoints_MultiControl(36, from, controls, to)
    --local samples = GetBezierPoints_ControlPoints(36, bezier_seg.combined)

    local samples = GetBezierPoints_Segment(36, bezier_seg)

    for i = 1, #samples, 1 do
        log:Add_Dot(samples[i], "sample")
    end

    log:Save("single")
end)

registerHotkey("BezierTester_Multi", "multi", function()
    local log = this.GetLogger()

    local endpoints = {}
    local count = math.random(3, 6)
    for i = 1, count, 1 do
        table.insert(endpoints, GetRandomVector_Spherical(0, 4))
        log:Add_Dot(endpoints[#endpoints], "end")
    end

    --table.insert(endpoints, endpoints[1])       -- this would cause the call to open detect a closed path (circle)

    local beziers = nil
    if math.random(2) == 1 then
        log:WriteLine_Global("open path")
        beziers= GetBezierSegments(endpoints, 0.2, false)
    else
        log:WriteLine_Global("closed path")
        beziers = GetBezierSegments(endpoints, 0.3, true)
    end

    for i = 1, #beziers, 1 do
        for j = 1, #beziers[i].control_points, 1 do
            log:Add_Dot(beziers[i].control_points[j], "control")
        end
    end

    local samples = GetBezierPoints_Segments(72, beziers)
    for i = 1, #samples, 1 do
        log:Add_Dot(samples[i], "sample")
    end

    log:Save("multi")
end)

function this.GetLogger()
    local log = DebugRenderLogger:new(true)

    log:DefineCategory("end", "000", 1.5)
    log:DefineCategory("control", "BA655F", 1.25)
    log:DefineCategory("sample", "A2D7FC", 1)

    return log
end