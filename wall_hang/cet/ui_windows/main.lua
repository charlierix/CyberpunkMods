local this = {}

local MOUSE_MIN = -0.02
local MOUSE_MAX = -0.24
local STICK_MIN = 12
local STICK_MAX = 150

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

    main.jump_backward = this.Define_JumpBackward(main.latch_wallhang, const)
    main.jump_backward_help = this.Define_JumpBackward_Help(main.jump_backward, const)

    main.mouse_sensitivity = this.Define_MouseSensitivity(main.jump_backward, const)
    main.mouse_sensitivity_label = this.Define_MouseSensitivity_Label(main.mouse_sensitivity, const)
    main.mouse_sensitivity_help = this.Define_MouseSensitivity_Help(main.mouse_sensitivity_label, const)

    main.rightstick_sensitivity = this.Define_RightStickSensitivity(main.mouse_sensitivity, const)
    main.rightstick_sensitivity_label = this.Define_RightStickSensitivity_Label(main.rightstick_sensitivity, const)
    main.rightstick_sensitivity_help = this.Define_RightStickSensitivity_Help(main.rightstick_sensitivity_label, const)

    main.jumping = this.Define_Jumping(const)

    main.crawl_slide = this.Define_CrawlSlide(const)

    main.wall_attraction = this.Define_WallAttraction(const)

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
    vars_ui.main.mouse_sensitivity.value = nil
    vars_ui.main.rightstick_sensitivity.value = nil

    vars_ui.keys:StopWatching()     -- doing this in case it came from the input bindings window (which put keys in a watching state)
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Main(isCloseRequested, vars_ui, window, const, player_arcade)
    local main = vars_ui.main

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_ShouldAutoShow(main.should_autoshow, vars_ui)

    this.Refresh_LatchWallHang(main.latch_wallhang, const)

    this.Refresh_JumpBackward(main.jump_backward, const)

    this.Refresh_MouseSensitivity(main.mouse_sensitivity, const)

    this.Refresh_RightStickSensitivity(main.rightstick_sensitivity, const)

    this.Refresh_Jumping(main.jumping, player_arcade)

    this.Refresh_CrawlSlide(main.crawl_slide, player_arcade)

    this.Refresh_WallAttraction(main.wall_attraction, player_arcade)

    this.Refresh_IsDirty(main.okcancel, const, main.latch_wallhang, main.jump_backward, main.mouse_sensitivity, main.rightstick_sensitivity)

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

    Draw_CheckBox(main.jump_backward, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(main.jump_backward_help, vars_ui.style.helpButton, window.left, window.top, vars_ui)

    Draw_Label(main.mouse_sensitivity_label, vars_ui.style.colors)
    Draw_HelpButton(main.mouse_sensitivity_help, vars_ui.style.helpButton, window.left, window.top, vars_ui)
    Draw_Slider(main.mouse_sensitivity, vars_ui.style.slider)

    Draw_Label(main.rightstick_sensitivity_label, vars_ui.style.colors)
    Draw_HelpButton(main.rightstick_sensitivity_help, vars_ui.style.helpButton, window.left, window.top, vars_ui)
    Draw_Slider(main.rightstick_sensitivity, vars_ui.style.slider)

    if Draw_SummaryButton(main.jumping, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top) then
        TransitionWindows_Jumping(vars_ui, const)
    end

    if Draw_SummaryButton(main.crawl_slide, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top) then
        TransitionWindows_CrawlSlide(vars_ui, const)
    end

    if Draw_SummaryButton(main.wall_attraction, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top) then
        TransitionWindows_WallAttraction(vars_ui, const)
    end

    local isOKClicked, isCloseClicked = Draw_OkCancelButtons(main.okcancel, vars_ui.style.okcancelButtons)
    if isOKClicked then
        this.Save(main.latch_wallhang, main.jump_backward, main.mouse_sensitivity, main.rightstick_sensitivity, const)
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
            pos_x = 110,
            pos_y = -165,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_LatchWallHang(def, const)
    --NOTE: ActivateWindow_Main sets this to nil
    if def.isChecked == nil then
        def.isChecked = const.latch_wallhang
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

function this.Define_JumpBackward(relative_to, const)
    -- CheckBox
    return
    {
        invisible_name = "Main_JumpBackward",

        text = "Jump Backward",

        isEnabled = true,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 24,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_JumpBackward(def, const)
    --NOTE: ActivateWindow_Main sets this to nil
    if def.isChecked == nil then
        def.isChecked = const.should_jump_backward
    end
end
function this.Define_JumpBackward_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Main_JumpBackward_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Whether to jump off of walls when facing the wall (and not looking straight up)

This feature sounded good in my head, but has a tendency to cause unintended death

NOTE: Holding in shift will ignore this checkbox setting]]

    return retVal
end

function this.Define_MouseSensitivity_Label(relative_to, const)
    -- Label
    return
    {
        text = "Mouse Look Sensitivity",

        position =
        {
            relative_to = relative_to,

            pos_x = 24,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_MouseSensitivity_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Main_MouseSensitivity_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 11,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[When hanging from a wall, this uses rapid teleporting to stay in place, which means that left/right mouselook must be manually handled

(up/down is handled automatically by the game)]]

    return retVal
end
function this.Define_MouseSensitivity(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Main_MouseSensitivity_Value",

        min = 0,
        max = 144,

        is_dozenal = true,
        decimal_places = 0,

        width = 200,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 30,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_MouseSensitivity(def, const)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = GetScaledValue(def.min, def.max, MOUSE_MIN, MOUSE_MAX, const.mouse_sensitivity)       -- this function can handle the inversed mapping
    end
end

function this.Define_RightStickSensitivity_Label(relative_to, const)
    -- Label
    return
    {
        text = "Controller Look Sensitivity",

        position =
        {
            relative_to = relative_to,

            pos_x = 24,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_RightStickSensitivity_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Main_RightStickSensitivity_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 11,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This is only used when you have a controller

The final sensitivity speed is Mouse x RightStick

So this slider is relative to mouse sensitivity]]

    return retVal
end
function this.Define_RightStickSensitivity(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Main_RightStickSensitivity_Value",

        min = 0,
        max = 144,

        is_dozenal = true,
        decimal_places = 0,

        width = 200,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 24,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_RightStickSensitivity(def, const)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = GetScaledValue(def.min, def.max, STICK_MIN, STICK_MAX, const.rightstick_sensitivity)
    end
end

function this.Define_Jumping(const)
    -- SummaryButton
    return
    {
        header_prompt = "Jumping",

        content =
        {
            -- the content is presented as sorted by name
            a_strength = { prompt = "strength" },
            b_vert_speed_full = { prompt = "vert full" },
            c_vert_speed_zero = { prompt = "vert zero" },
        },

        position =
        {
            pos_x = -220,
            pos_y = 130,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "Main_Jumping",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_Jumping(def, player_arcade)
    def.content.a_strength.value = Format_DecimalToDozenal(player_arcade.jump_strength, 1)
    def.content.b_vert_speed_full.value = Format_DecimalToDozenal(player_arcade.jump_speed_fullStrength, 1)
    def.content.c_vert_speed_zero.value = Format_DecimalToDozenal(player_arcade.jump_speed_zeroStrength, 1)
end

function this.Define_CrawlSlide(const)
    -- SummaryButton
    return
    {
        header_prompt = "Crawl/Slide",

        content =
        {
            -- the content is presented as sorted by name
            a_slide_speed = { prompt = "slide speed" },
            b_slide_drag = { prompt = "slide drag" },
            c_crawl_horz = { prompt = "crawl horizontal" },
            d_crawl_up = { prompt = "crawl up" },
            e_crawl_down = { prompt = "crawl down" },
        },

        position =
        {
            pos_x = 0,
            pos_y = 130,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "Main_CrawlSlide",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_CrawlSlide(def, player_arcade)
    def.content.a_slide_speed.value = Format_DecimalToDozenal(player_arcade.wallSlide_minSpeed, 1)
    def.content.b_slide_drag.value = Format_DecimalToDozenal(player_arcade.wallSlide_dragAccel, 1)
    def.content.c_crawl_horz.value = Format_DecimalToDozenal(player_arcade.wallcrawl_speed_horz, 1)
    def.content.d_crawl_up.value = Format_DecimalToDozenal(player_arcade.wallcrawl_speed_up, 1)
    def.content.e_crawl_down.value = Format_DecimalToDozenal(player_arcade.wallcrawl_speed_down, 1)
end

function this.Define_WallAttraction(const)
    -- SummaryButton
    return
    {
        header_prompt = "Wall Attraction",

        content =
        {
            -- the content is presented as sorted by name
            a_max_dist = { prompt = "max distance" },
            b_accel = { prompt = "acceleration" },
            c_antigrav = { prompt = "anti gravity" },
        },

        position =
        {
            pos_x = 220,
            pos_y = 130,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "Main_WallAttraction",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_WallAttraction(def, player_arcade)
    def.content.a_max_dist.value = Format_DecimalToDozenal(player_arcade.wallDistance_attract_max, 1)
    def.content.b_accel.value = Format_DecimalToDozenal(player_arcade.attract_accel, 1)
    def.content.c_antigrav.value = Format_DecimalToDozenal(player_arcade.attract_antigrav, 2)
end

function this.Refresh_IsDirty(def, const, latch_wallhang, jump_backward, mouse_sensitivity, rightstick_sensitivity)
    local isDirty = false

    if const.latch_wallhang ~= latch_wallhang.isChecked then
        isDirty = true

    elseif const.should_jump_backward ~= jump_backward.isChecked then
        isDirty = true
    
    elseif not IsNearValue(GetScaledValue(mouse_sensitivity.min, mouse_sensitivity.max, MOUSE_MIN, MOUSE_MAX, const.mouse_sensitivity), mouse_sensitivity.value) then
        isDirty = true

    elseif not IsNearValue(GetScaledValue(rightstick_sensitivity.min, rightstick_sensitivity.max, STICK_MIN, STICK_MAX, const.rightstick_sensitivity), rightstick_sensitivity.value) then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(latch_wallhang, jump_backward, mouse_sensitivity, rightstick_sensitivity, const)
    const.latch_wallhang = latch_wallhang.isChecked
    const.should_jump_backward = jump_backward.isChecked
    const.mouse_sensitivity = GetScaledValue(MOUSE_MIN, MOUSE_MAX, mouse_sensitivity.min, mouse_sensitivity.max, mouse_sensitivity.value)
    const.rightstick_sensitivity = GetScaledValue(STICK_MIN, STICK_MAX, rightstick_sensitivity.min, rightstick_sensitivity.max, rightstick_sensitivity.value)

    SetSetting_Bool(const.settings.Latch_WallHang, const.latch_wallhang)
    SetSetting_Bool(const.settings.ShouldJumpBackward, const.should_jump_backward)
    SetSetting_Float(const.settings.MouseSensitivity, const.mouse_sensitivity)
    SetSetting_Float(const.settings.RightStickSensitivity, const.rightstick_sensitivity)
end