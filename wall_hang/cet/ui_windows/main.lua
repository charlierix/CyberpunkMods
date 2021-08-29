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

    --main.title = Define_Title("Wall Hang", const)        -- the title bar already says this

    main.consoleWarning = this.Define_ConsoleWarning(const)
    main.should_autoshow = this.Define_ShouldAutoShow(main.consoleWarning, const)

    main.input_bindings = this.Define_InputBindings(const)

    main.latch_wallhang = this.Define_LatchWallHang(const)
    main.latch_wallhang_help = this.Define_LatchWallHang_Help(main.latch_wallhang, const)

    main.okcancel = Define_OkCancelButtons(true, vars_ui, const)

    FinishDefiningWindow(main)
end

function ActivateWindow_Main(vars_ui, const)
    if not vars_ui.main then
        DefineWindow_Main(vars_ui, const)
    end

    vars_ui.main.changes:Clear()

    vars_ui.main.should_autoshow.isChecked = nil
    vars_ui.main.latch_wallhang.isChecked = nil

    vars_ui.keys:StopWatching()     -- doing this in case it came from the input bindings window (which put keys in a watching state)
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Main(isCloseRequested, vars, vars_ui, window, const)
    local main = vars_ui.main

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_ShouldAutoShow(main.should_autoshow, vars_ui)

    this.Refresh_LatchWallHang(main.latch_wallhang, vars)

    this.Refresh_IsDirty(main.okcancel, vars, main.latch_wallhang)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(main.render_nodes, vars_ui.style, vars_ui.line_heights)
    CalculatePositions(main.render_nodes, window.width, window.height, const)

    -------------------------------- Show ui elements --------------------------------

    --Draw_Label(main.title, vars_ui.style.colors)

    Draw_Label(main.consoleWarning, vars_ui.style.colors)

    if Draw_CheckBox(main.should_autoshow, vars_ui.style.checkbox, vars_ui.style.colors) then
        this.Update_ShouldAutoShow(main.should_autoshow, vars_ui, const)
    end

    if Draw_SummaryButton(main.input_bindings, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top) then
        TransitionWindows_InputBindings(vars_ui, const)
    end

    Draw_CheckBox(main.latch_wallhang, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(main.latch_wallhang_help, vars_ui.style.helpButton, window.left, window.top, vars_ui)

    local isOKClicked, isCloseClicked = Draw_OkCancelButtons(main.okcancel, vars_ui.style.okcancelButtons)
    if isOKClicked then
        this.Save(vars, main.latch_wallhang, const)
    end

    local shouldClose = isOKClicked or isCloseClicked or (isCloseRequested and not main.okcancel.isDirty)       -- they can't close with keyboard if dirty.  Once dirty, they must click Ok or Cancel
    return not shouldClose       -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

--NOTE: Define functions get called during init.  Refresh functions get called each frame that the config is visible

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

function this.Define_ShouldAutoShow(parent, const)
    -- CheckBox
    return
    {
        invisible_name = "Main_ShouldAutoShow",

        text = "Auto show config when opening console",

        isEnabled = true,

        position =
        {
            relative_to = parent,

            pos_x = 0,
            pos_y = 6,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        foreground_override = "info",

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_ShouldAutoShow(def, vars_ui)
    --NOTE: TransitionWindows_Main sets this to nil
    if def.isChecked == nil then
        def.isChecked = vars_ui.autoshow_withconsole
    end
end
function this.Update_ShouldAutoShow(def, vars_ui, const)
    -- In memory copy of the bool
    vars_ui.autoshow_withconsole = def.isChecked

    -- DB copy of the bool
    SetSetting_Bool(const.settings.AutoShowConfig_WithConsole, def.isChecked)
end

function this.Define_InputBindings(const)
    -- SummaryButton
    return
    {
        header_prompt = "Input Bindings",

        position =
        {
            pos_x = 48,
            pos_y = 72,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.top,
        },

        invisible_name = "Main_InputBindings",

        CalcSize = CalcSize_SummaryButton,
    }
end

function this.Define_LatchWallHang(const)
    -- CheckBox
    return
    {
        invisible_name = "Main_LatchWallHang",

        text = "Latch WallHang Key",

        isEnabled = true,

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_LatchWallHang(def, vars)
    --NOTE: ActivateWindow_Main sets this to nil
    if def.isChecked == nil then
        def.isChecked = vars.latch_wallhang
    end
end

function this.Define_LatchWallHang_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Main_LatchWallHang_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[checked: Once you jump, you only need to press the wall hang key once

uncheckd: The wall hang key must be held in

If latch is set, then pressing the key again will disengage (also jumping from the wall)]]

    return retVal
end

function this.Refresh_IsDirty(def, vars, latch_wallhang)
    local isDirty = false

    if vars.latch_wallhang ~= latch_wallhang.isChecked then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(vars, latch_wallhang, const)
    vars.latch_wallhang = latch_wallhang.isChecked
    SetSetting_Bool(const.settings.Latch_WallHang, vars.latch_wallhang)
end