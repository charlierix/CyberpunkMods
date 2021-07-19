local this = {}

local isHovered_desired_checkbox = false
local isHovered_desired_slider = false
local isHovered_max_updown = false

function DefineWindow_GrappleStraight_Distances(vars_ui, const)
    local gst8_dist = {}
    vars_ui.gst8_dist = gst8_dist

    gst8_dist.changes = Changes:new()

    gst8_dist.title = Define_Title("Grapple Straight - Distances", const)

    gst8_dist.name = Define_Name(const)

    gst8_dist.stickFigure = Define_StickFigure(false, const)
    gst8_dist.arrows = Define_GrappleArrows(true, false)
    gst8_dist.desired_line = Define_GrappleDesiredLength(true)

    -- Desired Length
    gst8_dist.desired_checkbox = this.Define_Desired_CheckBox(const)
    gst8_dist.desired_help = this.Define_Desired_Help(const)
    gst8_dist.desired_slider = this.Define_Desired_Slider(const)

    -- Max Distance (Aim_Straight.max_distance)
    local prompt, value, updown, help = Define_PropertyPack_Vertical("Max Aim Distance", 220, 100, const, false, "GrappleStraight_Distances_MaxDist", this.Tooltip_MaxDistance())
    gst8_dist.max_prompt = prompt
    gst8_dist.max_value = value
    gst8_dist.max_updown = updown
    gst8_dist.max_help = help

    gst8_dist.experience = Define_Experience(const, "grapple")

    gst8_dist.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function ActivateWindow_GrappleStraight_Distances(vars_ui)
    vars_ui.gst8_dist.changes:Clear()

    vars_ui.gst8_dist.desired_checkbox.isChecked = nil
    vars_ui.gst8_dist.desired_slider.value = nil
end

function DrawWindow_GrappleStraight_Distances(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_GrappleStraight_Distances: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local gst8_dist = vars_ui.gst8_dist

    local changes = gst8_dist.changes

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_dist.name, grapple.name)

    Refresh_GrappleArrows(gst8_dist.arrows, grapple, false, isHovered_max_updown, false)
    Refresh_GrappleDesiredLength(gst8_dist.desired_line, grapple, this.GetChanged_DesiredLength(gst8_dist.desired_checkbox, gst8_dist.desired_slider), changes, isHovered_desired_checkbox or isHovered_desired_slider)

    this.Refresh_Desired_CheckBox(gst8_dist.desired_checkbox, grapple)
    this.Refresh_Desired_Slider(gst8_dist.desired_slider, grapple, changes)

    --TODO: MaxDistance Update should be non linear
    this.Refresh_MaxDistance_Value(gst8_dist.max_value, grapple, changes)
    this.Refresh_MaxDistance_UpDown(gst8_dist.max_updown, grapple, player, changes)

    this.Refresh_Experience(gst8_dist.experience, player, grapple, changes)

    this.Refresh_IsDirty(gst8_dist.okcancel, changes, gst8_dist.desired_checkbox, gst8_dist.desired_slider, grapple)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_dist.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_dist.name, vars_ui.style.colors, window.width, window.height, const)

    Draw_StickFigure(gst8_dist.stickFigure, vars_ui.style.graphics, window.left, window.top, window.width, window.height, const)
    Draw_GrappleArrows(gst8_dist.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)
    Draw_GrappleDesiredLength(gst8_dist.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height)

    -- Desired Length
    _, isHovered_desired_checkbox = Draw_CheckBox(gst8_dist.desired_checkbox, vars_ui.style.checkbox, vars_ui.style.colors, window.width, window.height, const)

    if gst8_dist.desired_checkbox.isChecked then
        _, isHovered_desired_slider = Draw_Slider(gst8_dist.desired_slider, vars_ui.style.slider, window.width, window.height, const, vars_ui.line_heights)
    else
        isHovered_desired_slider = false
    end

    this.Update_DesiredLength(gst8_dist.desired_checkbox, gst8_dist.desired_slider, changes)

    Draw_HelpButton(gst8_dist.desired_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

    -- Max Distance
    Draw_Label(gst8_dist.max_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(gst8_dist.max_value, vars_ui.style.colors, window.width, window.height, const)

    local isDownClicked, isUpClicked
    isDownClicked, isUpClicked, isHovered_max_updown = Draw_UpDownButtons(gst8_dist.max_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    this.Update_MaxDistance(gst8_dist.max_updown, changes, gst8_dist.desired_slider, isDownClicked, isUpClicked, grapple)

    Draw_HelpButton(gst8_dist.max_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

    Draw_OrderedList(gst8_dist.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_dist.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, changes, gst8_dist.desired_checkbox, gst8_dist.desired_slider)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_dist.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Refresh_Experience(def, player, grapple, changes)
    def.content.available.value = tostring(math.floor(player.experience + changes:Get("experience")))
    def.content.used.value = tostring(Round(grapple.experience - changes:Get("experience")))
end

function this.Define_Desired_CheckBox(const)
    -- CheckBox
    return
    {
        invisible_name = "GrappleStraight_Distances_Desired_CheckBox",

        text = "Desired Length",

        isEnabled = true,

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

function this.Define_Desired_Help(const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "GrappleStraight_Distances_Desired_Help",

        position =
        {
            pos_x = 330,
            pos_y = 90,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },
    }

    retVal.tooltip =
[[This is the distance from the anchor point along the grapple line.  A distance of zero is the anchor point itself

This is where accelerations pull towards

If unchecked, the distance will be how far the player is from the anchor point at the time of starting a grapple

A distance of zero is useful for pull style grapples

An undefined distance is useful for rope like grapples (tarzan swinging)

Somewhere in the middle may be good for limited swinging, wall hanging, pole vault]]

    return retVal
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
    -- There is no need to store changes in the changes list.  Value is directly changed
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

function this.Tooltip_MaxDistance()
    return
[[How far away the grapple can anchor to

This is a very useful property to upgrade.  It will allow you to reach more distance places, go straight up the sides of tall buildings

NOTE: The game doesn't reliably load collision meshes beyond around 50.  So you can see the visuals, but the raycast won't see it.  This seems to mostly be vertical displacement, so trying to go up really tall buildings can be frustrating.  The air dash feature was added to help combat this]]
end
function this.Refresh_MaxDistance_Value(def, grapple, changes)
    def.text = tostring(Round(grapple.aim_straight.max_distance + changes:Get("max_distance")))
end
function this.Refresh_MaxDistance_UpDown(def, grapple, player, changes)
    local down, up, isFree_down, isFree_up = GetDecrementIncrement(grapple.aim_straight.max_distance_update, grapple.aim_straight.max_distance + changes:Get("max_distance"), player.experience + changes:Get("experience"))
    Refresh_UpDownButton(def, down, up, isFree_down, isFree_up)
end
function this.Update_MaxDistance(def, changes, def_slider, isDownClicked, isUpClicked, grapple)
    Update_UpDownButton("max_distance", "experience", isDownClicked, isUpClicked, def, changes)

    def_slider.max = grapple.aim_straight.max_distance + changes:Get("max_distance")
    if def_slider.value > def_slider.max then
        def_slider.value = def_slider.max
    end
end

function this.Refresh_IsDirty(def, changes, def_checkbox, def_slider, grapple)
    local desired_length = this.GetChanged_DesiredLength(def_checkbox, def_slider)

    def.isDirty = changes:IsDirty() or not IsNearValue_nillable(grapple.desired_length, desired_length)
end

function this.Save(player, grapple, changes, def_checkbox, def_slider)
    if not player:TransferExperience_GrappleStraight(grapple, -changes:Get("experience")) then
        do return end
    end

    grapple.desired_length = this.GetChanged_DesiredLength(def_checkbox, def_slider)

    grapple.aim_straight.max_distance = grapple.aim_straight.max_distance + changes:Get("max_distance")

    player:Save()
end