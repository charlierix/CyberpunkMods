-- This holds player level state (has nothing to do with cyberpunk's playerpuppet class)
--
-- This is closely tied to the Player model

Player = { }

function Player:new(o, state, const, debug)
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.state = state
    obj.const = const
    obj.debug = debug

    obj:Load()

    return obj
end



------------------------------------ Private Methods ------------------------------------

-- This loads the current profile for the current playthrough.  If there are none, this will create
-- a new one based on defaults
function Player:Load()
    -- Get player's uniqueID (comes back as zero if there is no entry)
    --self.o:SetPlayerUniqueID(1)
    local playerID = self.o:GetPlayerUniqueID()

    print("playerID: '" .. tostring(playerID) .. "'")

    if playerID and playerID > 0 then
        -- Retrieve entry from db
        local row = GetPlayerEntry(playerID)

        if row then
            -- Deserialize from db
            print("finish deserializing the player row")
        else
            -- The save file and db are out of sync (maybe the db was deleted).  Create a new ID and
            -- load default template values
            self:Load_Default(playerID)
        end
    else
        self:Load_Default(playerID)
    end
end

function Player:Load_Default(existingPlayerID)
    -- Save file doesn't have this quest string (or it does, but that ID isn't in the db).  Get a
    -- new ID and store it in the save file
    --
    -- It won't stick if they don't hit save.  But this is a one time setup per playthrough, so
    -- there's a good chance that saves will happen (worst case, there would be a few orphaned rows
    -- and the user will need to redo their grapple settings)

    local playerID = GetNextPlayerID(true, existingPlayerID)
    self.o:SetPlayerUniqueID(playerID)

    print("new playerID: '" .. tostring(playerID) .. "'")


    --CreateNewPlayerID(self.o, existingPlayerID)



    --Finish creating profile


end

function CreateNewPlayerID(o, existingPlayerID)
    -- -- If ID passed in is > 0, then burn IDs

    -- -- They probably deleted the database, so need to start generating IDs after the last
    -- -- was issued.  This will reduce the chance or generating a new ID that happens to be
    -- -- the same as another save file's

    -- -- There's no guarantee though.  Say there are two save files:
    -- --  A plays for a while with ID 1
    -- --  B gets ID 2
    -- --
    -- --  They reset the DB while playing B, get ID of 2 + 5031 = 5033
    -- --  They delete the DB, switch to A, get ID of 1 + 5030 = 5031 (rand just happens to pick something very near prev random)
    -- --  They make char C, then D
    -- --  Char D now has the same ID as A

    -- local increment
    -- if not existingPlayerID or existingPlayerID == 0 then
    --     increment = 1
    -- else
    --     increment = existingPlayerID + math.random(100, 100000) -- this will support up to 20,000 resets
    -- end

    -- print("incrementing " .. tostring(increment))

    -- local playerID = GetNextPlayerID(true, existingPlayerID)
    -- o:SetPlayerUniqueID(playerID)

    -- print("new playerID: '" .. tostring(playerID) .. "'")
end