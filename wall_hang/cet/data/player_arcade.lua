-- Wall Hang will have two types of modes: arcade and realism
-- Arcade is a single set of constants for all characters
-- Realism will be the same constants but unique to the playthrough character

local this = {}

local FOLDER = "!settings"

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

    -- Save is likely called from ui, which means they may have changed the jump combos
    self:LoadJumpConfigs()
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
    self:LoadJumpConfigs()
end

function PlayerArcade:MapModelToSelf(model)
    --NOTE: This function is written very defensively, the assumption is that properties will be added over time,
    --so new code will try to load old db entries.  Missing properties will take the default value

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

    -- jump from json files
    this.PossiblyPortJumpSettings(model, self.const)

    self.planted_name = model.planted_name
    self.planted_shift_name = model.planted_shift_name
    self.rebound_name = model.rebound_name
    self.rebound_shift_name = model.rebound_shift_name

    -- jump config overrides
    this.StoreModelValue(self, model, "override_relatch", self.const.override_relatch.use_config)
    this.StoreModelValue(self, model, "override_strength_mult", 1)
    this.StoreModelValue(self, model, "override_speed_mult", 1)
end
function PlayerArcade:MapSelfToModel()
    return
    {
        wallDistance_attract_max = self.wallDistance_attract_max,

        attract_accel = self.attract_accel,
        attract_pow = self.attract_pow,
        attract_antigrav = self.attract_antigrav,

        wallSlide_minSpeed = self.wallSlide_minSpeed,
        wallSlide_dragAccel = self.wallSlide_dragAccel,

        wallcrawl_speed_horz = self.wallcrawl_speed_horz,
        wallcrawl_speed_up = self.wallcrawl_speed_up,
        wallcrawl_speed_down = self.wallcrawl_speed_down,

        planted_name = self.planted_name,
        planted_shift_name = self.planted_shift_name,
        rebound_name = self.rebound_name,
        rebound_shift_name = self.rebound_shift_name,

        override_relatch = self.override_relatch,
        override_strength_mult = self.override_strength_mult,
        override_speed_mult = self.override_speed_mult,
    }
end

function PlayerArcade:LoadJumpConfigs()
    if self.planted_name ~= self.const.jump_config_none then
        self.planted = this.DeserializeConfigFile(self.planted_name)
    else
        self.planted = nil
    end

    if self.planted_shift_name ~= self.const.jump_config_none then
        self.planted_shift = this.DeserializeConfigFile(self.planted_shift_name)
    else
        self.planted_shift = nil
    end

    if self.rebound_name ~= self.const.jump_config_none then
        self.rebound = this.DeserializeConfigFile(self.rebound_name)
    else
        self.rebound = nil
    end

    if self.rebound_shift_name ~= self.const.jump_config_none then
        self.rebound_shift = this.DeserializeConfigFile(self.rebound_shift_name)
    else
        self.rebound_shift = nil
    end
end

----------------------------------- Private Methods -----------------------------------

function this.StoreModelValue(obj, model, prop_name, default)
    if model[prop_name] then
        obj[prop_name] = model[prop_name]
    else
        obj[prop_name] = default
    end
end

function this.DeserializeConfigFile(name)
    if not name then
        return nil
    end

    local filename = FOLDER .. "/" .. name .. ".json"

    local handle = io.open(filename, "r")
    if not handle then
        LogError("jump config file name not found: " .. filename)
        return nil
    end

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

function this.PossiblyPortJumpSettings(model, const)
    if model.planted_name or model.planted_shift_name or model.rebound_name or model.rebound_shift_name then
        -- Some are populated, make sure all are populated (shouldn't need to do this, just being safe)
        if not model.planted_name then
            model.planted_name = const.jump_config_none
        end

        if not model.planted_shift_name then
            model.planted_shift_name = const.jump_config_none
        end

        if not model.rebound_name then
            model.rebound_name = const.jump_config_none
        end

        if not model.rebound_shift_name then
            model.rebound_shift_name = const.jump_config_none
        end
    else
        -- Nothing is populated
        local db_value = GetSetting_Bool(const.settings.ShouldJumpBackward, nil)

        if db_value == nil then
            -- Database is empty, use new defaults
            -- NOTE: this would also be the case where they left default settings alone (never touched the checkbox)
            model.planted_name = const.jump_config_default
            model.planted_shift_name = const.jump_config_default_shift
            model.rebound_name = const.jump_config_default
            model.rebound_shift_name = const.jump_config_default_shift

        elseif db_value == true then
            -- They explicitly set jump back to true, so use the configs that give the same functionality
            model.planted_name = const.jump_config_default_nolatch
            model.planted_shift_name = const.jump_config_default_nolatch
            model.rebound_name = const.jump_config_backjump_nolatch
            model.rebound_shift_name = const.jump_config_backjump_nolatch

        else
            -- They explicitly set jump back to false, so use the configs that give the same functionality
            model.planted_name = const.jump_config_default_nolatch
            model.planted_shift_name = const.jump_config_default_nolatch
            model.rebound_name = const.jump_config_uponly_nolatch
            model.rebound_shift_name = const.jump_config_backjump_nolatch
        end
    end
end

function this.ToAnimationCurve(key_values)
    local retVal = AnimationCurve:new()

    for _, item in ipairs(key_values) do
        retVal:AddKeyValue(item.key, item.value)
    end

    return retVal
end