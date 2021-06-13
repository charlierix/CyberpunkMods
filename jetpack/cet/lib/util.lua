function IsStandingStill(velocity)
    return (GetVectorLengthSqr(velocity) < (0.03 * 0.03))        --IsNearZero_vec4 is too exact if you're sitting still on a vehicle, need something a looser like +-.03
end

-- Returns true if the table is an instance of the class
-- NOTE: This doesn't work every time (when objects get nested within objects)
--https://stackoverflow.com/questions/45192939/lua-check-if-a-table-is-an-instance
function IsInstance(table, class)
    while table do
        table = getmetatable(table)
        if class == table then
            return true
        end
    end

    return false
end

-- Posted by Foxxy
function IsPlayerInAnyMenu()
    local blackboardDefs = Game.GetAllBlackboardDefs()
    if not blackboardDefs then
        return true
    end

    local blackboard = Game.GetBlackboardSystem():Get(blackboardDefs.UI_System);
    if not blackboard then
        return true
    end

    local uiSystemBB = (blackboardDefs.UI_System);
    if not uiSystemBB then
        return true
    end

    return(blackboard:GetBool(uiSystemBB.IsInMenu));
end

-- Not sure if this is really needed, but don't want to risk random always being seeded with 0
-- https://scriptinghelpers.org/questions/17929/what-is-the-difference-between-random-and-randomseed
function InitializeRandom()
    math.randomseed(os.time())

    for i=1, 144 do
        math.random()
    end
end

function StopSound(o, vars)
    if vars.sound_current and (o.timer - vars.sound_started) > 2 then     -- all the sounds this mod plays are really quick
        o:StopSound(vars.sound_current)
        vars.sound_current = nil
    end
end

-- This takes a table of names {1:"a", 2:"b", 3:"c"} and turns it into a key value table where the key and value are
-- the same
--
-- Usage:
-- local days = CreateEnum({"aday", "bday", "friday"})
-- local specificDay = days.bday
-- if specificDay == days.bday then print("yay") end
function CreateEnum(names)
    local enum = { }

    for i=1, #names do
        enum[names[i]] = names[i]
    end

    return enum
end
