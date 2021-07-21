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

function InitializeKeyTrackers(vars, keys, o, const)
    -- Pull bindings from the DB
    local bindings = GetAllInputBindings()

    if not bindings then
        -- No rows, use defaults
        bindings = GetDefaultInputBindings(const)

        for key, value in pairs(bindings) do
            SetInputBinding(key, value)
        end
    end

    vars.startStopTracker = InputTracker_StartStop:new(o, keys, const)

    for key, value in pairs(bindings) do
        vars.startStopTracker:UpdateBinding(key, value)
    end

    -- print("keynames (deduped list):")
    -- ReportTable(vars.startStopTracker.keynames)
    -- print("")
    -- print("call_order (subsets last):")
    -- ReportTable(vars.startStopTracker.call_order)

    keys:ClearActions()

    for i=1, #vars.startStopTracker.keynames do
        keys:AddAction(vars.startStopTracker.keynames[i])
    end
end
function GetDefaultInputBindings(const)
    local bindings = {}

    -- These strings have to exactly match what comes from Observe('PlayerPuppet', 'OnAction'

    bindings[const.bindings.grapple1] = { "Left", "Right", "Forward" }          -- A+D+W
    bindings[const.bindings.grapple2] = { "Left", "Right", "Back" }             -- A+D+S
    bindings[const.bindings.grapple3] = { "QuickMelee", "Forward" }             -- Q+W          --NOTE: other actions also trigger when they press Q, but QuickMelee is all that really needs to be listened for (assuming they keep default in game bindings)
    bindings[const.bindings.grapple4] = { "QuickMelee", "Right" }               -- Q+D
    bindings[const.bindings.grapple5] = { "QuickMelee", "Back" }                -- Q+S
    bindings[const.bindings.grapple6] = { "Left", "Right" }                     -- A+D          -- using this instead of QWD, because it would be easier to press.  The danger of this is if you intend to hit AWD or ASD and hit AD instead

    bindings[const.bindings.stop] = { "Jump" }                                  -- Space        -- { "Left", "Right" } -- When they are tarzan swinging and try to aquire a new grapple point, but don't have enough energy, this was making the current grapple cancel.  Changing to jump so there's no accidental cancellation

    return bindings
end

-- This takes a set of names ("a", "b", "c") and turns it into a key value table where the key and value are
-- the same
--
-- Usage:
-- local days = CreateEnum("aday", "bday", "friday")
-- local specificDay = days.bday
-- if specificDay == days.bday then print("yay") end
function CreateEnum(...)
    local enum = {}

    for i = 1, select("#", ...) do
        local text = select(i, ...)
        enum[text] = text
    end

    return enum
end