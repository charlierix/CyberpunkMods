local this = {}

local modes_by_key = {}

local next_token = 0

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

    next_token = 0
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Main(isCloseRequested, vars, vars_ui, player, window, o, const)
    local main = vars_ui.main

    ------------------------- Finalize models for this frame -------------------------

    player:EnsureNotMock()

    this.Refresh_ModeList(main.modelist, vars_ui, player, vars.sounds_thrusting, o, const)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(main.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(main.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    --TODO: label describing the mode list

    Draw_StackPanel(main.modelist, vars_ui.style.listbox, window.left, window.top, vars_ui.scale)

    local _, isCloseClicked = Draw_OkCancelButtons(main.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)

    this.Actions_ModeList(main.modelist, vars_ui, player, vars.sounds_thrusting, const)

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
function this.Refresh_ModeList(def, vars_ui, player, sounds_thrusting, o, const)

    --NOTE: the last item in def.items is an add button, so the count will be one higher than mode primary key list

    local mode_keys_count = 0
    if player.mode_keys then
        mode_keys_count = #player.mode_keys
    end

    local mode_index = 1
    if player.mode_index then
        mode_index = player.mode_index
    end

    if not def.items then       -- cleared during activate
        def.items = this.Rebuild_ModeList(player.mode_keys, mode_index, vars_ui, sounds_thrusting, o, const)

    elseif #def.items - 1 ~= mode_keys_count then     -- this case should never happen
        def.items = this.Rebuild_ModeList(player.mode_keys, mode_index, vars_ui, sounds_thrusting, o, const)

    else        -- make sure the stored list matches what the player row has
        for i = 1, mode_keys_count, 1 do
            if def.items[i].mode.mode_key ~= player.mode_keys[i] then
                def.items = this.Rebuild_ModeList(player.mode_keys, mode_index, vars_ui, sounds_thrusting, o, const)
                do break end
            end
        end
    end
end

function this.Actions_ModeList(def, vars_ui, player, sounds_thrusting, const)
    if not def.items then
        do return end
    end

    for i, item in ipairs(def.items) do
        if i < #def.items then
            if item.action_instruction then
                if item.action_instruction == const.modelist_actions.move_up then
                    this.Actions_ModeList_MoveUpDown(def, i, -1, player)

                elseif item.action_instruction == const.modelist_actions.move_down then
                    this.Actions_ModeList_MoveUpDown(def, i, 1, player)

                elseif item.action_instruction == const.modelist_actions.delete then
                    this.Actions_ModeList_Delete(i, player, sounds_thrusting, const)

                elseif item.action_instruction == const.modelist_actions.clone then
                    this.Actions_ModeList_Clone(i, player)

                elseif item.action_instruction == const.modelist_actions.edit then
                    TransitionWindows_Mode(vars_ui, const, item.mode, i)
                end

                do return end       -- only one button should ever be pressed.  If more than one, just execute the first
            end
        else
            if item.is_clicked then
                --TODO: switch to mode choose window.  If they commit, do the mode keys addition logic and player save in that window
                this.Actions_ModeList_Add(player)
                do return end
            end
        end
    end
end
function this.Actions_ModeList_MoveUpDown(def, index, direction, player)
    --TODO: keep add entry in mind (#def.items - 1)
    local new_index = index + direction
    if new_index < 1 or new_index > #def.items then
        do return end       -- already at the front or end of the list, nothing to do
    end

    -- Adjust player.mode_keys
    local key_temp = player.mode_keys[new_index]
    player.mode_keys[new_index] = player.mode_keys[index]
    player.mode_keys[index] = key_temp

    -- Adjust player.mode_index
    if player.mode_index == index then
        player.mode_index = new_index
    elseif player.mode_index == new_index then
        player.mode_index = index
    end

    -- Update database
    player:Save()

    -- no need to call this.Rebuild_ModeList, since it will be called next frame
end
function this.Actions_ModeList_Delete(index, player, sounds_thrusting, const)
    if not player.mode_keys or index > #player.mode_keys then
        LogError("Told to delete a mode that doesn't exist")
        do return end
    end

    table.remove(player.mode_keys, index)

    if player.mode_index > 0 then
        if index < player.mode_index then
            player.mode_index = player.mode_index - 1
        end

        if player.mode_index > #player.mode_keys then
            player.mode_index = #player.mode_keys
        end

        if #player.mode_keys == 0 then
            player.mode_index = 0
            player.mode = nil

        elseif player.mode_keys[player.mode_index] ~= player.mode.mode_key then
            local mode_json, errMsg = dal.GetMode_ByKey(player.mode_keys[player.mode_index])
            if not mode_json then
                LogError("Actions_ModeList_Delete: Couldn't get new mode: " .. errMsg)
                player.mode_index = 0
                player.mode = nil
            end

            player.mode = mode_defaults.FromJSON(mode_json, player.mode_keys[player.mode_index], sounds_thrusting, const)
        end
    end

    player:Save()
end
function this.Actions_ModeList_Clone(index, player)
    -- Duplicate the primary key.  Next frame, this list won't match def.items, so def.items will get rebuilt
    --
    -- When the user modifies one of those entries, the modified json won't match and a new mode row will get
    -- created (dal.GetModeKey_ByContent)
    table.insert(player.mode_keys, index, player.mode_keys[index])

    player:Save()
end
function this.Actions_ModeList_Add(player)

    -- For now, just pick a random primary key and add to the list

    local all_mode_keys, errMsg = dal.GetAllModeKeys()
    if not all_mode_keys then
        LogError("Couldn't get list of mode keys: " .. tostring(errMsg))
        do return end
    end

    local index = math.random(#all_mode_keys)

    if not player.mode_keys then
        player.mode_keys = {}
        player.mode_index = 1
    end

    table.insert(player.mode_keys, all_mode_keys[index])

    player:Save()
end

-- Creates a list of ModeList_Item that matches the list of mode primary keys in player entry (player.mode_keys)
function this.Rebuild_ModeList(mode_keys, mode_index, vars_ui, sounds_thrusting, o, const)
    if not mode_keys then
        return this.Rebuild_ModeList_AppendAddItem({}, vars_ui, o, const)
    end

    local retVal = {}

    for i, key in ipairs(mode_keys) do
        local key_string = tostring(key)

        if not modes_by_key[key_string] then
            local mode_json, errMsg = dal.GetMode_ByKey(key)
            if errMsg then
                LogError("Couldn't retrieve mode: " .. errMsg)
                return this.Rebuild_ModeList_AppendAddItem({}, vars_ui, o, const)
            end

            local mode = mode_defaults.FromJSON(mode_json, key, sounds_thrusting, const)
            modes_by_key[key_string] = mode
        end

        next_token = next_token + 1     -- this needs to be unique, used in invisible names
        local item = ModeList_Item:new(next_token, modes_by_key[key_string], i == mode_index, vars_ui, o, const)

        table.insert(retVal, item)
    end

    return this.Rebuild_ModeList_AppendAddItem(retVal, vars_ui, o, const)
end
function this.Rebuild_ModeList_AppendAddItem(items, vars_ui, o, const)
    local item = ModeList_Add:new(vars_ui, o, const)
    table.insert(items, item)
    return items
end

-- This would be more efficient if I could get it to work (select rows where primarykey in (...))
function this.Rebuild_ModeList_SINGLEQUERY(mode_keys, vars_ui, sounds_thrusting, o, const)
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

        local item = ModeList_Item:new(mode, vars_ui, o, const)

        table.insert(retVal, item)
    end

    return retVal
end

