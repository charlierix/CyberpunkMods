local this = {}

function Define_Window_Grapple_Straight(vars_ui, const)
    local grapple_straight = {}
    vars_ui.grapple_straight = grapple_straight

    grapple_straight.changes = {}        -- this will hold values that have changes to be applied

    grapple_straight.title = Define_Title("Straight Grapple", const)

    grapple_straight.name = this.Define_Name(const)
    grapple_straight.description = this.Define_Description(const)


    -- summary length

    -- summary accel along
    -- summary accel look

    -- summary aim duration

    -- summary antigrav

    -- summary airdash

    -- summary stop early






    -- ordered experience



    grapple_straight.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function DrawWindow_Grapple_Straight(vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_Grapple_Straight: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local grapple_straight = vars_ui.grapple_straight

    ------------------------- Finalize models for this frame -------------------------
    this.Refresh_Name(grapple_straight.name, grapple)
    this.Refresh_Description(grapple_straight.description, grapple)

    this.Refresh_IsDirty(grapple_straight.okcancel, grapple_straight.name, grapple_straight.description, grapple)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(grapple_straight.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_TextBox(grapple_straight.name, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.line_heights, window.width, window.height, const)
    if Draw_LabelClickable(grapple_straight.description, vars_ui.style.textbox, vars_ui.style.colors, window.left, window.top, window.width, window.height, const) then
        --TODO: Transition to description editor
    end







    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(grapple_straight.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        print("TODO: Save Grapple Straight")
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Name(const)
    -- TextBox
    return
    {
        name = "txtGrappleName",

        maxChars = 48,
        min_width = 120,
        --max_width = 240,

        isMultiLine = false,

        foreground_override = "subTitle",

        position =
        {
            pos_x = 30,
            pos_y = 30,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },
    }
end
function this.Refresh_Name(def, grapple)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    --NOTE: TransitionWindows_Grapple sets this to nil
    if not def.text then
        def.text = grapple.name
    end
end

function this.Define_Description(const)
    -- LabelClickable
    return
    {
        name = "txtGrappleDescription",

        max_width = 360,

        position =
        {
            pos_x = 30,
            pos_y = 66,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },
    }
end
function this.Refresh_Description(def, grapple)
    if not def.text then
        def.text = grapple.description
    end
end

function this.Refresh_IsDirty(def, def_name, def_description, grapple)
    local isDirty = false

    if def_name.text and def_name.text ~= grapple.name then
        isDirty = true
    elseif def_description.text and def_description.text ~= grapple.description then
        isDirty = true
    end

    def.isDirty = isDirty
end