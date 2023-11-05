local this = {}

-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode(vars_ui, const)
    local modewin = {}
    vars_ui.modewin = modewin

    modewin.changes = Changes:new()

    modewin.name = this.Define_Name(const)
    modewin.description = this.Define_Description(modewin.name, const, vars_ui.configWindow.width / vars_ui.scale)

    --TODO: impulse / teleport
    --TODO: sounds

    modewin.accel = this.Define_Accel(const)
    modewin.jump_land = this.Define_JumpLand(const)
    modewin.energy = this.Define_Energy(const)
    modewin.timedilation = this.Define_TimeDilation(const)
    modewin.rebound = this.Define_Rebound(const)
    modewin.mouse_steer = this.Define_MouseSteer(const)
    modewin.rmb = this.Define_RightMouseButton(const)

    modewin.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(modewin)
end

function ActivateWindow_Mode(vars_ui, const)
    if not vars_ui.modewin then
        DefineWindow_Mode(vars_ui, const)
    end

    local modewin = vars_ui.modewin

    modewin.changes:Clear()

    modewin.name.text = nil
    modewin.description.text = nil


end

-- This gets called each frame from DrawConfig()
function DrawWindow_Mode(isCloseRequested, vars, vars_ui, player, window, o, const)
    local modewin = vars_ui.modewin

    local mode = vars_ui.transition_info.mode

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Name(modewin.name, mode)
    this.Refresh_Description(modewin.description, mode)

    this.Refresh_Accel(modewin.accel, mode)
    this.Refresh_JumpLand(modewin.jump_land, mode)
    this.Refresh_Energy(modewin.energy, mode)
    this.Refresh_TimeDilation(modewin.timedilation, mode)
    this.Refresh_Rebound(modewin.rebound, mode)
    this.Refresh_MouseSteer(modewin.mouse_steer, mode)
    this.Refresh_RightMouseButton(modewin.rmb, mode)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(modewin.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(modewin.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_TextBox(modewin.name, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_TextBox(modewin.description, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)

    -- NOTE: ignoring isHovered
    if Draw_SummaryButton(modewin.accel, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        --TransitionWindows_Mode_Accel(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.jump_land, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        --TransitionWindows_Mode_JumpLand(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.energy, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        --TransitionWindows_Mode_Energy(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.timedilation, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        --TransitionWindows_Mode_TimeDilation(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.rebound, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        --TransitionWindows_Mode_Rebound(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.mouse_steer, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        --TransitionWindows_Mode_MouseSteer(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.rmb, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        --TransitionWindows_Mode_RightMouseButton(vars_ui, const)
    end

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(modewin.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, mode, vars_ui.transition_info.mode_index)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not modewin.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Name(const)
    -- TextBox
    return
    {
        invisible_name = "Mode_Name",

        maxChars = 60,
        min_width = 200,
        --max_width = 240,

        isMultiLine = false,

        foreground_override = "title",

        position =
        {
            pos_x = 30,
            pos_y = 30,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Name(def, mode)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    -- NOTE: ActivateWindow_Mode sets this to nil
    if not def.text then
        def.text = mode.name
    end
end

function this.Define_Description(relative_to, const, parent_width)
    -- TextBox
    return
    {
        invisible_name = "Mode_Description",

        maxChars = 288,
        width = parent_width - (30 * 2),        -- the relative_to has an x offset of 30
        height = 60,        -- height is required when multi line

        isMultiLine = true,

        foreground_override = "modelistitem_description",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 4,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Description(def, mode)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    -- NOTE: ActivateWindow_Mode sets this to nil
    if not def.text then
        def.text = mode.description
    end
end

function this.Define_Accel(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = -180,
            pos_y = -60,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Accelerations",

        content =
        {
            -- the content is presented as sorted by name
            a_horz = { prompt = "horizontal" },
            b_vert = { prompt = "vertical" },
            c_initial = { prompt = "initial" },
            d_gravity = { prompt = "gravity" },
        },

        invisible_name = "Mode_Accel",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_Accel(def, mode)
    if mode.accel then
        def.content.a_horz.value = this.QualifySummaryValue({}, mode.accel.horz_stand)      --TODO: overload that takes stand and dash, averages results
        def.content.b_vert.value = this.QualifySummaryValue({}, mode.accel.vert_stand)
        def.content.c_initial.value = this.QualifySummaryValue({}, mode.accel.vert_initial)
        def.content.d_gravity.value = this.QualifySummaryValue({}, mode.accel.gravity)
        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_JumpLand(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = 0,
            pos_y = -60,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Jump / Land",

        content =
        {
            -- the content is presented as sorted by name
            a_explosive = { prompt = "explosive" },
            b_delay = { prompt = "delay" },
            c_falldamage = { prompt = "fall damage" },
        },

        invisible_name = "Mode_JumpLand",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_JumpLand(def, mode)
    if mode.jump_land then
        -- explosive
        local explosive = ""        -- setting to empty string grays out the prompt
        if mode.jump_land.explosiveJumping or mode.jump_land.explosiveLanding then
            explosive = "yes"
        end

        def.content.a_explosive.value = explosive

        -- delay
        def.content.b_delay.value = this.QualifySummaryValue({}, mode.jump_land.holdJumpDelay)

        -- falldamage
        local falldamage = "yes"
        if mode.jump_land.shouldSafetyFire then
            falldamage = "no"
        end

        def.content.c_falldamage.value = falldamage

        -- unused
        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_Energy(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = 180,
            pos_y = -60,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Energy",

        content =
        {
            -- the content is presented as sorted by name
            a_max = { prompt = "max" },
            b_burn = { prompt = "burn rate" },
            c_recovery = { prompt = "recovery" },
        },

        invisible_name = "Mode_Energy",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_Energy(def, mode)
    if mode.energy then
        def.content.a_max.value = this.QualifySummaryValue({}, mode.energy.maxBurnTime)
        def.content.b_burn.value = this.QualifySummaryValue({}, mode.energy.burnRate_dash)      --TODO: overload that takes dash and horz, averages results
        def.content.c_recovery.value = this.QualifySummaryValue({}, mode.energy.recoveryRate)
        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_TimeDilation(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = -180,
            pos_y = 90,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Time Dilation",

        content =
        {
            -- the content is presented as sorted by name
            a_type = { prompt = nil },
        },

        invisible_name = "Mode_TimeDilation",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_TimeDilation(def, mode)
    if mode.timeSpeed then
        def.content.a_type.value = this.QualifySummaryValue({}, mode.timeSpeed)
        def.unused_text = nil

    elseif mode.timeSpeed_gradient then
        def.content.a_type.value = "gradient"
        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_Rebound(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = 0,
            pos_y = 90,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Rebound",

        content =
        {
            -- the content is presented as sorted by name
            a_hasrebound = { prompt = nil },
        },

        invisible_name = "Mode_Rebound",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_Rebound(def, mode)
    if mode.rebound then
        def.content.a_hasrebound.value = "has rebound"
        def.unused_text = nil
    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_MouseSteer(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = 180,
            pos_y = 90,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Mouse Steering",

        content =
        {
            -- the content is presented as sorted by name
            a_has_mouse_steer = { prompt = nil },
        },

        invisible_name = "Mode_MouseSteer",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_MouseSteer(def, mode)
    if mode.rotateVel and mode.rotateVel.is_used then
        def.content.a_has_mouse_steer.value = "has mouse steering"
        def.unused_text = nil
    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_RightMouseButton(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = 40,
            pos_y = 40,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
        },

        header_prompt = "Right Mouse Button",

        content =
        {
            -- the content is presented as sorted by name
            a_type = { prompt = nil },
        },

        invisible_name = "Mode_RightMouseButton",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_RightMouseButton(def, mode)
    if mode.rmb_extra then
        def.content.a_type.value = mode.rmb_extra.rmb_type
        def.unused_text = nil
    else
        def.unused_text = def.header_prompt
    end
end

function this.Save(player, mode, mode_index)
    -- Store mode in the database, maybe build a new instance of mode


    -- Change player's mode primary key list


    -- If mode_index == player.mode_index, make sure player has the updated mode


    -- Save player
end

-- Take in params for ranges and their description
function this.QualifySummaryValue(ranges, value)
    return "tbd"
end