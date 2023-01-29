function IsStandingStill(velocity)
    return (GetVectorLengthSqr(velocity) < (0.03 * 0.03))        --IsNearZero_vec4 is too exact if you're sitting still on a vehicle, need something a looser like +-.03
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

function PossiblyStopSound(o, vars, maxTime)
    if not maxTime then
        maxTime = 6     -- all the sounds this mod plays are fairly quick
    end

    if vars.sound_current and (o.timer - vars.sound_started) > maxTime then
        o:StopSound(vars.sound_current)
        vars.sound_current = nil
    end
end

function LogError(message)
    message = "Ghost Forward [ERROR] : " .. message

    print(message)
    spdlog.error(message)
end