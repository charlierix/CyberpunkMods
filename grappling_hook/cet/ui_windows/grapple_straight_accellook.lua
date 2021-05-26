local this = {}
local default_accel = GetDefault_ConstantAccel()

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

    -- Accel (Grapple.accel_alongLook.accel)
    local prompt, value, updown, help = Define_PropertyPack_Vertical("Acceleration", -180, 100, const)
    gst8_acclook.accel_prompt = prompt
    gst8_acclook.accel_value = value
    gst8_acclook.accel_updown = updown
    gst8_acclook.accel_help = help

    -- Speed (Grapple.accel_alongLook.speed)
    prompt, value, updown, help = Define_PropertyPack_Vertical("Max Speed", 180, 100, const)
    gst8_acclook.speed_prompt = prompt
    gst8_acclook.speed_value = value
    gst8_acclook.speed_updown = updown
    gst8_acclook.speed_help = help

    gst8_acclook.experience = Define_Experience(const, "grapple")

    gst8_acclook.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function DrawWindow_GrappleStraight_AccelLook(vars_ui, player, window, const)
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

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_acclook.name, grapple.name)

    this.Refresh_Experience(gst8_acclook.experience, player, grapple, gst8_acclook.changes, gst8_acclook.has_accellook.isChecked, startedWithAL)

    Refresh_GrappleArrows(gst8_acclook.arrows, grapple, true, false, false)
    Refresh_GrappleDesiredLength(gst8_acclook.desired_line, grapple, nil, gst8_acclook.changes, false)

    this.Refresh_HasAccelLook(gst8_acclook.has_accellook, player, grapple, accel, gst8_acclook.changes)

    this.Refresh_Accel_Value(gst8_acclook.accel_value, accel, gst8_acclook.changes)
    this.Refresh_Accel_UpDown(gst8_acclook.accel_updown, accel, player, gst8_acclook.changes)

    this.Refresh_Speed_Value(gst8_acclook.speed_value, accel, gst8_acclook.changes)
    this.Refresh_Speed_UpDown(gst8_acclook.speed_updown, accel, player, gst8_acclook.changes)

    this.Refresh_IsDirty(gst8_acclook.okcancel, gst8_acclook.changes, grapple, gst8_acclook.has_accellook)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_acclook.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_acclook.name, vars_ui.style.colors, window.width, window.height, const)

    Draw_StickFigure(gst8_acclook.stickFigure, vars_ui.style.graphics, window.left, window.top, window.width, window.height, const)
    Draw_GrappleArrows(gst8_acclook.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)
    Draw_GrappleDesiredLength(gst8_acclook.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height)

    if Draw_CheckBox(gst8_acclook.has_accellook, vars_ui.style.checkbox, window.width, window.height, const) then
        this.Update_HasAccelLook(gst8_acclook.has_accellook, accel, gst8_acclook.changes, startedWithAL)
    end

    if gst8_acclook.has_accellook.isChecked then
        -- Accel
        Draw_Label(gst8_acclook.accel_prompt, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(gst8_acclook.accel_value, vars_ui.style.colors, window.width, window.height, const)

        local isDownClicked, isUpClicked = Draw_UpDownButtons(gst8_acclook.accel_updown, vars_ui.style.updownButtons, window.width, window.height, const)
        this.Update_Accel(gst8_acclook.accel_updown, gst8_acclook.changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_acclook.accel_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)

        -- Speed
        Draw_Label(gst8_acclook.speed_prompt, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(gst8_acclook.speed_value, vars_ui.style.colors, window.width, window.height, const)

        isDownClicked, isUpClicked = Draw_UpDownButtons(gst8_acclook.speed_updown, vars_ui.style.updownButtons, window.width, window.height, const)
        this.Update_Speed(gst8_acclook.speed_updown, gst8_acclook.changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_acclook.speed_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)
    end

    Draw_OrderedList(gst8_acclook.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_acclook.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, accel, gst8_acclook.changes, gst8_acclook.has_accellook.isChecked, startedWithAL)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Define_HasAccelLook(const)
    -- CheckBox
    return
    {
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

    if def.isChecked then
        if startedWithAL then
            changes.experience_buysell = 0     -- started with accel look, unchecked at some point, now they're putting it back.  There is no extra cost
        else
            changes.experience_buysell = -total        -- started without, so this is the purchase cost
        end
    else
        if startedWithAL then
            changes.experience_buysell = total     -- started with accel look, now selling it, so gain the experience
        else
            changes.experience_buysell = 0     -- started without, purchased, now removing again
        end
    end
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

    local cost = this.GetXPGainLoss(hasAL, startedWithAL, changes)

    grapple.experience = grapple.experience - cost
    player.experience = player.experience + cost

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