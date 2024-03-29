local this = {}

local flight_method = CreateEnum("impulse", "teleport")

local qualsum_accel_horz = nil
local qualsum_accel_vert = nil
local qualsum_accel_initial = nil
local qualsum_accel_gravity = nil
local qualsum_jumpland_delay = nil
local qualsum_time_dilation = nil
local qualsum_energy_max = nil
local qualsum_energy_burn_dash = nil
local qualsum_energy_burn_horz = nil
local qualsum_energy_recover = nil

-- This gets called during activate and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode(vars_ui, const)
    local modewin = {}
    vars_ui.modewin = modewin

    modewin.name = this.Define_Name(const)
    modewin.description = this.Define_Description(modewin.name, const, vars_ui.configWindow.width / vars_ui.scale)      -- I don't think scale is set properly yet

    modewin.accel = this.Define_Accel(const)
    modewin.jump_land = this.Define_JumpLand(modewin.accel, const)
    modewin.rebound = this.Define_Rebound(modewin.jump_land, const)
    modewin.timedilation = this.Define_TimeDilation(modewin.jump_land, const)
    modewin.mouse_steer = this.Define_MouseSteer(modewin.rebound, const)

    modewin.energy = this.Define_Energy(const)

    modewin.extrakey1 = this.Define_ExtraKey1(const)
    modewin.extrarmb = this.Define_RightMouseButton(modewin.extrakey1, const)
    modewin.extrakey2 = this.Define_ExtraKey2(modewin.extrakey1, const)

    modewin.flightmethod_combo = this.Define_FlightMethod_Combo(const)
    modewin.flightmethod_help = this.Define_FlightMethod_Help(modewin.flightmethod_combo, const)
    modewin.flightmethod_label = this.Define_FlightMethod_Label(modewin.flightmethod_help, const)

    modewin.sound_combo = this.Define_Sound_Combo(modewin.flightmethod_combo, const)
    modewin.sound_help = this.Define_Sound_Help(modewin.sound_combo, const)
    modewin.sound_label = this.Define_Sound_Label(modewin.sound_help, const)

    modewin.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(modewin)
end

function ActivateWindow_Mode(vars_ui, const)
    if not vars_ui.modewin then
        DefineWindow_Mode(vars_ui, const)
    end

    this.EnsureSummaryQualsPopulated()

    local modewin = vars_ui.modewin

    modewin.name.text = nil
    modewin.description.text = nil

    modewin.flightmethod_combo.selected_item = nil
    modewin.sound_combo.selected_item = nil
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
    this.Refresh_RightMouseButton(modewin.extrarmb, mode)
    this.Refresh_ExtraKey1(modewin.extrakey1, mode)
    this.Refresh_ExtraKey2(modewin.extrakey2, mode)

    this.Refresh_FlightMethod_Combo(modewin.flightmethod_combo, mode)
    this.Refresh_Sound_Combo(modewin.sound_combo, mode)

    this.Refresh_IsDirty(modewin.okcancel, modewin.name, modewin.description, modewin.flightmethod_combo, modewin.sound_combo, mode)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(modewin.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(modewin.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_TextBox(modewin.name, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_TextBox(modewin.description, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)

    -- NOTE: ignoring isHovered
    if Draw_SummaryButton(modewin.accel, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Mode_Accel(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.jump_land, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Mode_JumpLand(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.energy, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Mode_Energy(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.timedilation, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Mode_TimeDilation(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.rebound, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Mode_Rebound(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.mouse_steer, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Mode_MouseSteer(vars_ui, const)
    end

    if Draw_SummaryButton(modewin.extrarmb, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Mode_Extra(vars_ui, const, mode.extra_rmb, function(m, e) if e then e.key = "rmb" end; m.extra_rmb = e end)      -- the delegate takes a mode and extra and populates the correct property off of mode (also tells the instance of extra what key to look for in keys)
    end

    if Draw_SummaryButton(modewin.extrakey1, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Mode_Extra(vars_ui, const, mode.extra_key1, function(m, e) if e then e.key = "extra1" end; m.extra_key1 = e end)
    end

    if Draw_SummaryButton(modewin.extrakey2, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Mode_Extra(vars_ui, const, mode.extra_key2, function(m, e) if e then e.key = "extra2" end; m.extra_key2 = e end)
    end

    Draw_ComboBox(modewin.flightmethod_combo, vars_ui.style.combobox, vars_ui.scale)
    Draw_HelpButton(modewin.flightmethod_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Label(modewin.flightmethod_label, vars_ui.style.colors, vars_ui.scale)

    Draw_ComboBox(modewin.sound_combo, vars_ui.style.combobox, vars_ui.scale)
    Draw_HelpButton(modewin.sound_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Label(modewin.sound_label, vars_ui.style.colors, vars_ui.scale)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(modewin.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, mode, vars_ui.transition_info.mode_index, modewin.name, modewin.description, modewin.flightmethod_combo, modewin.sound_combo)
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
            pos_x = 25,
            pos_y = 40,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Name(def, mode)
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
        width = parent_width - 10 - (25 * 2),       -- shouldn't need that extra 10 reduced, but it's too wide otherwise
        height = 90,        -- height is required when multi line

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
            pos_x = 25,
            pos_y = -15,
            horizontal = const.alignment_horizontal.left,
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
        def.content.a_horz.value = this.QualifySummaryValue(qualsum_accel_horz, mode.accel.horz_stand)

        local accel_vert = mode_defaults.ImpulseGravityAdjust_ToUI(mode.useImpulse, mode.accel.gravity, mode.accel.vert_stand)
        def.content.b_vert.value = this.QualifySummaryValue(qualsum_accel_vert, accel_vert)

        if mode.accel.vert_initial then
            def.content.c_initial.value = this.QualifySummaryValue(qualsum_accel_initial, mode.accel.vert_initial)
        else
            def.content.c_initial.value = ""        -- show gray text
        end

        def.content.d_gravity.value = this.QualifySummaryValue(qualsum_accel_gravity, math.abs(mode.accel.gravity))

        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_JumpLand(relative_to, const)
    -- SummaryButton
    return
    {
        position =
        {
            relative_to = relative_to,

            pos_x = 180,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.center,
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
        def.content.b_delay.value = this.QualifySummaryValue(qualsum_jumpland_delay, mode.jump_land.holdJumpDelay)

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

function this.Define_Rebound(relative_to, const)
    -- SummaryButton
    return
    {
        position =
        {
            relative_to = relative_to,

            pos_x = 180,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.center,
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

function this.Define_TimeDilation(relative_to, const)
    -- SummaryButton
    return
    {
        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 125,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.center,
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
    if mode.timeDilation then
        def.content.a_type.value = this.QualifySummaryValue(qualsum_time_dilation, mode.timeDilation)
        def.unused_text = nil

    elseif mode.timeDilation_gradient then
        def.content.a_type.value = "gradient"
        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_MouseSteer(relative_to, const)
    -- SummaryButton
    return
    {
        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 125,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.center,
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
    if mode.mouseSteer then
        def.content.a_has_mouse_steer.value = "has mouse steering"
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
            pos_x = 25,
            pos_y = 25,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
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
        def.content.a_max.value = this.QualifySummaryValue(qualsum_energy_max, mode.energy.maxBurnTime)
        def.content.b_burn.value = this.QualifySummaryValue_Two(qualsum_energy_burn_dash, mode.energy.burnRate_dash, qualsum_energy_burn_horz, mode.energy.burnRate_horz)
        def.content.c_recovery.value = this.QualifySummaryValue(qualsum_energy_recover, mode.energy.recoveryRate)
        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_RightMouseButton(relative_to, const)
    -- SummaryButton
    return
    {
        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = -80,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
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
    if mode.extra_rmb then
        def.content.a_type.value = mode.extra_rmb.extra_type
        def.unused_text = nil
    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_ExtraKey1(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = 70,
            pos_y = 50,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Extra Key 1",

        content =
        {
            -- the content is presented as sorted by name
            a_type = { prompt = nil },
        },

        invisible_name = "Mode_ExtraKey1",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_ExtraKey1(def, mode)
    if mode.extra_key1 then
        def.content.a_type.value = mode.extra_key1.extra_type
        def.unused_text = nil
    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_ExtraKey2(relative_to, const)
    -- SummaryButton
    return
    {
        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 80,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Extra Key 2",

        content =
        {
            -- the content is presented as sorted by name
            a_type = { prompt = nil },
        },

        invisible_name = "Mode_ExtraKey2",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_ExtraKey2(def, mode)
    if mode.extra_key2 then
        def.content.a_type.value = mode.extra_key2.extra_type
        def.unused_text = nil
    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_FlightMethod_Combo(const)
    -- ComboBox
    return
    {
        preview_text = flight_method.impulse,
        selected_item = nil,

        items =
        {
            flight_method.impulse,
            flight_method.teleport,
        },

        width = 120,

        position =
        {
            pos_x = 75,
            pos_y = 30,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.bottom,
        },

        invisible_name = "Mode_FlightMethod_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_FlightMethod_Combo(def, mode)
    if not def.selected_item then
        if mode.useImpulse then
            def.selected_item = flight_method.impulse
        else
            def.selected_item = flight_method.teleport
        end
    end
end
function this.Define_FlightMethod_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Mode_FlightMethod_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Impulse:  The game does physics and collisions.  Better for lower speeds, better interaction with walls/ledges

Teleport:  The mod does physics and collisions.  Better for high speed, slightly more floaty feeling

It's recommended to use a mod that removes the sepia filter (for impulse based flight)

NOTE:  There is a bug with impulse based and holding in tab.  So if you're going to do quickhacks while flying, use teleport based]]

    return retVal
end
function this.Define_FlightMethod_Label(relative_to, const)
    -- Label
    return
    {
        text = "Flight Method",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
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

function this.Define_Sound_Combo(relative_to, const)
    -- ComboBox
    return
    {
        preview_text = const.thrust_sound_type.steam,
        selected_item = nil,

        items =
        {
            const.thrust_sound_type.steam,
            const.thrust_sound_type.steam_quiet,
            const.thrust_sound_type.levitate,
            const.thrust_sound_type.jump,
            const.thrust_sound_type.silent,
        },

        width = 120,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 15,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.top,
            vertical = const.alignment_vertical.bottom,
        },

        invisible_name = "Mode_Sound_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Sound_Combo(def, mode)
    if not def.selected_item then
        def.selected_item = mode.sound_type
    end
end
function this.Define_Sound_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Mode_Sound_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[What set of sounds to use]]

    return retVal
end
function this.Define_Sound_Label(relative_to, const)
    -- Label
    return
    {
        text = "Sounds",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
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

function this.Refresh_IsDirty(def, def_name, def_description, def_flightmethod, def_sound, mode)
    local isDirty = false

    if def_name.text and def_name.text ~= mode.name then
        isDirty = true

    elseif def_description.text and def_description.text ~= mode.description then
        isDirty = true

    elseif def_flightmethod.selected_item == flight_method.impulse and not mode.useImpulse then
        isDirty = true

    elseif def_flightmethod.selected_item == flight_method.teleport and mode.useImpulse then
        isDirty = true

    elseif def_sound.selected_item ~= mode.sound_type then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, mode, mode_index, def_name, def_description, def_flightmethod, def_sound)
    mode.name = def_name.text
    mode.description = def_description.text

    local prev_useImpulse = mode.useImpulse

    if def_flightmethod.selected_item == flight_method.impulse then
        mode.useImpulse = true
    elseif def_flightmethod.selected_item == flight_method.teleport then
        mode.useImpulse = false
    end

    if prev_useImpulse ~= mode.useImpulse then
        -- Vertical accelerations are adjusted for gravity with impulse, but not with teleport
        local vert_prev = mode_defaults.ImpulseGravityAdjust_ToUI(prev_useImpulse, mode.accel.gravity, mode.accel.vert_stand)
        mode.accel.vert_stand = mode_defaults.ImpulseGravityAdjust_ToMode(mode.useImpulse, mode.accel.gravity, vert_prev)

        local vertdash_prev = mode_defaults.ImpulseGravityAdjust_ToUI(prev_useImpulse, mode.accel.gravity, mode.accel.vert_dash)
        mode.accel.vert_dash = mode_defaults.ImpulseGravityAdjust_ToMode(mode.useImpulse, mode.accel.gravity, vertdash_prev)
    end

    mode.sound_type = def_sound.selected_item

    player:SaveUpdatedMode(mode, mode_index)
end

---------------------------------------------------------------------------------------

function this.EnsureSummaryQualsPopulated()
    if qualsum_accel_horz then
        do return end
    end

    -- tiny, negligible, very low
    -- low
    -- mid
    -- high
    -- extreme, extra, very high


    -- 0 to 80
    qualsum_accel_horz =
    {
        { boundary = 0.1, text = "tiny" },      -- any value until 0.1 will be called tiny
        { boundary = 0.75, text = "low" },      -- values between 0.1 and 0.75 will be low
        { boundary = 6, text = "mid" },
        { boundary = 48, text = "high" },
        { boundary = 384, text = "extreme" },       -- this upper value doesn't matter, anything above 48 will be extreme
    }

    qualsum_accel_vert =
    {
        { boundary = 0.45, text = "tiny" },
        { boundary = 1.38, text = "low" },
        { boundary = 4.2, text = "mid" },
        { boundary = 12.5, text = "high" },
        { boundary = 40, text = "extreme" },
    }

    qualsum_accel_initial =
    {
        { boundary = 1.05, text = "tiny" },
        { boundary = 2.3, text = "low" },
        { boundary = 5, text = "mid" },
        { boundary = 11.2, text = "high" },
        { boundary = 25, text = "extreme" },
    }

    qualsum_accel_gravity =
    {
        { boundary = 1.5, text = "tiny" },      --NOTE: gravity is negative, so will need to run the abs against this
        { boundary = 5, text = "low" },
        { boundary = 17, text = "mid" },
        { boundary = 24, text = "high" },
        { boundary = 40, text = "extreme" },
    }

    qualsum_jumpland_delay =
    {
        { boundary = 0.2, text = "low" },
        { boundary = 0.24, text = "mid" },
        { boundary = 1, text = "high" },
    }

    qualsum_time_dilation =
    {
        { boundary = 0.1, text = "extreme" },
        { boundary = 0.35, text = "high" },
        { boundary = 0.6, text = "mid" },
        { boundary = 0.85, text = "low" },
        { boundary = 1, text = "negligible" },
    }

    qualsum_energy_max =
    {
        { boundary = 1, text = "tiny" },
        { boundary = 2, text = "low" },
        { boundary = 8, text = "mid" },
        { boundary = 37, text = "high" },
        { boundary = 999, text = "infinite" },       -- anything over 36 gets set to 999
    }

    -- both values will be evaluated, return the max qual
    qualsum_energy_burn_dash =
    {
        { boundary = 0.9, text = "low" },
        { boundary = 2.5, text = "mid" },
        { boundary = 4, text = "high" },
    }
    qualsum_energy_burn_horz =
    {
        { boundary = 0.15, text = "low" },
        { boundary = 0.5, text = "mid" },
        { boundary = 2, text = "high" },
    }

    qualsum_energy_recover =
    {
        { boundary = 0.25, text = "low" },
        { boundary = 1.5, text = "mid" },
        { boundary = 3, text = "high" },
        { boundary = 99, text = "infinite" },
    }
end

-- Take in params for ranges and their description
function this.QualifySummaryValue(ranges, value)
    local retVal = ranges[1].text

    if value >= ranges[#ranges].boundary then
        retVal = ranges[#ranges].text
    else
        for _, range in ipairs(ranges) do
            if value < range.boundary then
                retVal = range.text
                do break end
            end
        end
    end

    return retVal
end
-- This takes in two sets and returns the text of the greater
-- NOTE: range1 and range2 need to be the same size, and need to have the same text at each step
function this.QualifySummaryValue_Two(ranges1, value1, ranges2, value2)
    if #ranges1 ~= #ranges2 then
        return "QualifySummaryValue_Two: Invalid ranges"
    end

    local retVal = nil

    if value1 >= ranges1[#ranges1].boundary or value2 >= ranges2[#ranges2].boundary then
        retVal = ranges1[#ranges1].text
    else
        local retVal1 = nil
        local retVal2 = nil

        for i = 1, #ranges1, 1 do
            if not retVal1 and value1 < ranges1[i].boundary then
                retVal1 = ranges1[i].text
            end

            if not retVal2 and value2 < ranges2[i].boundary then
                retVal2 = ranges2[i].text
            end

            if not retVal1 and not retVal2 then
                retVal = ranges1[1].text
            elseif not retVal1 then
                retVal = retVal2
            elseif not retVal2 then
                retVal = retVal
            else
                if value1 > value2 then
                    retVal = retVal1
                else
                    retVal = retVal2
                end
            end
        end
    end

    return retVal
end