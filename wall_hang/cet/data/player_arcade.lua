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

    -- jumping OLD
    this.StoreModelValue(self, model, "jump_strength", 11)

    this.StoreModelValue(self, model, "jump_speed_fullStrength", 3)     -- any vertical speed lower than this will get full jump strength
    this.StoreModelValue(self, model, "jump_speed_zeroStrength", 7)     -- this is the vertical speed where no more impulse will be applied.  Gradient to full at jump_speed_fullStrength

    -- wall attraction
    this.StoreModelValue(self, model, "wallDistance_attract_max", 6)

    this.StoreModelValue(self, model, "attract_accel", 8)
    this.StoreModelValue(self, model, "attract_pow", 4)
    this.StoreModelValue(self, model, "attract_antigrav", 0.66666666)

    -- crawl/slide
    this.StoreModelValue(self, model, "wallSlide_minSpeed", 4)
    this.StoreModelValue(self, model, "wallSlide_dragAccel", 16)

    this.StoreModelValue(self, model, "wallcrawl_speed_horz", 1.2)
    this.StoreModelValue(self, model, "wallcrawl_speed_up", 0.8)
    this.StoreModelValue(self, model, "wallcrawl_speed_down", 1.6)

    ----------------------- rebound jump settings -----------------------

    self.rebound = this.DeserializeConfig("walljump")

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

function this.DeserializeConfig(name)
    if not name then
        return
        {
            has_horizontal = false,
            has_straightup = false,
        }
    end

    local filename = "!settings/" .. name .. ".json"

    --TODO: fail gracefully if file doesn't exist

    local handle = io.open(filename, "r")
    local json = handle:read("*all")

    local deserialized = extern_json.decode(json)

    local retVal =
    {
        description = deserialized.description,
        has_horizontal = deserialized.has_horizontal,
        has_straightup = deserialized.has_straightup,
    }

    if deserialized.has_horizontal then
        retVal.horizontal =
        {
            percent_up = this.ToAnimationCurve(deserialized.horizontal.percent_up),
            percent_along = this.ToAnimationCurve(deserialized.horizontal.percent_along),
            percent_away = this.ToAnimationCurve(deserialized.horizontal.percent_away),

            percent_at_speed = this.ToAnimationCurve(deserialized.horizontal.percent_at_speed),

            percent_look = this.ToAnimationCurve(deserialized.horizontal.percent_look),
            percent_look_strength = this.ToAnimationCurve(deserialized.horizontal.percent_look_strength),

            yaw_turn = this.ToAnimationCurve(deserialized.horizontal.yaw_turn),

            percent_latch_after_jump = this.ToAnimationCurve(deserialized.horizontal.percent_latch_after_jump),
            relatch_time_seconds = this.ToAnimationCurve(deserialized.horizontal.relatch_time_seconds),
            wallattract_distance_max = this.ToAnimationCurve(deserialized.horizontal.wallattract_distance_max),
            wallattract_accel = this.ToAnimationCurve(deserialized.horizontal.wallattract_accel),
            wallattract_pow = this.ToAnimationCurve(deserialized.horizontal.wallattract_pow),
            wallattract_antigrav = this.ToAnimationCurve(deserialized.horizontal.wallattract_antigrav),

            strength = deserialized.horizontal.strength,
        }
    end

    if deserialized.has_straightup then
        retVal.straight_up =
        {
            percent = this.ToAnimationCurve(deserialized.straight_up.percent),

            percent_vert_whenup = this.ToAnimationCurve(deserialized.straight_up.percent_vert_whenup),
            percent_horz_whenup = this.ToAnimationCurve(deserialized.straight_up.percent_horz_whenup),

            percent_at_speed = this.ToAnimationCurve(deserialized.straight_up.percent_at_speed),

            strength = deserialized.straight_up.strength,

            latch_after_jump = deserialized.straight_up.latch_after_jump,
            relatch_time_seconds = deserialized.straight_up.relatch_time_seconds,
            wallattract_distance_max = deserialized.straight_up.wallattract_distance_max,
            wallattract_accel = deserialized.straight_up.wallattract_accel,
            wallattract_pow = deserialized.straight_up.wallattract_pow,
            wallattract_antigrav = deserialized.straight_up.wallattract_antigrav,
        }
    end

    return retVal
end

function this.ToAnimationCurve(key_values)
    local retVal = AnimationCurve:new()

    for _, item in ipairs(key_values) do
        retVal:AddKeyValue(item.key, item.value)
    end

    return retVal
end