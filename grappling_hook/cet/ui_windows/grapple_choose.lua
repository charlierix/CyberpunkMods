local this = {}

-- This is 1:1 with grapple_choose.available.items, and holds additional info about each item
-- { { isDefault, name, grappleKey, description }, {...}, {...} }
local available_info = nil
local isAnyAvailable = false

function DefineWindow_Grapple_Choose(vars_ui, const)
    local grapple_choose = {}
    vars_ui.grapple_choose = grapple_choose

    grapple_choose.title = Define_Title("New/Load Grapple", const)

    grapple_choose.low_xp1 = this.Define_LowXP1(const)
    grapple_choose.low_xp2 = this.Define_LowXP2(const)

    grapple_choose.name = this.Define_Name(const)
    grapple_choose.description = this.Define_Description(const)

    grapple_choose.available = this.Define_AvailableGrapples(const)

    grapple_choose.experience = Define_Experience(const)

    grapple_choose.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(grapple_choose)
end

function ActivateWindow_Grapple_Choose(vars_ui, const, player)
    if not vars_ui.grapple_choose then
        DefineWindow_Grapple_Choose(vars_ui, const)
    end

    local grapple_choose = vars_ui.grapple_choose

    -- Query existing grapples (also gets hardcoded defaults)
    local info, items, selectable = this.GetAvailable(player.experience)

    available_info = info

    grapple_choose.available.items = items
    grapple_choose.available.selectable = selectable
    grapple_choose.available.selected_index = 0

    isAnyAvailable = this.IsAnyAvailable(grapple_choose.available.selectable)
end

function DrawWindow_Grapple_Choose(isCloseRequested, vars_ui, player, window, const)
    local grapple_choose = vars_ui.grapple_choose

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Name(grapple_choose.name, grapple_choose.available.selected_index)
    this.Refresh_Description(grapple_choose.description, grapple_choose.available.selected_index)

    this.Refresh_Experience(grapple_choose.experience, player)

    this.Refresh_IsDirty(grapple_choose.okcancel, grapple_choose.available.selected_index)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(grapple_choose.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(grapple_choose.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(grapple_choose.title, vars_ui.style.colors, vars_ui.scale)

    Draw_ListBox(grapple_choose.available, vars_ui.style.listbox, vars_ui.scale)

    if isAnyAvailable then
        if grapple_choose.available.selected_index > 0 then
            Draw_Label(grapple_choose.name, vars_ui.style.colors, vars_ui.scale)
            Draw_Label(grapple_choose.description, vars_ui.style.colors, vars_ui.scale)
        end
    else
        Draw_Label(grapple_choose.low_xp1, vars_ui.style.colors, vars_ui.scale)
        Draw_Label(grapple_choose.low_xp2, vars_ui.style.colors, vars_ui.scale)
    end

    Draw_OrderedList(grapple_choose.experience, vars_ui.style.colors)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(grapple_choose.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, vars_ui.transition_info.grappleIndex, available_info[grapple_choose.available.selected_index])
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not grapple_choose.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.GetAvailable(experience)
    local defaults = GetDefault_Grapple_Choices()
    local fromDB = GetAvailableGrapples()

    local info = {}
    local items = {}
    local selectable = {}

    -- Defaults
    for i = 1, #defaults do
        info[#info+1] = this.GetAvailable_Info(true, defaults[i].name, nil, defaults[i].description)
        items[#items+1] = this.Format_ItemText(defaults[i].experience, defaults[i].name)
        selectable[#selectable+1] = experience >= defaults[i].experience
    end

    if fromDB and #fromDB > 0 then
        -- Separator Line
        info[#info+1] = this.GetAvailable_Info(false, nil, nil, nil)
        items[#items+1] = "  ------------------------------------------  "
        selectable[#selectable+1] = false

        -- From DB
        for i = 1, #fromDB do
            info[#info+1] = this.GetAvailable_Info(false, fromDB[i].name, fromDB[i].grapple_key, fromDB[i].description)
            items[#items+1] = this.Format_ItemText(fromDB[i].experience, fromDB[i].name, fromDB[i].date)
            selectable[#selectable+1] = experience >= fromDB[i].experience
        end
    end

    return info, items, selectable
end
function this.GetAvailable_Info(isDefault, name, grappleKey, description)
    return
    {
        isDefault = isDefault,
        name = name,
        grappleKey = grappleKey,
        description = description,
    }
end

function this.Format_ItemText(experience, name, date)
    -- Column 1: Experience
    local retVal = tostring(experience)

    -- Column 2: Name
    retVal = this.EnsureStringLength(retVal, 3, true)
    retVal = retVal .. "  " .. name

    -- Column 3: Date
    if date then
        retVal = this.EnsureStringLength(retVal, 30, false)
        retVal = retVal .. "  " .. date
    end

    return retVal
end

function this.EnsureStringLength(text, desired_length, shouldPadLeft)
    local retVal = text

    local len = string.len(retVal)
    if len < desired_length then
        if shouldPadLeft then
            retVal = string.rep(" ", desired_length - len) .. retVal
        else
            retVal = retVal .. string.rep(" ", desired_length - len)
        end
    end

    return retVal
end

function this.IsAnyAvailable(selectable)
    if not selectable then
        return false
    end

    for i = 1, #selectable do
        if selectable[i] then
            return true
        end
    end

    return false
end

function this.Define_LowXP1(const)
    -- Label
    return
    {
        text = "nothing available",

        position =
        {
            pos_x = -210,
            pos_y = -80,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "info",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_LowXP2(const)
    -- Label
    return
    {
        text = "more experience required",

        position =
        {
            pos_x = -210,
            pos_y = -20,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "info",

        CalcSize = CalcSize_Label,
    }
end

function this.Define_Name(const)
    -- Label
    return
    {
        text = "",

        position =
        {
            pos_x = 100,
            pos_y = -120,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },

        color = "subTitle",

        CalcSize = CalcSize_Label,
    }
end
function this.Refresh_Name(def, selected_index)
    if isAnyAvailable and available_info and selected_index > 0 then
        def.text = available_info[selected_index].name
    else
        def.text = ""
    end
end

function this.Define_Description(const)
    -- Label
    return
    {
        text = "",

        max_width = 400,

        position =
        {
            pos_x = 100,
            pos_y = -80,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",      -- Grapple_Straight has description in a LabelClickable, which defaults to textbox's foreground if it's not overriden.  TextBox's color happens to be the same as this (if the stylesheet ever changes, may want a dedicated color name for this)

        CalcSize = CalcSize_Label,
    }
end
function this.Refresh_Description(def, selected_index)
    if isAnyAvailable and available_info and selected_index > 0 then
        def.text = available_info[selected_index].description
    else
        def.text = ""
    end
end

function this.Define_AvailableGrapples(const)
    -- ListBox
    return
    {
        invisible_name = "Grapple_Choose_Available",

        -- These are populated for real in activate
        items = {},
        selected_index = 0,

        width = 400,
        height = 650,

        position =
        {
            pos_x = 48,
            pos_y = 48,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_ListBox,
    }
end

function this.Refresh_Experience(def, player)
    --TODO: May want to subtract off the selected grapple's cost
    def.content.available.value = tostring(math.floor(player.experience))
end

function this.Refresh_IsDirty(def, selected_index)
    def.isDirty = selected_index > 0
end

function this.Save(player, grappleIndex, info)
    local grapple
    if info.isDefault then
        grapple = GetDefault_Grapple_ByName(info.name)      -- it's one of the default templates
    else
        grapple = GetGrapple_ByKey(info.grappleKey)
    end

    if not grapple then
        LogError("Couldn't get grapple")
        do return end
    end

    player:SetGrappleByIndex(grappleIndex, grapple)

    player.experience = player.experience - grapple.experience

    player:Save()
end