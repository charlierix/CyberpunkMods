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

function Player:UnlockPlayer()
    self.isUnlocked = true

    -- If the player was locked, experience should have been zero, but if something got out of sync, preserve
    -- existing if it was greater
    self.experience = math.max(self.experience, GetDefault_Experience())

    -- Same here, energy tank should be nil coming into this function
    if not self.energy_tank then
        self.energy_tank = GetDefault_EnergyTank()
    end

    -- Save to DB
    self:Save()
end

-- Saves people from writing an ugly if elseif set
function Player:GetGrappleByIndex(index)
    local errMsg = this.ValidateIndex(index)
    if errMsg then
        LogError("Player:GetGrappleByIndex: " .. errMsg .. ": " .. tostring(index))
        return nil
    end

    return self["grapple" .. tostring(index)]
end
function Player:SetGrappleByIndex(index, grapple)
    local errMsg = this.ValidateIndex(index)
    if errMsg then
        LogError("Player:SetGrappleByIndex: " .. errMsg .. ": " .. tostring(index))
    end

    self["grapple" .. tostring(index)] = grapple
end

function Player:TransferExperience_GrappleStraight(grapple, purchaseXP)
    if self.experience - purchaseXP < 0 then
        LogError("TransferExperience_GrappleStraight: Not enough player xp: " .. tostring(self.experience) .. ", purchaseXP: " .. tostring(purchaseXP))
        return false

    elseif grapple.experience + purchaseXP < 0 then
        LogError("TransferExperience_GrappleStraight: Not enough grapple xp: " .. tostring(grapple.experience) .. ", purchaseXP: " .. tostring(purchaseXP))
        return false
    end

    grapple.experience = grapple.experience + purchaseXP
    self.experience = self.experience - purchaseXP

    grapple.energy_cost = GetEnergyCost_GrappleStraight(grapple.experience)

    return true
end
function Player:TransferExperience_EnergyTank(energy_tank, purchaseXP)
    if self.experience - purchaseXP < 0 then
        LogError("TransferExperience_EnergyTank: Not enough player xp: " .. tostring(self.experience) .. ", purchaseXP: " .. tostring(purchaseXP))
        return false

    elseif energy_tank.experience + purchaseXP < 0 then
        LogError("TransferExperience_EnergyTank: Not enough energy tank xp: " .. tostring(energy_tank.experience) .. ", purchaseXP: " .. tostring(purchaseXP))
        return false
    end

    energy_tank.experience = energy_tank.experience + purchaseXP
    self.experience = self.experience - purchaseXP

    return true
end

function Player:Save()
    local pkey, errMsg = SavePlayer(self:MapSelfToModel())

    --TODO: Handle errors

    self.PlayerPrimaryKey = pkey
end

------------------------------- Private Instance Methods ------------------------------

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
    if playerEntry then
        playerEntry.isUnlocked = this.IsPlayerUnlocked(playerEntry)
    else
        -- There's no need to store default in the db.  Wait until they change something
        playerEntry = GetDefault_Player(playerID)
    end

    -- This should never happen, but if it does, just make an energy tank so other logic doesn't break
    if playerEntry.isUnlocked and not playerEntry.energy_tank then
        playerEntry.energy_tank = GetDefault_EnergyTank()
    end

    self:MapModelToSelf(playerEntry, primKey)
end

-- Puts the contents of the player model entry in self.  This will save all the users of
-- this class from having an extra dot (player.player.grapple1....)
function Player:MapModelToSelf(model, primkey)
    self.playerID = model.playerID
    self.energy_tank = model.energy_tank

    self.grapple1 = model.grapple1
    self.grapple2 = model.grapple2
    self.grapple3 = model.grapple3
    self.grapple4 = model.grapple4
    self.grapple5 = model.grapple5
    self.grapple6 = model.grapple6

    self.experience = model.experience

    self.isUnlocked = model.isUnlocked ~= nil and model.isUnlocked      -- this isn't in the database, so make sure the value stored in self is non nil

    self.PlayerPrimaryKey = primkey
end
function Player:MapSelfToModel()
    return
    {
        playerID = self.playerID,
        energy_tank = self.energy_tank,

        grapple1 = self.grapple1,
        grapple2 = self.grapple2,
        grapple3 = self.grapple3,
        grapple4 = self.grapple4,
        grapple5 = self.grapple5,
        grapple6 = self.grapple6,

        experience = self.experience,
    }
end

-------------------------------- Private Static Methods -------------------------------

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

function this.IsPlayerUnlocked(playerEntry)
    -- See if they have experience
    if not IsNearZero(playerEntry.experience) and playerEntry.experience > 0 then
        return true
    end

    -- See if they have any grapples equipped
    for i = 1, 6 do
        if playerEntry["grapple" .. tostring(i)] then
            return true
        end
    end

    if playerEntry.energy_tank then
        return true
    end

    return false
end