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

    -- jumping
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
    --TODO: this shouldn't be coming from a json file in the future
    --TODO: if no custom config, use a hardcoded default

    local filename = "!settings/walljump.json"

    local handle = io.open(filename, "r")
    local json = handle:read("*all")

    local deserialized = extern_json.decode(json)

    self.rebound =
    {
        horizontal =
        {
            percent_up = this.ToAnimationCurve(deserialized.horizontal.percent_up),
            percent_along = this.ToAnimationCurve(deserialized.horizontal.percent_along),
            percent_away = this.ToAnimationCurve(deserialized.horizontal.percent_away),

            percent_at_speed = this.ToAnimationCurve(deserialized.horizontal.percent_at_speed),

            percent_look = this.ToAnimationCurve(deserialized.horizontal.percent_look),

            yaw_turn = this.ToAnimationCurve(deserialized.horizontal.yaw_turn),

            percent_latch_after_jump = this.ToAnimationCurve(deserialized.horizontal.percent_latch_after_jump),

            strength = deserialized.horizontal.strength,
        },

        has_straightup = deserialized.has_straightup,
    }

    if deserialized.has_straightup then
        self.rebound.straight_up =
        {
            percent = this.ToAnimationCurve(deserialized.straight_up.percent),

            percent_vert_whenup = this.ToAnimationCurve(deserialized.straight_up.percent_vert_whenup),
            percent_horz_whenup = this.ToAnimationCurve(deserialized.straight_up.percent_horz_whenup),

            percent_at_speed = this.ToAnimationCurve(deserialized.straight_up.percent_at_speed),

            strength = deserialized.straight_up.strength,
        }
    end

    -- --------------- ORIG ---------------
    -- straightup_vert_percent = this.ToAnimationCurve(deserialized.straightup_vert_percent),

    -- percent_vert_whenup = this.ToAnimationCurve(deserialized.percent_vert_whenup),
    -- percent_horz_whenup = this.ToAnimationCurve(deserialized.percent_horz_whenup),

    -- horz_percent_up = this.ToAnimationCurve(deserialized.horz_percent_up),
    -- horz_percent_along = this.ToAnimationCurve(deserialized.horz_percent_along),
    -- horz_percent_away = this.ToAnimationCurve(deserialized.horz_percent_away),
    -- horz_strength = this.ToAnimationCurve(deserialized.horz_strength),
    -- horizontal_percent_look = this.ToAnimationCurve(deserialized.horizontal_percent_look),

    -- yaw_turn_percent = this.ToAnimationCurve(deserialized.yaw_turn_percent),

    -- horizontal_percent_at_speed = this.ToAnimationCurve(deserialized.horizontal_percent_at_speed),

    -- straightup_strength = deserialized.straightup_strength,
    -- straightup_percent_at_speed = this.ToAnimationCurve(deserialized.straightup_percent_at_speed),

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

function this.ToAnimationCurve(key_values)
    local retVal = AnimationCurve:new()

    for _, item in ipairs(key_values) do
        retVal:AddKeyValue(item.key, item.value)
    end

    return retVal
end