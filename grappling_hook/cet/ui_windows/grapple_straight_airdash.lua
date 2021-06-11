local this = {}
local default_airdash = GetDefault_AirDash()

function DefineWindow_GrappleStraight_AirDash(vars_ui, const)
    local gst8_airdash = {}
    vars_ui.gst8_airdash = gst8_airdash

    gst8_airdash.changes = Changes:new()

    gst8_airdash.title = Define_Title("Grapple Straight - Air Dash", const)

    gst8_airdash.name = Define_Name(const)

    gst8_airdash.stickFigure = Define_StickFigure(false, const)
    gst8_airdash.arrows = Define_GrappleArrows(false, true)
    gst8_airdash.desired_line = Define_GrappleDesiredLength(false)

    -- Checkbox for whether to have airdash (Aim_Straight.air_dash)
    gst8_airdash.has_airdash = this.Define_HasAirDash(const)
    gst8_airdash.has_help = this.Define_Has_Help(const)

    gst8_airdash.burn_rate = this.Define_BurnRate(const)

    -- Percent (AirDash.burnReducePercent)
    local prompt, value, updown, help = Define_PropertyPack_Vertical("Reduce Percent", -220, 130, const, false, "GrappleStraight_AirDash_Percent", this.Tooltip_Percent())
    gst8_airdash.percent_prompt = prompt
    gst8_airdash.percent_value = value
    gst8_airdash.percent_updown = updown
    gst8_airdash.percent_help = help

    -- Accel (AirDash.accel.accel)
    prompt, value, updown, help = Define_PropertyPack_Vertical("Acceleration", 0, 130, const, false, "GrappleStraight_AirDash_Accel", this.Tooltip_Accel())
    gst8_airdash.accel_prompt = prompt
    gst8_airdash.accel_value = value
    gst8_airdash.accel_updown = updown
    gst8_airdash.accel_help = help

    -- Speed (AirDash.accel.speed)
    prompt, value, updown, help = Define_PropertyPack_Vertical("Max Speed", 220, 130, const, false, "GrappleStraight_AirDash_Speed", this.Tooltip_Speed())
    gst8_airdash.speed_prompt = prompt
    gst8_airdash.speed_value = value
    gst8_airdash.speed_updown = updown
    gst8_airdash.speed_help = help

    gst8_airdash.experience = Define_Experience(const, "grapple")

    gst8_airdash.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

local isHovered_has = false
local isHovered_percent = false
local isHovered_accel = false
local isHovered_speed = false

function DrawWindow_GrappleStraight_AirDash(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_GrappleStraight_AirDash: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local airdash = grapple.aim_straight.air_dash
    if not airdash then
        airdash = default_airdash
    end

    local startedWithAD = grapple.aim_straight.air_dash ~= nil

    local gst8_airdash = vars_ui.gst8_airdash

    local changes = gst8_airdash.changes

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_airdash.name, grapple.name)

    Refresh_GrappleArrows(gst8_airdash.arrows, grapple, true, false, isHovered_has or isHovered_percent or isHovered_accel or isHovered_speed)
    Refresh_GrappleDesiredLength(gst8_airdash.desired_line, grapple, nil, changes, false)

    this.Refresh_HasAirDash(gst8_airdash.has_airdash, player, grapple.aim_straight, airdash, changes)

    this.Refresh_BurnRate(gst8_airdash.burn_rate, airdash, changes)

    this.Refresh_Percent_Value(gst8_airdash.percent_value, airdash, changes)
    this.Refresh_Percent_UpDown(gst8_airdash.percent_updown, airdash, player, changes)

    this.Refresh_Accel_Value(gst8_airdash.accel_value, airdash.accel, changes)
    this.Refresh_Accel_UpDown(gst8_airdash.accel_updown, airdash.accel, player, changes)

    this.Refresh_Speed_Value(gst8_airdash.speed_value, airdash.accel, changes)
    this.Refresh_Speed_UpDown(gst8_airdash.speed_updown, airdash.accel, player, changes)

    this.Refresh_Experience(gst8_airdash.experience, player, grapple, changes, gst8_airdash.has_airdash.isChecked, startedWithAD)

    this.Refresh_IsDirty(gst8_airdash.okcancel, changes, grapple, gst8_airdash.has_airdash)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_airdash.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_airdash.name, vars_ui.style.colors, window.width, window.height, const)

    Draw_StickFigure(gst8_airdash.stickFigure, vars_ui.style.graphics, window.left, window.top, window.width, window.height, const)
    Draw_GrappleArrows(gst8_airdash.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)
    Draw_GrappleDesiredLength(gst8_airdash.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height)

    local wasChecked
    wasChecked, isHovered_has = Draw_CheckBox(gst8_airdash.has_airdash, vars_ui.style.checkbox, vars_ui.style.colors, window.width, window.height, const)
    if wasChecked then
        this.Update_HasAirDash(gst8_airdash.has_airdash, airdash, changes, startedWithAD)
    end

    Draw_HelpButton(gst8_airdash.has_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

    if gst8_airdash.has_airdash.isChecked then
        Draw_OrderedList(gst8_airdash.burn_rate, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

        -- Percent
        Draw_Label(gst8_airdash.percent_prompt, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(gst8_airdash.percent_value, vars_ui.style.colors, window.width, window.height, const)

        local isDownClicked, isUpClicked
        isDownClicked, isUpClicked, isHovered_percent = Draw_UpDownButtons(gst8_airdash.percent_updown, vars_ui.style.updownButtons, window.width, window.height, const)
        this.Update_Percent(gst8_airdash.percent_updown, changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_airdash.percent_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

        -- Accel
        Draw_Label(gst8_airdash.accel_prompt, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(gst8_airdash.accel_value, vars_ui.style.colors, window.width, window.height, const)

        isDownClicked, isUpClicked, isHovered_accel = Draw_UpDownButtons(gst8_airdash.accel_updown, vars_ui.style.updownButtons, window.width, window.height, const)
        this.Update_Accel(gst8_airdash.accel_updown, changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_airdash.accel_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

        -- Speed
        Draw_Label(gst8_airdash.speed_prompt, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(gst8_airdash.speed_value, vars_ui.style.colors, window.width, window.height, const)

        isDownClicked, isUpClicked, isHovered_speed = Draw_UpDownButtons(gst8_airdash.speed_updown, vars_ui.style.updownButtons, window.width, window.height, const)
        this.Update_Speed(gst8_airdash.speed_updown, changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_airdash.speed_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)
    else
        isHovered_percent = false
        isHovered_accel = false
        isHovered_speed = false
    end

    Draw_OrderedList(gst8_airdash.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_airdash.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, grapple.aim_straight, airdash, changes, gst8_airdash.has_airdash.isChecked, startedWithAD)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_airdash.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_HasAirDash(const)
    -- CheckBox
    return
    {
        invisible_name = "GrappleStraight_AirDash_HasAirDash",

        text = "Has Air Dash",

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }
end
function this.Refresh_HasAirDash(def, player, aim, airdash, changes)
    --NOTE: TransitionWindows_Straight_AirDash sets this to nil
    if def.isChecked == nil then
        def.isChecked = aim.air_dash ~= nil
    end

    if def.isChecked then
        def.isEnabled = true        -- it doesn't cost xp to remove, so the checkbox is always enabled here
    else
        def.isEnabled = player.experience + changes:Get("experience_buysell") >= airdash.experience
    end
end
function this.Update_HasAirDash(def, airdash, changes, startedWithAD)
    local total = airdash.experience        -- this is the price when the window was started, changes are tracked separately

    PopulateBuySell(def.isChecked, startedWithAD, changes, "experience_buysell", total)
end

function this.Define_Has_Help(const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "GrappleStraight_AirDash_Has_Help",

        position =
        {
            pos_x = 70,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }

    retVal.tooltip =
[[This is sort of like a rocket pack that propels you along the look direction

It's purpose is to give a little boost to reach spots you couldn't otherwise

It activates when the aim duration is over without seeing an anchor point.  The boost will stop once a grapple can be achieved, then the grapple will occur

It will also stop if there is no more energy

The main reason for making it was because raycasts can fail beyond 40-60, especially when looking up the side of a building.  Imagine the buildings as made of large lego blocks.  The visuals are always there, but the collision blocks aren't loaded until the player is close enough]]

    return retVal
end

function this.Define_BurnRate(const)
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
            pos_x = -220,
            pos_y = 60,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        gap = 12,

        color_prompt = "edit_prompt",
        color_value = "edit_value",
    }
end
function this.Refresh_BurnRate(def, airdash, changes)
    local rate = airdash.energyBurnRate * (1 - (airdash.burnReducePercent + changes:Get("burnReducePercent")))

    def.content.a_rate.value = tostring(Round(airdash.energyBurnRate, 2))
    def.content.b_reduced.value = tostring(Round(rate, 2))
end

function this.Tooltip_Percent()
    return "Reduces the cost per second of using air dash"
end
function this.Refresh_Percent_Value(def, airdash, changes)
    def.text = tostring(Round((airdash.burnReducePercent + changes:Get("burnReducePercent")) * 100)) .. "%"
end
function this.Refresh_Percent_UpDown(def, airdash, player, changes)
    local down, up = GetDecrementIncrement(airdash.burnReducePercent_update, airdash.burnReducePercent + changes:Get("burnReducePercent"), player.experience + changes:Get("experience_buysell") + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, 0, 100)
end
function this.Update_Percent(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("burnReducePercent", def.value_down)
        changes:Add("experience", 1)
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("burnReducePercent", def.value_up)
        changes:Subtract("experience", 1)
    end
end

function this.Tooltip_Accel()
    return
[[How hard to accelerate in the direction you are looking

(Gravity in this game is 16)]]
end
function this.Refresh_Accel_Value(def, accel, changes)
    def.text = tostring(Round(accel.accel + changes:Get("accel")))
end
function this.Refresh_Accel_UpDown(def, accel, player, changes)
    local down, up = GetDecrementIncrement(accel.accel_update, accel.accel + changes:Get("accel"), player.experience + changes:Get("experience_buysell") + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, 0)
end
function this.Update_Accel(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("accel", def.value_down)
        changes:Add("experience", 1)
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("accel", def.value_up)
        changes:Subtract("experience", 1)
    end
end

function this.Tooltip_Speed()
    return "Stops accelerating once this speed is reached"
end
function this.Refresh_Speed_Value(def, accel, changes)
    def.text = tostring(Round(accel.speed + changes:Get("speed")))
end
function this.Refresh_Speed_UpDown(def, accel, player, changes)
    local down, up = GetDecrementIncrement(accel.speed_update, accel.speed + changes:Get("speed"), player.experience + changes:Get("experience_buysell") + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, 0)
end
function this.Update_Speed(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("speed", def.value_down)
        changes:Add("experience", 1)
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("speed", def.value_up)
        changes:Subtract("experience", 1)
    end
end

function this.Refresh_Experience(def, player, grapple, changes, hasAD, startedWithAD)
    local cost = this.GetXPGainLoss(hasAD, startedWithAD, changes)

    def.content.available.value = tostring(math.floor(player.experience + cost))
    def.content.used.value = tostring(Round(grapple.experience - cost))
end

function this.Refresh_IsDirty(def, changes, aim, def_checkbox)
    local isDirty = false

    if def_checkbox.isChecked then
        if aim.air_dash then
            isDirty = changes:IsDirty()     -- changing existing
        else
            isDirty = true      -- creating a new one
        end
    else
        isDirty = aim.air_dash ~= nil       -- potentially removing one
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, aim, airdash, changes, hasAD, startedWithAD)
    if hasAD then
        if aim.air_dash then
            aim.air_dash.burnReducePercent = airdash.burnReducePercent + changes:Get("burnReducePercent")
            aim.air_dash.accel.accel = airdash.accel.accel + changes:Get("accel")
            aim.air_dash.accel.speed = airdash.accel.speed + changes:Get("speed")
            aim.air_dash.experience = airdash.experience - changes:Get("experience")
        else
            aim.air_dash =
            {
                energyBurnRate = airdash.energyBurnRate,        -- it's safe to directly copy this, because update structure is readonly

                burnReducePercent = airdash.burnReducePercent + changes:Get("burnReducePercent"),
                burnReducePercent_update = airdash.burnReducePercent_update,

                accel =
                {
                    accel = airdash.accel.accel + changes:Get("accel"),
                    accel_update = airdash.accel.accel_update,

                    speed = airdash.accel.speed + changes:Get("speed"),
                    speed_update = airdash.accel.speed_update,

                    deadSpot_distance = airdash.accel.deadSpot_distance,
                    deadSpot_speed = airdash.accel.deadSpot_speed,
                },

                mappin_name = airdash.mappin_name,

                experience = airdash.experience - changes:Get("experience")
            }
        end
    else
        aim.air_dash = nil
    end

    local cost = this.GetXPGainLoss(hasAD, startedWithAD, changes)

    grapple.experience = grapple.experience - cost
    player.experience = player.experience + cost

    player:Save()
end

function this.GetXPGainLoss(hasAD, startedWithAD, changes)
    if hasAD then
        if startedWithAD then
            return changes:Get("experience")
        else
            return changes:Get("experience_buysell") + changes:Get("experience")
        end
    else
        if startedWithAD then
            return changes:Get("experience_buysell")       -- not including any upgrades/buybacks on individual props, because they are selling what they started with
        else
            return 0
        end
    end
end