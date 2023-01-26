local this = {}

function DefineWindow_Jumping2(vars_ui, const)
    local jumping = {}
    vars_ui.jumping2 = jumping

    jumping.changes = Changes:new()

    jumping.title = Define_Title("Jumping", const)


    jumping.combo = this.Define_Combo(const)

    -- jumping.combo =
    -- {
    --     preview_text = "select an item",
    --     selected_item = nil,

    --     items =
    --     {
    --         "hello",
    --         "there",
    --         "all"
    --     },

    --     invisible_name = "Jumping2_Combo",
    -- }


    jumping.list = this.Define_List(const)


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


    -- // Widgets: Combo Box
    -- // - The BeginCombo()/EndCombo() api allows you to manage your contents and selection state however you want it, by creating e.g. Selectable() items.
    -- // - The old Combo() api are helpers over BeginCombo()/EndCombo() which are kept available for convenience purpose. This is analogous to how ListBox are created.
    -- IMGUI_API bool          BeginCombo(const char* label, const char* preview_value, ImGuiComboFlags flags = 0);
    -- IMGUI_API void          EndCombo(); // only call EndCombo() if BeginCombo() returns true!
    -- IMGUI_API bool          Combo(const char* label, int* current_item, const char* const items[], int items_count, int popup_max_height_in_items = -1);
    -- IMGUI_API bool          Combo(const char* label, int* current_item, const char* items_separated_by_zeros, int popup_max_height_in_items = -1);      // Separate items with \0 within a string, end item-list with \0\0. e.g. "One\0Two\0Three\0"
    -- IMGUI_API bool          Combo(const char* label, int* current_item, bool(*items_getter)(void* data, int idx, const char** out_text), void* data, int items_count, int popup_max_height_in_items = -1);

    -- // Widgets: Selectables
    -- // - A selectable highlights when hovered, and can display another color when selected.
    -- // - Neighbors selectable extend their highlight bounds in order to leave no gap between them. This is so a series of selected Selectable appear contiguous.
    -- IMGUI_API bool          Selectable(const char* label, bool selected = false, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0, 0)); // "bool selected" carry the selection state (read-only). Selectable() is clicked is returns true so you can modify your selection state. size.x==0.0: use remaining width, size.x>0.0: specify width. size.y==0.0: use label height, size.y>0.0: specify height
    -- IMGUI_API bool          Selectable(const char* label, bool* p_selected, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0, 0));      // "bool* p_selected" point to the selection state (read-write), as a convenient helper.


    -- // Flags for ImGui::BeginCombo()
    -- enum ImGuiComboFlags_
    -- {
    --     ImGuiComboFlags_None                    = 0,
    --     ImGuiComboFlags_PopupAlignLeft          = 1 << 0,   // Align the popup toward the left by default
    --     ImGuiComboFlags_HeightSmall             = 1 << 1,   // Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
    --     ImGuiComboFlags_HeightRegular           = 1 << 2,   // Max ~8 items visible (default)
    --     ImGuiComboFlags_HeightLarge             = 1 << 3,   // Max ~20 items visible
    --     ImGuiComboFlags_HeightLargest           = 1 << 4,   // As many fitting items as possible
    --     ImGuiComboFlags_NoArrowButton           = 1 << 5,   // Display on the preview box without the square arrow button
    --     ImGuiComboFlags_NoPreview               = 1 << 6,   // Display only a square arrow button
    --     ImGuiComboFlags_HeightMask_             = ImGuiComboFlags_HeightSmall | ImGuiComboFlags_HeightRegular | ImGuiComboFlags_HeightLarge | ImGuiComboFlags_HeightLargest
    -- };


    -- // Flags for ImGui::Selectable()
    -- enum ImGuiSelectableFlags_
    -- {
    --     ImGuiSelectableFlags_None               = 0,
    --     ImGuiSelectableFlags_DontClosePopups    = 1 << 0,   // Clicking this don't close parent popup window
    --     ImGuiSelectableFlags_SpanAllColumns     = 1 << 1,   // Selectable frame can span all columns (text will still fit in current column)
    --     ImGuiSelectableFlags_AllowDoubleClick   = 1 << 2,   // Generate press events on double clicks too
    --     ImGuiSelectableFlags_Disabled           = 1 << 3,   // Cannot be selected, display grayed out text
    --     ImGuiSelectableFlags_AllowItemOverlap   = 1 << 4    // (WIP) Hit testing to allow subsequent widgets to overlap this one
    -- };




    -- local def = jumping.combo

    -- local prompt = def.preview_text
    -- if def.selected_item then
    --     prompt = def.selected_item
    -- end

    -- if ImGui.BeginCombo("##" .. def.invisible_name, prompt, ImGuiComboFlags.HeightLarge) then
    --     for _, item in ipairs(def.items) do
    --         if ImGui.Selectable(item, (item == def.selected_item)) then
    --             def.selected_item = item
    --         end
    --     end

    --     ImGui.EndCombo()
    -- end


    Draw_ComboBox(jumping.combo, vars_ui.style.combobox, vars_ui.scale)





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

function this.Define_List(const)

    
end