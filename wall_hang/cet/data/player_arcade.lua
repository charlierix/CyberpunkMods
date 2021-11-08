-- Wall Hang will have two types of modes: arcade and realism
-- Arcade is a single set of constants for all characters
-- Realism will be the same constants but unique to the playthrough character

local this = {}

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


    -- wall attraction
    this.StoreModelValue(self, model, "wallDistance_attract_max", 4.8)

    this.StoreModelValue(self, model, "attract_accel", 8)
    this.StoreModelValue(self, model, "attract_pow", 4)
    this.StoreModelValue(self, model, "attract_antigrav", 0.66)


    -- jumping
    this.StoreModelValue(self, model, "jump_strength", 11)

    this.StoreModelValue(self, model, "jump_speed_fullStrength", 3)     -- any vertical speed lower than this will get full jump strength
    this.StoreModelValue(self, model, "jump_speed_zeroStrength", 7)     -- this is the vertical speed where no more impulse will be applied.  Gradient to full at jump_speed_fullStrength


    -- crawl/slide
    this.StoreModelValue(self, model, "wallSlide_minSpeed", 4)
    this.StoreModelValue(self, model, "wallSlide_dragAccel", 16)


    this.StoreModelValue(self, model, "wallcrawl_speed_horz", 1.2)
    this.StoreModelValue(self, model, "wallcrawl_speed_up", 0.8)
    this.StoreModelValue(self, model, "wallcrawl_speed_down", 1.6)
end
function PlayerArcade:MapSelfToModel()
    return
    {
        jump_strength = self.jump_strength,

        wallDistance_attract_max = self.wallDistance_attract_max,

        attract_accel = self.attract_accel,
        attract_pow = self.attract_pow,
        attract_antigrav = self.attract_antigrav,

        wallSlide_minSpeed = self.wallSlide_minSpeed,
        wallSlide_dragAccel = self.wallSlide_dragAccel,

        jump_speed_fullStrength = self.jump_speed_fullStrength,
        jump_speed_zeroStrength = self.jump_speed_zeroStrength,

        wallcrawl_speed_horz = self.wallcrawl_speed_horz,
        wallcrawl_speed_up = self.wallcrawl_speed_up,
        wallcrawl_speed_down = self.wallcrawl_speed_down,
    }
end

----------------------------------- Private Methods -----------------------------------

function this.StoreModelValue(obj, model, prop_name, default)
    if model[prop_name] then
        obj[prop_name] = model[prop_name]
    else
        obj[prop_name] = default
    end
end