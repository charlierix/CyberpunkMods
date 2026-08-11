# Custom Entity Tester 2a (CE2a)

## Fixed Bridge API + Phased Quickhack Testing

### Purpose

Follow-up to customentity2 (CE2). CE2 proved drone spawning and target acquisition work, but failed at bridge access because it used the wrong CET API (`Game.GetScriptableSystem()` instead of `Game.GetScriptableSystemsContainer():Get()`).

CE2a fixes that single bug and restructures the test into clear phases to isolate what works and what does not.

### What CE2a Tests

1. **Fix the bridge API** -- Does `Game.GetScriptableSystemsContainer():Get("OrbHackingBridge")` successfully return the REDscript ScriptableSystem?
2. **Test with player as executor** (Phase 1) -- Does the REDscript bridge (SetUp + native pipeline) produce a visible device hack effect when the player is the executor? No drone needed, no Red4ext hook needed.
3. **Test with drone as executor** (Phase 2) -- Does the drone pass the `IsPossible()` validation gate? If not, confirms we need a real Red4ext hook for tester3.

### Lineage

| Tester | Result | Key Lesson |
|---|---|---|
| customentity1 | Failed | Invalid entity paths; bridge compilation issue |
| customentity1a | Success | Valid paths; exEntitySpawner works; DynamicEntitySpec as fallback |
| customentity1b | Partial | Redscript bridge compiles; drone spawns but device action system rejects drone as executor |
| customentity2 | Partial | Drone spawns, target acquired, but wrong bridge API -- `GetScriptableSystem()` returns nil; Red4ext hook is a stub |
| **customentity2a** | Testing | Fixed bridge API; phased testing (player first, then drone) |

### What Changed from CE2

| Aspect | CE2 | CE2a |
|---|---|---|
| Bridge access API | `Game.GetScriptableSystem()` (broken) | `GetScriptableSystemsContainer():Get()` (correct) + CName fallback |
| Test structure | Combined player + drone test in one call | Separate Phase 1 (player) + Phase 2 (drone) |
| Phase 1 (player) | Required drone to be spawned first | Works without drone -- player executor only |
| API diagnostics | None | Logs which APIs exist on init |
| Red4ext | Included (stub, does nothing) | Reused from CE2 (no changes, no new build) |
| Redscript | Included | Reused from CE2 (no changes) |
| Files to deploy | 4 (Lua + Reds + DLL + manifest) | 1 (Lua only -- Reds + DLL already deployed from CE2) |

### Architecture

```
CET Lua (init.lua)  [CHANGED -- fixed bridge API]
    |
    +--> Spawn drone with exEntitySpawner (Method A, proven in CE2)
    +--> Acquire target device (GetLookAtObject with fallback args)
    +--> Get bridge via GetScriptableSystemsContainer():Get()  [FIXED]
    +--> Phase 1: bridge:ExecuteDeviceActionByName(device, "PingDevice", player)
    +--> Phase 2: bridge:ExecuteDeviceActionByName(device, "PingDevice", drone)
         |
         v
    REDscript (OrbHackingBridge.reds)  [REUSED from CE2 -- no changes]
         |
         +--> device.GetDevicePS() as ScriptableDeviceComponentPS
         +--> ps.GenerateContext(Remote, clearance, executor, entityID)
         +--> ps.GetQuickHackActions(actions, context)
         +--> Find action by name ("PingDevice")
         +--> action.SetUp(ps)  [THE CRITICAL STEP]
         +--> action.SetExecutor(executor)
         +--> action.IsPossible(executor)  [Gate -- player passes, drone may not]
         +--> action.CompleteAction(game)
         |
         v
    Device PS -- On* handler fires -- VISIBLE EFFECT
```

### Files

| File | Language | Install Path |
|---|---|---|
| `cet/init.lua` | CET Lua | `bin/x64/plugins/cyber_engine_tweaks/mods/customentity2a/init.lua` |
| *(reuse)* `customentity2/redscript/OrbHackingBridge.reds` | REDscript | `r6/scripts/OrbHackingBridge.reds` (already deployed) |
| *(reuse)* `customentity2/red4ext/build/Release/OrbHackingBridge.dll` | C++ | `red4ext/plugins/OrbHackingBridge/` (already deployed) |

### Hotkeys (2 total)

| # | Label | Action |
|---|---|---|
| 1 | `CE2a: Spawn/Despawn Drone` | Spawn or despawn the drone near player |
| 2 | `CE2a: Run Ping Quickhack Test` | Execute ping quickhack on targeted device (Phase 1: player, Phase 2: drone if spawned) |

### Testing Protocol

#### Step 1: Deploy

Deploy ONLY the CET Lua file. The REDscript and Red4ext from customentity2 should already be in place from CE2 testing.

#### Step 2: Verify Bridge API Fix

1. Launch the game
2. Check CET console for `[CE2a] Bridge loaded via GetScriptableSystemsContainer():Get(...)`
3. If bridge loads: API fix works. Proceed to Step 3.
4. If bridge still nil: Check diagnostic logs -- `API check: GetScriptableSystem = true/false` and `API check: GetScriptableSystemsContainer = true/false`

#### Step 3: Phase 1 -- Player as Executor

1. Look at a hackable device (camera, TV, turret, access point)
2. Press `CE2a: Run Ping Quickhack Test`
3. No drone needed for Phase 1 -- the player is the executor
4. Check CET log for `Phase 1 result: SUCCESS`
5. Verify visible ping effect in game

#### Step 4: Phase 2 -- Drone as Executor

1. Press `CE2a: Spawn/Despawn Drone` to spawn a drone
2. Look at a hackable device again
3. Press `CE2a: Run Ping Quickhack Test` again
4. Check CET log for `Phase 2 result: ...`

### Expected Outcomes

| Phase 1 Result | Phase 2 Result | Meaning |
|---|---|---|
| SUCCESS | NOT_POSSIBLE | Bridge works! IsPossible is the gate for drone. Build real Red4ext hook for tester3. |
| SUCCESS | SUCCESS | Bridge works AND drone passes IsPossible naturally. No Red4ext needed! |
| SUCCESS | ERROR | Bridge works but drone executor causes a different error. Investigate. |
| NO_ACTION | -- | Device has no PingDevice quickhack. Try a different device or action. |
| NOT_POSSIBLE | -- | Even player fails IsPossible. Check if player has cyberdeck equipped. |
| ERROR | -- | Bridge call itself errors. Check REDscript method signatures. |
| Bridge still nil | -- | API fix did not work. Check CName variant, check Redscript compilation. |

### References

- [customentity2/FINAL ANALYSIS.md](../customentity2/FINAL%20ANALYSIS.md) -- Root cause analysis of CE2 failures
- [customentity2/ANALYSIS.md](../customentity2/ANALYSIS.md) -- Why Red4ext is needed
- [deploy.md](deploy.md) -- Deployment instructions
