local this = {}

-- This holds player level state (has nothing to do with cyberpunk's playerpuppet class)
--
-- This is closely tied to the Player model
--
-- This is meant to be static data (that's why it's in the db folder.  Any runtime variables need to be
-- in the vars array)

Player = {}

function Player:new(o, vars, const, debug)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.vars = vars
    obj.const = const
    obj.debug = debug

    -- See MapRowToSelf() for the rest of the member variables

    obj:Load()

    return obj
end

-- Saves people from writing an ugly if elseif set
function Player:GetGrappleByIndex(index)
    local errMsg = this.ValidateIndex(index)
    if errMsg then
        print("Player:GetGrappleByIndex: " .. errMsg .. ": " .. tostring(index))
        return nil
    end

    return self["grapple" .. tostring(index)]
end
function Player:SetGrappleByIndex(index, grapple)
    local errMsg = this.ValidateIndex(index)
    if errMsg then
        print("Player:SetGrappleByIndex: " .. errMsg .. ": " .. tostring(index))
    end

    self["grapple" .. tostring(index)] = grapple
end

function Player:Save()
    local pkey, errMsg = SavePlayer(self:MapSelfToModel())

    --TODO: Handle errors

    self.PlayerPrimaryKey = pkey
end

------------------------------------ Private Instance Methods -----------------------------------

-- This loads the current profile for the current playthrough.  If there are none, this will create
-- a new one based on defaults
function Player:Load()
    -- Get player's uniqueID (comes back as zero if there is no entry)
    local playerID = self.o:GetPlayerUniqueID()
    if not playerID or playerID == 0 then
        playerID = this.CreateNewPlayerID(self.o)
    end

    -- Retrieve entry from db
    local playerEntry, primKey, errMsg = GetPlayerEntry(playerID)
    if not playerEntry then
        -- There's no need to store default in the db.  Wait until they change something
        playerEntry = GetDefault_Player(playerID)
    end

    self:MapModelToSelf(playerEntry, primKey)
end

-- Puts the contents of the player model entry in self.  This will save all the users of
-- this class from having an extra dot (player.player.grapple1....)
function Player:MapModelToSelf(model, primkey)
    self.playerID = model.playerID
    self.energy_tank = model.energy_tank

    -- action mapping 1,2,3,4,5,6

    self.grapple1 = model.grapple1
    self.grapple2 = model.grapple2
    self.grapple3 = model.grapple3
    self.grapple4 = model.grapple4
    self.grapple5 = model.grapple5
    self.grapple6 = model.grapple6

    self.experience = model.experience

    self.PlayerPrimaryKey = primkey
end

function Player:MapSelfToModel()
    return
    {
        playerID = self.playerID,
        energy_tank = self.energy_tank,

        -- action mapping 1,2,3,4,5,6

        grapple1 = self.grapple1,
        grapple2 = self.grapple2,
        grapple3 = self.grapple3,
        grapple4 = self.grapple4,
        grapple5 = self.grapple5,
        grapple6 = self.grapple6,

        experience = self.experience,
    }
end

------------------------------------- Private Static Methods ------------------------------------

function this.CreateNewPlayerID(o)
    -- Save file doesn't have this quest string.  Get a new ID and store it in the save file

    -- It won't stick if they don't hit save.  But this is a one time setup per playthrough, so
    -- there's a good chance that saves will happen (worst case, there would be a few orphaned rows
    -- and the user will need to redo their grapple settings)

    local playerID = os.time()      -- seconds since 1/1/1970

    o:SetPlayerUniqueID(playerID)

    return playerID
end

function this.ValidateIndex(index)
    if index == nil then
        return "Index is nil"

    elseif type(index) ~= "number" then
        return "Index is not a number"

    elseif math.floor(index) ~= index then
        return "Index is floating point"

    elseif index < 1 or index > 6 then
        return "Index is out of range"

    else
        return nil
    end
end