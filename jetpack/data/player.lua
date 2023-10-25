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

    -- See MapModelToSelf() for the rest of the member variables

    this.Load(obj)

    return obj
end

function Player:NextMode()
    
end

----------------------------------- Private Methods -----------------------------------

function this.Load(obj)

    -- For this first draft, just move the code that was in init into this class







end