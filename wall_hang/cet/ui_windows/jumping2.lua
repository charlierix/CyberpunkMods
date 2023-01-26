local this = {}

function DefineWindow_Jumping2(vars_ui, const)
    local jumping = {}
    vars_ui.jumping2 = jumping

    jumping.changes = Changes:new()

    jumping.title = Define_Title("Jumping", const)

    --jumping.combo = this.Define_Combo(const)


    





    jumping.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(jumping)
end

function ActivateWindow_Jumping2(vars_ui, const)
    if not vars_ui.jumping2 then
        DefineWindow_Jumping2(vars_ui, const)
    end
end

function DrawWindow_Jumping2(isCloseRequested, vars_ui, window, const, player, player_arcade)
    local jumping = vars_ui.jumping2

    ------------------------- Finalize models for this frame -------------------------

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(jumping.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(jumping.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    --Draw_ComboBox(jumping.combo, vars_ui.style.combobox, vars_ui.scale)





    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(jumping.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        --this.Save(player, player_arcade)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not jumping.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Combo(const)
    -- ComboBox
    return
    {
        preview_text = "select an item",
        selected_item = nil,

        items =
        {
            "hello",
            "there",
            "all",
            "item1",
            "item2",
            "item3",
            "item4",
            "item5",
            "item6",
            "item7",
            "item8",
            "item9",
            "itemX",
            "itemE",
            "item10",
            "item11",
            "really long text that needs to expand",
            "item12",
            "item13",
            "item21",
            "item22",
            "item23",
            "item24",
            "item25",
            "item26",
            "item27",
            "item28",
            "item29",
            "item2X",
            "item2E",
            "item31",
            "item32",
            "item33",
            "item34",
            "item35",
            "item36",
            "item37",
            "item38",
            "item39",
            "item3X",
            "item3E",
            "item41",
            "item42",
            "item43",
            "item44",
            "item45",
            "item46",
            "item47",
            "item48",
            "item49",
            "item4X",
            "item4E",
        },

        --width = 240,

        position =
        {
            pos_x = -100,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "Jumping2_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
