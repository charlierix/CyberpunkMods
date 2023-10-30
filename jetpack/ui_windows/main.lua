local this = {}

local modes_by_key = {}

-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Main(vars_ui, const)
    local main = {}
    vars_ui.main = main

    main.changes = Changes:new()

    main.modelist = this.Define_ModeList(const)

    main.okcancel = Define_OkCancelButtons(true, vars_ui, const)

    FinishDefiningWindow(main)
end

function ActivateWindow_Main(vars_ui, const)
    if not vars_ui.main then
        DefineWindow_Main(vars_ui, const)
    end

    local main = vars_ui.main

    main.changes:Clear()

    main.modelist.items = nil
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Main(isCloseRequested, vars, vars_ui, player, window, o, const)
    local main = vars_ui.main

    ------------------------- Finalize models for this frame -------------------------

    player:EnsureNotMock()

    this.Refresh_ModeList(main.modelist, vars_ui, player, vars.sounds_thrusting, const)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(main.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(main.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    --Draw_Label(main.title, vars_ui.style.colors, vars_ui.scale)

    --Draw_Label(main.consoleWarning, vars_ui.style.colors, vars_ui.scale)

    Draw_StackPanel(main.modelist, vars_ui.style.listbox, window.left, window.top, vars_ui.scale)


    local _, isCloseClicked = Draw_OkCancelButtons(main.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)

    return not (isCloseRequested or isCloseClicked)       -- stop showing when they click the close button (or press config key a second time.  This main page doesn't have anything to save, so it's ok to exit at any time)
end

----------------------------------- Private Methods -----------------------------------

function this.Define_ModeList(const)
    -- StackPanel
    return
    {
        invisible_name = "Main_Modes_List",

        -- These are populated for real in activate
        items = {},

        width = 340,
        --height = 490,
        height = 480,

        position =
        {
            pos_x = 20,
            pos_y = 0,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_StackPanel,
    }
end
function this.Refresh_ModeList(def, vars_ui, player, sounds_thrusting, const)
    if not def.items then       -- cleared during activate
        def.items = this.Rebuild_ModeList(player.mode_keys, vars_ui, sounds_thrusting, const)

    elseif #def.items ~= #player.mode_keys then     -- this case should never happen
        def.items = this.Rebuild_ModeList(player.mode_keys, vars_ui, sounds_thrusting, const)

    else        -- make sure the stored list matches what the player row has
        for i = 1, #player.mode_keys, 1 do
            if def.items[i].mode.mode_key ~= player.mode_keys[i] then
                def.items = this.Rebuild_ModeList(player.mode_keys, vars_ui, sounds_thrusting, const)
                do break end
            end
        end
    end
end

function this.Rebuild_ModeList(mode_keys, vars_ui, sounds_thrusting, const)
    local retVal = {}

    for _, key in ipairs(mode_keys) do
        local key_string = tostring(key)

        if not modes_by_key[key_string] then
            local mode_json, errMsg = dal.GetMode_ByKey(key)
            if errMsg then
                LogError("Couldn't retrieve mode: " .. errMsg)
                return {}
            end

            local mode = mode_defaults.FromJSON(mode_json, key, sounds_thrusting, const)
            modes_by_key[key_string] = mode
        end

        local item = ModeList_Item:new(modes_by_key[key_string], vars_ui, const)

        table.insert(retVal, item)
    end

    return retVal
end

-- This would be more efficient if I could get it to work (select rows where primarykey in (...))
function this.Rebuild_ModeList_SINGLEQUERY(mode_keys, vars_ui, sounds_thrusting, const)
    -- Get a list of keys that aren't in the mode cache
    local missing_keys = {}

    for _, key in ipairs(mode_keys) do
        if not modes_by_key[tostring(key)] then
            table.insert(missing_keys, key)
        end
    end

    -- Fill cache with missing from the database
    if #missing_keys > 0 then
        local missing_modes, errMsg = dal.GetModes_ByKeys(table.pack(missing_keys))
        if errMsg then
            LogError("Couldn't retrieve modes: " .. errMsg)
            return {}
        end

        for _, mode_row in ipairs(missing_modes) do
            local mode = mode_defaults.FromJSON(mode_row.JSON, mode_row.ModeKey, sounds_thrusting, const)
            modes_by_key[tostring(mode.ModeKey)] = mode
        end
    end

    -- Build the return list
    local retVal = {}

    for _, key in ipairs(mode_keys) do
        local key_string = tostring(key)

        local mode = modes_by_key[key_string]

        if not mode then
            LogError("Couldn't find mode by key: " .. key_string)
            return {}
        end

        local item = ModeList_Item:new(mode, vars_ui, const)

        table.insert(retVal, item)
    end

    return retVal
end