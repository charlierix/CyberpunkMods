local this = {}

local MOUSE_MIN = -0.02
local MOUSE_MAX = -0.24
local STICK_MIN = 12
local STICK_MAX = 150
local JUMPSTRENGTH_MIN = 4
local JUMPSTRENGTH_MAX = 36

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

    main.mouse_sensitivity = this.Define_MouseSensitivity(main.latch_wallhang, const)
    main.mouse_sensitivity_label = this.Define_MouseSensitivity_Label(main.mouse_sensitivity, const)

    main.rightstick_sensitivity = this.Define_RightStickSensitivity(main.mouse_sensitivity, const)
    main.rightstick_sensitivity_label = this.Define_RightStickSensitivity_Label(main.rightstick_sensitivity, const)

    main.jump_strength = this.Define_JumpStrength(main.rightstick_sensitivity, const)
    main.jump_strength_label = this.Define_JumpStrength_Label(main.jump_strength, const)

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
    vars_ui.main.jump_strength.value = nil

    vars_ui.keys:StopWatching()     -- doing this in case it came from the input bindings window (which put keys in a watching state)
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Main(isCloseRequested, vars, vars_ui, window, const, player, player_arcade)
    local main = vars_ui.main

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_ShouldAutoShow(main.should_autoshow, vars_ui)

    this.Refresh_LatchWallHang(main.latch_wallhang, const)

    this.Refresh_MouseSensitivity(main.mouse_sensitivity, const)

    this.Refresh_RightStickSensitivity(main.rightstick_sensitivity, const)

    this.Refresh_JumpStrength(main.jump_strength, player_arcade)

    this.Refresh_IsDirty(main.okcancel, const, player_arcade, main.latch_wallhang, main.mouse_sensitivity, main.rightstick_sensitivity, main.jump_strength)

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

    Draw_Label(main.mouse_sensitivity_label, vars_ui.style.colors)
    Draw_Slider(main.mouse_sensitivity, vars_ui.style.slider)

    Draw_Label(main.rightstick_sensitivity_label, vars_ui.style.colors)
    Draw_Slider(main.rightstick_sensitivity, vars_ui.style.slider)

    Draw_Label(main.jump_strength_label, vars_ui.style.colors)
    Draw_Slider(main.jump_strength, vars_ui.style.slider)

    local isOKClicked, isCloseClicked = Draw_OkCancelButtons(main.okcancel, vars_ui.style.okcancelButtons)
    if isOKClicked then
        this.Save(main.latch_wallhang, main.mouse_sensitivity, main.rightstick_sensitivity, main.jump_strength, const, player, player_arcade)
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
            pos_x = 100,
            pos_y = -70,
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
function this.Define_MouseSensitivity(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Main_MouseSensitivity_Value",

        min = 0,
        max = 144,

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
function this.Define_RightStickSensitivity(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Main_RightStickSensitivity_Value",

        min = 0,
        max = 144,

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

function this.Define_JumpStrength_Label(relative_to, const)
    -- Label
    return
    {
        text = "Jump Strength",

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
function this.Define_JumpStrength(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Main_JumpStrength_Value",

        min = 0,
        max = 144,

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
function this.Refresh_JumpStrength(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = GetScaledValue(def.min, def.max, JUMPSTRENGTH_MIN, JUMPSTRENGTH_MAX, player_arcade.jump_strength)
    end
end

function this.Refresh_IsDirty(def, const, player_arcade, latch_wallhang, mouse_sensitivity, rightstick_sensitivity, jump_strength)
    local isDirty = false

    if const.latch_wallhang ~= latch_wallhang.isChecked then
        isDirty = true

    elseif not IsNearValue(GetScaledValue(mouse_sensitivity.min, mouse_sensitivity.max, MOUSE_MIN, MOUSE_MAX, const.mouse_sensitivity), mouse_sensitivity.value) then
        isDirty = true

    elseif not IsNearValue(GetScaledValue(rightstick_sensitivity.min, rightstick_sensitivity.max, STICK_MIN, STICK_MAX, const.rightstick_sensitivity), rightstick_sensitivity.value) then
        isDirty = true

    elseif not IsNearValue(GetScaledValue(jump_strength.min, jump_strength.max, JUMPSTRENGTH_MIN, JUMPSTRENGTH_MAX, player_arcade.jump_strength), jump_strength.value) then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(latch_wallhang, mouse_sensitivity, rightstick_sensitivity, jump_strength, const, player, player_arcade)
    const.latch_wallhang = latch_wallhang.isChecked
    const.mouse_sensitivity = GetScaledValue(MOUSE_MIN, MOUSE_MAX, mouse_sensitivity.min, mouse_sensitivity.max, mouse_sensitivity.value)
    const.rightstick_sensitivity = GetScaledValue(STICK_MIN, STICK_MAX, rightstick_sensitivity.min, rightstick_sensitivity.max, rightstick_sensitivity.value)
    player_arcade.jump_strength = GetScaledValue(JUMPSTRENGTH_MIN, JUMPSTRENGTH_MAX, jump_strength.min, jump_strength.max, jump_strength.value)

    SetSetting_Bool(const.settings.Latch_WallHang, const.latch_wallhang)
    SetSetting_Float(const.settings.MouseSensitivity, const.mouse_sensitivity)
    SetSetting_Float(const.settings.RightStickSensitivity, const.rightstick_sensitivity)

    player_arcade:Save()
    player:Reset()
end