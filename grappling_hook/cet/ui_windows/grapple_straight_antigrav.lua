local this = {}
local default_antigrav = GetDefault_AntiGravity()

function DefineWindow_GrappleStraight_AntiGrav(vars_ui, const)
    local gst8_antgrav = {}
    vars_ui.gst8_antgrav = gst8_antgrav

    gst8_antgrav.changes = Changes:new()

    gst8_antgrav.title = Define_Title("Grapple Straight - Anti Gravity", const)

    gst8_antgrav.name = Define_Name(const)

    gst8_antgrav.stickFigure = Define_StickFigure(true, const)
    gst8_antgrav.arrows = Define_GrappleArrows(false, false)
    gst8_antgrav.desired_line = Define_GrappleDesiredLength(false)

    -- Checkbox for whether to have antigrav (Grapple.anti_gravity)
    gst8_antgrav.has_antigrav = this.Define_HasAntiGrav(const)
    gst8_antgrav.has_help = this.Define_Has_Help(const)

    -- Percent (AntiGravity.antigrav_percent)
    local prompt, value, updown, help = Define_PropertyPack_Vertical("Antigrav Percent", -180, 100, const, false, "GrappleStraight_AntiGrav_Percent", this.Tooltip_Percent())
    gst8_antgrav.percent_prompt = prompt
    gst8_antgrav.percent_value = value
    gst8_antgrav.percent_updown = updown
    gst8_antgrav.percent_help = help

    -- Fade Duration (AntiGravity.fade_duration)
    prompt, value, updown, help = Define_PropertyPack_Vertical("Fade Duration", 180, 100, const, false, "GrappleStraight_AntiGrav_Fade", this.Tooltip_Fade())
    gst8_antgrav.fade_prompt = prompt
    gst8_antgrav.fade_value = value
    gst8_antgrav.fade_updown = updown
    gst8_antgrav.fade_help = help

    gst8_antgrav.experience = Define_Experience(const, "grapple")

    gst8_antgrav.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function ActivateWindow_GrappleStraight_AntiGrav(vars_ui)
    vars_ui.gst8_antgrav.changes:Clear()

    vars_ui.gst8_antgrav.has_antigrav.isChecked = nil
end

local isHovered_has = false
local isHovered_percent = false
local isHovered_fade = false

function DrawWindow_GrappleStraight_AntiGrav(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_GrappleStraight_AntiGrav: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local antigrav = grapple.anti_gravity
    if not antigrav then
        antigrav = default_antigrav
    end

    local startedWithAG = grapple.anti_gravity ~= nil

    local gst8_antgrav = vars_ui.gst8_antgrav

    local changes = gst8_antgrav.changes

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_antgrav.name, grapple.name)

    Refresh_StickFigure(gst8_antgrav.stickFigure, isHovered_has or isHovered_percent or isHovered_fade)
    Refresh_GrappleArrows(gst8_antgrav.arrows, grapple, false, false, false)
    Refresh_GrappleDesiredLength(gst8_antgrav.desired_line, grapple, nil, changes, false)

    this.Refresh_HasAntiGrav(gst8_antgrav.has_antigrav, player, grapple, antigrav, changes)

    this.Refresh_Percent_Value(gst8_antgrav.percent_value, antigrav, changes)
    this.Refresh_Percent_UpDown(gst8_antgrav.percent_updown, antigrav, player, changes)

    this.Refresh_Fade_Value(gst8_antgrav.fade_value, antigrav, changes)
    this.Refresh_Fade_UpDown(gst8_antgrav.fade_updown, antigrav, player, changes)

    this.Refresh_Experience(gst8_antgrav.experience, player, grapple, changes, gst8_antgrav.has_antigrav.isChecked, startedWithAG)

    this.Refresh_IsDirty(gst8_antgrav.okcancel, changes, grapple, gst8_antgrav.has_antigrav)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_antgrav.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_antgrav.name, vars_ui.style.colors, window.width, window.height, const)

    Draw_StickFigure(gst8_antgrav.stickFigure, vars_ui.style.graphics, window.left, window.top, window.width, window.height, const)
    Draw_GrappleArrows(gst8_antgrav.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)
    Draw_GrappleDesiredLength(gst8_antgrav.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height)

    local wasChecked
    wasChecked, isHovered_has = Draw_CheckBox(gst8_antgrav.has_antigrav, vars_ui.style.checkbox, vars_ui.style.colors, window.width, window.height, const)
    if wasChecked then
        this.Update_HasAntiGrav(gst8_antgrav.has_antigrav, antigrav, changes, startedWithAG)
    end

    Draw_HelpButton(gst8_antgrav.has_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

    if gst8_antgrav.has_antigrav.isChecked then
        -- Percent
        Draw_Label(gst8_antgrav.percent_prompt, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(gst8_antgrav.percent_value, vars_ui.style.colors, window.width, window.height, const)

        local isDownClicked, isUpClicked
        isDownClicked, isUpClicked, isHovered_percent = Draw_UpDownButtons(gst8_antgrav.percent_updown, vars_ui.style.updownButtons, window.width, window.height, const)
        this.Update_Percent(gst8_antgrav.percent_updown, changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_antgrav.percent_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

        -- Fade
        Draw_Label(gst8_antgrav.fade_prompt, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(gst8_antgrav.fade_value, vars_ui.style.colors, window.width, window.height, const)

        isDownClicked, isUpClicked, isHovered_fade = Draw_UpDownButtons(gst8_antgrav.fade_updown, vars_ui.style.updownButtons, window.width, window.height, const)
        this.Update_Fade(gst8_antgrav.fade_updown, changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_antgrav.fade_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)
    else
        isHovered_percent = false
        isHovered_fade = false
    end

    Draw_OrderedList(gst8_antgrav.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_antgrav.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, antigrav, changes, gst8_antgrav.has_antigrav.isChecked, startedWithAG)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_antgrav.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_HasAntiGrav(const)
    -- CheckBox
    return
    {
        invisible_name = "GrappleStraight_AntiGrav_HasAntiGrav",

        text = "Has Anti Gravity",

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }
end
function this.Refresh_HasAntiGrav(def, player, grapple, antigrav, changes)
    --NOTE: TransitionWindows_Straight_AntiGrav sets this to nil
    if def.isChecked == nil then
        def.isChecked = grapple.anti_gravity ~= nil
    end

    if def.isChecked then
        def.isEnabled = true        -- it doesn't cost xp to remove, so the checkbox is always enabled here
    else
        def.isEnabled = player.experience + changes:Get("experience_buysell") >= antigrav.experience
    end
end
function this.Update_HasAntiGrav(def, antigrav, changes, startedWithAG)
    --local total = antigrav.experience + changes:Get("experience")     -- don't want to include values in changes, because that would be a double counting
    local total = antigrav.experience

    PopulateBuySell(def.isChecked, startedWithAG, changes, "experience_buysell", total)
end

function this.Define_Has_Help(const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "GrappleStraight_AntiGrav_Has_Help",

        position =
        {
            pos_x = 85,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }

    retVal.tooltip =
[[Antigravity will make you more floaty while grappling

It has a side benefit of not requiring such strong acceleration values

Antigravity is useful for pull style grapples, causing you to fly more easily, getting thrown farther

A small amount of antigrav might be desirable for tarzan swinging, because it will slow down the swing.  But a large amount of antigravity will just be annoying and generally uncontrollable]]

    return retVal
end

function this.Tooltip_Percent()
    return
[[0% would be standard gravity

100% would be weightless]]
end
function this.Refresh_Percent_Value(def, antigrav, changes)
    def.text = tostring(Round((antigrav.antigrav_percent + changes:Get("antigrav_percent")) * 100)) .. "%"
end
function this.Refresh_Percent_UpDown(def, antigrav, player, changes)
    local down, up = GetDecrementIncrement(antigrav.antigrav_percent_update, antigrav.antigrav_percent + changes:Get("antigrav_percent"), player.experience + changes:Get("experience_buysell") + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, 0, 100)
end
function this.Update_Percent(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("antigrav_percent", def.value_down)
        changes:Add("experience", 1)
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("antigrav_percent", def.value_up)
        changes:Subtract("experience", 1)
    end
end

function this.Tooltip_Fade()
    return
[[This is in seconds

When a grapple has ended, the antigravity will fade to standard gravity

Increasing this duration will keep you lighter longer, and will have the effect of throwing you farther]]
end
function this.Refresh_Fade_Value(def, antigrav, changes)
    def.text = tostring(Round(antigrav.fade_duration + changes:Get("fade_duration"), 2))
end
function this.Refresh_Fade_UpDown(def, antigrav, player, changes)
    local down, up = GetDecrementIncrement(antigrav.fade_duration_update, antigrav.fade_duration + changes:Get("fade_duration"), player.experience + changes:Get("experience_buysell") + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, 2)
end
function this.Update_Fade(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("fade_duration", def.value_down)
        changes:Add("experience", 1)
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("fade_duration", def.value_up)
        changes:Subtract("experience", 1)
    end
end

function this.Refresh_Experience(def, player, grapple, changes, hasAG, startedWithAG)
    local cost = this.GetXPGainLoss(hasAG, startedWithAG, changes)

    def.content.available.value = tostring(math.floor(player.experience + cost))
    def.content.used.value = tostring(Round(grapple.experience - cost))
end

function this.Refresh_IsDirty(def, changes, grapple, def_checkbox)
    local isDirty = false

    if def_checkbox.isChecked then
        if grapple.anti_gravity then
            isDirty = changes:IsDirty()     -- changing existing
        else
            isDirty = true      -- creating a new one
        end
    else
        isDirty = grapple.anti_gravity ~= nil       -- potentially removing one
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, antigrav, changes, hasAG, startedWithAG)
    if hasAG then
        if grapple.anti_gravity then
            grapple.anti_gravity.antigrav_percent = antigrav.antigrav_percent + changes:Get("antigrav_percent")
            grapple.anti_gravity.fade_duration = antigrav.fade_duration + changes:Get("fade_duration")
            grapple.anti_gravity.experience = antigrav.experience - changes:Get("experience")
        else
            grapple.anti_gravity =
            {
                antigrav_percent = antigrav.antigrav_percent + changes:Get("antigrav_percent"),
                antigrav_percent_update = antigrav.antigrav_percent_update,     -- it's safe to directly copy this, because update structure is readonly

                fade_duration = antigrav.fade_duration + changes:Get("fade_duration"),
                fade_duration_update = antigrav.fade_duration_update,

                experience = antigrav.experience - changes:Get("experience")
            }
        end
    else
        grapple.anti_gravity = nil
    end

    local cost = this.GetXPGainLoss(hasAG, startedWithAG, changes)

    grapple.experience = grapple.experience - cost
    player.experience = player.experience + cost

    player:Save()
end

function this.GetXPGainLoss(hasAG, startedWithAG, changes)
    if hasAG then
        if startedWithAG then
            return changes:Get("experience")
        else
            return changes:Get("experience_buysell") + changes:Get("experience")
        end
    else
        if startedWithAG then
            return changes:Get("experience_buysell")       -- not including any upgrades/buybacks on individual props, because they are selling what they started with
        else
            return 0
        end
    end
end