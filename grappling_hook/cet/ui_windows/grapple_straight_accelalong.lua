local this = {}
local default_accel = GetDefault_ConstantAccel()

function DefineWindow_GrappleStraight_AccelAlong(vars_ui, const)
    local gst8_accalong = {}
    vars_ui.gst8_accalong = gst8_accalong

    gst8_accalong.changes = Changes:new()

    gst8_accalong.title = Define_Title("Grapple Straight - Acceleration (toward anchor)", const)

    gst8_accalong.name = Define_Name(const)

    gst8_accalong.stickFigure = Define_StickFigure(false, const)
    gst8_accalong.arrows = Define_GrappleArrows(true, false)


    --TODO: An option to make the desired line dashed

    gst8_accalong.desired_line = Define_GrappleDesiredLength(true)


    -- New control:
    --TODO: Two arrows above, pointing toward the desired line
    --TODO: Lines below to show the deadspot


    -- Checkbox for whether to have accel along (Grapple.accel_alongGrappleLine)
    gst8_accalong.has_accelalong = this.Define_HasAccelAlong(const)

    -- Accel (Grapple.accel_alongGrappleLine.accel)
    local prompt, value, updown, help = Define_PropertyPack_Vertical("Acceleration", -180, 100, const)
    gst8_accalong.accel_prompt = prompt
    gst8_accalong.accel_value = value
    gst8_accalong.accel_updown = updown
    gst8_accalong.accel_help = help

    -- Speed (Grapple.accel_alongGrappleLine.speed)
    prompt, value, updown, help = Define_PropertyPack_Vertical("Max Speed", 180, 100, const)
    gst8_accalong.speed_prompt = prompt
    gst8_accalong.speed_value = value
    gst8_accalong.speed_updown = updown
    gst8_accalong.speed_help = help

    -- Dead Spot Distance (Grapple.accel_alongGrappleLine.deadSpot_distance)
    gst8_accalong.deadspot_label = this.Define_DeadSpot_Label(const)
    gst8_accalong.deadspot_help = this.Define_DeadSpot_Help(const)
    gst8_accalong.deadspot_dist = this.Define_DeadSpot_Dist(const)

    gst8_accalong.experience = Define_Experience(const, "grapple")

    gst8_accalong.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

local isHovered_deadspot = false

function DrawWindow_GrappleStraight_AccelAlong(vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_GrappleStraight_AccelAlong: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local accel = grapple.accel_alongGrappleLine
    if not accel then
        accel = default_accel
    end

    local startedWithAG = grapple.accel_alongGrappleLine ~= nil

    local gst8_accalong = vars_ui.gst8_accalong

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_accalong.name, grapple.name)

    Refresh_GrappleArrows(gst8_accalong.arrows, grapple, true, false, false)
    Refresh_GrappleDesiredLength(gst8_accalong.desired_line, grapple, nil, gst8_accalong.changes, false)

    this.Refresh_HasAccelAlong(gst8_accalong.has_accelalong, player, grapple, accel, gst8_accalong.changes)

    this.Refresh_Accel_Value(gst8_accalong.accel_value, accel, gst8_accalong.changes)
    this.Refresh_Accel_UpDown(gst8_accalong.accel_updown, accel, player, gst8_accalong.changes)

    this.Refresh_Speed_Value(gst8_accalong.speed_value, accel, gst8_accalong.changes)
    this.Refresh_Speed_UpDown(gst8_accalong.speed_updown, accel, player, gst8_accalong.changes)

    this.Refresh_DeadSpot_Dist(gst8_accalong.deadspot_dist, accel)

    this.Refresh_Experience(gst8_accalong.experience, player, grapple, gst8_accalong.changes, gst8_accalong.has_accelalong.isChecked, startedWithAG)

    this.Refresh_IsDirty(gst8_accalong.okcancel, gst8_accalong.changes, grapple, gst8_accalong.has_accelalong, gst8_accalong.deadspot_dist)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_accalong.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_accalong.name, vars_ui.style.colors, window.width, window.height, const)

    Draw_StickFigure(gst8_accalong.stickFigure, vars_ui.style.graphics, window.left, window.top, window.width, window.height, const)
    Draw_GrappleArrows(gst8_accalong.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)
    Draw_GrappleDesiredLength(gst8_accalong.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height)

    if Draw_CheckBox(gst8_accalong.has_accelalong, vars_ui.style.checkbox, window.width, window.height, const) then
        this.Update_HasAccelAlong(gst8_accalong.has_accelalong, accel, gst8_accalong.changes, startedWithAG)
    end

    if gst8_accalong.has_accelalong.isChecked then
        -- Accel
        Draw_Label(gst8_accalong.accel_prompt, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(gst8_accalong.accel_value, vars_ui.style.colors, window.width, window.height, const)

        local isDownClicked, isUpClicked = Draw_UpDownButtons(gst8_accalong.accel_updown, vars_ui.style.updownButtons, window.width, window.height, const)
        this.Update_Accel(gst8_accalong.accel_updown, gst8_accalong.changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_accalong.accel_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)

        -- Speed
        Draw_Label(gst8_accalong.speed_prompt, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(gst8_accalong.speed_value, vars_ui.style.colors, window.width, window.height, const)

        isDownClicked, isUpClicked = Draw_UpDownButtons(gst8_accalong.speed_updown, vars_ui.style.updownButtons, window.width, window.height, const)
        this.Update_Speed(gst8_accalong.speed_updown, gst8_accalong.changes, isDownClicked, isUpClicked)

        Draw_HelpButton(gst8_accalong.speed_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)

        -- Dead Spot Distance
        Draw_Label(gst8_accalong.deadspot_label, vars_ui.style.colors, window.width, window.height, const)
        Draw_HelpButton(gst8_accalong.deadspot_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)
        _, isHovered_deadspot = Draw_Slider(gst8_accalong.deadspot_dist, vars_ui.style.slider, window.width, window.height, const, vars_ui.line_heights)
    else
        isHovered_deadspot = false
    end

    Draw_OrderedList(gst8_accalong.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_accalong.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, accel, gst8_accalong.changes, gst8_accalong.has_accelalong.isChecked, startedWithAG, gst8_accalong.deadspot_dist)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Define_HasAccelAlong(const)
    -- CheckBox
    return
    {
        text = "Has acceleration along grapple line",

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }
end
function this.Refresh_HasAccelAlong(def, player, grapple, accel, changes)
    --NOTE: TransitionWindows_Straight_AccelAlong sets this to nil
    if def.isChecked == nil then
        def.isChecked = grapple.accel_alongGrappleLine ~= nil
    end

    if def.isChecked then
        def.isEnabled = true        -- it doesn't cost xp to remove, so the checkbox is always enabled here
    else
        def.isEnabled = player.experience + changes:Get("experience_buysell") >= accel.experience
    end
end
function this.Update_HasAccelAlong(def, accel, changes, startedWithAG)
    local total = accel.experience        -- this is the price when the window was started, changes are tracked separately

    if def.isChecked then
        if startedWithAG then
            changes.experience_buysell = 0     -- started with accel along, unchecked at some point, now they're putting it back.  There is no extra cost
        else
            changes.experience_buysell = -total        -- started without, so this is the purchase cost
        end
    else
        if startedWithAG then
            changes.experience_buysell = total     -- started with accel along, now selling it, so gain the experience
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

function this.Define_DeadSpot_Label(const)
    -- Label
    return
    {
        text = "Dead Spot",

        position =
        {
            pos_x = -117,
            pos_y = 210,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",
    }
end
function this.Define_DeadSpot_Help(const)
    -- HelpButton
    return
    {
        position =
        {
            pos_x = -70,
            pos_y = 210,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "GrappleStraight_AccelAlong_DeadSpot_Help"
    }
end
function this.Define_DeadSpot_Dist(const)
    -- Slider
    return
    {
        invisible_name = "GrappleStraight_AccelAlong_DeadSpot_Dist",

        min = 0,
        max = 6,

        decimal_places = 1,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 0,
            pos_y = 240,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }
end
function this.Refresh_DeadSpot_Dist(def, accel)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: TransitionWindows_Straight_Distances sets this to nil
    if not def.value then
        def.value = accel.deadSpot_distance
    end
end

function this.Refresh_Experience(def, player, grapple, changes, hasAG, startedWithAG)
    local cost = this.GetXPGainLoss(hasAG, startedWithAG, changes)

    def.content.available.value = tostring(math.floor(player.experience + cost))
    def.content.used.value = tostring(Round(grapple.experience - cost))
end

function this.Refresh_IsDirty(def, changes, grapple, def_checkbox, def_slider)
    local isDirty = false

    if def_checkbox.isChecked then
        if grapple.accel_alongGrappleLine then
            isDirty = changes:IsDirty() or not IsNearValue(def_slider.value, grapple.accel_alongGrappleLine.deadSpot_distance)      -- changing existing
        else
            isDirty = true      -- creating a new one
        end
    else
        isDirty = grapple.accel_alongGrappleLine ~= nil       -- potentially removing one
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, accel, changes, hasAG, startedWithAG, def_slider)
    if hasAG then
        local deadspot = def_slider.value
        if deadspot < def_slider.min then
            deadspot = def_slider.min
        elseif deadspot > def_slider.max then
            deadspot = def_slider.max
        end

        if grapple.accel_alongGrappleLine then
            grapple.accel_alongGrappleLine.accel = accel.accel + changes:Get("accel")
            grapple.accel_alongGrappleLine.speed = accel.speed + changes:Get("speed")
            grapple.accel_alongGrappleLine.deadSpot_distance = deadspot
            grapple.accel_alongGrappleLine.experience = accel.experience - changes:Get("experience")
        else
            grapple.accel_alongGrappleLine =
            {
                accel = accel.accel + changes:Get("accel"),
                accel_update = accel.accel_update,

                speed = accel.speed + changes:Get("speed"),
                speed_update = accel.speed_update,

                deadSpot_distance = deadspot,
                deadSpot_speed = accel.deadSpot_speed,

                experience = accel.experience - changes:Get("experience"),
            }
        end
    else
        grapple.accel_alongGrappleLine = nil
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