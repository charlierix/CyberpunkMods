--https://www.lua.org/pil/contents.html
--https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
--http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#numerical_error_and_result_codes

--https://github.com/yamashi/CyberEngineTweaks/blob/eb0f7daf2971ed480abf04355458cbe326a0e922/src/sol_imgui/README.md
--https://github.com/ocornut/imgui/blob/b493cae8c971843886d760bb816dcab661779d69/imgui.h
--https://github.com/ocornut/imgui/blob/25fbff2156640cc79e9a79db00522019b4a0420f/imgui_draw.cpp

--https://wiki.cybermods.net/cyber-engine-tweaks/console/functions
--https://redscript.redmodding.org/
--https://codeberg.org/adamsmasher/cyberpunk/src/branch/master

--https://github.com/jac3km4/redscript

require "debug_render_logger"
extern_json = require "external/json"       -- storing this in a global variable so that its functions must be accessed through that variable

registerHotkey("DebugRenderLoggerTestKey", "tester hotkey", function()

    --NOTE: Be sure to add a folder "!logs" (or change the constant at the top of the logger class)

    local log = DebugRenderLogger:new(true)

    log:WriteLine_Global("adding categories")

    log:DefineCategory("a", "DB0", 0.8)
    log:DefineCategory("b", "0FF", 3.14159)

    log:WriteLine_Global("first frame")

    log:Add_Dot(Vector4.new(0, 0, 0, 1))
    log:Add_Dot(Vector4.new(1, 0, 0, 1), nil, "F00")
    log:Add_Dot(Vector4.new(0, 1, 0, 1), nil, "0F0")
    log:Add_Dot(Vector4.new(0, 0, 1, 1), nil, "00F")

    log:WriteLine_Frame("hello")
    log:WriteLine_Frame("there", "888")
    log:WriteLine_Frame("everybody", "666", 1.5)

    log:WriteLine_Global("second frame", "F01830", 12)

    log:NewFrame("second", "222")

    log:Add_Line(Vector4.new(12, 0, 0, 1), Vector4.new(0, 12, 0, 1), "a")
    log:Add_Line(Vector4.new(24, 0, 0, 1), Vector4.new(0, 24, 0, 1), "b", "000", 8)
    log:Add_Circle(Vector4.new(0, 0, 0, 1), Vector4.new(0, 1, 0, 1), 3, nil, nil, nil, "a circle")

    log:NewFrame("third")

    log:Add_Square(Vector4.new(9, 9, -1, 1), Vector4.new(0, -1, -1, 1), 3, 8)

    log:WriteLine_Global("finished", nil, 0.5)

    log:Save()
end)
