local this = {}

local SPEED_MIN = 0
local SPEED_MAX = 16

function DefineWindow_Jumping(vars_ui, const)
    local jumping = {}
    vars_ui.jumping = jumping

    jumping.changes = Changes:new()

    jumping.title = Define_Title("Jumping", const)

    -- player_arcade.jump_strength
    jumping.strength = this.Define_Strength(const)
    jumping.strength_label = this.Define_Strength_Label(jumping.strength, const)
    jumping.strength_help = this.Define_Strength_Help(jumping.strength_label, const)

    jumping.speed_label = this.Define_Speed_Label(jumping.strength, const)
    jumping.speed_help = this.Define_Speed_Help(jumping.speed_label, const)

    -- player_arcade.jump_speed_fullStrength
    jumping.speed_full = this.Define_SpeedFull(jumping.speed_label, const)
    jumping.speed_full_label = this.Define_SpeedFull_Label(jumping.speed_full, const)
    jumping.speed_full_help = this.Define_SpeedFull_Help(jumping.speed_full_label, const)

    -- player_arcade.jump_speed_zeroStrength
    jumping.speed_zero = this.Define_SpeedZero(jumping.speed_full, const)
    jumping.speed_zero_label = this.Define_SpeedZero_Label(jumping.speed_zero, const)
    jumping.speed_zero_help = this.Define_SpeedZero_Help(jumping.speed_zero_label, const)

    jumping.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(jumping)
end

function ActivateWindow_Jumping(vars_ui, const)
    if not vars_ui.jumping then
        DefineWindow_Jumping(vars_ui, const)
    end

    vars_ui.jumping.changes:Clear()

    vars_ui.jumping.strength.value = nil
    vars_ui.jumping.speed_full.value = nil
    vars_ui.jumping.speed_zero.value = nil
end

function DrawWindow_Jumping(isCloseRequested, vars_ui, window, const, player, player_arcade)
    local jumping = vars_ui.jumping

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Strength(jumping.strength, player_arcade)

    this.Refresh_SpeedFull(jumping.speed_full, player_arcade)

    this.Refresh_SpeedZero(jumping.speed_zero, player_arcade)

    this.Refresh_IsDirty(jumping.okcancel, player_arcade, jumping.strength, jumping.speed_full, jumping.speed_zero)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(jumping.render_nodes, vars_ui.style, const, vars_ui.line_heights)
    CalculatePositions(jumping.render_nodes, window.width, window.height, const, vars_ui.em)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(jumping.title, vars_ui.style.colors, vars_ui.em)

    Draw_Label(jumping.strength_label, vars_ui.style.colors, vars_ui.em)
    Draw_HelpButton(jumping.strength_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(jumping.strength, vars_ui.style.slider, vars_ui.em)

    Draw_Label(jumping.speed_label, vars_ui.style.colors, vars_ui.em)
    Draw_HelpButton(jumping.speed_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    Draw_Label(jumping.speed_full_label, vars_ui.style.colors, vars_ui.em)
    Draw_HelpButton(jumping.speed_full_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(jumping.speed_full, vars_ui.style.slider, vars_ui.em)

    Draw_Label(jumping.speed_zero_label, vars_ui.style.colors, vars_ui.em)
    Draw_HelpButton(jumping.speed_zero_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(jumping.speed_zero, vars_ui.style.slider, vars_ui.em)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(jumping.okcancel, vars_ui.style.okcancelButtons, vars_ui.em)
    if isOKClicked then
        this.Save(player, player_arcade, jumping.strength, jumping.speed_full, jumping.speed_zero)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not jumping.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Strength_Label(relative_to, const)
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
function this.Define_Strength_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping_Strength_Help",

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
[[How strong to jump

This is used when jumping away from the wall as well as straight up]]

    return retVal
end
function this.Define_Strength(const)
    -- Slider
    return
    {
        invisible_name = "Jumping_Strength_Value",

        min = 4,
        max = 28,

        is_dozenal = true,
        decimal_places = 1,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 65,
            pos_y = -120,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Strength(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.jump_strength
    end
end

function this.Define_Speed_Label(relative_to, const)
    -- Label
    return
    {
        text = "Max Vertical Speed",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 120,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Speed_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping_Speed_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[When jumping straight up, the boost will reduce to zero if already going up quickly enough]]

    return retVal
end

function this.Define_SpeedFull_Label(relative_to, const)
    -- Label
    return
    {
        text = "Full Until",

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
function this.Define_SpeedFull_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping_SpeedFull_Help",

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
[[If jumping while going up slower than this, the impulse will be maximum

If the vertical speed is between 'Full Until' and 'Zero After', then the jump impulse will be reduced]]

    return retVal
end
function this.Define_SpeedFull(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Jumping_SpeedFull_Value",

        min = SPEED_MIN,
        max = SPEED_MAX,

        is_dozenal = true,
        decimal_places = 1,

        width = 250,

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
function this.Refresh_SpeedFull(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.jump_speed_fullStrength
    end
end

function this.Define_SpeedZero_Label(relative_to, const)
    -- Label
    return
    {
        text = "Zero After",

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
function this.Define_SpeedZero_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping_SpeedZero_Help",

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
[[If jumping while going up faster than this, the impulse will be zero (and a click sound will play)

If the vertical speed is between 'Full Until' and 'Zero After', then the jump impulse will be reduced]]

    return retVal
end
function this.Define_SpeedZero(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Jumping_SpeedZero_Value",

        min = SPEED_MIN,
        max = SPEED_MAX,

        is_dozenal = true,
        decimal_places = 1,

        width = 250,

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
function this.Refresh_SpeedZero(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.jump_speed_zeroStrength
    end
end

function this.Refresh_IsDirty(def, player_arcade, jump_strength, speed_full, speed_zero)
    local isDirty = false

    if not IsNearValue(jump_strength.value, player_arcade.jump_strength) then
        isDirty = true

    elseif not IsNearValue(speed_full.value, player_arcade.jump_speed_fullStrength) then
        isDirty = true

    elseif not IsNearValue(speed_zero.value, player_arcade.jump_speed_zeroStrength) then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, player_arcade, jump_strength, speed_full, speed_zero)
    player_arcade.jump_strength = jump_strength.value
    player_arcade.jump_speed_fullStrength = speed_full.value
    player_arcade.jump_speed_zeroStrength = speed_zero.value

    player_arcade:Save()
    player:Reset()
end