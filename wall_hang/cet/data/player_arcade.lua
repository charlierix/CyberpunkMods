-- Wall Hang will have two types of modes: arcade and realism
-- Arcade is a single set of constants for all characters
-- Realism will be the same constants but unique to the playthrough character

PlayerArcade = {}

function PlayerArcade:new(o, vars, const, debug)
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

function PlayerArcade:Save()
    local model = self:MapSelfToModel()
    local json = extern_json.encode(model)
    SetPlayerArcade(json)
end

------------------------------- Private Instance Methods ------------------------------

-- This loads the row.  If there is none, this will create a new one based on defaults
function PlayerArcade:Load()
    -- Retrieve entry from db
    local json, errMsg = GetPlayerArcade()

    local entry = nil

    if json then
        entry = extern_json.decode(json)
    else
        entry = { }
    end

    self:MapModelToSelf(entry)
end

function PlayerArcade:MapModelToSelf(model)
    --NOTE: This function is written very defensively, the assumption is that properties will be added over time,
    --so new code will try to load old db entries.  Missing properties will take the default value

    if model.jump_strength then
        self.jump_strength = model.jump_strength
    else
        self.jump_strength = 11
    end
end
function PlayerArcade:MapSelfToModel()
    return
    {
        jump_strength = self.jump_strength,
    }
end