local this = {}

function DefineWindow_Grapple_Choose(vars_ui, const)
    local grapple_choose = {}
    vars_ui.grapple_choose = grapple_choose

    grapple_choose.title = Define_Title("New/Load Grapple", const)


    --TODO: A label if there's not enough xp
    --  "Requires more experience"


    -- A list to choose grapples from.  Premade are at the top of the list.  Order by name,experience
    --  Two columns, cost and name

    -- When they click one of the items, show:
    --  Name
    --  Description
    --
    --  In the future, a summary report

    grapple_choose.available = this.Define_AvailableGrapples(const)



    grapple_choose.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function ActivateWindow_Grapple_Choose(vars_ui)
    local grapple_choose = vars_ui.grapple_choose

    grapple_choose.available.items =
    {
        "hello 1",
        "there",
        "everybody",
        "one more",
        "hello 2",
        "there",
        "everybody",
        "one more",
        "hello 3",
        "there",
        "everybody - how about some really long text",
        "one more",
        "hello 4",
        "there",
        "everybody",
        "one more",
        "hello 5",
        "there",
        "everybody",
        "one more",
        "hello 6",
        "there",
        "everybody",
        "one more",
        "hello 7",
        "there",
        "everybody",
        "one more",
        "hello 8",
        "there",
        "everybody",
        "one more",
        "hello 9",
        "there",
        "everybody",
        "one more",
        "hello 10",
        "there",
        "everybody",
        "one more",
    }

    grapple_choose.available.selected_index = 0
    --grapple_choose.available.selected_index = #grapple_choose.available.items + 1       -- can't use zero, it will just select the first item
end

function DrawWindow_Grapple_Choose(isCloseRequested, vars_ui, player, window, const)
    local grapple_choose = vars_ui.grapple_choose

    Draw_Label(grapple_choose.title, vars_ui.style.colors, window.width, window.height, const)


    -- ImGui.SetCursorPos(window.width / 2, window.height / 2)

    -- ImGui.PushItemWidth(200)
    -- --selectedIndex = ImGui.Combo("##dontworryaboutit", selectedIndex, items, #items)
    -- selectedIndex = ImGui.ListBox("##dontworryaboutit", selectedIndex, items, #items, 12)
    -- ImGui.PopItemWidth()

    Draw_ListBox(grapple_choose.available, vars_ui.style.listbox, window.left, window.top, window.width, window.height, const)


    local _, isCancelClicked = Draw_OkCancelButtons(grapple_choose.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not grapple_choose.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_AvailableGrapples(const)
    -- ListBox
    return
    {
        invisible_name = "Grapple_Choose_Available",

        -- These are populated for real in activate
        items = {},
        selected_index = 0,

        width = 288,
        height = 450,

        position =
        {
            pos_x = 48,
            pos_y = 0,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.center,
        },
    }
end