local this = {}
local default_airanchor = GetDefault_AirAnchor()

local COLUMN_X = 140

local isHovered_has = false
local isHovered_cost = false
local isHovered_rate = false

function DefineWindow_GrappleStraight_AirAnchor(vars_ui, const)
    local gst8_airanchor = {}
    vars_ui.gst8_airanchor = gst8_airanchor

    gst8_airanchor.changes = Changes:new()

    gst8_airanchor.title = Define_Title("Grapple Straight - Air Anchor", const)

    gst8_airanchor.name = Define_Name(const)


-- highlight the standard line on hover

    gst8_airanchor.stickFigure = Define_StickFigure(false, const)
    gst8_airanchor.arrows = Define_GrappleArrows(true, false)
    gst8_airanchor.desired_line = Define_GrappleDesiredLength(false)

    -- Checkbox for whether to have air anchor (Aim_Straight.air_anchor)
    gst8_airanchor.has_airanchor = this.Define_HasAirAnchor(const)
    gst8_airanchor.has_help = this.Define_Has_Help(gst8_airanchor.has_airanchor, const)

    -- Energy Cost
    gst8_airanchor.cost = this.Define_Cost(const)

    local prompt, value, updown, help = Define_PropertyPack_Vertical("Reduce Percent", -COLUMN_X, 130, const, false, "GrappleStraight_AirAnchor_Cost", this.Tooltip_Cost())
    gst8_airanchor.cost_prompt = prompt
    gst8_airanchor.cost_value = value
    gst8_airanchor.cost_updown = updown
    gst8_airanchor.cost_help = help

    -- Burn Rate
    gst8_airanchor.rate = this.Define_Rate(const)

    prompt, value, updown, help = Define_PropertyPack_Vertical("Reduce Percent", COLUMN_X, 130, const, false, "GrappleStraight_AirAnchor_Rate", this.Tooltip_Rate())
    gst8_airanchor.rate_prompt = prompt
    gst8_airanchor.rate_value = value
    gst8_airanchor.rate_updown = updown
    gst8_airanchor.rate_help = help

    gst8_airanchor.experience = Define_Experience(const, "grapple")

    gst8_airanchor.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(gst8_airanchor)
end

function ActivateWindow_GrappleStraight_AirAnchor(vars_ui, const)
    if not vars_ui.gst8_airanchor then
        DefineWindow_GrappleStraight_AirAnchor(vars_ui, const)
    end

    vars_ui.gst8_airanchor.changes:Clear()

    vars_ui.gst8_airanchor.has_airanchor.isChecked = nil
end

function DrawWindow_GrappleStraight_AirAnchor(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_GrappleStraight_AirAnchor: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local airanchor = grapple.aim_straight.air_anchor
    if not airanchor then
        airanchor = default_airanchor
    end

    local startedWithAA = grapple.aim_straight.air_anchor ~= nil

    local gst8_airanchor = vars_ui.gst8_airanchor

    local changes = gst8_airanchor.changes

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_airanchor.name, grapple.name)

    Refresh_GrappleArrows(gst8_airanchor.arrows, grapple, false, isHovered_has or isHovered_cost or isHovered_rate, false)
    Refresh_GrappleDesiredLength(gst8_airanchor.desired_line, grapple, nil, changes, false)

    this.Refresh_HasAirAnchor(gst8_airanchor.has_airanchor, player, grapple.aim_straight, airanchor, changes)

    -- Cost
    this.Refresh_Cost(gst8_airanchor.cost, airanchor, changes)

    this.Refresh_Cost_Value(gst8_airanchor.cost_value, airanchor, changes)
    this.Refresh_Cost_UpDown(gst8_airanchor.cost_updown, airanchor, player, changes)

    -- Rate
    this.Refresh_Rate(gst8_airanchor.rate, airanchor, changes)

    this.Refresh_Rate_Value(gst8_airanchor.rate_value, airanchor, changes)
    this.Refresh_Rate_UpDown(gst8_airanchor.rate_updown, airanchor, player, changes)

    this.Refresh_Experience(gst8_airanchor.experience, player, grapple, changes, gst8_airanchor.has_airanchor.isChecked, startedWithAA)

    this.Refresh_IsDirty(gst8_airanchor.okcancel, changes, grapple.aim_straight, gst8_airanchor.has_airanchor)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(gst8_airanchor.render_nodes, vars_ui.style, vars_ui.line_heights)
    CalculatePositions(gst8_airanchor.render_nodes, window.width, window.height, const)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_airanchor.title, vars_ui.style.colors)

    Draw_Label(gst8_airanchor.name, vars_ui.style.colors)

    Draw_StickFigure(gst8_airanchor.stickFigure, vars_ui.style.graphics, window.left, window.top)
    Draw_GrappleArrows(gst8_airanchor.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)
    Draw_GrappleDesiredLength(gst8_airanchor.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height)


    local wasChecked
    wasChecked, isHovered_has = Draw_CheckBox(gst8_airanchor.has_airanchor, vars_ui.style.checkbox, vars_ui.style.colors)
    if wasChecked then
        this.Update_HasAirAnchor(gst8_airanchor.has_airanchor, airanchor, changes, startedWithAA)
    end

    Draw_HelpButton(gst8_airanchor.has_help, vars_ui.style.helpButton, window.left, window.top, vars_ui)

    if gst8_airanchor.has_airanchor.isChecked then
        -- Cost
        Draw_OrderedList(gst8_airanchor.cost, vars_ui.style.colors)

        Draw_Label(gst8_airanchor.cost_prompt, vars_ui.style.colors)
        Draw_Label(gst8_airanchor.cost_value, vars_ui.style.colors)

        local isDownClicked, isUpClicked
        isDownClicked, isUpClicked, isHovered_cost = Draw_UpDownButtons(gst8_airanchor.cost_updown, vars_ui.style.updownButtons)
        this.Update_Cost(gst8_airanchor.cost_updown, changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_airanchor.cost_help, vars_ui.style.helpButton, window.left, window.top, vars_ui)

        -- Rate
        Draw_OrderedList(gst8_airanchor.rate, vars_ui.style.colors)

        Draw_Label(gst8_airanchor.rate_prompt, vars_ui.style.colors)
        Draw_Label(gst8_airanchor.rate_value, vars_ui.style.colors)

        local isDownClicked, isUpClicked
        isDownClicked, isUpClicked, isHovered_rate = Draw_UpDownButtons(gst8_airanchor.rate_updown, vars_ui.style.updownButtons)
        this.Update_Rate(gst8_airanchor.rate_updown, changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_airanchor.rate_help, vars_ui.style.helpButton, window.left, window.top, vars_ui)
    else
        isHovered_cost = false
        isHovered_rate = false
    end

    Draw_OrderedList(gst8_airanchor.experience, vars_ui.style.colors)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_airanchor.okcancel, vars_ui.style.okcancelButtons)
    if isOKClicked then
        this.Save(player, grapple, grapple.aim_straight, airanchor, changes, gst8_airanchor.has_airanchor.isChecked, startedWithAA)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_airanchor.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------


function this.Define_HasAirAnchor(const)
    -- CheckBox
    return
    {
        invisible_name = "GrappleStraight_AirAnchor_HasAirAnchor",

        text = "Has Air Anchor",

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
function this.Refresh_HasAirAnchor(def, player, aim, airanchor, changes)
    --NOTE: TransitionWindows_Straight_AirAnchor sets this to nil
    if def.isChecked == nil then
        def.isChecked = aim.air_anchor ~= nil
    end

    if def.isChecked then
        def.isEnabled = true        -- it doesn't cost xp to remove, so the checkbox is always enabled here
    else
        def.isEnabled = player.experience + changes:Get("experience_buysell") >= airanchor.experience
    end
end
function this.Update_HasAirAnchor(def, airanchor, changes, startedWithAA)
    local total = airanchor.experience        -- this is the price when the window was started, changes are tracked separately

    PopulateBuySell(def.isChecked, startedWithAA, changes, "experience_buysell", total)
end

function this.Define_Has_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "GrappleStraight_AirAnchor_Has_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This will anchor to mid air if the aim duration expired without seeing a solid object

This will cost extra energy each time you use it, as well as energy drain while in use (to power a mini drone that serves as an anchor point)]]

    return retVal
end

function this.Define_Cost(const)
    -- OrderedList
    return
    {
        content =
        {
            a_rate = { prompt = "Extra Energy Cost" },
            b_reduced = { prompt = "Reduced" },
        },

        position =
        {
            pos_x = -COLUMN_X,
            pos_y = 60,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        gap = 12,

        color_prompt = "edit_prompt",
        color_value = "edit_value",

        CalcSize = CalcSize_OrderedList,
    }
end
function this.Refresh_Cost(def, airanchor, changes)
    local cost = airanchor.energyCost * (1 - (airanchor.energyCost_reduction_percent + changes:Get("energyCost_reduction_percent")))

    def.content.a_rate.value = tostring(Round(airanchor.energyCost, 1))
    def.content.b_reduced.value = tostring(Round(cost, 1))
end

function this.Tooltip_Cost()
    return "Reduces the extra cost of using air anchor"
end
function this.Refresh_Cost_Value(def, airanchor, changes)
    def.text = tostring(Round((airanchor.energyCost_reduction_percent + changes:Get("energyCost_reduction_percent")) * 100)) .. "%"
end
function this.Refresh_Cost_UpDown(def, airanchor, player, changes)
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(airanchor.energyCost_reduction_percent_update, airanchor.energyCost_reduction_percent + changes:Get("energyCost_reduction_percent"), player.experience + changes:Get("experience_buysell") + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up, 0, 100)
end
function this.Update_Cost(def, changes, isDownClicked, isUpClicked)
    Update_UpDownButton("energyCost_reduction_percent", "experience", isDownClicked, isUpClicked, def, changes)
end

function this.Define_Rate(const)
    -- OrderedList
    return
    {
        content =
        {
            a_rate = { prompt = "Burn Rate" },
            b_reduced = { prompt = "Reduced" },
        },

        position =
        {
            pos_x = COLUMN_X,
            pos_y = 60,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        gap = 12,

        color_prompt = "edit_prompt",
        color_value = "edit_value",

        CalcSize = CalcSize_OrderedList,
    }
end
function this.Refresh_Rate(def, airanchor, changes)
    local rate = airanchor.energyBurnRate * (1 - (airanchor.burnReducePercent + changes:Get("burnReducePercent")))

    def.content.a_rate.value = tostring(Round(airanchor.energyBurnRate, 2))
    def.content.b_reduced.value = tostring(Round(rate, 2))
end

function this.Tooltip_Rate()
    return "Reduces the cost per second of using air anchor"
end
function this.Refresh_Rate_Value(def, airanchor, changes)
    def.text = tostring(Round((airanchor.burnReducePercent + changes:Get("burnReducePercent")) * 100)) .. "%"
end
function this.Refresh_Rate_UpDown(def, airanchor, player, changes)
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(airanchor.burnReducePercent_update, airanchor.burnReducePercent + changes:Get("burnReducePercent"), player.experience + changes:Get("experience_buysell") + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up, 0, 100)
end
function this.Update_Rate(def, changes, isDownClicked, isUpClicked)
    Update_UpDownButton("burnReducePercent", "experience", isDownClicked, isUpClicked, def, changes)
end

function this.Refresh_Experience(def, player, grapple, changes, hasAA, startedWithAA)
    local cost = this.GetXPGainLoss(hasAA, startedWithAA, changes)

    def.content.available.value = tostring(math.floor(player.experience + cost))
    def.content.used.value = tostring(Round(grapple.experience - cost))
end

function this.Refresh_IsDirty(def, changes, aim, def_checkbox)
    local isDirty = false

    if def_checkbox.isChecked then
        if aim.air_anchor then
            isDirty = changes:IsDirty()     -- changing existing
        else
            isDirty = true      -- creating a new one
        end
    else
        isDirty = aim.air_anchor ~= nil       -- potentially removing one
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, aim, airanchor, changes, hasAA, startedWithAA)
    local cost = this.GetXPGainLoss(hasAA, startedWithAA, changes)
    if not player:TransferExperience_GrappleStraight(grapple, -cost) then
        do return end
    end

    if hasAA then
        if aim.air_anchor then
            aim.air_anchor.experience = airanchor.experience - changes:Get("experience")
            aim.air_anchor.energyCost_reduction_percent = airanchor.energyCost_reduction_percent + changes:Get("energyCost_reduction_percent")
            aim.air_anchor.burnReducePercent = airanchor.burnReducePercent + changes:Get("burnReducePercent")

        else
            -- Stitch together a new one based on the default and changed values
            aim.air_anchor =
            {
                energyCost = airanchor.energyCost,

                energyCost_reduction_percent = airanchor.energyCost_reduction_percent + changes:Get("energyCost_reduction_percent"),
                energyCost_reduction_percent_update = airanchor.energyCost_reduction_percent_update,

                energyBurnRate = airanchor.energyBurnRate,

                burnReducePercent = airanchor.burnReducePercent + changes:Get("burnReducePercent"),
                burnReducePercent_update = airanchor.burnReducePercent_update,

                experience = airanchor.experience - changes:Get("experience")
            }
        end
    else
        aim.air_anchor = nil
    end

    player:Save()
end

function this.GetXPGainLoss(hasAA, startedWithAA, changes)
    if hasAA then
        if startedWithAA then
            return changes:Get("experience")
        else
            return changes:Get("experience_buysell") + changes:Get("experience")
        end
    else
        if startedWithAA then
            return changes:Get("experience_buysell")       -- not including any upgrades/buybacks on individual props, because they are selling what they started with
        else
            return 0
        end
    end
end