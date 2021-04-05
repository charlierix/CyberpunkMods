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
    local playerID = self.o:GetPlayerUniqueID()

    print("playerID: " .. tostring(playerID))

    if playerID and playerID > 0 then
        -- Retrieve entry from db
        local row = GetPlayerEntry(playerID)

        if row then
            -- Deserialize from db
            print("finish deserializing the player row")
        else
            -- The save file and db are out of sync (maybe the db was deleted).  Create a new ID and
            -- load default template values
            self:Load_Default()
        end
    else
        self:Load_Default()
    end
end

function Player:Load_Default()
    -- Save file doesn't have this quest string (or it does, but that ID isn't in the db).  Get a
    -- new ID and store it in the save file
    --
    -- It won't stick if they don't hit save.  But this is a one time setup per playthrough, so
    -- there's a good chance that saves will happen (worst case, there would be a few orphaned rows
    -- and the user will need to redo their grapple settings)

    local playerID = GetNextPlayerID()
    self.o:SetPlayerUniqueID(playerID)

    print("new playerID: " .. tostring(playerID))


    --Finish creating profile


end