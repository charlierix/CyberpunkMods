local this = {}

-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Main(vars_ui, const)
    local main = {}
    vars_ui.main = main

    main.changes = Changes:new()

    --main.title = Define_Title("Jetpack", const)        -- the title bar already says this

    --main.consoleWarning = this.Define_ConsoleWarning(const)       -- since jetpack doesn't have a hotkey for show/hide config, this warning seems more like noise than something useful


    main.modelist = this.Define_ModeList(const)



    main.okcancel = Define_OkCancelButtons(true, vars_ui, const)

    FinishDefiningWindow(main)
end

function ActivateWindow_Main(vars_ui, const)
    if not vars_ui.main then
        DefineWindow_Main(vars_ui, const)
    end

    local main = vars_ui.main

    main.changes:Clear()

    local items = {}
    for i = 1, 5, 1 do
        --table.insert(items, tostring(i))
        table.insert(items, ModeList_Item:new(nil))
    end

    main.modelist.items = items


    --vars_ui.keys:StopWatching()     -- doing this in case it came from the input bindings window (which put keys in a watching state)
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Main(isCloseRequested, vars, vars_ui, player, window, o, const)
    local main = vars_ui.main

    ------------------------- Finalize models for this frame -------------------------


    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(main.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(main.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    --Draw_Label(main.title, vars_ui.style.colors, vars_ui.scale)

    --Draw_Label(main.consoleWarning, vars_ui.style.colors, vars_ui.scale)

    Draw_StackPanel(main.modelist, vars_ui.style.listbox, window.left, window.top, vars_ui.scale)


    local _, isCloseClicked = Draw_OkCancelButtons(main.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)

    return not (isCloseRequested or isCloseClicked)       -- stop showing when they click the close button (or press config key a second time.  This main page doesn't have anything to save, so it's ok to exit at any time)
end

----------------------------------- Private Methods -----------------------------------

function this.Define_ConsoleWarning(const)
    -- Label
    return
    {
        text = "NOTE: buttons won't respond unless the console window is also open",

        position =
        {
            pos_x = 0,
            pos_y = 24,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.top,
        },

        color = "info",

        CalcSize = CalcSize_Label,
    }
end

function this.Define_ModeList(const)
    -- StackPanel
    return
    {
        invisible_name = "Main_Modes_List",

        -- These are populated for real in activate
        items = {},

        width = 340,
        --height = 490,
        height = 100,

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_StackPanel,
    }
end