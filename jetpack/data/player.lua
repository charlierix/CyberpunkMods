local this = {}
Player = {}

local datautil = require "data/datautil"

function Player:new(o, vars, const, debug)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.vars = vars
    obj.const = const
    obj.debug = debug

    obj.is_mock = true
    obj.mode = nil

    ------ Non mock properties ------
    -- obj.playerKey
    -- obj.playerID
    -- obj.mode_keys
    -- obj.mode_index

    this.Load(obj)

    return obj
end

function Player:NextMode()
    if self.is_mock then
        -- Create a uniqueID and save in the save file
        local playerID = os.time()      -- seconds since 1/1/1970
        self.o:SetPlayerUniqueID(playerID)

        -- Create a new row in the database and store the contents of that row in this class's member variables
        local player_entry, errMsg = datautil.CreateNewPlayer(playerID, self.vars.sounds_thrusting, self.const)
        if not player_entry then
            this.ResetToMock(self, "Couldn't load player row, loading defaults: " .. tostring(errMsg))
            do return end
        end

        this.StorePlayerEntry(self, player_entry)
    end

    -- Advance to the next one, also updating the db
    local index, mode, errMsg = datautil.NextMode(self.playerKey, self.mode_keys, self.mode_index, self.vars.sounds_thrusting, self.const)
    if errMsg then
        this.ResetToMock(self, "Error switching modes, loading defaults: " .. tostring(errMsg))
        do return end
    end

    self.mode_index = index
    this.StoreMode(self, mode)

    self.vars.showConfigNameUntil = self.o.timer + 3
end

----------------------------------- Private Methods -----------------------------------

-- This loads the current profile for the current playthrough.  If there are none, use default mode, but
-- not actually populate the database yet (wait for the first real need)
function this.Load(obj)
    -- Get player's uniqueID (comes back as zero if there is no entry)
    local playerID = obj.o:GetPlayerUniqueID()
    if not playerID or playerID == 0 then
        this.SetupMock(obj)
        do return end
    end

    -- Pull from database
    local player_entry, errMsg = datautil.LoadExistingPlayer(playerID, obj.vars.sounds_thrusting, obj.const)
    if not player_entry then
        this.ResetToMock(obj, "Couldn't load player row, loading defaults: " .. tostring(errMsg))
        do return end
    end

    -- Store in this object's member variables
    this.StorePlayerEntry(obj, player_entry)
end

function this.ResetToMock(obj, errMsg)
    LogError(errMsg)

    this.SetupMock(obj)

    obj.vars.sounds_thrusting:ModeChanged(obj.mode.sound_type)
    obj.vars.should_rebound_impulse = false
end

function this.SetupMock(obj)
    obj.is_mock = true

    local mode = mode_defaults.GetConfigValues(0, obj.vars.sounds_thrusting, obj.const)
    this.StoreMode(obj, mode)
end

function this.StorePlayerEntry(obj, player_entry)
    obj.is_mock = false

    obj.playerKey = player_entry.playerKey
    obj.playerID = player_entry.playerID
    obj.mode_keys = player_entry.mode_keys
    obj.mode_index = player_entry.mode_index

    this.StoreMode(obj, player_entry.mode)
end
function this.StoreMode(obj, mode)
    obj.mode = mode
    obj.vars.sounds_thrusting:ModeChanged(obj.mode.sound_type)
    obj.vars.remainBurnTime = obj.mode.energy.maxBurnTime
end