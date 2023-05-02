local this = {}

function DefineWindow_Grapple_Swing(vars_ui, const)
    local grapple_swing = {}
    vars_ui.grapple_swing = grapple_swing

    grapple_swing.changes = Changes:new()

    grapple_swing.title = Define_Title("Swing", const)

    grapple_swing.name = this.Define_Name(const)
    grapple_swing.description = this.Define_Description(grapple_swing.name, const)

    grapple_swing.visuals = this.Define_Visuals(const)

    local prompt, value, updown, help = Define_PropertyPack_Vertical("Energy Cost Reduction", -120, -100, const, false, "Grapple_Swing_EnergyCostReduction", this.Tooltip_EnergyCostReduction())
    grapple_swing.energyreduce_prompt = prompt
    grapple_swing.energyreduce_value = value
    grapple_swing.energyreduce_updown = updown
    grapple_swing.energyreduce_help = help

    prompt, value, updown, help = Define_PropertyPack_Vertical("Boost Cost Reduction", 120, -100, const, false, "Grapple_Swing_BoostCostReduction", this.Tooltip_BoostCostReduction())
    grapple_swing.boostreduce_prompt = prompt
    grapple_swing.boostreduce_value = value
    grapple_swing.boostreduce_updown = updown
    grapple_swing.boostreduce_help = help

    prompt, value, updown, help = Define_PropertyPack_Vertical("Boost Accel", -120, 100, const, false, "Grapple_Swing_BoostAccel", this.Tooltip_BoostAccel())
    grapple_swing.boostaccel_prompt = prompt
    grapple_swing.boostaccel_value = value
    grapple_swing.boostaccel_updown = updown
    grapple_swing.boostaccel_help = help

    prompt, value, updown, help = Define_PropertyPack_Vertical("Boosting Air Friction Reduction", 120, 100, const, false, "Grapple_Swing_AirFrictionReduction", this.Tooltip_AirFrictionReduction())
    grapple_swing.airfrictionreduce_prompt = prompt
    grapple_swing.airfrictionreduce_value = value
    grapple_swing.airfrictionreduce_updown = updown
    grapple_swing.airfrictionreduce_help = help


    -- Should Latch
    -- Max Latch Angle
    -- Max Latch Relative Speed


    grapple_swing.experience = Define_Experience(const, "grapple")

    grapple_swing.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(grapple_swing)
end

function ActivateWindow_Grapple_Swing(vars_ui, const)
    if not vars_ui.grapple_swing then
        DefineWindow_Grapple_Swing(vars_ui, const)
    end

    vars_ui.grapple_swing.changes:Clear()

    vars_ui.grapple_swing.name.text = nil
    vars_ui.grapple_swing.description.text = nil
end

function DrawWindow_Grapple_Swing(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        LogError("DrawWindow_Grapple_Swing: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local grapple_swing = vars_ui.grapple_swing

    local changes = grapple_swing.changes

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Name(grapple_swing.name, grapple)

    this.Refresh_Description(grapple_swing.description, grapple)

    this.Refresh_EnergyCostReduction_Value(grapple_swing.energyreduce_value, grapple, changes)
    this.Refresh_EnergyCostReduction_UpDown(grapple_swing.energyreduce_updown, grapple, player, changes)

    this.Refresh_BoostCostReduction_Value(grapple_swing.boostreduce_value, grapple, changes)
    this.Refresh_BoostCostReduction_UpDown(grapple_swing.boostreduce_updown, grapple, player, changes)

    this.Refresh_BoostAccel_Value(grapple_swing.boostaccel_value, grapple, changes)
    this.Refresh_BoostAccel_UpDown(grapple_swing.boostaccel_updown, grapple, player, changes)

    this.Refresh_AirFrictionReduction_Value(grapple_swing.airfrictionreduce_value, grapple, changes)
    this.Refresh_AirFrictionReduction_UpDown(grapple_swing.airfrictionreduce_updown, grapple, player, changes)

    this.Refresh_Experience(grapple_swing.experience, player, grapple, changes)

    this.Refresh_IsDirty(grapple_swing.okcancel, grapple_swing.name, changes, grapple)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(grapple_swing.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(grapple_swing.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(grapple_swing.title, vars_ui.style.colors, vars_ui.scale)

    Draw_TextBox(grapple_swing.name, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(grapple_swing.description, vars_ui.style.colors, vars_ui.scale)

    -- Energy Cost Reduction
    Draw_Label(grapple_swing.energyreduce_prompt, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(grapple_swing.energyreduce_value, vars_ui.style.colors, vars_ui.scale)

    local isDownClicked, isUpClicked = Draw_UpDownButtons(grapple_swing.energyreduce_updown, vars_ui.style.updownButtons, vars_ui.scale)
    this.Update_EnergyCostReduction(grapple_swing.energyreduce_updown, changes, isDownClicked, isUpClicked)

    Draw_HelpButton(grapple_swing.energyreduce_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    -- Boost Cost Reduction
    Draw_Label(grapple_swing.boostreduce_prompt, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(grapple_swing.boostreduce_value, vars_ui.style.colors, vars_ui.scale)

    isDownClicked, isUpClicked = Draw_UpDownButtons(grapple_swing.boostreduce_updown, vars_ui.style.updownButtons, vars_ui.scale)
    this.Update_BoostCostReduction(grapple_swing.boostreduce_updown, changes, isDownClicked, isUpClicked)

    Draw_HelpButton(grapple_swing.boostreduce_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    -- Boost Accel
    Draw_Label(grapple_swing.boostaccel_prompt, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(grapple_swing.boostaccel_value, vars_ui.style.colors, vars_ui.scale)

    isDownClicked, isUpClicked = Draw_UpDownButtons(grapple_swing.boostaccel_updown, vars_ui.style.updownButtons, vars_ui.scale)
    this.Update_BoostAccel(grapple_swing.boostaccel_updown, changes, isDownClicked, isUpClicked)

    Draw_HelpButton(grapple_swing.boostaccel_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    -- Air Friction Reduction
    Draw_Label(grapple_swing.airfrictionreduce_prompt, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(grapple_swing.airfrictionreduce_value, vars_ui.style.colors, vars_ui.scale)

    isDownClicked, isUpClicked = Draw_UpDownButtons(grapple_swing.airfrictionreduce_updown, vars_ui.style.updownButtons, vars_ui.scale)
    this.Update_AirFrictionReduction(grapple_swing.airfrictionreduce_updown, changes, isDownClicked, isUpClicked)

    Draw_HelpButton(grapple_swing.airfrictionreduce_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    if Draw_SummaryButton(grapple_swing.visuals, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Visuals(vars_ui, const)
    end

    Draw_OrderedList(grapple_swing.experience, vars_ui.style.colors)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(grapple_swing.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, grapple, grapple_swing.name, changes)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not grapple_swing.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Name(const)
    -- TextBox
    return
    {
        invisible_name = "Grapple_Swing_GrappleName",

        maxChars = 48,
        min_width = 120,
        --max_width = 240,

        isMultiLine = false,

        foreground_override = "subTitle",

        position =
        {
            pos_x = 30,
            pos_y = 30,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Name(def, grapple)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    --NOTE: ActivateWindow_Grapple_Swing sets this to nil
    if not def.text then
        def.text = grapple.name
    end
end

function this.Define_Description(relative_to, const)
    -- Label
    return
    {
        max_width = 320,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 13,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Refresh_Description(def, grapple)
    if not def.text then
        def.text = grapple.description
    end
end

function this.Define_Visuals(const)
    -- SummaryButton
    return
    {
        header_prompt = "Visuals / Color",

        position =
        {
            pos_x = 0,
            pos_y = 60,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.top,
        },

        invisible_name = "Grapple_Swing_Visuals",

        CalcSize = CalcSize_SummaryButton,
    }
end

function this.Tooltip_EnergyCostReduction()
    return
[[]]
end

function this.Tooltip_BoostCostReduction()
    return
[[]]
end

function this.Tooltip_BoostAccel()
    return
[[]]
end

function this.Tooltip_AirFrictionReduction()
    return
[[]]
end

function this.Refresh_EnergyCostReduction_Value(def, grapple, changes)
    def.text = tostring(Round((grapple.aim_swing.cost_reduction_percent + changes:Get("cost_reduction_percent")) * 100)) .. "%"
end
function this.Refresh_EnergyCostReduction_UpDown(def, grapple, player, changes)
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(grapple.aim_swing.cost_reduction_percent_update, grapple.aim_swing.cost_reduction_percent + changes:Get("cost_reduction_percent"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up, 0, 100)
end
function this.Update_EnergyCostReduction(def, changes, isDownClicked, isUpClicked)
    Update_UpDownButton("cost_reduction_percent", "experience", isDownClicked, isUpClicked, def, changes)
end

function this.Refresh_BoostCostReduction_Value(def, grapple, changes)
    def.text = tostring(Round((grapple.aim_swing.boost_cost_reduction_percent + changes:Get("boost_cost_reduction_percent")) * 100)) .. "%"
end
function this.Refresh_BoostCostReduction_UpDown(def, grapple, player, changes)
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(grapple.aim_swing.boost_cost_reduction_percent_update, grapple.aim_swing.boost_cost_reduction_percent + changes:Get("boost_cost_reduction_percent"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up, 0, 100)
end
function this.Update_BoostCostReduction(def, changes, isDownClicked, isUpClicked)
    Update_UpDownButton("boost_cost_reduction_percent", "experience", isDownClicked, isUpClicked, def, changes)
end

function this.Refresh_BoostAccel_Value(def, grapple, changes)
    def.text = tostring(Round(grapple.aim_swing.boost_accel + changes:Get("boost_accel")))
end
function this.Refresh_BoostAccel_UpDown(def, grapple, player, changes)
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(grapple.aim_swing.boost_accel_update, grapple.aim_swing.boost_accel + changes:Get("boost_accel"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up, 0, 1)
end
function this.Update_BoostAccel(def, changes, isDownClicked, isUpClicked)
    Update_UpDownButton("boost_accel", "experience", isDownClicked, isUpClicked, def, changes)
end

function this.Refresh_AirFrictionReduction_Value(def, grapple, changes)
    def.text = tostring(Round((grapple.aim_swing.boostedairfriction_reduction_percent + changes:Get("boostedairfriction_reduction_percent")) * 100)) .. "%"
end
function this.Refresh_AirFrictionReduction_UpDown(def, grapple, player, changes)
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(grapple.aim_swing.boostedairfriction_reduction_percent_update, grapple.aim_swing.boostedairfriction_reduction_percent + changes:Get("boostedairfriction_reduction_percent"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up, 0, 100)
end
function this.Update_AirFrictionReduction(def, changes, isDownClicked, isUpClicked)
    Update_UpDownButton("boostedairfriction_reduction_percent", "experience", isDownClicked, isUpClicked, def, changes)
end

function this.Refresh_Experience(def, player, grapple, changes)
    def.content.available.value = tostring(math.floor(player.experience + changes:Get("experience")))
    def.content.used.value = tostring(Round(grapple.experience - changes:Get("experience")))
end

function this.Refresh_IsDirty(def, def_name, changes, grapple)
    local isDirty = false

    if def_name.text and def_name.text ~= grapple.name then
        isDirty = true

    elseif changes:IsDirty() then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, def_name, changes)
    if not player:TransferExperience_Grapple(grapple, -changes:Get("experience")) then
        do return end
    end

    grapple.name = def_name.text

    grapple.aim_swing.cost_reduction_percent = grapple.aim_swing.cost_reduction_percent + changes:Get("cost_reduction_percent")
    grapple.aim_swing.boost_cost_reduction_percent = grapple.aim_swing.boost_cost_reduction_percent + changes:Get("boost_cost_reduction_percent")
    grapple.aim_swing.boost_accel = grapple.aim_swing.boost_accel + changes:Get("boost_accel")
    grapple.aim_swing.boostedairfriction_reduction_percent = grapple.aim_swing.boostedairfriction_reduction_percent + changes:Get("boostedairfriction_reduction_percent")

    player:Save()
end