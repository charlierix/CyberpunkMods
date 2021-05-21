local this = {}

function DefineWindow_GrappleStraight_Distances(vars_ui, const)
    local gst8_dist = {}
    vars_ui.gst8_dist = gst8_dist

    gst8_dist.changes = Changes:new()

    gst8_dist.title = Define_Title("Grapple Straight - Distances", const)

    gst8_dist.name = Define_Name(const)

    gst8_dist.stickFigure = Define_StickFigure(false, const)
    gst8_dist.arrows = Define_GrappleArrows(true, false, const)
    gst8_dist.desired_line = Define_GrappleDesiredLength(true, const)

    -- Max Distance (Aim_Straight.max_distance)
    local prompt, value, updown, help = Define_PropertyPack_Vertical("Max Aim Distance", 220, 100, const)
    gst8_dist.max_prompt = prompt
    gst8_dist.max_value = value
    gst8_dist.max_updown = updown
    gst8_dist.max_help = help

    -- Desired Length
    gst8_dist.desired_checkbox = this.Define_Desired_CheckBox(const)
    gst8_dist.desired_slider = this.Define_Desired_Slider(const)

    gst8_dist.experience = Define_Experience(const, "grapple")

    gst8_dist.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

local isHovered_desired = false

function DrawWindow_GrappleStraight_Distances(vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_GrappleStraight_Distances: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local gst8_dist = vars_ui.gst8_dist

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_dist.name, grapple.name)

    Refresh_GrappleArrows(gst8_dist.arrows, grapple, false, false, false)
    Refresh_GrappleDesiredLength(gst8_dist.desired_line, grapple, this.GetChanged_DesiredLength(gst8_dist.desired_checkbox, gst8_dist.desired_slider), gst8_dist.changes, isHovered_desired)

    this.Refresh_Experience(gst8_dist.experience, player, grapple, gst8_dist.changes)

    --TODO: MaxDistance Update should be non linear
    this.Refresh_MaxDistance_Value(gst8_dist.max_value, grapple, gst8_dist.changes)
    this.Refresh_MaxDistance_UpDown(gst8_dist.max_updown, grapple, player, gst8_dist.changes)

    this.Refresh_Desired_CheckBox(gst8_dist.desired_checkbox, grapple)
    this.Refresh_Desired_Slider(gst8_dist.desired_slider, grapple, gst8_dist.changes)

    this.Refresh_IsDirty(gst8_dist.okcancel, gst8_dist.changes, gst8_dist.desired_checkbox, gst8_dist.desired_slider, grapple)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_dist.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_dist.name, vars_ui.style.colors, window.width, window.height, const)

    Draw_StickFigure(gst8_dist.stickFigure, vars_ui.style.graphics, window.left, window.top, window.width, window.height, const)
    Draw_GrappleArrows(gst8_dist.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)
    Draw_GrappleDesiredLength(gst8_dist.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height)

    -- Max Distance
    Draw_Label(gst8_dist.max_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(gst8_dist.max_value, vars_ui.style.colors, window.width, window.height, const)

    local isDownClicked, isUpClicked = Draw_UpDownButtons(gst8_dist.max_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    this.Update_MaxDistance(gst8_dist.max_updown, gst8_dist.changes, gst8_dist.desired_slider, isDownClicked, isUpClicked, grapple)

    Draw_HelpButton(gst8_dist.max_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)

    -- Desired Length
    Draw_CheckBox(gst8_dist.desired_checkbox, vars_ui.style.checkbox, window.width, window.height, const)

    if gst8_dist.desired_checkbox.isChecked then
        _, isHovered_desired = Draw_Slider(gst8_dist.desired_slider, vars_ui.style.slider, window.width, window.height, const, vars_ui.line_heights)
    else
        isHovered_desired = false
    end

    this.Update_DesiredLength(gst8_dist.desired_checkbox, gst8_dist.desired_slider, gst8_dist.changes)

    Draw_OrderedList(gst8_dist.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_dist.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, gst8_dist.changes, gst8_dist.desired_checkbox, gst8_dist.desired_slider)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Refresh_Experience(def, player, grapple, changes)
    def.content.available.value = tostring(math.floor(player.experience + changes:Get("experience")))
    def.content.used.value = tostring(Round(grapple.experience - changes:Get("experience")))
end

function this.Refresh_MaxDistance_Value(def, grapple, changes)
    def.text = tostring(Round(grapple.aim_straight.max_distance + changes:Get("max_distance")))
end
function this.Refresh_MaxDistance_UpDown(def, grapple, player, changes)
    local down, up = GetDecrementIncrement(grapple.aim_straight.max_distance_update, grapple.aim_straight.max_distance + changes:Get("max_distance"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up)
end
function this.Update_MaxDistance(def, changes, def_slider, isDownClicked, isUpClicked, grapple)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("max_distance", def.value_down)
        changes:Add("experience", 1)
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("max_distance", def.value_up)
        changes:Subtract("experience", 1)
    end

    def_slider.max = grapple.aim_straight.max_distance + changes:Get("max_distance")
    if def_slider.value > def_slider.max then
        def_slider.value = def_slider.max
    end
end

function this.Define_Desired_CheckBox(const)
    -- CheckBox
    return
    {
        text = "Desired Length",

        position =
        {
            pos_x = 200,
            pos_y = 90,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },
    }
end
function this.Refresh_Desired_CheckBox(def, grapple)
    --NOTE: TransitionWindows_Straight_Distances sets this to nil
    if def.isChecked == nil then
        def.isChecked = grapple.desired_length ~= nil
    end
end
function this.Update_DesiredLength(def_checkbox, def_slider, changes)
    if def_checkbox.isChecked then
        changes.desired_length = def_slider.value
    else
        changes.desired_length = nil
    end
end

function this.Define_Desired_Slider(const)
    -- Slider
    return
    {
        invisible_name = "GrappleStraight_Distances_DesiredSlider",

        min = 0,
        --max = ,       -- This is set in refresh

        decimal_places = 1,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 200,
            pos_y = 126,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },
    }
end
function this.Refresh_Desired_Slider(def, grapple, changes)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    --NOTE: TransitionWindows_Straight_Distances sets this to nil
    if not def.value then
        if grapple.desired_length then
            -- Desired Length is populated, use that value
            def.value = grapple.desired_length
        else
            -- There is currently no desired length.  If the check the checkbox, the default value should be zero
            def.value = 0
        end
    end

    def.max = grapple.aim_straight.max_distance + changes:Get("max_distance")
end

function this.GetChanged_DesiredLength(def_checkbox, def_slider)
    if def_checkbox.isChecked then
        if def_slider.value < def_slider.min then
            return def_slider.min
        elseif def_slider.value > def_slider.max then
            return def_slider.max
        else
            return def_slider.value
        end
    else
        return nil
    end
end

function this.Refresh_IsDirty(def, changes, def_checkbox, def_slider, grapple)
    local desired_length = this.GetChanged_DesiredLength(def_checkbox, def_slider)

    def.isDirty = changes:IsDirty() or not IsNearValue_nillable(grapple.desired_length, desired_length)
end

function this.Save(player, grapple, changes, def_checkbox, def_slider)
    grapple.desired_length = this.GetChanged_DesiredLength(def_checkbox, def_slider)

    grapple.aim_straight.max_distance = grapple.aim_straight.max_distance + changes:Get("max_distance")

    grapple.experience = grapple.experience - changes:Get("experience")
    player.experience = player.experience + changes:Get("experience")

    player:Save()
end