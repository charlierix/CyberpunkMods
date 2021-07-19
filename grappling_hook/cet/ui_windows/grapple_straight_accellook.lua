local this = {}
local default_accel = GetDefault_ConstantAccel()

local isHovered_has = false
local isHovered_accel = false
local isHovered_speed = false

function DefineWindow_GrappleStraight_AccelLook(vars_ui, const)
    local gst8_acclook = {}
    vars_ui.gst8_acclook = gst8_acclook

    gst8_acclook.changes = Changes:new()

    gst8_acclook.title = Define_Title("Grapple Straight - Acceleration (look direction)", const)

    gst8_acclook.name = Define_Name(const)

    gst8_acclook.stickFigure = Define_StickFigure(false, const)
    gst8_acclook.arrows = Define_GrappleArrows(false, true)
    gst8_acclook.desired_line = Define_GrappleDesiredLength(false)

    -- Checkbox for whether to have accel look (Grapple.accel_alongLook)
    gst8_acclook.has_accellook = this.Define_HasAccelLook(const)
    gst8_acclook.has_help = this.Define_HasHelp(const)

    -- Accel (Grapple.accel_alongLook.accel)
    local prompt, value, updown, help = Define_PropertyPack_Vertical("Acceleration", -180, 100, const, false, "GrappleStraight_AccelLook_Accel", this.Tooltip_Accel())
    gst8_acclook.accel_prompt = prompt
    gst8_acclook.accel_value = value
    gst8_acclook.accel_updown = updown
    gst8_acclook.accel_help = help

    -- Speed (Grapple.accel_alongLook.speed)
    prompt, value, updown, help = Define_PropertyPack_Vertical("Max Speed", 180, 100, const, false, "GrappleStraight_AccelLook_Speed", this.Tooltip_Speed())
    gst8_acclook.speed_prompt = prompt
    gst8_acclook.speed_value = value
    gst8_acclook.speed_updown = updown
    gst8_acclook.speed_help = help

    gst8_acclook.experience = Define_Experience(const, "grapple")

    gst8_acclook.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(gst8_acclook)
end

function ActivateWindow_GrappleStraight_AccelLook(vars_ui, const)
    if not vars_ui.gst8_acclook then
        DefineWindow_GrappleStraight_AccelLook(vars_ui, const)
    end

    vars_ui.gst8_acclook.changes:Clear()

    vars_ui.gst8_acclook.has_accellook.isChecked = nil
end

function DrawWindow_GrappleStraight_AccelLook(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_GrappleStraight_AccelLook: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local accel = grapple.accel_alongLook
    if not accel then
        accel = default_accel
    end

    local startedWithAL = grapple.accel_alongLook ~= nil

    local gst8_acclook = vars_ui.gst8_acclook

    local changes = gst8_acclook.changes

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_acclook.name, grapple.name)

    Refresh_GrappleArrows(gst8_acclook.arrows, grapple, true, false, isHovered_has or isHovered_accel or isHovered_speed)
    Refresh_GrappleDesiredLength(gst8_acclook.desired_line, grapple, nil, changes, false)

    this.Refresh_HasAccelLook(gst8_acclook.has_accellook, player, grapple, accel, changes)

    this.Refresh_Accel_Value(gst8_acclook.accel_value, accel, changes)
    this.Refresh_Accel_UpDown(gst8_acclook.accel_updown, accel, player, changes)

    this.Refresh_Speed_Value(gst8_acclook.speed_value, accel, changes)
    this.Refresh_Speed_UpDown(gst8_acclook.speed_updown, accel, player, changes)

    this.Refresh_Experience(gst8_acclook.experience, player, grapple, changes, gst8_acclook.has_accellook.isChecked, startedWithAL)

    this.Refresh_IsDirty(gst8_acclook.okcancel, changes, grapple, gst8_acclook.has_accellook)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_acclook.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_acclook.name, vars_ui.style.colors, window.width, window.height, const)

    Draw_StickFigure(gst8_acclook.stickFigure, vars_ui.style.graphics, window.left, window.top, window.width, window.height, const)
    Draw_GrappleArrows(gst8_acclook.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)
    Draw_GrappleDesiredLength(gst8_acclook.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height)

    local wasChecked
    wasChecked, isHovered_has = Draw_CheckBox(gst8_acclook.has_accellook, vars_ui.style.checkbox, vars_ui.style.colors, window.width, window.height, const)
    if wasChecked then
        this.Update_HasAccelLook(gst8_acclook.has_accellook, accel, changes, startedWithAL)
    end

    Draw_HelpButton(gst8_acclook.has_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

    if gst8_acclook.has_accellook.isChecked then
        -- Accel
        Draw_Label(gst8_acclook.accel_prompt, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(gst8_acclook.accel_value, vars_ui.style.colors, window.width, window.height, const)

        local isDownClicked, isUpClicked
        isDownClicked, isUpClicked, isHovered_accel = Draw_UpDownButtons(gst8_acclook.accel_updown, vars_ui.style.updownButtons, window.width, window.height, const)
        this.Update_Accel(gst8_acclook.accel_updown, changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_acclook.accel_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

        -- Speed
        Draw_Label(gst8_acclook.speed_prompt, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(gst8_acclook.speed_value, vars_ui.style.colors, window.width, window.height, const)

        isDownClicked, isUpClicked, isHovered_speed = Draw_UpDownButtons(gst8_acclook.speed_updown, vars_ui.style.updownButtons, window.width, window.height, const)
        this.Update_Speed(gst8_acclook.speed_updown, changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_acclook.speed_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)
    else
        isHovered_accel = false
        isHovered_speed = false
    end

    Draw_OrderedList(gst8_acclook.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_acclook.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, accel, changes, gst8_acclook.has_accellook.isChecked, startedWithAL)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_acclook.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_HasAccelLook(const)
    -- CheckBox
    return
    {
        invisible_name = "GrappleStraight_AccelLook_HasAccelLook",

        text = "Has Acceleration in Look Direction",

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }
end
function this.Refresh_HasAccelLook(def, player, grapple, accel, changes)
    --NOTE: TransitionWindows_Straight_AccelLook sets this to nil
    if def.isChecked == nil then
        def.isChecked = grapple.accel_alongLook ~= nil
    end

    if def.isChecked then
        def.isEnabled = true        -- it doesn't cost xp to remove, so the checkbox is always enabled here
    else
        def.isEnabled = player.experience + changes:Get("experience_buysell") >= accel.experience
    end
end
function this.Update_HasAccelLook(def, accel, changes, startedWithAL)
    local total = accel.experience        -- this is the price when the window was started, changes are tracked separately

    PopulateBuySell(def.isChecked, startedWithAL, changes, "experience_buysell", total)
end

function this.Define_HasHelp(const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "GrappleStraight_AccelLook_HasHelp",

        position =
        {
            pos_x = 150,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }

    retVal.tooltip =
[[While grappling, this will apply an acceleration in the direction you are looking

This allows you to somewhat steer your flight based on where you look

Watch videos of grappling in titanfall2 for examples of this play style]]

    return retVal
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
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(accel.accel_update, accel.accel + changes:Get("accel"), player.experience + changes:Get("experience_buysell") + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up, 0)
end
function this.Update_Accel(def, changes, isDownClicked, isUpClicked)
    Update_UpDownButton("accel", "experience", isDownClicked, isUpClicked, def, changes)
end

function this.Tooltip_Speed()
    return
[[Stops accelerating once this speed is reached]]
end
function this.Refresh_Speed_Value(def, accel, changes)
    def.text = tostring(Round(accel.speed + changes:Get("speed")))
end
function this.Refresh_Speed_UpDown(def, accel, player, changes)
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(accel.speed_update, accel.speed + changes:Get("speed"), player.experience + changes:Get("experience_buysell") + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up, 0)
end
function this.Update_Speed(def, changes, isDownClicked, isUpClicked)
    Update_UpDownButton("speed", "experience", isDownClicked, isUpClicked, def, changes)
end

function this.Refresh_Experience(def, player, grapple, changes, hasAL, startedWithAL)
    local cost = this.GetXPGainLoss(hasAL, startedWithAL, changes)

    def.content.available.value = tostring(math.floor(player.experience + cost))
    def.content.used.value = tostring(Round(grapple.experience - cost))
end

function this.Refresh_IsDirty(def, changes, grapple, def_checkbox)
    local isDirty = false

    if def_checkbox.isChecked then
        if grapple.accel_alongLook then
            isDirty = changes:IsDirty()     -- changing existing
        else
            isDirty = true      -- creating a new one
        end
    else
        isDirty = grapple.accel_alongLook ~= nil       -- potentially removing one
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, accel, changes, hasAL, startedWithAL)
    local cost = this.GetXPGainLoss(hasAL, startedWithAL, changes)
    if not player:TransferExperience_GrappleStraight(grapple, -cost) then
        do return end
    end

    if hasAL then
        if grapple.accel_alongLook then
            grapple.accel_alongLook.accel = accel.accel + changes:Get("accel")
            grapple.accel_alongLook.speed = accel.speed + changes:Get("speed")
            grapple.accel_alongLook.experience = accel.experience - changes:Get("experience")
        else
            grapple.accel_alongLook =
            {
                accel = accel.accel + changes:Get("accel"),
                accel_update = accel.accel_update,

                speed = accel.speed + changes:Get("speed"),
                speed_update = accel.speed_update,

                deadSpot_distance = accel.deadSpot_distance,
                deadSpot_speed = accel.deadSpot_speed,

                experience = accel.experience - changes:Get("experience"),
            }
        end
    else
        grapple.accel_alongLook = nil
    end

    player:Save()
end

function this.GetXPGainLoss(hasAL, startedWithAL, changes)
    if hasAL then
        if startedWithAL then
            return changes:Get("experience")
        else
            return changes:Get("experience_buysell") + changes:Get("experience")
        end
    else
        if startedWithAL then
            return changes:Get("experience_buysell")       -- not including any upgrades/buybacks on individual props, because they are selling what they started with
        else
            return 0
        end
    end
end