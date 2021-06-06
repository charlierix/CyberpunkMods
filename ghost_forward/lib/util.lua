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