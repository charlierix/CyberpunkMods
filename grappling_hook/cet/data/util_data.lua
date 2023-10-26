function InitializeKeyTrackers(vars, keys, o, const)
    -- Pull bindings from the DB
    local bindings = dal.GetAllInputBindings()

    if not bindings then
        -- No rows, use defaults
        bindings = GetDefaultInputBindings(const)

        for key, value in pairs(bindings) do
            dal.SetInputBinding(key, value)
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