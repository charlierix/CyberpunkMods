local this = {}

function DefineWindow_GrappleStraight_AimDuration(vars_ui, const)
    local gst8_aimdur = {}
    vars_ui.gst8_aimdur = gst8_aimdur

    gst8_aimdur.changes = Changes:new()

    gst8_aimdur.title = Define_Title("Grapple Straight - Aim Duration", const)

    gst8_aimdur.name = Define_Name(const)

    local prompt, value, updown, help = Define_PropertyPack_Vertical("Aim Duration", 0, 0, const, false, "GrappleStraight_AimDuration_AimDuration", this.Tooltip_AimDuration())
    gst8_aimdur.dur_prompt = prompt
    gst8_aimdur.dur_value = value
    gst8_aimdur.dur_updown = updown
    gst8_aimdur.dur_help = help

    gst8_aimdur.experience = Define_Experience(const, "grapple")

    gst8_aimdur.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function DrawWindow_GrappleStraight_AimDuration(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_GrappleStraight_AimDuration: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local gst8_aimdur = vars_ui.gst8_aimdur

    local changes = gst8_aimdur.changes

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_aimdur.name, grapple.name)

    this.Refresh_AimDuration_Value(gst8_aimdur.dur_value, grapple, changes)
    this.Refresh_AimDuration_UpDown(gst8_aimdur.dur_updown, grapple, player, changes)

    this.Refresh_Experience(gst8_aimdur.experience, player, grapple, changes)

    this.Refresh_IsDirty(gst8_aimdur.okcancel, changes)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_aimdur.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_aimdur.name, vars_ui.style.colors, window.width, window.height, const)

    -- Max Distance
    Draw_Label(gst8_aimdur.dur_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(gst8_aimdur.dur_value, vars_ui.style.colors, window.width, window.height, const)

    local isDownClicked, isUpClicked = Draw_UpDownButtons(gst8_aimdur.dur_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    this.Update_AimDuration(gst8_aimdur.dur_updown, changes, isDownClicked, isUpClicked)

    Draw_HelpButton(gst8_aimdur.dur_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

    Draw_OrderedList(gst8_aimdur.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_aimdur.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, changes)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_aimdur.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Tooltip_AimDuration()
    return
[[How long to scan for a grapple point before giving up
    
When a grapple attempt is started, but you're not looking directly at something to grapple to (or maybe what you're looking at is too far away), this gives a chance to look around slightly in order to latch on

There is no need to hold the button down, the aim kicks in immediately and keeps aiming until the time is up

If air dash is equipped, it will activate when a grapple attempt fails (at the end of the aim duration)

NOTE: The energy is removed when aiming starts, but if the time runs out without anchoring to anything, that energy is refunded]]
end

function this.Refresh_AimDuration_Value(def, grapple, changes)
    def.text = tostring(Round(grapple.aim_straight.aim_duration + changes:Get("aim_duration"), 2))
end
function this.Refresh_AimDuration_UpDown(def, grapple, player, changes)
    local down, up = GetDecrementIncrement(grapple.aim_straight.aim_duration_update, grapple.aim_straight.aim_duration + changes:Get("aim_duration"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, 2)
end
function this.Update_AimDuration(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("aim_duration", def.value_down)
        changes:Add("experience", 1)
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("aim_duration", def.value_up)
        changes:Subtract("experience", 1)
    end
end

function this.Refresh_Experience(def, player, grapple, changes)
    def.content.available.value = tostring(math.floor(player.experience + changes:Get("experience")))
    def.content.used.value = tostring(Round(grapple.experience - changes:Get("experience")))
end

function this.Refresh_IsDirty(def, changes)
    def.isDirty = changes:IsDirty()
end

function this.Save(player, grapple, changes)
    grapple.aim_straight.aim_duration = grapple.aim_straight.aim_duration + changes:Get("aim_duration")

    grapple.experience = grapple.experience - changes:Get("experience")
    player.experience = player.experience + changes:Get("experience")

    player:Save()
end