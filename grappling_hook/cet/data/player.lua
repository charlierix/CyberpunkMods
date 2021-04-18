-- This holds player level state (has nothing to do with cyberpunk's playerpuppet class)
--
-- This is closely tied to the Player model
--
-- This is meant to be static data (that's why it's in the db folder.  Any runtime variables need to be
-- in the state array)

Player = { }

function Player:new(o, state, const, debug)
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.state = state
    obj.const = const
    obj.debug = debug

    -- See MapRowToSelf() for the rest of the member variables

    obj:Load()

    return obj
end


--TODO: Create methods for updating some of the stats.  Maybe taking subsets of the tree
--These upgrade function will also insert the new stats in the database


------------------------------------ Private Instance Methods ------------------------------------

-- This loads the current profile for the current playthrough.  If there are none, this will create
-- a new one based on defaults
function Player:Load()
    -- Get player's uniqueID (comes back as zero if there is no entry)
    --self.o:SetPlayerUniqueID(1)
    local playerID = self.o:GetPlayerUniqueID()
    if not playerID or playerID == 0 then
        playerID = CreateNewPlayerID(self.o)
    end

    print("playerID: '" .. tostring(playerID) .. "'")

    -- Retrieve entry from db
    local row = GetPlayerEntry(playerID)

    if not row then
        -- There's no need to store default in the db.  Wait until they change something
        row = GetDefault_Player(playerID)
    end

    self:MapRowToSelf(row)
end

-- Puts the contents of the parent player row in self.  This will save all the users of this class
-- from having an extra dot (player.player.grapple1....)
function Player:MapRowToSelf(row)
    self.playerID = row.playerID
    self.name = row.name
    self.energy_tank = row.energy_tank

    -- action mapping 1,2,3

    self.grapple1 = row.grapple1
    self.grapple2 = row.grapple2
    --self.grapple3 = row.grapple3

    self.experience = row.experience
end

------------------------------------ Private Static Methods ------------------------------------

function CreateNewPlayerID(o)
    -- Save file doesn't have this quest string.  Get a new ID and store it in the save file

    -- It won't stick if they don't hit save.  But this is a one time setup per playthrough, so
    -- there's a good chance that saves will happen (worst case, there would be a few orphaned rows
    -- and the user will need to redo their grapple settings)

    local playerID = os.time()      -- seconds since 1/1/1970
    o:SetPlayerUniqueID(playerID)

    return playerID
end
