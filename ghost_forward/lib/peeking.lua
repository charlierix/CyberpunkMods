-- This creates a plateau whose edges are a gaussian curve
function GetPeekDistPercent(elapsedTime, totalTime)
    if (elapsedTime < 0) or (elapsedTime > totalTime) then
        return 0
    end

    local scaledTime = elapsedTime / totalTime

    if scaledTime <= 0.5 then
        return GetPeekDistPercent_Calc(scaledTime)
    else
        return GetPeekDistPercent_Calc(1 - scaledTime)
    end
end

-- Scaled must be from 0 to .5
function GetPeekDistPercent_Calc(scaled)
    -- 144 has it near zero at scaled time of .2 (then subtracting from 1 puts the percent at 1)
    return 1 - math.exp(-144 * scaled * scaled)
end