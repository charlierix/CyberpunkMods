local this = {}

function Define_Window_GrappleStraight_Distances(vars_ui, const)
    local gst8_dist = {}
    vars_ui.gst8_dist = gst8_dist

    gst8_dist.changes = {}        -- this will hold values that have changes to be applied

    gst8_dist.title = Define_Title("Grapple Straight - Distances", const)

    gst8_dist.name = Define_Name(const)


    gst8_dist.stickFigure = Define_StickFigure(true, const)
    gst8_dist.arrows = Define_GrappleArrows(true, const)


    --TODO: Probably want this laid out horizontal
    -- Max Distance (Aim_Straight.max_distance)
    local prompt, value, updown, help = Define_PropertyPack_Vertical("Max Aim Distance", 0, 0, const)
    gst8_dist.max_prompt = prompt
    gst8_dist.max_value = value
    gst8_dist.max_updown = updown
    gst8_dist.max_help = help


    gst8_dist.desired_checkbox = this.Define_Desired_CheckBox(const)


    gst8_dist.experience = Define_Experience(const, "grapple")

    gst8_dist.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

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

    Refresh_Arrows(gst8_dist.arrows, grapple, false, false, false)

    this.Refresh_Experience(gst8_dist.experience, player, grapple, gst8_dist.changes)

    --TODO: MaxDistance Update should be non linear
    this.Refresh_MaxDistance_Value(gst8_dist.max_value, grapple, gst8_dist.changes)
    this.Refresh_MaxDistance_UpDown(gst8_dist.max_updown, grapple, player, gst8_dist.changes)

    this.Refresh_Desired_CheckBox(gst8_dist.desired_checkbox, grapple)

    this.Refresh_IsDirty(gst8_dist.okcancel, gst8_dist.changes)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_dist.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_dist.name, vars_ui.style.colors, window.width, window.height, const)

    Draw_StickFigure(gst8_dist.stickFigure, vars_ui.style.graphics, window.left, window.top, window.width, window.height, const)
    Draw_GrappleArrows(gst8_dist.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)

    -- Max Distance
    Draw_Label(gst8_dist.max_prompt, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(gst8_dist.max_value, vars_ui.style.colors, window.width, window.height, const)

    local isDownClicked, isUpClicked = Draw_UpDownButtons(gst8_dist.max_updown, vars_ui.style.updownButtons, window.width, window.height, const)
    this.Update_MaxDistance(gst8_dist.max_updown, gst8_dist.changes, isDownClicked, isUpClicked)

    Draw_HelpButton(gst8_dist.max_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)



    Draw_CheckBox(gst8_dist.desired_checkbox, vars_ui.style.checkbox, window.width, window.height, const)



    --Use one of these (need to figure out the difference between them)
    --ImGui.DragFloat
    --ImGui.SliderFloat


    --ImGuiSliderFlags_AlwaysClamp

    -- ImGui.PushItemWidth(ImGui.GetWindowContentRegionWidth() - ImGui.CalcTextSize("Tilt/Rotation "))
    -- value, changed = ImGui.DragFloat("Up/Down", value, 0.01)


    --value, changed = ImGui.SliderFloat("Rotation", value, -180, 180)






    Draw_OrderedList(gst8_dist.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_dist.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, gst8_dist.changes)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Refresh_Experience(def, player, grapple, changes)
    def.content.available.value = tostring(math.floor(player.experience + changes.experience))
    def.content.used.value = tostring(Round(grapple.experience - changes.experience))
end

function this.Refresh_MaxDistance_Value(def, grapple, changes)
    def.text = tostring(Round(grapple.aim_straight.max_distance + changes.max_distance))
end
function this.Refresh_MaxDistance_UpDown(def, grapple, player, changes)
    local down, up = GetDecrementIncrement(grapple.aim_straight.max_distance_update, grapple.aim_straight.max_distance + changes.max_distance, player.experience + changes.experience)
    Refresh_UpDownButton(def, down, up)
end
function this.Update_MaxDistance(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes.max_distance = changes.max_distance - def.value_down
        changes.experience = changes.experience + 1
    end

    if isUpClicked and def.isEnabled_up then
        changes.max_distance = changes.max_distance + def.value_up
        changes.experience = changes.experience - 1
    end
end


function this.Define_Desired_CheckBox(const)
    -- CheckBox
    return
    {
        text = "Desired Length",

        position =
        {
            pos_x = -200,
            pos_y = 100,
            horizontal = const.alignment_horizontal.center,
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



function this.Refresh_IsDirty(def, changes)
    local isClean =
        IsNearZero(changes.max_distance)

    def.isDirty = not isClean
end

function this.Save(player, grapple, changes)
    grapple.aim_straight.max_distance = grapple.aim_straight.max_distance + changes.max_distance

    grapple.experience = grapple.experience - changes.experience
    player.experience = player.experience + changes.experience

    player:Save()
end