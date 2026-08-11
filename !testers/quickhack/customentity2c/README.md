# Custom Entity Tester 2c (CE2c)

## Quickhack Clearance Fix + Action Dump

### Purpose

Follow-up to customentity2b (CE2b). CE2b proved the OnAttach/OnDetach lifecycle fix worked -- the bridge loaded successfully via `GetScriptableSystemsContainer():Get("OrbHackingBridge")`. However, both Phase 1 (player) and Phase 2 (drone) returned `NO_ACTION`, and the CET log showed an error at `init.lua:399`.

CE2c fixes two issues identified in the CE2b log:

1. **REDscript: Wrong clearance type** -- The bridge used `Device.GetInteractionClearance()` (general interactions) instead of `Device.GetInteractionQuickHackClearance()` (quickhack-specific). This caused `GetQuickHackActions()` to return an empty or incomplete action list, resulting in `NO_ACTION`.

2. **CET Lua: Diagnostic line crashed onInit** -- The line `tostring(Game.GetScriptableSystem ~= nil)` threw an error because CET's metatable raises when accessing non-existent `GameInstance` members. This crashed the `onInit` callback before `GetBridge()` could run.

### Root Cause Analysis from CE2b Log

| Issue | Log Evidence | Root Cause | Fix |
|---|---|---|---|
| onInit crash | `init.lua:399: Function GetScriptableSystem is not a GameInstance member` | `Game.GetScriptableSystem` access triggers CET metatable error | Wrap diagnostic in `pcall()` |
| NO_ACTION (both phases) | `Phase 1 result: NO_ACTION`, `Phase 2 result: NO_ACTION` | `Device.GetInteractionClearance()` returns general interaction clearance, not quickhack clearance | Change to `Device.GetInteractionQuickHackClearance()` |
| VendingMachine target | `Target: ToCName{ ... --[[ VendingMachine --]] }` | VendingMachines typically don't have PingDevice quickhack | Add action dump logging + fallback to first available action |

### Why This Is NOT a Red4ext Issue

The `NO_ACTION` result occurs **before** `IsPossible()` is ever called. The REDscript pipeline is:

```
GenerateContext -> GetQuickHackActions -> FindAction -> SetUp -> SetExecutor -> IsPossible -> CompleteAction
```

`NO_ACTION` means the failure is at `FindAction` (step 3) -- the action list was empty because the wrong clearance was used. The Red4ext `IsPossible()` hook (step 6) was never reached. This is a REDscript/CET fix, not a Red4ext issue.

### What CE2c Tests

1. **Quickhack clearance fix** -- Does `Device.GetInteractionQuickHackClearance()` cause `GetQuickHackActions()` to return the correct quickhack actions?
2. **Action dump diagnostics** -- What quickhack actions are actually available on the targeted device?
3. **Fallback execution** -- If `PingDevice` isn't available, can we execute the first available quickhack action?
4. **Player as executor** (Phase 1) -- Does the fixed bridge produce a visible device hack effect?
5. **Drone as executor** (Phase 2) -- Does the drone pass `IsPossible()` validation?

### Lineage

| Tester | Result | Key Lesson |
|---|---|---|
| customentity2 | Partial | Drone spawns, target acquired, wrong bridge API, Red4ext stub |
| customentity2a | Partial | Bridge API fixed but still nil -- REDscript missing OnAttach/OnDetach |
| customentity2b | Partial | Bridge loads (OnAttach/OnDetach fix worked!) but NO_ACTION -- wrong clearance + onInit crash |
| **customentity2c** | Testing | Quickhack clearance fix + action dump + fallback execution |

### What Changed from CE2b

| Aspect | CE2b | CE2c |
|---|---|---|
| REDscript clearance | `Device.GetInteractionClearance()` | `Device.GetInteractionQuickHackClearance()` (critical fix) |
| CET diagnostic | `tostring(Game.GetScriptableSystem ~= nil)` (crashes) | `pcall(function() return Game.GetScriptableSystem ~= nil end)` (safe) |
| Action dump | None | `ListAvailableActions()` method + `CE2c: List Device Actions` hotkey |
| Fallback execution | None | `ExecuteFirstAvailableAction()` -- tries first available action if specific one not found |
| NO_ACTION detail | Just `"NO_ACTION"` | `"NO_ACTION (requested: PingDevice, available: DistractEnemies, ...")` |
| Hotkeys | 2 | 3 (added List Device Actions) |
| Files to deploy | 2 (Lua + Reds) | 2 (Lua + Reds -- must replace CE2b Reds) |

### Files

| File | Language | Install Path |
|---|---|---|
| `cet/init.lua` | CET Lua | `bin/x64/plugins/cyber_engine_tweaks/mods/customentity2c/init.lua` |
| `redscript/OrbHackingBridge.reds` | REDscript | `r6/scripts/OrbHackingBridge.reds` (replaces CE2b version) |
| *(reuse)* `customentity2/red4ext/.../OrbHackingBridge.dll` | C++ | `red4ext/plugins/OrbHackingBridge/` (already deployed) |

### REDscript Fix (Key Change)

The critical fix is changing the clearance type in `GenerateContext()`:

```reds
// CE2b (BROKEN):
let context: GetActionsContext = ps.GenerateContext(
  gamedeviceRequestType.Remote,
  Device.GetInteractionClearance(),        // wrong: general interactions
  executorObj,
  executorObj.GetEntityID()
);

// CE2c (FIXED):
let context: GetActionsContext = ps.GenerateContext(
  gamedeviceRequestType.Remote,
  Device.GetInteractionQuickHackClearance(), // correct: quickhack actions
  executorObj,
  executorObj.GetEntityID()
);
```

### CET Lua Fix (Key Change)

The diagnostic line that crashed onInit is now wrapped in `pcall`:

```lua
-- CE2b (BROKEN -- crashes onInit):
Log(string.format('API check: GetScriptableSystem = %s',
    tostring(Game.GetScriptableSystem ~= nil)))  -- accessing Game.GetScriptableSystem throws

-- CE2c (FIXED):
local oldOk, oldExists = pcall(function()
    return Game.GetScriptableSystem ~= nil
end)
Log(string.format('API check: GetScriptableSystem = %s',
    tostring(oldOk and oldExists or false)))
```

### New REDscript Methods

| Method | Purpose |
|---|---|
| `ListAvailableActions(device, executor)` | Returns all quickhack action names available on the device for the given executor. Diagnostic tool. |
| `ExecuteFirstAvailableAction(device, executor)` | Executes the first available quickhack action. Fallback when specific action name not found. |

### Hotkeys (3 total)

| # | Label | Action |
|---|---|---|
| 1 | `CE2c: Spawn/Despawn Drone` | Spawn or despawn the drone near player |
| 2 | `CE2c: Run Ping Quickhack Test` | Execute ping quickhack on targeted device (Phase 1: player, Phase 2: drone if spawned). Falls back to first available action if PingDevice not found. |
| 3 | `CE2c: List Device Actions` | List all quickhack actions available on the targeted device for player and drone |

### Testing Protocol

#### Step 1: Deploy

1. Copy `cet/init.lua` to `<game>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity2c/init.lua`
2. Copy `redscript/OrbHackingBridge.reds` to `<game>/r6/scripts/OrbHackingBridge.reds` (replaces CE2b version)
3. Red4ext DLL from customentity2 should already be in place
4. **Remove or disable CE2b** -- delete or rename `<game>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity2b/` to avoid conflicts

#### Step 2: Verify Bridge Loads

1. Launch the game
2. Check CET console for `[CE2c] Bridge loaded via GetScriptableSystemsContainer():Get("OrbHackingBridge")`
3. Verify no `init.lua:399` error appears (the pcall fix should prevent the crash)
4. If bridge loads: proceed to Step 3
5. If bridge still nil: check REDscript compilation log

#### Step 3: List Device Actions (NEW)

1. Look at a hackable device (camera, TV, turret, access point, vending machine)
2. Press `CE2c: List Device Actions`
3. Check CET log for `Player actions: N actions: ActionName1, ActionName2, ...`
4. This tells you exactly what quickhack actions are available on the targeted device
5. **Try multiple device types** -- cameras and access points are most likely to have PingDevice

#### Step 4: Phase 1 -- Player as Executor

1. Look at a hackable device (preferably a **camera** or **access point** -- these have PingDevice)
2. Press `CE2c: Run Ping Quickhack Test`
3. Check CET log for:
   - `Available actions: N actions: ...` (action dump before execution)
   - `Phase 1 result (PingDevice): SUCCESS` or `Phase 1 fallback result: SUCCESS (action: ...)`
4. Verify visible quickhack effect in game

#### Step 5: Phase 2 -- Drone as Executor

1. Press `CE2c: Spawn/Despawn Drone` to spawn a drone
2. Look at a hackable device again
3. Press `CE2c: Run Ping Quickhack Test` again
4. Check CET log for `Phase 2 result: ...`

### Device Quickhack Reference

| Device Type | Has PingDevice? | Common Quickhacks |
|---|---|---|
| Camera | Yes | PingDevice, CameraSurveillance, DistractEnemies |
| Access Point | Yes | PingDevice, DataMine, MassVulnerability |
| TV | Yes | PingDevice, DistractEnemies |
| Turret | Yes | PingDevice, TurretReset, DistractEnemies |
| VendingMachine | No | DistractEnemies, GrenadeTrap |

**Recommendation**: Target a **camera** or **access point** for PingDevice testing. VendingMachines (used in CE2b test) do not have PingDevice.

### Expected Outcomes

| Phase 1 Result | Phase 2 Result | Meaning |
|---|---|---|
| SUCCESS | NOT_POSSIBLE | Bridge works! IsPossible is the gate for drone. Build real Red4ext hook for tester3. |
| SUCCESS | SUCCESS | Bridge works AND drone passes IsPossible naturally. No Red4ext needed! |
| SUCCESS | ERROR | Bridge works but drone executor causes a different error. Investigate. |
| NO_ACTION (available: ...) | -- | Device has quickhacks but not PingDevice. Try fallback or different device. |
| NO_ACTION (no quickhack actions) | -- | Clearance fix didn't work or no cyberdeck. Check action dump with List Device Actions. |
| NOT_POSSIBLE | -- | Even player fails IsPossible. Check if player has cyberdeck equipped. |
| ERROR | -- | Bridge call itself errors. Check REDscript method signatures. |
| Bridge still nil | -- | REDscript compilation failed. Check REDscript log. |

### References

- [customentity2b/log - cet.txt](../customentity2b/log%20-%20cet.txt) -- CE2b test log showing NO_ACTION and onInit crash
- [customentity2b/README.md](../customentity2b/README.md) -- CE2b OnAttach/OnDetach lifecycle fix
- [customentity2/FINAL ANALYSIS.md](../customentity2/FINAL%20ANALYSIS.md) -- Root cause analysis of CE2 failures
- [customentity2a/README.md](../customentity2a/README.md) -- CE2a bridge API fix attempt
