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
        self.wallDistance_attract_max = model.wallDistance_attract_max
        self.attract_accel = model.attract_accel
        self.attract_pow = model.attract_pow

    else
        self.jump_strength = 11
        self.wallDistance_attract_max = 3.6
        self.attract_accel = 4
        self.attract_pow = 4
    end
end
function PlayerArcade:MapSelfToModel()
    return
    {
        jump_strength = self.jump_strength,
        wallDistance_attract_max = self.wallDistance_attract_max,
        attract_accel = self.attract_accel,
        attract_pow = self.attract_pow,
    }
end