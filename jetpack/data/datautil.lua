local this = {}
local DataUtil = {}

-- Creates a new player row with default modes
-- NOTE: Even if there are rows for this playerID, a new row will still be created with default modes
-- Returns:
--    PlayerEntry (the type returned is defined in models\Player)
--    Error Message (only populated if the first two are nil)
function DataUtil.CreateNewPlayer(playerID, sounds_thrusting, const)
    local modes_key, modes_live, errMsg = this.GetDefaultModes(sounds_thrusting, const)
    if errMsg then
        return nil, errMsg
    end

    local player_key, errMsg = dal.InsertPlayer(playerID, modes_key, 1)
    if not player_key then
        return nil, errMsg
    end

    return
    {
        playerKey = player_key,
        playerID = playerID,
        mode_keys = modes_key,
        mode = modes_live[1],
        mode_index = 1,
    },
    nil
end

-- Returns the latest player by ID (or nil)
-- Returns:
--    PlayerEntry (the type returned is defined in models\Player)
--    Error Message (only populated if the first two are nil)
function DataUtil.LoadExistingPlayer(playerID, sounds_thrusting, const)
    local player_row, errMsg = dal.GetLatestPlayer(playerID)
    if not player_row then
        return nil, errMsg
    end

    local mode_key = player_row.ModeKeys[player_row.ModeIndex]

    local mode_json, errMsg = dal.GetMode_ByKey(mode_key)
    if not mode_json then
        return nil, errMsg
    end

    local mode = mode_defaults.FromJSON(mode_json, mode_key, sounds_thrusting, const)

    return
    {
        playerKey = player_row.PlayerKey,
        playerID = playerID,
        mode_keys = player_row.ModeKeys,
        mode = mode,
        mode_index = player_row.ModeIndex,
    },
    nil
end

-- Advances the index to the next mode in the list (or loops back to one)
-- Returns:
--  modeIndex
--  mode (see models\Mode)
--  Error Message (only populated if first two are nil)
function DataUtil.NextMode(playerKey, mode_keys, current_index, sounds_thrusting, const)
    if #mode_keys == 0 then
        return nil, nil, "list of mode keys is empty"
    end

    local index = current_index + 1
    if index < 1 or index > #mode_keys then
        index = 1
    end

    local mode_json, errMsg = dal.GetMode_ByKey(mode_keys[index])
    if not mode_json then
        return nil, nil, errMsg
    end

    local mode = mode_defaults.FromJSON(mode_json, mode_keys[index], sounds_thrusting, const)

    local errMsg = dal.UpdatePlayer_ModeIndex(playerKey, index)
    if errMsg then
        return nil, nil, errMsg
    end

    return index, mode, nil
end

----------------------------------- Private Methods -----------------------------------

function this.GetDefaultModes(sounds_thrusting, const)
    local count = mode_defaults.GetConfigValues_Count()

    local modes_live = {}
    local modes_key = {}

    for i = 1, count, 1 do
        --NOTE: sounds_thrusting is a live class, but only gets called during tick
        local mode = mode_defaults.GetConfigValues(i, sounds_thrusting, const)

        local mode_json = mode_defaults.ToJSON(mode, const)

        local modeKey = dal.GetModeKey_ByContent(mode.name, mode_json)
        if not modeKey then
            local modeKey_temp, errMsg = dal.InsertMode(mode.name, mode_json)

            if modeKey_temp then
                modeKey = modeKey_temp
            else
                return nil, nil, errMsg
            end
        end

        mode.mode_key = modeKey

        table.insert(modes_key, modeKey)
        table.insert(modes_live, mode)
    end

    return modes_key, modes_live, nil
end

return DataUtil