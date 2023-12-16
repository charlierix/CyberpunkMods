local this = {}

-- This gets called during activate and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode_JumpLand(vars_ui, const)
    local mode_jumpland = {}
    vars_ui.mode_jumpland = mode_jumpland

    mode_jumpland.title = Define_Title("Jump / Land", const)
    mode_jumpland.name = Define_Name(const)

    -- shouldSafetyFire
    mode_jumpland.safetyfire_checkbox = this.Define_SafetyFire_Checkbox(const)
    mode_jumpland.safetyfire_help = this.Define_SafetyFire_Help(mode_jumpland.safetyfire_checkbox, const)

    -- TODO: the jumping should have an option for in vs out
    -- explosiveJumping
    mode_jumpland.explosivejump_checkbox = this.Define_ExplosiveJump_Checkbox(const)
    mode_jumpland.explosivejump_help = this.Define_ExplosiveJump_Help(mode_jumpland.explosivejump_checkbox, const)

    -- explosiveLanding
    mode_jumpland.explosiveland_checkbox = this.Define_ExplosiveLand_Checkbox(const)
    mode_jumpland.explosiveland_help = this.Define_ExplosiveLand_Help(mode_jumpland.explosiveland_checkbox, const)

    -- holdJumpDelay
    mode_jumpland.jumpdelay_value = this.Define_JumpDelay_Value(const)
    mode_jumpland.jumpdelay_label = this.Define_JumpDelay_Label(mode_jumpland.jumpdelay_value, const)
    mode_jumpland.jumpdelay_help = this.Define_JumpDelay_Help(mode_jumpland.jumpdelay_label, const)

    mode_jumpland.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(mode_jumpland)
end

function ActivateWindow_Mode_JumpLand(vars_ui, const)
    if not vars_ui.mode_jumpland then
        DefineWindow_Mode_JumpLand(vars_ui, const)
    end

    local mode_jumpland = vars_ui.mode_jumpland

    mode_jumpland.safetyfire_checkbox.isChecked = nil
    mode_jumpland.explosivejump_checkbox.isChecked = nil
    mode_jumpland.explosiveland_checkbox.isChecked = nil
    mode_jumpland.jumpdelay_value.value = nil
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Mode_JumpLand(isCloseRequested, vars, vars_ui, player, window, o, const)
    local mode_jumpland = vars_ui.mode_jumpland

    local mode = vars_ui.transition_info.mode

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(mode_jumpland.name, mode.name)

    this.Refresh_SafetyFire_Checkbox(mode_jumpland.safetyfire_checkbox, mode)
    this.Refresh_ExplosiveJump_Checkbox(mode_jumpland.explosivejump_checkbox, mode)
    this.Refresh_ExplosiveLand_Checkbox(mode_jumpland.explosiveland_checkbox, mode)
    this.Refresh_JumpDelay_Value(mode_jumpland.jumpdelay_value, mode)

    this.Refresh_IsDirty(mode_jumpland.okcancel, mode, mode_jumpland.safetyfire_checkbox, mode_jumpland.explosivejump_checkbox, mode_jumpland.explosiveland_checkbox, mode_jumpland.jumpdelay_value)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(mode_jumpland.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(mode_jumpland.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(mode_jumpland.title, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(mode_jumpland.name, vars_ui.style.colors, vars_ui.scale)

    -- shouldSafetyFire
    Draw_CheckBox(mode_jumpland.safetyfire_checkbox, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(mode_jumpland.safetyfire_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    -- explosiveJumping
    Draw_CheckBox(mode_jumpland.explosivejump_checkbox, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(mode_jumpland.explosivejump_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    -- explosiveLanding
    Draw_CheckBox(mode_jumpland.explosiveland_checkbox, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(mode_jumpland.explosiveland_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    -- holdJumpDelay
    Draw_Label(mode_jumpland.jumpdelay_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(mode_jumpland.jumpdelay_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(mode_jumpland.jumpdelay_value, vars_ui.style.slider, vars_ui.scale)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(mode_jumpland.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, mode, vars_ui.transition_info.mode_index, mode_jumpland.safetyfire_checkbox, mode_jumpland.explosivejump_checkbox, mode_jumpland.explosiveland_checkbox, mode_jumpland.jumpdelay_value)
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)

    elseif isCancelClicked then
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)
    end

    return not (isCloseRequested and not mode_jumpland.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_SafetyFire_Checkbox(const)
    -- CheckBox
    return
    {
        invisible_name = "Mode_JumpLand_SafetyFire_Checkbox",

        text = "Eliminate Fall Damage",

        isEnabled = true,

        position =
        {
            pos_x = -140,
            pos_y = -70,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_SafetyFire_Checkbox(def, mode)
    --NOTE: ActivateWindow_Mode_JumpLand sets this to nil
    if def.isChecked == nil then
        def.isChecked = mode.jump_land.shouldSafetyFire
    end
end
function this.Define_SafetyFire_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Mode_JumpLand_SafetyFire_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[If this is turned on, fall damage will be eliminated by stopping the player right before they hit they ground

This damage elimination only happens if jetpack was recently used

This relies on raycasts and every once in a while, the player could land on edges or small objects without a raycast seeing it

There are other mods that turn off fall damage permanently

Personally, I like keeping fall damage most of the time and only turning it off when doing crazy arial stuff]]

    return retVal
end

function this.Define_ExplosiveJump_Checkbox(const)
    -- CheckBox
    return
    {
        invisible_name = "Mode_JumpLand_ExplosiveJump_Checkbox",

        text = "Explosive Jumping",

        isEnabled = true,

        position =
        {
            pos_x = 140,
            pos_y = -100,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_ExplosiveJump_Checkbox(def, mode)
    --NOTE: ActivateWindow_Mode_JumpLand sets this to nil
    if def.isChecked == nil then
        def.isChecked = mode.jump_land.explosiveJumping
    end
end
function this.Define_ExplosiveJump_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Mode_JumpLand_ExplosiveJump_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This will ragdoll npcs that are nearby when starting a jetpack

Only npcs that are in the player's view will be affected]]

    return retVal
end

function this.Define_ExplosiveLand_Checkbox(const)
    -- CheckBox
    return
    {
        invisible_name = "Mode_JumpLand_ExplosiveLand_Checkbox",

        text = "Explosive Landing",

        isEnabled = true,

        position =
        {
            pos_x = 140,
            pos_y = -40,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_ExplosiveLand_Checkbox(def, mode)
    --NOTE: ActivateWindow_Mode_JumpLand sets this to nil
    if def.isChecked == nil then
        def.isChecked = mode.jump_land.explosiveLanding
    end
end
function this.Define_ExplosiveLand_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Mode_JumpLand_ExplosiveLand_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This will ragdoll npcs near where the player lands

Harder impacts create stronger ragdolling

You'll want to turn off fall damage to use this properly

Only npcs that are in the player's view will be affected]]

    return retVal
end

function this.Define_JumpDelay_Label(relative_to, const)
    -- Label
    return
    {
        text = "Jump Delay",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_JumpDelay_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_JumpLand_JumpDelay_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This is in seconds.  The optimal delay is a quarter second or just a little less

Jetpack activates by holding in the jump.  It won't activate if too close to the ground

If the the delay is too low, jetpack will try to activate more often that you want

If the delay is too long, the player will jump and be coming back down before the jetpack tries to activate.  Then it shuts off because the player is too close to the ground]]

    return retVal
end
function this.Define_JumpDelay_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_JumpLand_JumpDelay_Value",

        min = 0.1,
        max = 0.6,

        decimal_places = 2,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 0,
            pos_y = 130,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_JumpDelay_Value(def, mode)
    --NOTE: ActivateWindow_Mode_JumpLand sets this to nil
    if not def.value then
        def.value = mode.jump_land.holdJumpDelay
    end
end

function this.Refresh_IsDirty(def, mode, def_safetyfire_checkbox, def_explosivejump_checkbox, def_explosiveland_checkbox, def_jumpdelay_value)
    local isDirty = false

    if mode.jump_land.shouldSafetyFire ~= def_safetyfire_checkbox.isChecked then
        isDirty = true

    elseif mode.jump_land.explosiveJumping ~= def_explosivejump_checkbox.isChecked then
        isDirty = true

    elseif mode.jump_land.explosiveLanding ~= def_explosiveland_checkbox.isChecked then
        isDirty = true

    elseif not IsNearValue(mode.jump_land.holdJumpDelay, def_jumpdelay_value.value) then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, mode, mode_index, def_safetyfire_checkbox, def_explosivejump_checkbox, def_explosiveland_checkbox, def_jumpdelay_value)
    mode.jump_land.shouldSafetyFire = def_safetyfire_checkbox.isChecked
    mode.jump_land.explosiveJumping = def_explosivejump_checkbox.isChecked
    mode.jump_land.explosiveLanding = def_explosiveland_checkbox.isChecked
    mode.jump_land.holdJumpDelay = def_jumpdelay_value.value

    player:SaveUpdatedMode(mode, mode_index)
end