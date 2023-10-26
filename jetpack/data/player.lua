local this = {}

Player = {}

function Player:new(o, vars, const, debug)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.vars = vars
    obj.const = const
    obj.debug = debug

    obj.mode = nil

    -- See MapModelToSelf() for the rest of the member variables

    this.Load(obj)

    return obj
end

function Player:NextMode()
    local newIndex = self.mode.index + 1
    SetSetting_Int(self.const.settings.Mode, newIndex)

    self.mode = GetConfigValues(newIndex, self.vars.sounds_thrusting, self.const)
    self.vars.showConfigNameUntil = self.o.timer + 3

    self.vars.sounds_thrusting:ModeChanged(self.mode.sound_type)
    self.vars.should_rebound_redscript = false
end

----------------------------------- Private Methods -----------------------------------

function this.Load(obj)

    -- For this first draft, just moving the code that was in init into this class

    obj.mode = GetConfigValues(GetSetting_Int(obj.const.settings.Mode, 0), obj.vars.sounds_thrusting, obj.const)
    obj.vars.sounds_thrusting:ModeChanged(obj.mode.sound_type)

    obj.vars.remainBurnTime = obj.mode.energy.maxBurnTime
end