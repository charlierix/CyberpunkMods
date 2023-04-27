local this = {}

function DefineWindow_Grapple_Swing(vars_ui, const)
    local grapple_swing = {}
    vars_ui.grapple_swing = grapple_swing

    grapple_swing.changes = Changes:new()

    grapple_swing.title = Define_Title("Swing", const)

    grapple_swing.name = this.Define_Name(const)
    grapple_swing.description = this.Define_Description(grapple_swing.name, const)


    --grapple_swing.visuals = this.Define_Visuals(const)


    -- Air Density % (from 0.1 to 3)
    -- Gravity % (from 0.1 to 2)

    -- Accel Mult % (from 0.5 to 2)
    -- Distance Mult % (from 0.5 to 2)

    -- Should Latch
    -- Max Latch Angle

    -- Show extra graphics


    grapple_swing.experience = Define_Experience(const, "grapple")

    grapple_swing.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(grapple_swing)
end

function ActivateWindow_Grapple_Swing(vars_ui, const)
    if not vars_ui.grapple_swing then
        DefineWindow_Grapple_Swing(vars_ui, const)
    end

    vars_ui.grapple_swing.changes:Clear()

    vars_ui.grapple_straight.name.text = nil
    vars_ui.grapple_straight.description.text = nil
end

function DrawWindow_Grapple_Swing(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        LogError("DrawWindow_Grapple_Swing: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local grapple_swing = vars_ui.grapple_swing

    local changes = grapple_swing.changes

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Name(grapple_swing.name, grapple)

    this.Refresh_Description(grapple_swing.description, grapple)

    this.Refresh_Experience(grapple_swing.experience, player, grapple)

    this.Refresh_IsDirty(grapple_swing.okcancel, grapple_swing.name, grapple)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(grapple_swing.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(grapple_swing.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(grapple_swing.title, vars_ui.style.colors, vars_ui.scale)

    Draw_TextBox(grapple_swing.name, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(grapple_swing.description, vars_ui.style.colors, vars_ui.scale)


    -- if Draw_SummaryButton(grapple_swing.visuals, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
    --     TransitionWindows_Swing_Visuals(vars_ui, const)
    -- end


    Draw_OrderedList(grapple_swing.experience, vars_ui.style.colors)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(grapple_swing.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, grapple, grapple_swing.name)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not grapple_swing.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Name(const)
    -- TextBox
    return
    {
        invisible_name = "Grapple_Swing_GrappleName",

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

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Name(def, grapple)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    --NOTE: ActivateWindow_Swing_Straight sets this to nil
    if not def.text then
        def.text = grapple.name
    end
end

function this.Define_Description(relative_to, const)
    -- Label
    return
    {
        max_width = 320,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 13,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Refresh_Description(def, grapple)
    if not def.text then
        def.text = grapple.description
    end
end

function this.Refresh_Experience(def, player, grapple)
    def.content.available.value = tostring(math.floor(player.experience))
    def.content.used.value = tostring(Round(grapple.experience))
end

function this.Refresh_IsDirty(def, def_name, grapple)
    local isDirty = false

    if def_name.text and def_name.text ~= grapple.name then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, def_name)
    grapple.name = def_name.text

    player:Save()
end